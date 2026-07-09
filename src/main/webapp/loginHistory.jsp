<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.fooddelivery.model.LoginHistory" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>FoodHub - Login History</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-deep: #050508;
            --card-glass: rgba(14, 14, 24, 0.75);
            --text-main: #ffffff;
            --text-muted: #9494b0;
            --accent-red: #ff5566;
            --accent-orange: #ff8844;
            --lightning-cyan: #00f3ff;
            --border-color: rgba(255, 255, 255, 0.06);
        }
        
        * { box-sizing: border-box; margin: 0; padding: 0; }
        
        body { 
            background-color: var(--bg-deep); 
            color: var(--text-main); 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            min-height: 100vh;
            overflow-x: hidden;
            position: relative;
        }

        /* Ambient Background Blur Elements */
        body::before {
            content: '';
            position: absolute;
            width: 500px;
            height: 500px;
            top: -10%;
            left: -10%;
            background: radial-gradient(circle, rgba(255, 85, 102, 0.12) 0%, transparent 70%);
            filter: blur(80px);
            z-index: -1;
            pointer-events: none;
        }

        header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            padding: 20px 8%; 
            background-color: rgba(14, 14, 24, 0.4); 
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border-bottom: 1px solid var(--border-color); 
        }
        header h1 { font-family: 'Syne', sans-serif; font-weight: 800; font-size: 1.8rem; letter-spacing: -1px; }
        header h1 span { background: linear-gradient(90deg, var(--accent-red), var(--accent-orange)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        nav a { color: var(--text-muted); text-decoration: none; margin-left: 25px; font-weight: 500; transition: color 0.3s ease; }
        nav a:hover { color: var(--text-main); text-shadow: 0 0 10px rgba(255, 255, 255, 0.3); }
        
        /* CINEMATIC HIGH-ENERGY CONIC LIGHTNING WRAPPER */
        .lightning-container-track {
            max-width: 940px;
            margin: 50px auto;
            position: relative;
            border-radius: 20px;
            padding: 3px;
            overflow: hidden;
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.6);
            display: flex;
        }

        .lightning-container-track::before {
            content: '';
            position: absolute;
            width: 150%;
            height: 300%;
            top: -100%;
            left: -25%;
            background: conic-gradient(
                transparent, 
                var(--accent-red), 
                var(--lightning-cyan), 
                var(--accent-orange), 
                transparent 30%
            );
            animation: lightningRotate 5s linear infinite;
            z-index: 0;
        }

        @keyframes lightningRotate {
            100% { transform: rotate(360deg); }
        }

        .container { 
            width: 100%;
            padding: 35px; 
            background: var(--card-glass); 
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border-radius: 18px; 
            position: relative;
            z-index: 1;
        }
        
        h2 { 
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            border-bottom: 1px solid var(--border-color); 
            padding-bottom: 20px; 
            margin-top: 0; 
            font-size: 1.6rem;
            display: flex;
            align-items: center;
        }
        
        .table-responsive-wrapper {
            width: 100%;
            overflow-x: auto;
            margin-top: 15px;
        }

        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 16px 20px; text-align: left; border-bottom: 1px solid var(--border-color); transition: background-color 0.25s ease; }
        th { color: var(--text-muted); font-weight: 600; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 0.5px; }
        
        tbody tr { transition: all 0.2s ease; }
        tbody tr:hover { background-color: rgba(255, 255, 255, 0.02); }
        tbody tr:hover td { color: #ffffff; }
        
        .user-id-code { 
            font-family: monospace; 
            background: rgba(0, 243, 255, 0.06); 
            border: 1px solid rgba(0, 243, 255, 0.15);
            color: var(--lightning-cyan); 
            padding: 4px 10px; 
            border-radius: 6px; 
            font-weight: bold;
            font-size: 0.9rem;
            text-shadow: 0 0 8px rgba(0, 243, 255, 0.2);
        }

        .user-name-cell {
            font-weight: 600;
            color: rgba(255, 255, 255, 0.95);
        }

        .time-cell {
            color: var(--text-muted);
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

    <header>
        <h1>Food<span>Hub</span></h1>
        <nav>
            <a href="home">Home</a>
            <a href="MenuServlet">Menus</a>
        </nav>
    </header>

    <!-- Wrapped within high-energy dynamic tracking line -->
    <div class="lightning-container-track">
        <div class="container">
            <h2>
                <i class="fa-solid fa-clock-rotate-left" style="background: linear-gradient(90deg, var(--accent-red), var(--accent-orange)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-right: 12px;"></i> 
                User Login Audit History
            </h2>
            
            <div class="table-responsive-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>User ID</th>
                            <th>Profile Name</th>
                            <th>Email Address</th>
                            <th>Login Time</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<LoginHistory> historyList = (List<LoginHistory>) request.getAttribute("historyList");
                            if (historyList != null && !historyList.isEmpty()) {
                                for (LoginHistory log : historyList) {
                        %>
                            <tr>
                                <td><span class="user-id-code">#<%= log.getUserId() %></span></td>
                                <td class="user-name-cell"><%= log.getUsername() %></td>
                                <td><%= log.getEmail() %></td>
                                <td class="time-cell"><i class="fa-regular fa-calendar-check" style="margin-right: 6px; color: var(--accent-orange); opacity: 0.7;"></i> <%= log.getLoginTime() %></td>
                            </tr>
                        <% 
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="4" style="text-align: center; color: var(--text-muted); padding: 50px; font-weight: 500;">
                                    <i class="fa-solid fa-shield-halved" style="display: block; font-size: 2rem; margin-bottom: 12px; opacity: 0.3;"></i>
                                    No login tracking data captured yet.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</body>
</html>