<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>FoodHub - Create Account</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #121212;
            --card-bg: #1a1a1a;
            --text-main: #ffffff;
            --text-muted: #aaaaaa;
            --accent-red: #e74c3c;
            --accent-orange: #ff8c42;
            --accent-hover: #c0392b;
            --input-bg: #eef3ff;
            --input-text: #121212;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            background-color: var(--bg-color);
            color: var(--text-main);
            font-family: 'Inter', 'Segoe UI', sans-serif;
            overflow-x: hidden;
        }
        header {
            display: flex; justify-content: space-between; align-items: center; padding: 15px 8%;
            background-color: var(--card-bg); box-shadow: 0 4px 20px rgba(0,0,0,0.5);
        }
        header h1 { margin: 0; font-size: 1.6rem; font-weight: 800; }
        header h1 span {
            background: linear-gradient(90deg, var(--accent-red), var(--accent-orange));
            -webkit-background-clip: text; background-clip: text; color: transparent;
        }
        nav a { color: var(--text-muted); text-decoration: none; margin-left: 25px; transition: color 0.2s ease; }
        nav a:hover { color: var(--accent-red); }

        .wrapper { display: flex; justify-content: center; align-items: center; min-height: 85vh; padding: 30px 0; position: relative; }
        .wrapper-glow {
            position: absolute;
            width: 420px; height: 420px; border-radius: 50%;
            background: radial-gradient(circle, rgba(231,76,60,0.18) 0%, rgba(231,76,60,0) 70%);
            top: 50%; left: 50%; transform: translate(-50%, -50%);
            z-index: 0; pointer-events: none;
            animation: floatGlow 8s ease-in-out infinite;
        }
        @keyframes floatGlow {
            0%, 100% { transform: translate(-50%, -50%) scale(1); }
            50% { transform: translate(-50%, -46%) scale(1.08); }
        }
        @keyframes fadeSlideUp {
            from { opacity: 0; transform: translateY(24px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .card {
            background-color: var(--card-bg); border-radius: 18px; padding: 40px; width: 100%; max-width: 380px;
            box-shadow: 0 16px 40px rgba(0,0,0,0.45); text-align: center;
            position: relative; z-index: 1;
            animation: fadeSlideUp 0.6s ease both;
        }
        .card h2 { font-size: 1.7rem; margin-bottom: 8px; font-weight: 800; }
        .card > p { color: var(--text-muted); margin-bottom: 25px; }

        .form-group { text-align: left; margin-bottom: 20px; }
        .form-group label { display: block; color: var(--text-muted); margin-bottom: 8px; font-size: 0.9rem; }
        .auth-input {
            width: 100%; box-sizing: border-box; background-color: var(--input-bg); color: var(--input-text);
            border: 2px solid transparent; padding: 14px; border-radius: 12px; font-size: 1rem; outline: none;
            transition: box-shadow 0.2s ease, border-color 0.2s ease;
        }
        .auth-input:focus {
            border-color: var(--accent-red);
            box-shadow: 0 0 0 3px rgba(231,76,60,0.2);
        }
        .btn-submit {
            width: 100%;
            background: linear-gradient(90deg, var(--accent-red), var(--accent-orange));
            color: white; border: none; padding: 14px; border-radius: 12px; font-size: 1.05rem; font-weight: 700;
            cursor: pointer; margin-top: 10px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 10px 26px rgba(231,76,60,0.4); }
        .error { color: #ff6b6b; margin-bottom: 15px; font-size: 0.9rem; }
        .auth-footer { margin-top: 22px; color: var(--text-muted); font-size: 0.9rem; }
        .auth-footer a { color: var(--accent-red); text-decoration: none; font-weight: 700; }
        .auth-footer a:hover { color: var(--accent-orange); }
    </style>
</head>
<body>

    <header>
        <h1>Food<span>Hub</span></h1>
        <nav>
            <a href="home">Home</a>
            <a href="login.jsp">Login</a>
        </nav>
    </header>

    <div class="wrapper">
        <div class="wrapper-glow"></div>
        <div class="card">
            <h2>Create Account</h2>
            <p>Join FoodHub and start ordering</p>

            <%
                String error = request.getParameter("error");
                if ("mismatch".equals(error)) {
            %>
                <div class="error">Passwords do not match. Please try again.</div>
            <% } else if ("failed".equals(error)) { %>
                <div class="error">Registration failed. This email may already be in use.</div>
            <% } %>

            <form action="register" method="POST">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="username" class="auth-input" placeholder="John Doe" required>
                </div>

                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" class="auth-input" placeholder="name@email.com" required>
                </div>

                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" class="auth-input" placeholder="••••••••••••" required>
                </div>

                <div class="form-group">
                    <label>Confirm Password</label>
                    <input type="password" name="confirmPassword" class="auth-input" placeholder="••••••••••••" required>
                </div>

                <button type="submit" class="btn-submit">Create Account</button>
            </form>

            <div class="auth-footer">
                Already have an account? <a href="login.jsp">Sign in</a>
            </div>
        </div>
    </div>

</body>
</html>
