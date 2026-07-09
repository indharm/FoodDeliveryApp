package com.fooddelivery.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.fooddelivery.model.Cart;
import com.fooddelivery.model.CartItem;
import com.fooddelivery.model.User;
import com.fooddelivery.util.DBConnection;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Cart cart = (Cart) session.getAttribute("cart");

        if (user == null) {
            response.sendRedirect("login.jsp?action=checkout");
            return;
        }

        if (cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        String fullName = request.getParameter("fullName");
        String mobileNumber = request.getParameter("mobileNumber");
        String address = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod");

        if (fullName == null || fullName.trim().isEmpty()) {
            fullName = user.getUsername();
        }
        if (mobileNumber == null || mobileNumber.trim().isEmpty()) {
            mobileNumber = "N/A";
        }
        if (address == null || address.trim().isEmpty()) {
            address = "Default Delivery Address Context";
        }
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            paymentMethod = "COD";
        }

        double itemTotal = cart.getTotal();
        double deliveryFee = 40.0;
        double platformFee = 5.0;
        double totalAmount = itemTotal + deliveryFee + platformFee;

        int generatedOrderId = -1;

        String insertOrderQuery = "INSERT INTO orders (user_id, total_amount, status, payment_mode, delivery_address, full_name, mobile_number) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String insertOrderItemQuery = "INSERT INTO order_items (order_id, menu_item_id, item_name, quantity, price) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false); 

            try (PreparedStatement psOrder = con.prepareStatement(insertOrderQuery, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, user.getId());
                psOrder.setDouble(2, totalAmount);
                psOrder.setString(3, "PENDING");
                psOrder.setString(4, paymentMethod);
                psOrder.setString(5, address);
                psOrder.setString(6, fullName);
                psOrder.setString(7, mobileNumber);
                
                psOrder.executeUpdate();

                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedOrderId = rs.getInt(1);
                    }
                }
            }

            if (generatedOrderId != -1) {
                try (PreparedStatement psItem = con.prepareStatement(insertOrderItemQuery)) {
                    for (Map.Entry<Integer, CartItem> entry : cart.getItems().entrySet()) {
                        CartItem item = entry.getValue();

                        psItem.setInt(1, generatedOrderId);
                        psItem.setInt(2, item.getItemId());
                        psItem.setString(3, item.getName());
                        psItem.setInt(4, item.getQuantity());
                        psItem.setDouble(5, item.getPrice());
                        
                        psItem.addBatch();
                    }
                    psItem.executeBatch();
                }

                con.commit();
                
                cart.clear(); 
                session.setAttribute("cart", cart);

                request.setAttribute("orderId", generatedOrderId);
                request.getRequestDispatcher("/orderSuccess.jsp").forward(request, response);
            } else {
                con.rollback();
                request.setAttribute("errorMessage", "Failed to generate order tracking instance ID index.");
                request.getRequestDispatcher("/cart.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Transaction aborted due to server exception error: " + e.getMessage());
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("cart.jsp");
    }
}