package com.example.clinic.controller.patient;

import com.example.clinic.entities.Consultation;
import com.example.clinic.entities.Patient;
import com.example.clinic.service.ConsultationService;
import com.example.clinic.util.DateUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/patient/history")
public class PatientHistoryServlet extends HttpServlet {

    private ConsultationService consultationService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.consultationService = new ConsultationService();
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
        Long patientId = patient.getId();

        try {
            List<Consultation> pastConsultations =
                    consultationService.getPastConsultationsForPatient(patientId);

            Map<Long, String> formattedDates = new HashMap<>();
            Map<Long, String> formattedShortDates = new HashMap<>();
            Map<Long, String> formattedTimes = new HashMap<>();

            for (Consultation c : pastConsultations) {
                formattedDates.put(c.getIdConsultation(), DateUtils.formatDate(c.getDate()));
                formattedShortDates.put(c.getIdConsultation(), DateUtils.formatShortDate(c.getDate()));
                formattedTimes.put(c.getIdConsultation(), DateUtils.formatTime(c.getHeure()));
            }

            request.setAttribute("pastConsultations", pastConsultations);
            request.setAttribute("formattedDates", formattedDates);
            request.setAttribute("formattedShortDates", formattedShortDates);
            request.setAttribute("formattedTimes", formattedTimes);
            request.setAttribute("patient", patient);

            request.getRequestDispatcher("/WEB-INF/views/patient/history.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Error loading history: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/patient/history.jsp")
                    .forward(request, response);
        }
    }
}