package com.fooddelivery.servlet;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.fooddelivery.dao.LoginHistoryDAO;
import com.fooddelivery.daoimpl.LoginHistoryDAOImpl;
import com.fooddelivery.model.LoginHistory;

@WebServlet("/LoginHistoryServlet")
public class LoginHistoryServlet extends HttpServlet {
    private LoginHistoryDAO historyDAO;

    @Override
    public void init() throws ServletException {
        historyDAO = new LoginHistoryDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<LoginHistory> historyList = historyDAO.getAllLoginHistory();
        request.setAttribute("historyList", historyList);
        request.getRequestDispatcher("/loginHistory.jsp").forward(request, response);
    }
}