<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fooddelivery.model.User" %>
<%
    Object userObj = session.getAttribute("user");

    String username = "Guest User";
    String email = "Not Provided";
    String profileImage = null;

    if (userObj != null && userObj instanceof User) {
        User loggedInUser = (User) userObj;
        username = loggedInUser.getUsername();
        email = loggedInUser.getEmail();
        profileImage = loggedInUser.getProfileImage();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | FoodHub</title>
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

        .profile-wrapper {
            max-width: 600px;
            margin: 60px auto;
            padding: 0 20px;
            position: relative;
        }

        .profile-glow {
            position: absolute;
            width: 380px; height: 380px; border-radius: 50%;
            background: radial-gradient(circle, rgba(231,76,60,0.18) 0%, rgba(231,76,60,0) 70%);
            top: -80px; left: 50%; transform: translateX(-50%);
            z-index: 0; pointer-events: none;
            animation: floatGlow 8s ease-in-out infinite;
        }
        @keyframes floatGlow {
            0%, 100% { transform: translateX(-50%) translateY(0) scale(1); }
            50% { transform: translateX(-50%) translateY(14px) scale(1.06); }
        }

        @keyframes fadeSlideUp {
            from { opacity: 0; transform: translateY(22px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .profile-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 40px 30px;
            box-shadow: 0 10px 32px rgba(0,0,0,0.35);
            text-align: center;
            position: relative;
            z-index: 1;
            animation: fadeSlideUp 0.6s ease both;
        }

        .avatar-circle {
            width: 92px;
            height: 92px;
            background-color: rgba(231, 76, 60, 0.1);
            color: var(--accent-red);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin: 0 auto 18px auto;
            border: 3px solid transparent;
            background-image: linear-gradient(var(--card-bg), var(--card-bg)), linear-gradient(135deg, var(--accent-red), var(--accent-orange));
            background-origin: border-box;
            background-clip: padding-box, border-box;
            overflow: hidden;
            box-shadow: 0 6px 20px rgba(231,76,60,0.25);
        }

        .avatar-circle img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }

        .user-heading-name {
            font-size: 1.8rem;
            font-weight: 800;
            margin: 0 0 4px 0;
            color: var(--text-main);
        }

        .user-sub-email {
            font-size: 0.95rem;
            color: var(--text-muted);
            margin: 0 0 30px 0;
        }

        .info-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 35px;
            text-align: left;
        }

        .info-table td {
            padding: 14px 0;
            border-bottom: 1px solid var(--border-color);
            font-size: 0.95rem;
        }

        .label-col {
            color: var(--text-muted);
            font-weight: 400;
            width: 35%;
        }

        .value-col {
            color: var(--text-main);
            font-weight: 500;
            width: 65%;
        }

        .button-group-row {
            display: flex;
            gap: 16px;
        }

        .btn-profile-action {
            flex: 1;
            padding: 12px;
            font-size: 0.95rem;
            font-weight: 600;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
        }

        .btn-primary-red {
            background: linear-gradient(90deg, var(--accent-red), var(--accent-orange));
            color: #ffffff;
            border: none;
        }

        .btn-primary-red:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(231,76,60,0.4);
        }

        .btn-secondary-outline {
            background-color: transparent;
            color: var(--text-main);
            border: 1px solid var(--border-color);
        }

        .btn-secondary-outline:hover {
            background-color: rgba(255,255,255,0.05);
            border-color: var(--accent-red);
            color: var(--accent-red);
            transform: translateY(-2px);
        }
    </style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="profile-wrapper">
        <div class="profile-glow"></div>
        <div class="profile-card">

            <div class="avatar-circle">
                <% if (profileImage != null && !profileImage.isEmpty()) { %>
                    <img src="${pageContext.request.contextPath}/<%= profileImage %>" alt="Profile Photo">
                <% } else { %>
                    <i class="fa-regular fa-user"></i>
                <% } %>
            </div>

            <h1 class="user-heading-name"><%= username %></h1>
            <p class="user-sub-email"><%= email %></p>

            <table class="info-table">
                <tr>
                    <td class="label-col">Full Name</td>
                    <td class="value-col"><%= username %></td>
                </tr>
                <tr>
                    <td class="label-col">Email Address</td>
                    <td class="value-col"><%= email %></td>
                </tr>
            </table>

            <div class="button-group-row">
                <a href="${pageContext.request.contextPath}/editProfile.jsp" class="btn-profile-action btn-primary-red">
                    <i class="fa-regular fa-pen-to-square"></i> Edit Profile
                </a>
                <a href="${pageContext.request.contextPath}/changePassword.jsp" class="btn-profile-action btn-secondary-outline">
                    <i class="fa-solid fa-key"></i> Password
                </a>
            </div>

        </div>
    </div>

</body>
</html>
