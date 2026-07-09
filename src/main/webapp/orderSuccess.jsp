<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>FoodHub - Order Confirmed</title>
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
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            background-color: var(--bg-color);
            color: var(--text-main);
            font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
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
        nav a { color: var(--text-muted); text-decoration: none; font-weight: 500; transition: color 0.2s ease; }
        nav a:hover { color: var(--accent-red); }

        .confirmation-wrapper {
            max-width: 550px; margin: 90px auto; padding: 50px; background-color: var(--card-bg);
            border-radius: 18px; text-align: center; box-shadow: 0 12px 34px rgba(0,0,0,0.4);
            position: relative; overflow: hidden;
            animation: fadeSlideUp 0.6s ease both;
        }
        @keyframes fadeSlideUp {
            from { opacity: 0; transform: translateY(24px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .confirmation-glow {
            position: absolute; width: 360px; height: 360px; border-radius: 50%;
            background: radial-gradient(circle, rgba(46,196,182,0.18) 0%, rgba(46,196,182,0) 70%);
            top: -140px; left: 50%; transform: translateX(-50%);
            z-index: 0; pointer-events: none;
        }

        .success-icon-circle {
            width: 88px; height: 88px; border-radius: 50%;
            background: linear-gradient(135deg, #f1c27d, var(--accent-orange));
            display: flex; align-items: center; justify-content: center; margin: 0 auto 25px;
            position: relative; z-index: 1;
            box-shadow: 0 0 0 rgba(241, 194, 125, 0.5);
            animation: popIn 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) 0.15s both, pulseRing 2s ease-out 0.6s infinite;
        }
        @keyframes popIn {
            from { transform: scale(0); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }
        @keyframes pulseRing {
            0% { box-shadow: 0 0 0 0 rgba(241, 194, 125, 0.4); }
            70% { box-shadow: 0 0 0 16px rgba(241, 194, 125, 0); }
            100% { box-shadow: 0 0 0 0 rgba(241, 194, 125, 0); }
        }
        .success-icon-circle i { font-size: 2.3rem; color: #121212; }

        .confirmation-wrapper h2 {
            font-size: 1.8rem; margin: 0 0 10px; font-weight: 800; position: relative; z-index: 1;
        }
        .confirmation-wrapper p { color: var(--text-muted); margin: 0 0 28px; position: relative; z-index: 1; }
        .btn-back-home {
            display: inline-block;
            background: linear-gradient(90deg, var(--accent-red), var(--accent-orange));
            color: white; padding: 13px 34px;
            border-radius: 30px; font-weight: 700; text-decoration: none;
            position: relative; z-index: 1;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .btn-back-home:hover { transform: translateY(-2px); box-shadow: 0 10px 26px rgba(231,76,60,0.4); }
    </style>
</head>
<body>

    <header>
        <h1>Food<span>Hub</span></h1>
        <nav><a href="home">Home</a></nav>
    </header>

    <div class="confirmation-wrapper">
        <div class="confirmation-glow"></div>
        <div class="success-icon-circle">
            <i class="fa-solid fa-check"></i>
        </div>
        <h2>Order Confirmed!</h2>
        <p>Your order has been placed successfully.</p>
        <a href="home" class="btn-back-home">Back to Home</a>
    </div>

</body>
</html>
