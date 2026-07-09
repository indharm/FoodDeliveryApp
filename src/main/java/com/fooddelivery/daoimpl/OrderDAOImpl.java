package com.fooddelivery.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.fooddelivery.dao.OrderDAO;
import com.fooddelivery.model.Cart;
import com.fooddelivery.model.CartItem;
import com.fooddelivery.model.Order;
import com.fooddelivery.model.OrderItem;
import com.fooddelivery.util.DBConnection;

public class OrderDAOImpl implements OrderDAO {

    @Override
    public int placeOrder(int userId, int restaurantId, double totalAmount,
                          String status, String paymentMode,
                          String address, String fullName, String mobileNumber,
                          Cart cart) {

        String insertOrderQuery =
                "INSERT INTO orders (user_id, restaurant_id, total_amount, status, payment_mode, delivery_address, full_name, mobile_number) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        String insertOrderItemQuery =
                "INSERT INTO order_items (order_id, menu_item_id, item_name, quantity, price) VALUES (?, ?, ?, ?, ?)";

        Connection con = null;
        PreparedStatement psOrder = null;
        PreparedStatement psItem = null;
        ResultSet rs = null;

        int orderId = -1;

        try {

            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            psOrder = con.prepareStatement(insertOrderQuery, Statement.RETURN_GENERATED_KEYS);

            psOrder.setInt(1, userId);
            psOrder.setInt(2, restaurantId);
            psOrder.setDouble(3, totalAmount);
            psOrder.setString(4, status);
            psOrder.setString(5, paymentMode);
            psOrder.setString(6, address);
            psOrder.setString(7, fullName);
            psOrder.setString(8, mobileNumber);

            int rows = psOrder.executeUpdate();

            if (rows > 0) {
                rs = psOrder.getGeneratedKeys();
                if (rs.next()) {
                    orderId = rs.getInt(1);
                }
            }

            if (orderId != -1 && cart != null) {

                psItem = con.prepareStatement(insertOrderItemQuery);

                Map<Integer, CartItem> items = cart.getItems();

                for (CartItem item : items.values()) {
                    psItem.setInt(1, orderId);
                    psItem.setInt(2, item.getItemId());
                    psItem.setString(3, item.getName());
                    psItem.setInt(4, item.getQuantity());
                    psItem.setDouble(5, item.getPrice());
                    psItem.addBatch();
                }

                psItem.executeBatch();
                con.commit();

            } else {
                con.rollback();
            }

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (con != null) con.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            orderId = -1;

        } finally {
            try {
                if (rs != null) rs.close();
                if (psOrder != null) psOrder.close();
                if (psItem != null) psItem.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return orderId;
    }

    @Override
    public List<Order> getOrdersByUserId(int userId) {

        List<Order> orderList = new ArrayList<>();

        String query = "SELECT * FROM orders WHERE user_id=? ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orderList.add(mapRowToOrder(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return orderList;
    }

    @Override
    public boolean cancelOrder(int orderId, int userId) {

        String query = "UPDATE orders SET status='CANCELLED' WHERE id=? AND user_id=? AND status='PENDING'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, orderId);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public Order getOrderById(int orderId) {

        Order order = null;

        String query = "SELECT * FROM orders WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = mapRowToOrder(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return order;
    }

    @Override
    public List<Order> getAllOrders() {

        List<Order> orderList = new ArrayList<>();

        String query = "SELECT * FROM orders ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                orderList.add(mapRowToOrder(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return orderList;
    }

    @Override
    public boolean updateOrderStatus(int orderId, String newStatus) {

        String query = "UPDATE orders SET status=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, newStatus);
            ps.setInt(2, orderId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public List<OrderItem> getOrderItems(int orderId) {

        List<OrderItem> itemList = new ArrayList<>();

        String query = "SELECT * FROM order_items WHERE order_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setId(rs.getInt("id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setMenuItemId(rs.getInt("menu_item_id"));
                    item.setItemName(rs.getString("item_name"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getDouble("price"));
                    itemList.add(item);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return itemList;
    }

    /**
     * Shared row-mapping helper for orders table results.
     * Uses getObject(..., Integer.class) for restaurant_id since it's nullable in the DB —
     * rs.getInt() would silently coerce NULL to 0, losing the distinction.
     */
    private Order mapRowToOrder(ResultSet rs) throws Exception {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setRestaurantId(rs.getObject("restaurant_id", Integer.class));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setPaymentMode(rs.getString("payment_mode"));
        order.setDeliveryAddress(rs.getString("delivery_address"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setFullName(rs.getString("full_name"));
        order.setMobileNumber(rs.getString("mobile_number"));
        return order;
    }
}