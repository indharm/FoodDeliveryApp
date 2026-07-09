package com.fooddelivery.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.fooddelivery.dao.OrderDAO;
import com.fooddelivery.daoimpl.OrderDAOImpl;
import com.fooddelivery.model.Order;
import com.fooddelivery.model.OrderItem;
import com.fooddelivery.model.User;

@WebServlet("/orderHistory")
public class OrderHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO = new OrderDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<Order> orders = orderDAO.getOrdersByUserId(user.getId());

        // Fetch items for each order and key them by order ID for easy JSP lookup
        Map<Integer, List<OrderItem>> itemsByOrderId = new HashMap<>();
        for (Order order : orders) {
            itemsByOrderId.put(order.getId(), orderDAO.getOrderItems(order.getId()));
        }

        request.setAttribute("orderList", orders);
        request.setAttribute("itemsByOrderId", itemsByOrderId);
        request.getRequestDispatcher("/orderHistory.jsp").forward(request, response);
    }
}