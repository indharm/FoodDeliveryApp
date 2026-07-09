package com.fooddelivery.dao;

import java.util.List;
import com.fooddelivery.model.Cart;
import com.fooddelivery.model.Order;
import com.fooddelivery.model.OrderItem;

public interface OrderDAO {
    int placeOrder(int userId, int restaurantId, double totalAmount,
                    String status, String paymentMode, String address,
                    String fullName, String mobileNumber, Cart cart);

    List<Order> getOrdersByUserId(int userId);
    boolean cancelOrder(int orderId, int userId);
    Order getOrderById(int orderId);
    List<Order> getAllOrders();
    boolean updateOrderStatus(int orderId, String newStatus);
    List<OrderItem> getOrderItems(int orderId);
}