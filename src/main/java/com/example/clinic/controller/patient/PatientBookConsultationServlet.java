package com.example.clinic.controller.patient;

import com.example.clinic.entities.Consultation;
import com.example.clinic.entities.Departement;
import com.example.clinic.entities.Docteur;
import com.example.clinic.entities.Patient;
import com.example.clinic.service.ConsultationService;
import com.example.clinic.service.DepartementService;
import com.example.clinic.service.DocteurService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@WebServlet("/patient/book-consultation")
public class PatientBookConsultationServlet extends HttpServlet {

    private ConsultationService consultationService;
    private DocteurService docteurService;
    private DepartementService departementService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.consultationService = new ConsultationService();
        this.docteurService = new DocteurService();
        this.departementService = new DepartementService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userType = (String) session.getAttribute("userType");
        if (!"PATIENT".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Patient patient = (Patient) session.getAttribute("user");

        try {
            List<Departement> departements = departementService.getAllDepartements();
            request.setAttribute("departements", departements);

            String departementIdParam = request.getParameter("departementId");
            if (departementIdParam != null && !departementIdParam.isEmpty()) {
                Long departementId = Long.parseLong(departementIdParam);
                List<Docteur> docteurs = docteurService.getDocteursByDepartement(departementId);
                request.setAttribute("docteurs", docteurs);
                request.setAttribute("selectedDepartementId", departementId);
            }

            String docteurIdParam = request.getParameter("docteurId");
            if (docteurIdParam != null && !docteurIdParam.isEmpty()) {
                Long docteurId = Long.parseLong(docteurIdParam);
                request.setAttribute("selectedDocteurId", docteurId);

                String dateParam = request.getParameter("date");
                if (dateParam != null && !dateParam.isEmpty()) {
                    LocalDate selectedDate = LocalDate.parse(dateParam);
                    List<LocalTime> availableSlots =
                            consultationService.getAvailableTimeSlotsForDoctor(docteurId, selectedDate);
                    request.setAttribute("availableSlots", availableSlots);
                    request.setAttribute("selectedDate", dateParam);
                }
            }

            request.getRequestDispatcher("/WEB-INF/views/patient/book-consultation.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Error loading booking form: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/patient/book-consultation.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Patient patient = (Patient) session.getAttribute("user");
        Long patientId = patient.getId();

        String docteurIdParam = request.getParameter("docteurId");
        String dateParam = request.getParameter("date");
        String timeParam = request.getParameter("time");

        if (docteurIdParam == null || dateParam == null || timeParam == null) {
            request.setAttribute("error", "All fields are required");
            doGet(request, response);
            return;
        }

        try {
            Long docteurId = Long.parseLong(docteurIdParam);
            LocalDate date = LocalDate.parse(dateParam);
            LocalTime time = LocalTime.parse(timeParam);

            Consultation consultation = consultationService.bookConsultation(
                    patientId, docteurId, date, time
            );

            response.sendRedirect(request.getContextPath() +
                    "/patient/dashboard?success=Consultation booked successfully");

        } catch (IllegalArgumentException | IllegalStateException e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error booking consultation: " + e.getMessage());
            doGet(request, response);
        }
    }
}