package com.example.clinic.controller.doctor;

import com.example.clinic.entities.Consultation;
import com.example.clinic.entities.Docteur;
import com.example.clinic.entities.StatutConsultation;
import com.example.clinic.service.ConsultationService;
import com.example.clinic.util.DateUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/doctor/dashboard")
public class DoctorDashboardServlet extends HttpServlet {

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
        if (!"DOCTEUR".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Docteur docteur = (Docteur) session.getAttribute("user");
        Long docteurId = docteur.getId();

        try {
            List<Consultation> todayConsultations =
                    consultationService.getConsultationsByDate(LocalDate.now()).stream()
                            .filter(c -> c.getDocteur().getId().equals(docteurId))
                            .collect(Collectors.toList());

            List<Consultation> pendingValidations =
                    consultationService.getDocteurConsultations(docteurId).stream()
                            .filter(c -> c.getStatut() == StatutConsultation.RESERVEE)
                            .collect(Collectors.toList());

            List<Consultation> upcomingConsultations =
                    consultationService.getUpcomingConsultationsForDocteur(docteurId);

            Map<Long, String> formattedDates = new HashMap<>();
            Map<Long, String> formattedShortDates = new HashMap<>();
            Map<Long, String> formattedTimes = new HashMap<>();

            for (Consultation c : todayConsultations) {
                formattedDates.put(c.getIdConsultation(), DateUtils.formatDate(c.getDate()));
                formattedShortDates.put(c.getIdConsultation(), DateUtils.formatShortDate(c.getDate()));
                formattedTimes.put(c.getIdConsultation(), DateUtils.formatTime(c.getHeure()));
            }

            for (Consultation c : pendingValidations) {
                if (!formattedDates.containsKey(c.getIdConsultation())) {
                    formattedDates.put(c.getIdConsultation(), DateUtils.formatDate(c.getDate()));
                    formattedShortDates.put(c.getIdConsultation(), DateUtils.formatShortDate(c.getDate()));
                    formattedTimes.put(c.getIdConsultation(), DateUtils.formatTime(c.getHeure()));
                }
            }

            for (Consultation c : upcomingConsultations) {
                if (!formattedDates.containsKey(c.getIdConsultation())) {
                    formattedDates.put(c.getIdConsultation(), DateUtils.formatDate(c.getDate()));
                    formattedShortDates.put(c.getIdConsultation(), DateUtils.formatShortDate(c.getDate()));
                    formattedTimes.put(c.getIdConsultation(), DateUtils.formatTime(c.getHeure()));
                }
            }

            request.setAttribute("todayConsultations", todayConsultations);
            request.setAttribute("pendingValidations", pendingValidations);
            request.setAttribute("upcomingConsultations", upcomingConsultations);
            request.setAttribute("formattedDates", formattedDates);
            request.setAttribute("formattedShortDates", formattedShortDates);
            request.setAttribute("formattedTimes", formattedTimes);
            request.setAttribute("docteur", docteur);

            request.getRequestDispatcher("/WEB-INF/views/doctor/dashboard.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Error loading dashboard: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/doctor/dashboard.jsp")
                    .forward(request, response);
        }
    }
}