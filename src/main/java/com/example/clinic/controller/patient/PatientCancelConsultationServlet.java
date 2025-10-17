package com.example.clinic.controller.patient;

import com.example.clinic.entities.Patient;
import com.example.clinic.service.ConsultationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/patient/cancel-consultation")
public class PatientCancelConsultationServlet extends HttpServlet {

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

        Patient patient = (Patient) session.getAttribute("user");
        Long patientId = patient.getId();

        String consultationIdParam = request.getParameter("consultationId");

        if (consultationIdParam == null || consultationIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() +
                    "/patient/dashboard?error=Invalid consultation");
            return;
        }

        try {
            Long consultationId = Long.parseLong(consultationIdParam);

            consultationService.cancelConsultation(consultationId, patientId);

            response.sendRedirect(request.getContextPath() +
                    "/patient/dashboard?success=Consultation cancelled successfully");

        } catch (IllegalArgumentException | IllegalStateException e) {
            response.sendRedirect(request.getContextPath() +
                    "/patient/dashboard?error=" + e.getMessage());
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() +
                    "/patient/dashboard?error=Error cancelling consultation");
        }
    }
}