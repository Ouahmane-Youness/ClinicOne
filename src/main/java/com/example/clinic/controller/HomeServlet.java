package com.example.clinic.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;


@WebServlet(name = "HomeServlet", value = "/home")
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if(session != null && session.getAttribute("user") != null)
        {
            String userType = (String) session.getAttribute("userType");

            if( "PATIENT".equals(userType))
            {
                response.sendRedirect(request.getContextPath() + "/patient/dashboard");
                return;
            }
            if( "DOCTEUR".equals(userType))
            {
                response.sendRedirect(request.getContextPath() + "/docteur/dashboard");
                return;
            }
            if( "ADMIN".equals(userType))
            {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                return;
            }
            request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
        }

    }
}
