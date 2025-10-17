package com.example.clinic.controller.doctor;

import com.example.clinic.entities.Docteur;
import com.example.clinic.service.ConsultationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/doctor/validate-consultation")
public class DoctorValidateConsultationServlet extends HttpServlet {

    private ConsultationService consultationService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.consultationService = new ConsultationService();
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
        String action = request.getParameter("action");

        if (consultationIdParam == null || action == null) {
            response.sendRedirect(request.getContextPath() +
                    "/doctor/dashboard?error=Invalid request");
            return;
        }

        try {
            Long consultationId = Long.parseLong(consultationIdParam);

            if ("validate".equals(action)) {
                consultationService.validateConsultation(consultationId, docteurId);
                response.sendRedirect(request.getContextPath() +
                        "/doctor/dashboard?success=Consultation validated");
            } else if ("refuse".equals(action)) {
                consultationService.refuseConsultation(consultationId, docteurId);
                response.sendRedirect(request.getContextPath() +
                        "/doctor/dashboard?success=Consultation refused");
            } else {
                response.sendRedirect(request.getContextPath() +
                        "/doctor/dashboard?error=Invalid action");
            }

        } catch (IllegalArgumentException | IllegalStateException e) {
            response.sendRedirect(request.getContextPath() +
                    "/doctor/dashboard?error=" + e.getMessage());
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() +
                    "/doctor/dashboard?error=Error processing request");
        }
    }
}