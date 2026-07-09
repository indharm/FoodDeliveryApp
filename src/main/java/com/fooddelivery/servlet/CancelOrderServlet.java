package com.fooddelivery.servlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import com.fooddelivery.dao.OrderDAO;
import com.fooddelivery.daoimpl.OrderDAOImpl;
import com.fooddelivery.model.User;

@WebServlet("/cancelOrder")
public class CancelOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO = new OrderDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        orderDAO.cancelOrder(orderId, user.getId());
        response.sendRedirect(request.getContextPath() + "/orderHistory");
    }
}