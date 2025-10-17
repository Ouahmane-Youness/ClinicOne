package com.example.clinic.controller.doctor;

import com.example.clinic.entities.Consultation;
import com.example.clinic.entities.Docteur;
import com.example.clinic.entities.Patient;
import com.example.clinic.service.ConsultationService;
import com.example.clinic.service.PatientService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/doctor/patient-history")
public class DoctorPatientHistoryServlet extends HttpServlet {

    private ConsultationService consultationService;
    private PatientService patientService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.consultationService = new ConsultationService();
        this.patientService = new PatientService();
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
        if (!"DOCTEUR".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Docteur docteur = (Docteur) session.getAttribute("user");

        String patientIdParam = request.getParameter("patientId");

        if (patientIdParam == null || patientIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() +
                    "/doctor/dashboard?error=Invalid patient");
            return;
        }

        try {
            Long patientId = Long.parseLong(patientIdParam);

            Optional<Patient> patientOpt = patientService.getPatientById(patientId);
            if (patientOpt.isEmpty()) {
                response.sendRedirect(request.getContextPath() +
                        "/doctor/dashboard?error=Patient not found");
                return;
            }

            Patient patient = patientOpt.get();
            List<Consultation> patientHistory = consultationService.getPatientConsultations(patientId);

            request.setAttribute("patient", patient);
            request.setAttribute("patientHistory", patientHistory);
            request.setAttribute("docteur", docteur);

            request.getRequestDispatcher("/WEB-INF/views/doctor/patient-history.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() +
                    "/doctor/dashboard?error=Error loading patient history");
        }
    }
}