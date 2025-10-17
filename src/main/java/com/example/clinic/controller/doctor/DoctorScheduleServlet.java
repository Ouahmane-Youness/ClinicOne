package com.example.clinic.controller.doctor;

import com.example.clinic.entities.Consultation;
import com.example.clinic.entities.Docteur;
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

@WebServlet("/doctor/schedule")
public class DoctorScheduleServlet extends HttpServlet {

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

        String dateParam = request.getParameter("date");
        LocalDate selectedDate = (dateParam != null && !dateParam.isEmpty())
                ? LocalDate.parse(dateParam)
                : LocalDate.now();

        try {
            LocalDate startOfWeek = selectedDate.minusDays(selectedDate.getDayOfWeek().getValue() - 1);
            LocalDate endOfWeek = startOfWeek.plusDays(6);

            List<Consultation> weekConsultations =
                    consultationService.getConsultationsInDateRange(startOfWeek, endOfWeek).stream()
                            .filter(c -> c.getDocteur().getId().equals(docteurId))
                            .collect(Collectors.toList());

            Map<Long, String> formattedTimes = new HashMap<>();
            for (Consultation c : weekConsultations) {
                formattedTimes.put(c.getIdConsultation(), DateUtils.formatTime(c.getHeure()));
            }

            Map<Integer, String> weekDayNames = new HashMap<>();
            Map<Integer, String> weekDayNumbers = new HashMap<>();
            Map<Integer, String> weekMonthNames = new HashMap<>();

            for (int i = 0; i <= 6; i++) {
                LocalDate day = startOfWeek.plusDays(i);
                weekDayNames.put(i, DateUtils.formatDayName(day));
                weekDayNumbers.put(i, DateUtils.formatDayNumber(day));
                weekMonthNames.put(i, DateUtils.formatMonthName(day));
            }

            request.setAttribute("weekConsultations", weekConsultations);
            request.setAttribute("formattedTimes", formattedTimes);
            request.setAttribute("selectedDate", selectedDate);
            request.setAttribute("startOfWeek", startOfWeek);
            request.setAttribute("endOfWeek", endOfWeek);
            request.setAttribute("weekDayNames", weekDayNames);
            request.setAttribute("weekDayNumbers", weekDayNumbers);
            request.setAttribute("weekMonthNames", weekMonthNames);
            request.setAttribute("formattedStartDate", DateUtils.formatMonthName(startOfWeek) + " " + DateUtils.formatDayNumber(startOfWeek));
            request.setAttribute("formattedEndDate", DateUtils.formatDayNumber(endOfWeek) + ", " + startOfWeek.getYear());
            request.setAttribute("docteur", docteur);

            request.getRequestDispatcher("/WEB-INF/views/doctor/schedule.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Error loading schedule: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/doctor/schedule.jsp")
                    .forward(request, response);
        }
    }
}