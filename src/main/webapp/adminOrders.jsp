<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fooddelivery.model.Order" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin - Manage Orders | FoodHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Space+Mono:wght@700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-color: #121212;
            --card-bg: #1a1a1a;
            --text-main: #ffffff;
            --text-muted: #aaaaaa;
            --accent-red: #e74c3c;
            --accent-orange: #ff8c42;
            --border-color: #2a2a2a;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            background: var(--bg-color);
            color: var(--text-main);
            font-family: 'Inter', 'Segoe UI', sans-serif;
            min-height: 100vh;
            overflow-x: hidden;
            padding-bottom: 60px;
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 8%;
            background-color: var(--card-bg);
            box-shadow: 0 4px 20px rgba(0,0,0,0.5);
        }
        header h1 { font-weight: 800; font-size: 1.7rem; }
        header h1 span {
            background: linear-gradient(90deg, var(--accent-red), var(--accent-orange));
            -webkit-background-clip: text; background-clip: text; color: transparent;
        }
        nav a { color: var(--text-muted); text-decoration: none; margin-left: 25px; font-weight: 500; transition: color 0.2s ease; }
        nav a:hover { color: var(--accent-red); }

        @keyframes fadeSlideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .page-heading { max-width: 1200px; margin: 45px auto 0; padding: 0 24px; animation: fadeSlideUp 0.5s ease both; }
        .page-heading h2 { font-size: 2rem; font-weight: 800; margin-bottom: 4px; }
        .page-heading p { color: var(--text-muted); font-size: 0.95rem; }

        .management-panel-wrap {
            max-width: 1200px;
            margin: 30px auto;
            position: relative;
        }

        .management-panel {
            width: 100%;
            padding: 32px;
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            box-shadow: 0 14px 36px rgba(0,0,0,0.4);
            position: relative;
            overflow: hidden;
            animation: fadeSlideUp 0.55s ease 0.1s both;
        }
        .management-panel::before {
            content: '';
            position: absolute; top: 0; left: 0; right: 0; height: 4px;
            background: linear-gradient(90deg, var(--accent-red), var(--accent-orange));
        }

        .orders-table { width: 100%; border-collapse: collapse; }
        .orders-table th { text-align: left; color: var(--text-muted); font-weight: 600; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.5px; padding-bottom: 16px; border-bottom: 1px solid var(--border-color); }
        .order-row td { padding: 20px 10px; border-bottom: 1px solid var(--border-color); vertical-align: middle; font-size: 0.95rem; }
        .order-row:hover { background: rgba(255,255,255,0.015); }

        .id-badge { font-family: 'Space Mono', monospace; font-weight: 700; color: var(--accent-orange); }
        .user-badge { color: var(--text-main); font-weight: 500; }
        .order-total-val {
            font-family: 'Space Mono', monospace; font-weight: 700;
            background: linear-gradient(90deg, var(--accent-red), var(--accent-orange));
            -webkit-background-clip: text; background-clip: text; color: transparent;
        }
        .delivery-address { color: var(--text-muted); font-size: 0.9rem; max-width: 250px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

        .status-container { display: flex; align-items: center; gap: 8px; }
        .status-dot { width: 8px; height: 8px; border-radius: 50%; display: inline-block; }
        .status-PENDING { background-color: #ffb703; box-shadow: 0 0 8px rgba(255,183,3,0.6); }
        .status-OUT_FOR_DELIVERY { background-color: #6ab0ff; box-shadow: 0 0 8px rgba(106,176,255,0.6); }
        .status-DELIVERED { background-color: #2ec4b6; box-shadow: 0 0 8px rgba(46,196,182,0.6); }
        .status-CANCELLED { background-color: #ff6b6b; box-shadow: 0 0 8px rgba(255,107,107,0.6); }

        .status-select {
            background: #252525;
            color: white;
            border: 1px solid var(--border-color);
            border-radius: 30px;
            padding: 8px 16px;
            font-size: 0.85rem;
            font-weight: 600;
            outline: none;
            cursor: pointer;
            transition: border-color 0.3s ease;
        }
        .status-select:focus { border-color: var(--accent-red); }
        .status-select option { background-color: #1a1a1a; color: white; }

        .btn-update-pill {
            background: linear-gradient(135deg, var(--accent-red), var(--accent-orange));
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 30px;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 700;
            margin-left: 10px;
            box-shadow: 0 4px 15px rgba(231, 76, 60, 0.25);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .btn-update-pill:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(231, 76, 60, 0.4);
        }

        .empty-row td { text-align: center; color: var(--text-muted); padding: 50px 10px; border-bottom: none; font-size: 1.1rem; }
        .empty-row i { color: var(--accent-red); opacity: 0.6; }
    </style>
</head>
<body>

    <header>
        <h1>Food<span>Hub</span> Admin</h1>
        <nav>
            <a href="admin-dashboard"><i class="fa-solid fa-chart-pie" style="margin-right: 5px;"></i> Dashboard</a>
            <a href="home"><i class="fa-solid fa-house" style="margin-right: 5px;"></i> Storefront</a>
        </nav>
    </header>

    <div class="page-heading">
        <h2>Manage Orders</h2>
        <p>Update incoming live order states across fulfillment metrics</p>
    </div>

    <div class="management-panel-wrap">
        <div class="management-panel">
            <table class="orders-table">
                <thead>
                    <tr>
                        <th style="width: 12%;">Order ID</th>
                        <th style="width: 12%;">User ID</th>
                        <th style="width: 15%;">Total</th>
                        <th style="width: 25%;">Delivery Address</th>
                        <th style="width: 16%;">Current Status</th>
                        <th style="width: 20%;">Fulfillment Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Order> orderList = (List<Order>) request.getAttribute("orderList");
                        if (orderList != null && !orderList.isEmpty()) {
                            for (Order order : orderList) {
                                String currentStatus = order.getStatus();
                    %>
                        <tr class="order-row">
                            <td class="id-badge">#<%= order.getId() %></td>
                            <td class="user-badge">UID-<%= order.getUserId() %></td>
                            <td class="order-total-val">₹<%= (int) order.getTotalAmount() %></td>
                            <td><div class="delivery-address" title="<%= order.getDeliveryAddress() %>"><%= order.getDeliveryAddress() %></div></td>
                            <td>
                                <div class="status-container">
                                    <span class="status-dot status-<%= currentStatus %>"></span>
                                    <%= currentStatus %>
                                </div>
                            </td>
                            <td>
                                <form action="AdminOrderServlet" method="POST" style="display: flex; align-items: center;">
                                    <input type="hidden" name="orderId" value="<%= order.getId() %>">
                                    <select name="newStatus" class="status-select">
                                        <option value="PENDING" <%= "PENDING".equals(currentStatus) ? "selected" : "" %>>Pending</option>
                                        <option value="OUT_FOR_DELIVERY" <%= "OUT_FOR_DELIVERY".equals(currentStatus) ? "selected" : "" %>>Out for Delivery</option>
                                        <option value="DELIVERED" <%= "DELIVERED".equals(currentStatus) ? "selected" : "" %>>Delivered</option>
                                        <option value="CANCELLED" <%= "CANCELLED".equals(currentStatus) ? "selected" : "" %>>Cancelled</option>
                                    </select>
                                    <button type="submit" class="btn-update-pill">Update</button>
                                </form>
                            </td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr class="empty-row">
                            <td colspan="6">
                                <i class="fa-solid fa-folder-open" style="font-size: 2.5rem; margin-bottom: 12px; display: block;"></i>
                                No active customer orders found database-wide.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>
