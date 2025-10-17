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
import java.util.Optional;

@WebServlet("/doctor/complete-consultation")
public class DoctorCompleteConsultationServlet extends HttpServlet {

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

        String consultationIdParam = request.getParameter("consultationId");

        if (consultationIdParam == null || consultationIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() +
                    "/doctor/dashboard?error=Invalid consultation");
            return;
        }

        try {
            Long consultationId = Long.parseLong(consultationIdParam);
            Optional<Consultation> consultationOpt = consultationService.getConsultationById(consultationId);

            if (consultationOpt.isEmpty()) {
                response.sendRedirect(request.getContextPath() +
                        "/doctor/dashboard?error=Consultation not found");
                return;
            }

            Consultation consultation = consultationOpt.get();

            request.setAttribute("consultation", consultation);
            request.setAttribute("formattedDate", DateUtils.formatDate(consultation.getDate()));
            request.setAttribute("formattedTime", DateUtils.formatTime(consultation.getHeure()));

            request.getRequestDispatcher("/WEB-INF/views/doctor/complete-consultation.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() +
                    "/doctor/dashboard?error=Error loading consultation");
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

        Docteur docteur = (Docteur) session.getAttribute("user");
        Long docteurId = docteur.getId();

        String consultationIdParam = request.getParameter("consultationId");
        String compteRendu = request.getParameter("compteRendu");

        if (consultationIdParam == null || compteRendu == null || compteRendu.trim().isEmpty()) {
            request.setAttribute("error", "Medical report is required");
            doGet(request, response);
            return;
        }

        try {
            Long consultationId = Long.parseLong(consultationIdParam);

            consultationService.completeConsultation(consultationId, docteurId, compteRendu);

            response.sendRedirect(request.getContextPath() +
                    "/doctor/dashboard?success=Consultation completed");

        } catch (IllegalArgumentException | IllegalStateException e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error completing consultation");
            doGet(request, response);
        }
    }
}