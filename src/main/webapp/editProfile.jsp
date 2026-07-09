<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fooddelivery.model.User" %>
<%
    Object userObj = session.getAttribute("user");

    if (userObj == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    User loggedInUser = (User) userObj;
    String username = loggedInUser.getUsername();
    String email = loggedInUser.getEmail();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile | FoodHub</title>
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
            --input-bg: #eef3ff;
            --input-text: #121212;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            background-color: var(--bg-color);
            color: var(--text-main);
            font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow-x: hidden;
        }
        .profile-wrapper {
            max-width: 550px;
            margin: 60px auto;
            padding: 0 20px;
            position: relative;
        }
        .profile-glow {
            position: absolute;
            width: 340px; height: 340px; border-radius: 50%;
            background: radial-gradient(circle, rgba(231,76,60,0.16) 0%, rgba(231,76,60,0) 70%);
            top: -60px; left: 50%; transform: translateX(-50%);
            z-index: 0; pointer-events: none;
        }
        @keyframes fadeSlideUp {
            from { opacity: 0; transform: translateY(22px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .profile-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 35px 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.35);
            position: relative;
            z-index: 1;
            animation: fadeSlideUp 0.55s ease both;
        }
        .card-title {
            font-size: 1.5rem;
            font-weight: 800;
            margin: 0 0 25px 0;
            color: var(--text-main);
            text-align: center;
        }
        .form-group { margin-bottom: 20px; }
        .form-group label {
            display: block;
            font-size: 0.9rem;
            font-weight: 500;
            color: var(--text-muted);
            margin-bottom: 8px;
        }
        .form-control {
            width: 100%;
            padding: 12px;
            font-size: 0.95rem;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            box-sizing: border-box;
            font-family: inherit;
            color: var(--input-text);
            background-color: var(--input-bg);
            transition: box-shadow 0.2s ease, border-color 0.2s ease;
        }
        .form-control:focus {
            outline: none;
            border-color: var(--accent-red);
            box-shadow: 0 0 0 3px rgba(231,76,60,0.18);
        }
        .form-control:disabled {
            background-color: #d8d8d8;
            color: #777777;
            cursor: not-allowed;
        }
        .button-group-row {
            display: flex;
            gap: 16px;
            margin-top: 30px;
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
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .btn-primary-red {
            background: linear-gradient(90deg, var(--accent-red), var(--accent-orange));
            color: #ffffff;
            border: none;
        }
        .btn-primary-red:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(231,76,60,0.4); }
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
            <h2 class="card-title">Update Personal Details</h2>

            <form action="${pageContext.request.contextPath}/updateProfile" method="POST" enctype="multipart/form-data">

                <div class="form-group">
                    <label for="username">Full Name</label>
                    <input type="text" id="username" name="username" class="form-control" value="<%= username %>" required>
                </div>

                <div class="form-group">
                    <label for="email">Email Address (Primary Key ID)</label>
                    <input type="email" id="email" class="form-control" value="<%= email %>" disabled>
                    <input type="hidden" name="email" value="<%= email %>">
                </div>

                <div class="form-group">
                    <label for="profileImage">Profile Photo</label>
                    <input type="file" id="profileImage" name="profileImage" class="form-control" accept="image/*">
                </div>

                <div class="button-group-row">
                    <a href="profile.jsp" class="btn-profile-action btn-secondary-outline">Cancel</a>
                    <button type="submit" class="btn-profile-action btn-primary-red">
                        <i class="fa-regular fa-floppy-disk"></i> Save Changes
                    </button>
                </div>

            </form>
        </div>
    </div>

</body>
</html>
