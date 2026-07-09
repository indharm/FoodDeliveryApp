<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fooddelivery.model.User" %>
<%@ page import="com.fooddelivery.model.Order" %>
<%@ page import="com.fooddelivery.model.OrderItem" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order History | FoodHub</title>
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
            overflow-x: hidden;
        }

        header {
            display: flex; justify-content: space-between; align-items: center; padding: 15px 8%;
            background-color: var(--card-bg); box-shadow: 0 4px 20px rgba(0,0,0,0.5);
            position: sticky; top: 0; z-index: 200;
        }
        header h1 { margin: 0; font-size: 1.6rem; font-weight: 800; }
        header h1 span {
            background: linear-gradient(90deg, var(--accent-red), var(--accent-orange));
            -webkit-background-clip: text; background-clip: text; color: transparent;
        }
        nav { display: flex; align-items: center; gap: 20px; }
        nav a { color: var(--text-muted); text-decoration: none; font-weight: 500; transition: color 0.2s ease; }
        nav a:hover { color: var(--accent-red); }
        .user-badge {
            background: var(--card-bg); border: 1px solid var(--border-color); padding: 7px 16px;
            border-radius: 20px; display: flex; align-items: center; gap: 8px; font-size: 0.9rem;
        }

        @keyframes fadeSlideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .container { max-width: 900px; margin: 40px auto; padding: 0 20px; }
        .page-header { margin-bottom: 30px; animation: fadeSlideUp 0.5s ease both; }
        .page-header h1 { font-size: 2rem; margin-bottom: 6px; font-weight: 800; }
        .page-header p { color: var(--text-muted); }

        .order-card {
            background: var(--card-bg); border-radius: 14px; padding: 24px; margin-bottom: 22px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.25); border: 1px solid var(--border-color);
            opacity: 0; animation: fadeSlideUp 0.5s ease forwards;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .order-card:hover { transform: translateY(-3px); box-shadow: 0 12px 28px rgba(0,0,0,0.35); }

        .card-header { display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 1px solid var(--border-color); padding-bottom: 16px; margin-bottom: 18px; }
        .order-meta h3 { font-size: 1.15rem; margin-bottom: 3px; }
        .order-meta span { font-size: 0.82rem; color: #777; }

        .status-tag { padding: 5px 13px; border-radius: 30px; font-size: 0.78rem; font-weight: 700; display: flex; align-items: center; gap: 5px; text-transform: uppercase; }
        .status-pending { background: rgba(255, 183, 3, 0.12); color: #ffb703; }
        .status-delivered { background: rgba(46, 196, 182, 0.12); color: #2ec4b6; }
        .status-cancelled { background: rgba(255, 74, 74, 0.12); color: #ff6b6b; }
        .status-out { background: rgba(74, 144, 255, 0.12); color: #6ab0ff; }

        .card-body-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 18px; margin-bottom: 18px; }
        .info-group h4 { font-size: 0.78rem; color: #777; text-transform: uppercase; margin-bottom: 5px; font-weight: 500; }
        .info-group p { font-size: 0.92rem; font-weight: 500; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

        .order-items-list { margin-bottom: 18px; }
        .order-items-list h4 { font-size: 0.78rem; color: #777; text-transform: uppercase; margin-bottom: 10px; font-weight: 500; }
        .order-item-row { display: flex; justify-content: space-between; padding: 6px 0; border-bottom: 1px solid var(--border-color); font-size: 0.9rem; }
        .order-item-empty { color: var(--text-muted); font-size: 0.85rem; }

        .card-footer { display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--border-color); padding-top: 16px; }
        .total-box { display: flex; align-items: center; gap: 10px; }
        .total-box label { color: #777; font-size: 0.88rem; }
        .total-box price {
            font-size: 1.3rem; font-weight: 800;
            background: linear-gradient(90deg, var(--accent-red), var(--accent-orange));
            -webkit-background-clip: text; background-clip: text; color: transparent;
        }

        .actions-group { display: flex; gap: 10px; }
        .btn { padding: 9px 18px; border-radius: 8px; font-size: 0.85rem; font-weight: 600; cursor: pointer; text-decoration: none; display: flex; align-items: center; gap: 6px; border: none; transition: all 0.2s ease; }
        .btn-track { background: rgba(231, 76, 60, 0.12); color: var(--accent-red); }
        .btn-track:hover { background: linear-gradient(90deg, var(--accent-red), var(--accent-orange)); color: white; transform: translateY(-2px); box-shadow: 0 6px 16px rgba(231,76,60,0.35); }
        .btn-cancel { background: transparent; color: #777; border: 1px solid var(--border-color); }
        .btn-cancel:hover { background: var(--accent-red); color: white; border-color: var(--accent-red); transform: translateY(-2px); }

        .empty-state {
            text-align: center; padding: 70px 20px; background: var(--card-bg); border-radius: 14px;
            border: 1px solid var(--border-color); animation: fadeSlideUp 0.5s ease both;
        }
        .empty-state i { font-size: 3rem; color: var(--accent-red); margin-bottom: 18px; }
        .empty-state h3 { font-size: 1.3rem; margin-bottom: 6px; }
        .empty-state p { color: var(--text-muted); }
    </style>
</head>
<body>

    <header>
        <h1>Food<span>Hub</span></h1>
        <nav>
            <a href="home">Home</a>
            <a href="RestaurantServlet">Restaurants</a>
            <a href="cart.jsp">Cart</a>
            <div class="user-badge">
                <i class="fa-solid fa-user"></i>
                <%= loggedInUser.getUsername() %>
            </div>
        </nav>
    </header>

    <div class="container">
        <div class="page-header">
            <h1>Order History</h1>
            <p>Track and manage all your past orders.</p>
        </div>

        <c:choose>
            <c:when test="${not empty orderList}">
                <c:forEach var="order" items="${orderList}" varStatus="orderLoop">
                    <div class="order-card" style="animation-delay: ${orderLoop.index * 0.07}s;">
                        <div class="card-header">
                            <div class="order-meta">
                                <h3>Order #${order.id}</h3>
                                <span><fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" /></span>
                            </div>
                            <c:choose>
                                <c:when test="${order.status == 'PENDING'}">
                                    <div class="status-tag status-pending"><i class="fa-solid fa-hourglass-half"></i> Pending</div>
                                </c:when>
                                <c:when test="${order.status == 'OUT_FOR_DELIVERY'}">
                                    <div class="status-tag status-out"><i class="fa-solid fa-motorcycle"></i> Out for Delivery</div>
                                </c:when>
                                <c:when test="${order.status == 'DELIVERED'}">
                                    <div class="status-tag status-delivered"><i class="fa-solid fa-check"></i> Delivered</div>
                                </c:when>
                                <c:when test="${order.status == 'CANCELLED'}">
                                    <div class="status-tag status-cancelled"><i class="fa-solid fa-ban"></i> Cancelled</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="status-tag status-pending">${order.status}</div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="card-body-grid">
                            <div class="info-group"><h4>Delivery Address</h4><p>${order.deliveryAddress}</p></div>
                            <div class="info-group"><h4>Payment Mode</h4><p>${order.paymentMode}</p></div>
                            <div class="info-group"><h4>Status</h4><p>${order.status}</p></div>
                        </div>

                        <div class="order-items-list">
                            <h4>Items Ordered</h4>
                            <c:forEach var="item" items="${itemsByOrderId[order.id]}">
                                <div class="order-item-row">
                                    <span>${item.itemName} &times; ${item.quantity}</span>
                                    <span>&#8377;${item.price * item.quantity}</span>
                                </div>
                            </c:forEach>
                            <c:if test="${empty itemsByOrderId[order.id]}">
                                <p class="order-item-empty">Item details not available.</p>
                            </c:if>
                        </div>

                        <div class="card-footer">
                            <div class="total-box">
                                <label>Total Amount:</label>
                                <price>₹${order.totalAmount}</price>
                            </div>
                            <div class="actions-group">
                                <a href="${pageContext.request.contextPath}/trackOrder?orderId=${order.id}" class="btn btn-track">
                                    <i class="fa-solid fa-location-crosshairs"></i> Track Live
                                </a>
                                <c:if test="${order.status == 'PENDING'}">
                                    <form action="cancelOrder" method="POST" style="display: inline;">
                                        <input type="hidden" name="orderId" value="${order.id}">
                                        <button type="submit" class="btn btn-cancel"><i class="fa-solid fa-ban"></i> Cancel Order</button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fa-solid fa-receipt"></i>
                    <h3>No orders yet</h3>
                    <p>Your past orders will show up here once you place one.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</body>
</html>
