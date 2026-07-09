package com.fooddelivery.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.fooddelivery.dao.UserDAO;
import com.fooddelivery.daoimpl.UserDAOImpl;
import com.fooddelivery.model.User;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forward the client request directly to the registration page UI view
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Simple validation check: Ensure passwords match up perfectly
        if (!password.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + "/register?error=mismatch");
            return;
        }

        // Bundle form parameters into a data model instance container
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password);

        boolean isRegistered = userDAO.addUser(user);

        if (isRegistered) {
            // Registration successful -> Send user straight to the login view with a success indicator
        	response.sendRedirect(request.getContextPath() + "/login.jsp?status=registered");
        } else {
            // Failed execution (e.g., duplicated email field entry constraint breach)
            response.sendRedirect(request.getContextPath() + "/register?error=failed");
        }
    }
}