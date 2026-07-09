<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fooddelivery.model.User" %>
<%
    User navUser = (User) session.getAttribute("user");
    String navUsername = (navUser != null) ? navUser.getUsername() : null;
    String navProfileImage = (navUser != null) ? navUser.getProfileImage() : null;
%>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
    .global-nav {
        background: #1a1a1a;
        padding: 15px 8%;
        border-bottom: none;
        box-shadow: 0 4px 20px rgba(0,0,0,0.5);
        font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        position: sticky;
        top: 0;
        z-index: 200;
    }
    .nav-container {
        max-width: 1300px;
        margin: 0 auto;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .brand-logo {
        font-weight: 800;
        font-size: 1.6rem;
        color: #ffffff;
        text-decoration: none;
        letter-spacing: normal;
    }
    .brand-logo span {
        background: linear-gradient(90deg, #e74c3c, #ff8c42);
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
    }
    .nav-links {
        display: flex;
        align-items: center;
        gap: 25px;
        list-style: none;
    }
    .nav-link {
        color: #aaaaaa;
        text-decoration: none;
        font-weight: 500;
        font-size: 0.95rem;
        transition: color 0.2s ease;
        position: relative;
    }
    .nav-link:hover {
        color: #e74c3c;
    }
    .nav-profile {
        background: linear-gradient(90deg, #e74c3c, #ff8c42);
        color: #ffffff;
        text-decoration: none;
        font-weight: 600;
        font-size: 0.9rem;
        padding: 6px 18px 6px 6px;
        border-radius: 30px;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: transform 0.2s ease, box-shadow 0.2s ease;
    }
    .nav-profile:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(231,76,60,0.4);
        color: #ffffff;
    }
    .nav-profile-avatar {
        width: 26px;
        height: 26px;
        border-radius: 50%;
        object-fit: cover;
        display: block;
    }
    .nav-profile-icon {
        width: 26px;
        height: 26px;
        border-radius: 50%;
        background: rgba(255,255,255,0.2);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 0.8rem;
    }
    .nav-login-btn {
        border: 1px solid #2a2a2a;
        color: #ffffff;
        padding: 8px 16px;
        border-radius: 6px;
        text-decoration: none;
        font-weight: 500;
        font-size: 0.9rem;
        transition: all 0.2s ease;
    }
    .nav-login-btn:hover {
        background: linear-gradient(90deg, #e74c3c, #ff8c42);
        border-color: transparent;
        transform: translateY(-2px);
    }
</style>

<nav class="global-nav">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/home" class="brand-logo">Food<span>Hub</span></a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/home" class="nav-link">Home</a>
            <a href="${pageContext.request.contextPath}/RestaurantServlet" class="nav-link">Restaurants</a>
            <a href="${pageContext.request.contextPath}/cart.jsp" class="nav-link">Cart</a>
            <% if (navUsername != null) { %>
                <a href="${pageContext.request.contextPath}/profile.jsp" class="nav-profile">
                    <% if (navProfileImage != null && !navProfileImage.isEmpty()) { %>
                        <img src="${pageContext.request.contextPath}/<%= navProfileImage %>" alt="" class="nav-profile-avatar">
                    <% } else { %>
                        <span class="nav-profile-icon"><i class="fa-regular fa-user"></i></span>
                    <% } %>
                    <%= navUsername %>
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="nav-link" style="color: #e74c3c;">Logout</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/login.jsp" class="nav-login-btn">Log in</a>
            <% } %>
        </div>
    </div>
</nav>
