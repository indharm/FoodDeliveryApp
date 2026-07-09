<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fooddelivery.model.User" %>
<%@ page import="com.fooddelivery.model.Order" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Order order = (Order) request.getAttribute("order");
    String status = (order != null) ? order.getStatus() : "PENDING";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Track Your Order - FoodHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-color: #121212;
            --card-bg: #1a1a1a;
            --text-main: #ffffff;
            --text-muted: #aaaaaa;
            --accent-red: #e74c3c;
            --accent-orange: #ff8c42;
            --accent-hover: #c0392b;
            --border-color: #2a2a2a;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            background-color: var(--bg-color);
            color: var(--text-main);
            font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex; justify-content: center; align-items: center; min-height: 100vh; padding: 20px;
            overflow-x: hidden;
            position: relative;
        }
        .bg-glow {
            position: absolute; width: 460px; height: 460px; border-radius: 50%;
            background: radial-gradient(circle, rgba(231,76,60,0.14) 0%, rgba(231,76,60,0) 70%);
            top: 15%; left: 50%; transform: translateX(-50%);
            z-index: 0; pointer-events: none;
            animation: floatGlow 8s ease-in-out infinite;
        }
        @keyframes floatGlow {
            0%, 100% { transform: translateX(-50%) translateY(0) scale(1); }
            50% { transform: translateX(-50%) translateY(16px) scale(1.06); }
        }
        @keyframes fadeSlideUp {
            from { opacity: 0; transform: translateY(22px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .tracking-card {
            background: var(--card-bg); border: 1px solid var(--border-color); border-radius: 18px;
            box-shadow: 0 14px 36px rgba(0,0,0,0.45);
            width: 100%; max-width: 550px; padding: 34px;
            position: relative; z-index: 1;
            animation: fadeSlideUp 0.55s ease both;
        }
        .header { text-align: center; margin-bottom: 28px; }
        .header h1 {
            font-size: 1.75rem; margin-bottom: 6px; font-weight: 800;
        }
        .header h1 i {
            background: linear-gradient(90deg, var(--accent-red), var(--accent-orange));
            -webkit-background-clip: text; background-clip: text; color: transparent;
        }
        .header p { color: var(--text-muted); font-size: 0.9rem; }
        .order-id-badge { background-color: var(--border-color); padding: 5px 12px; border-radius: 20px; color: #ffb703; font-weight: 700; }

        .timeline { position: relative; margin: 20px 0 30px 20px; border-left: 3px dashed var(--border-color); }
        .timeline-item { position: relative; margin-bottom: 32px; padding-left: 32px; }
        .timeline-item:last-child { margin-bottom: 0; }
        .timeline-icon {
            position: absolute; left: -17px; top: 0; width: 30px; height: 30px; border-radius: 50%;
            background: var(--border-color); color: #888; display: flex; justify-content: center; align-items: center;
            font-size: 0.88rem; border: 2px solid var(--card-bg); transition: all 0.3s ease;
        }
        .timeline-item.completed .timeline-icon { background: #2ec4b6; color: white; }
        .timeline-item.active .timeline-icon {
            background: linear-gradient(135deg, var(--accent-red), var(--accent-orange));
            color: white;
            animation: pulseRing 1.8s ease-out infinite;
        }
        @keyframes pulseRing {
            0% { box-shadow: 0 0 0 0 rgba(231,76,60,0.5); }
            70% { box-shadow: 0 0 0 12px rgba(231,76,60,0); }
            100% { box-shadow: 0 0 0 0 rgba(231,76,60,0); }
        }
        .timeline-item.cancelled .timeline-icon { background: #ff4a4a; color: white; }

        .timeline-content h3 { font-size: 1.05rem; font-weight: 600; color: var(--text-muted); }
        .timeline-item.completed .timeline-content h3 { color: #2ec4b6; }
        .timeline-item.active .timeline-content h3 { color: var(--accent-orange); font-weight: 700; }
        .timeline-item.cancelled .timeline-content h3 { color: #ff6b6b; }
        .timeline-content p { font-size: 0.82rem; color: var(--text-muted); margin-top: 2px; }

        .btn-container { text-align: center; }
        .btn-home {
            background: linear-gradient(90deg, var(--accent-red), var(--accent-orange));
            color: white; text-decoration: none; padding: 12px 26px; border-radius: 8px; font-weight: 700;
            display: inline-block; transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .btn-home:hover { transform: translateY(-2px); box-shadow: 0 10px 24px rgba(231,76,60,0.4); }
    </style>
</head>
<body>

    <div class="bg-glow"></div>

    <div class="tracking-card">
        <div class="header">
            <h1><i class="fa-solid fa-route"></i> Track Live Order</h1>
            <p>Order Reference: <span class="order-id-badge">#<%= (order != null) ? order.getId() : "N/A" %></span></p>
        </div>

        <% if ("CANCELLED".equals(status)) { %>
            <div class="timeline">
                <div class="timeline-item completed">
                    <div class="timeline-icon"><i class="fa-solid fa-check"></i></div>
                    <div class="timeline-content">
                        <h3>Order Confirmed</h3>
                        <p>Your payment went through and the kitchen received your request.</p>
                    </div>
                </div>
                <div class="timeline-item cancelled">
                    <div class="timeline-icon"><i class="fa-solid fa-ban"></i></div>
                    <div class="timeline-content">
                        <h3>Order Cancelled</h3>
                        <p>This order was cancelled and will not be delivered.</p>
                    </div>
                </div>
            </div>
        <% } else { %>
            <div class="timeline">
                <div class="timeline-item completed">
                    <div class="timeline-icon"><i class="fa-solid fa-check"></i></div>
                    <div class="timeline-content">
                        <h3>Order Confirmed</h3>
                        <p>Your payment went through and the kitchen received your request.</p>
                    </div>
                </div>

                <div class="timeline-item <%= "PENDING".equals(status) ? "active" : "completed" %>">
                    <div class="timeline-icon"><i class="fa-solid fa-fire-burner"></i></div>
                    <div class="timeline-content">
                        <h3>Preparing Your Meal</h3>
                        <p>The chef is cooking your food right now.</p>
                    </div>
                </div>

                <div class="timeline-item <%= "OUT_FOR_DELIVERY".equals(status) ? "active" : ("DELIVERED".equals(status) ? "completed" : "") %>">
                    <div class="timeline-icon"><i class="fa-solid fa-motorcycle"></i></div>
                    <div class="timeline-content">
                        <h3>Out for Delivery</h3>
                        <p>A delivery executive is heading your way.</p>
                    </div>
                </div>

                <div class="timeline-item <%= "DELIVERED".equals(status) ? "completed" : "" %>">
                    <div class="timeline-icon"><i class="fa-solid fa-house-chimney"></i></div>
                    <div class="timeline-content">
                        <h3>Arrived Safely</h3>
                        <p>Enjoy your delicious meal!</p>
                    </div>
                </div>
            </div>
        <% } %>

        <div class="btn-container">
            <a href="home" class="btn-home"><i class="fa-solid fa-house"></i> Return to Dashboard</a>
        </div>
    </div>

</body>
</html>
