<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Search Dishes - FoodHub</title>
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
            --border-color: #2a2a2a;
            --input-bg: #eef3ff;
            --input-text: #121212;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Inter', 'Segoe UI', sans-serif;
            background: var(--bg-color);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
            position: relative;
        }

        /* Ambient glow, matching the rest of the app's hero/profile treatment */
        body::before {
            content: '';
            position: absolute;
            width: 560px;
            height: 560px;
            top: -8%;
            left: 50%;
            transform: translateX(-50%);
            border-radius: 50%;
            background: radial-gradient(circle, rgba(231,76,60,0.14) 0%, transparent 70%);
            filter: blur(60px);
            animation: cloudFloat 12s infinite alternate ease-in-out;
            pointer-events: none;
            z-index: -1;
        }

        @keyframes cloudFloat {
            0% { transform: translateX(-50%) translateY(0) scale(1); }
            100% { transform: translateX(-46%) translateY(-24px) scale(1.08); }
        }

        .search-wrap { max-width: 1200px; width: 100%; margin: 70px auto 80px; padding: 0 24px; flex: 1; position: relative; z-index: 1; }

        .search-heading {
            font-weight: 800;
            font-size: 2.4rem;
            text-align: center;
            margin-bottom: 32px;
        }

        /* Search track with rotating gradient ring, in-theme colors */
        .lightning-search-wrapper {
            position: relative;
            max-width: 610px;
            margin: 0 auto;
            padding: 3px;
            border-radius: 24px;
            overflow: hidden;
            display: flex;
            background: rgba(255, 255, 255, 0.01);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
            transition: all 0.3s ease;
        }

        .lightning-search-wrapper::before {
            content: '';
            position: absolute;
            width: 160%;
            height: 300%;
            top: -100%; left: -30%;
            background: conic-gradient(
                transparent,
                var(--accent-red),
                var(--accent-orange),
                transparent 45%
            );
            animation: lightningSpin 4s linear infinite;
            z-index: 0;
            opacity: 0.55;
            transition: opacity 0.3s ease;
        }

        .lightning-search-wrapper:focus-within::before {
            animation-duration: 2s;
            opacity: 1;
        }

        .lightning-search-wrapper:focus-within {
            box-shadow: 0 0 30px rgba(231, 76, 60, 0.25);
            transform: translateY(-2px);
        }

        @keyframes lightningSpin {
            100% { transform: rotate(360deg); }
        }

        .search-form {
            position: relative;
            z-index: 1;
            width: 100%;
            display: flex;
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            padding: 8px 8px 8px 22px;
            border-radius: 21px;
            align-items: center;
        }

        .search-form i.fa-magnifying-glass {
            font-size: 1.15rem;
            color: var(--text-muted);
            transition: color 0.3s ease;
        }

        .lightning-search-wrapper:focus-within i.fa-magnifying-glass {
            color: var(--accent-orange) !important;
            filter: drop-shadow(0 0 8px rgba(255,140,66,0.6));
        }

        .search-input {
            border: none;
            outline: none;
            width: 100%;
            font-family: inherit;
            font-size: 1.1rem;
            padding-left: 12px;
            background: transparent;
            color: var(--text-main);
            font-weight: 600;
        }
        .search-input::placeholder { color: #777; }

        .search-submit-btn {
            position: relative;
            background: linear-gradient(135deg, var(--accent-red), var(--accent-orange));
            color: white;
            border: none;
            padding: 14px 32px;
            border-radius: 16px;
            font-weight: 700;
            font-size: 1.05rem;
            cursor: pointer;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(231, 76, 60, 0.3);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .search-submit-btn:hover {
            transform: scale(1.02);
            box-shadow: 0 6px 20px rgba(231, 76, 60, 0.5);
        }

        /* Click ripple, recolored to match theme */
        .shockwave-burst {
            position: absolute;
            background: radial-gradient(circle, rgba(255, 140, 66, 0.6) 0%, transparent 70%);
            border-radius: 50%;
            pointer-events: none;
            transform: translate(-50%, -50%);
            animation: popOpen 0.5s ease-out forwards;
        }

        @keyframes popOpen {
            0% { width: 0px; height: 0px; opacity: 1; }
            100% { width: 400px; height: 400px; opacity: 0; }
        }
    </style>
</head>
<body>
<jsp:include page="/navbar.jsp" />

<div class="search-wrap">
    <h1 class="search-heading">Find Your Next Favorite Bite</h1>

    <div class="lightning-search-wrapper">
        <form action="${pageContext.request.contextPath}/search" method="GET" class="search-form">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input type="text" name="query" class="search-input" placeholder="Search for food items..." value="${param.query}" required />
            <button type="submit" class="search-submit-btn">Search</button>
        </form>
    </div>
</div>

<jsp:include page="/footer.jsp" />

<script>
    // Click ripple handler, recolored to match theme
    document.querySelector('.search-submit-btn').addEventListener('click', function(e) {
        const spark = document.createElement('div');
        spark.className = 'shockwave-burst';

        const rect = this.getBoundingClientRect();
        spark.style.left = `${e.clientX - rect.left}px`;
        spark.style.top = `${e.clientY - rect.top}px`;

        this.appendChild(spark);
        setTimeout(() => spark.remove(), 500);
    });
</script>
</body>
</html>
