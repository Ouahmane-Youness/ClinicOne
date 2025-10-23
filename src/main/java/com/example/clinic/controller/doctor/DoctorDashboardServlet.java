package com.example.clinic.controller.doctor;

import com.example.clinic.entities.Consultation;
import com.example.clinic.entities.Docteur;
import com.example.clinic.entities.StatutConsultation;
import com.example.clinic.service.ConsultationService;
import com.example.clinic.service.DocteurService;
import com.example.clinic.util.DateUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@WebServlet("/doctor/dashboard")
public class DoctorDashboardServlet extends HttpServlet {

    private ConsultationService consultationService;
    private DocteurService docteurService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.consultationService = new ConsultationService();
        this.docteurService = new DocteurService();
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
            Optional<Docteur> docteurOpt = docteurService.getDocteurById(docteurId);

            if (docteurOpt.isEmpty()) {
                request.setAttribute("error", "Doctor not found");
                request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
                return;
            }

            Docteur freshDocteur = docteurOpt.get();

            List<Consultation> todayConsultations =
                    consultationService.getConsultationsByDate(LocalDate.now()).stream()
                            .filter(c -> c.getDocteur().getId().equals(docteurId))
                            .filter(c -> c.getStatut() == StatutConsultation.VALIDEE)
                            .collect(Collectors.toList());

            List<Consultation> pendingValidations =
                    consultationService.getDocteurConsultations(docteurId).stream()
                            .filter(c -> c.getStatut() == StatutConsultation.RESERVEE)
                            .collect(Collectors.toList());

            List<Consultation> upcomingConsultations =
                    consultationService.getUpcomingConsultationsForDocteur(docteurId).stream()
                            .filter(c -> c.getDate().isAfter(LocalDate.now()) ||
                                    (c.getDate().equals(LocalDate.now()) && c.getHeure().isAfter(LocalTime.now())))
                            .limit(5)
                            .collect(Collectors.toList());

            List<Consultation> recentCompleted =
                    consultationService.getDocteurConsultations(docteurId).stream()
                            .filter(c -> c.getStatut() == StatutConsultation.TERMINEE)
                            .sorted((c1, c2) -> {
                                int dateCompare = c2.getDate().compareTo(c1.getDate());
                                if (dateCompare != 0) return dateCompare;
                                return c2.getHeure().compareTo(c1.getHeure());
                            })
                            .limit(3)
                            .collect(Collectors.toList());

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

            for (Consultation c : recentCompleted) {
                if (!formattedDates.containsKey(c.getIdConsultation())) {
                    formattedDates.put(c.getIdConsultation(), DateUtils.formatDate(c.getDate()));
                    formattedShortDates.put(c.getIdConsultation(), DateUtils.formatShortDate(c.getDate()));
                    formattedTimes.put(c.getIdConsultation(), DateUtils.formatTime(c.getHeure()));
                }
            }

            long totalPatients = consultationService.getDocteurConsultations(docteurId).stream()
                    .map(c -> c.getPatient().getId())
                    .distinct()
                    .count();

            long completedToday = consultationService.getConsultationsByDate(LocalDate.now()).stream()
                    .filter(c -> c.getDocteur().getId().equals(docteurId))
                    .filter(c -> c.getStatut() == StatutConsultation.TERMINEE)
                    .count();

            request.setAttribute("todayConsultations", todayConsultations);
            request.setAttribute("pendingValidations", pendingValidations);
            request.setAttribute("upcomingConsultations", upcomingConsultations);
            request.setAttribute("recentCompleted", recentCompleted);
            request.setAttribute("formattedDates", formattedDates);
            request.setAttribute("formattedShortDates", formattedShortDates);
            request.setAttribute("formattedTimes", formattedTimes);
            request.setAttribute("docteur", freshDocteur);
            request.setAttribute("totalPatients", totalPatients);
            request.setAttribute("completedToday", completedToday);

            request.getRequestDispatcher("/WEB-INF/views/doctor/dashboard.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading dashboard: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/doctor/dashboard.jsp")
                    .forward(request, response);
        }
    }
}