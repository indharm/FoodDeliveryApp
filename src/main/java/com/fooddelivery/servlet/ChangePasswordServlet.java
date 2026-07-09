package com.fooddelivery.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.fooddelivery.dao.UserDAO;
import com.fooddelivery.daoimpl.UserDAOImpl;
import com.fooddelivery.model.User;

@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "New password and confirm password do not match.");
            request.getRequestDispatcher("/changePassword.jsp").forward(request, response);
            return;
        }

        // Verify the old password is correct before allowing the change
        User validated = userDAO.validateUser(user.getEmail(), oldPassword);
        if (validated == null) {
            request.setAttribute("errorMessage", "Current password is incorrect.");
            request.getRequestDispatcher("/changePassword.jsp").forward(request, response);
            return;
        }

        boolean updated = userDAO.updatePassword(user.getId(), newPassword);

        if (updated) {
            // Keep the session's User object in sync with the new password
            user.setPassword(newPassword);
            session.setAttribute("user", user);

            request.setAttribute("successMessage", "Password changed successfully.");
            request.getRequestDispatcher("/changePassword.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Failed to update password. Please try again.");
            request.getRequestDispatcher("/changePassword.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/changePassword.jsp");
    }
}