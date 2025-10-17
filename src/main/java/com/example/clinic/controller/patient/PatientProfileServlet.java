package com.example.clinic.controller.patient;

import com.example.clinic.entities.Patient;
import com.example.clinic.service.PatientService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/patient/profile")
public class PatientProfileServlet extends HttpServlet {

    private PatientService patientService;

    @Override
    public void init() throws ServletException {
        super.init();
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
        if (!"PATIENT".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Patient patient = (Patient) session.getAttribute("user");
        request.setAttribute("patient", patient);

        request.getRequestDispatcher("/WEB-INF/views/patient/profile.jsp")
                .forward(request, response);
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

        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String poidsParam = request.getParameter("poids");
        String tailleParam = request.getParameter("taille");
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");

        try {
            Double poids = null;
            Double taille = null;

            if (poidsParam != null && !poidsParam.trim().isEmpty()) {
                poids = Double.parseDouble(poidsParam);
            }

            if (tailleParam != null && !tailleParam.trim().isEmpty()) {
                taille = Double.parseDouble(tailleParam);
            }

            Patient updatedPatient = patientService.updatePatient(
                    patientId, nom, prenom, poids, taille
            );

            if (oldPassword != null && !oldPassword.trim().isEmpty() &&
                    newPassword != null && !newPassword.trim().isEmpty()) {

                boolean passwordUpdated = patientService.updatePassword(
                        patientId, oldPassword, newPassword
                );

                if (!passwordUpdated) {
                    request.setAttribute("error", "Old password is incorrect");
                    request.setAttribute("patient", updatedPatient);
                    doGet(request, response);
                    return;
                }
            }

            session.setAttribute("user", updatedPatient);
            session.setAttribute("userName", updatedPatient.getPrenom() + " " + updatedPatient.getNom());

            response.sendRedirect(request.getContextPath() +
                    "/patient/profile?success=Profile updated successfully");

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error updating profile: " + e.getMessage());
            doGet(request, response);
        }
    }
}