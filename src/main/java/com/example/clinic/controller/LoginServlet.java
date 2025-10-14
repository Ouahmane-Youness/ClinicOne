package com.example.clinic.controller;

import com.example.clinic.entities.Docteur;
import com.example.clinic.entities.Patient;
import com.example.clinic.service.DocteurService;
import com.example.clinic.service.PatientService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private PatientService patientService;
    private DocteurService docteurService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.patientService = new PatientService();
        this.docteurService = new DocteurService();
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            String userType = (String) session.getAttribute("userType");
            redirectToDashboard(userType, request, response);
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    private void redirectToDashboard(String userType, HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String redirectUrl = request.getContextPath();

        switch (userType) {
            case "PATIENT":
                redirectUrl += "/patient/dashboard";
                break;
            case "DOCTEUR":
                redirectUrl += "/doctor/dashboard";
                break;
            case "ADMIN":
                redirectUrl += "/admin/dashboard";
                break;
            default:
                redirectUrl += "/";
        }

        response.sendRedirect(redirectUrl);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String userType = request.getParameter("userType");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty() ||
                userType == null || userType.trim().isEmpty()) {
            request.setAttribute("error", "all fields are required");
            request.getRequestDispatcher("WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        try {
            if ("PATIENT".equals(userType)) {
                Optional<Patient> patientOpt = patientService.authenticate(email.trim(), password);

                if (patientOpt.isPresent()) {
                    Patient patient = patientOpt.get();
                    HttpSession session = request.getSession();
                    session.setAttribute("user", patient);
                    session.setAttribute("userType", "PATIENT");
                    session.setAttribute("userId", patient.getId());
                    session.setAttribute("userName", patient.getPrenom() + " " + patient.getNom());
                    response.sendRedirect(request.getContextPath() + "/patient/dashboard");
                    return;
                }

            } else if ("DOCTEUR".equals(userType)) {
                Optional<Docteur> docteurOpt = docteurService.authenticate(email.trim(), password);

                if (docteurOpt.isPresent()) {
                    Docteur docteur = docteurOpt.get();
                    HttpSession session = request.getSession(true);
                    session.setAttribute("user", docteur);
                    session.setAttribute("userType", "DOCTEUR");
                    session.setAttribute("userId", docteur.getId());
                    session.setAttribute("userName", "Dr. " + docteur.getNom());

                    response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
                    return;
                }
            } else if ("ADMIN".equals(userType)) {
                if ("admin@clinic.com".equals(email) && "admin123".equals(password)) {
                    HttpSession session = request.getSession(true);
                    session.setAttribute("user", "ADMIN");
                    session.setAttribute("userType", "ADMIN");
                    session.setAttribute("userName", "Administrator");

                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    return;
                }
            }

            request.setAttribute("error", "Invalid email or password");
            request.setAttribute("email", email);
            request.setAttribute("userType", userType);
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred during login. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }


}