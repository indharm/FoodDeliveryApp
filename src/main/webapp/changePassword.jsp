<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password | FoodHub</title>
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
        .wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 85vh;
            padding: 40px 20px;
            position: relative;
        }
        .wrapper-glow {
            position: absolute;
            width: 340px; height: 340px; border-radius: 50%;
            background: radial-gradient(circle, rgba(231,76,60,0.16) 0%, rgba(231,76,60,0) 70%);
            top: 30%; left: 50%; transform: translate(-50%, -50%);
            z-index: 0; pointer-events: none;
        }
        @keyframes fadeSlideUp {
            from { opacity: 0; transform: translateY(22px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 40px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.35);
            position: relative;
            z-index: 1;
            animation: fadeSlideUp 0.55s ease both;
        }
        .card-header {
            text-align: center;
            margin-bottom: 28px;
        }
        .card-header i {
            font-size: 1.9rem;
            background: linear-gradient(135deg, var(--accent-red), var(--accent-orange));
            -webkit-background-clip: text; background-clip: text; color: transparent;
            margin-bottom: 10px;
            display: inline-block;
        }
        .card-header h1 {
            font-size: 1.55rem;
            font-weight: 800;
        }
        .card-header p {
            color: var(--text-muted);
            font-size: 0.88rem;
            margin-top: 6px;
        }
        .status-msg {
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 0.88rem;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .status-msg.error {
            background: rgba(231, 76, 60, 0.1);
            border: 1px solid rgba(231, 76, 60, 0.3);
            color: #ff6b6b;
        }
        .status-msg.success {
            background: rgba(46, 196, 182, 0.1);
            border: 1px solid rgba(46, 196, 182, 0.3);
            color: #2ec4b6;
        }
        .form-group { margin-bottom: 20px; }
        .form-group label {
            display: block;
            font-size: 0.88rem;
            font-weight: 500;
            color: var(--text-muted);
            margin-bottom: 8px;
        }
        .form-control {
            width: 100%;
            background: var(--input-bg);
            color: var(--input-text);
            border: 2px solid transparent;
            border-radius: 10px;
            padding: 13px 14px;
            font-size: 0.95rem;
            outline: none;
            transition: box-shadow 0.2s ease, border-color 0.2s ease;
        }
        .form-control:focus {
            border-color: var(--accent-red);
            box-shadow: 0 0 0 3px rgba(231,76,60,0.18);
        }
        .btn-submit {
            width: 100%;
            background: linear-gradient(90deg, var(--accent-red), var(--accent-orange));
            color: #ffffff;
            border: none;
            border-radius: 10px;
            padding: 14px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            margin-top: 6px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 10px 24px rgba(231,76,60,0.4); }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.88rem;
            transition: color 0.2s ease;
        }
        .back-link:hover { color: var(--accent-red); }
    </style>
</head>
<body>

    <jsp:include page="/navbar.jsp" />

    <div class="wrapper">
        <div class="wrapper-glow"></div>
        <div class="card">
            <div class="card-header">
                <i class="fa-solid fa-key"></i>
                <h1>Change Password</h1>
                <p>Update your account password</p>
            </div>

            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="status-msg error">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    <span><%= request.getAttribute("errorMessage") %></span>
                </div>
            <% } %>

            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="status-msg success">
                    <i class="fa-solid fa-circle-check"></i>
                    <span><%= request.getAttribute("successMessage") %></span>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/ChangePasswordServlet" method="post">

                <div class="form-group">
                    <label for="oldPassword">Current Password</label>
                    <input type="password" id="oldPassword" name="oldPassword" class="form-control" placeholder="Enter current password" required>
                </div>

                <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" class="form-control" placeholder="Enter new password" required>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm New Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Re-enter new password" required>
                </div>

                <button type="submit" class="btn-submit">Update Password</button>

                <a href="${pageContext.request.contextPath}/profile.jsp" class="back-link">
                    <i class="fa-solid fa-arrow-left"></i> Back to Profile
                </a>
            </form>
        </div>
    </div>

</body>
</html>
