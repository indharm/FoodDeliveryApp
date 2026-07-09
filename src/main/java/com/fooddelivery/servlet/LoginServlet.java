package com.fooddelivery.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.fooddelivery.dao.LoginHistoryDAO;
import com.fooddelivery.dao.UserDAO;
import com.fooddelivery.daoimpl.LoginHistoryDAOImpl;
import com.fooddelivery.daoimpl.UserDAOImpl;
import com.fooddelivery.model.User;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private LoginHistoryDAO historyDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        historyDAO = new LoginHistoryDAOImpl();
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email and Password cannot be blank.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User loggedInUser = userDAO.validateUser(email.trim(), password);

        if (loggedInUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", loggedInUser);

            historyDAO.logLogin(loggedInUser.getId(), loggedInUser.getUsername(), loggedInUser.getEmail());

            String action = request.getParameter("action");
            if ("checkout".equals(action)) {
                response.sendRedirect("checkout.jsp");
            } else {
                response.sendRedirect("home");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid email or password mismatch.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}