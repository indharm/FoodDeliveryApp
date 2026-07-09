<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fooddelivery.model.User" %>
<%@ page import="com.fooddelivery.model.Restaurant" %>
<%@ page import="java.util.List" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    String username = (loggedInUser != null) ? loggedInUser.getUsername() : "Guest";
    String profileImage = (loggedInUser != null) ? loggedInUser.getProfileImage() : null;
    List<Restaurant> popularRestaurants = (List<Restaurant>) request.getAttribute("restaurantList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodHub - Discover the Best Restaurants</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-color: #121212;
            --card-bg: #1a1a1a;
            --text-main: #ffffff;
            --text-muted: #aaaaaa;
            --accent-red: #e74c3c;
            --accent-hover: #c0392b;
            --border-color: #2a2a2a;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            background-color: var(--bg-color);
            color: var(--text-main);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        header { display: flex; justify-content: space-between; align-items: center; padding: 15px 8%; background-color: var(--card-bg); box-shadow: 0 4px 12px rgba(0,0,0,0.5); }
        header h1 { margin: 0; font-size: 1.6rem; }
        header h1 span { color: var(--accent-red); }
        nav { display: flex; align-items: center; gap: 25px; }
        nav a { color: var(--text-muted); text-decoration: none; font-weight: 500; }
        nav a:hover, nav a.active { color: var(--accent-red); }
        .profile-pill {
            background: var(--accent-red);
            color: white !important;
            padding: 6px 18px 6px 6px;
            border-radius: 30px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .profile-pill:hover { background: var(--accent-hover); }
        .profile-avatar {
            width: 26px;
            height: 26px;
            border-radius: 50%;
            object-fit: cover;
            display: block;
        }
        .profile-icon {
            width: 26px;
            height: 26px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
        }
        .signup-pill { background: var(--accent-red); color: white !important; padding: 7px 18px; border-radius: 30px; }

        /* Video Hero Section */
        .hero-video-wrap {
            position: relative;
            width: 100%;
            height: 78vh;
            min-height: 480px;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .hero-video-wrap video {
            position: absolute;
            top: 50%;
            left: 50%;
            min-width: 100%;
            min-height: 100%;
            width: auto;
            height: auto;
            transform: translate(-50%, -50%);
            object-fit: cover;
            z-index: 0;
        }
        .hero-video-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(180deg, rgba(0,0,0,0.55) 0%, rgba(18,18,18,0.75) 60%, rgba(18,18,18,0.95) 100%);
            z-index: 1;
        }
        .hero-video-content {
            position: relative;
            z-index: 2;
            text-align: center;
            padding: 0 20px;
            max-width: 720px;
        }
        .hero-video-content .hero-headline {
            font-size: 2.8rem;
            font-weight: 700;
            margin-bottom: 16px;
            line-height: 1.2;
        }
        .hero-video-content .hero-headline span { color: var(--accent-red); }
        .hero-video-content .hero-subtext {
            color: #eaeaea;
            font-size: 1.05rem;
            line-height: 1.6;
            margin-bottom: 30px;
        }

        .search-box {
            display: flex; background: rgba(26,26,26,0.85); border-radius: 30px; padding: 6px 6px 6px 20px;
            max-width: 520px; margin: 0 auto; align-items: center; border: 1px solid var(--border-color);
            backdrop-filter: blur(4px);
        }
        .search-box input { flex: 1; background: transparent; border: none; outline: none; color: white; font-size: 0.95rem; }
        .search-box input::placeholder { color: #bbb; }
        .search-box button {
            background: var(--accent-red); color: white; border: none; padding: 11px 26px; border-radius: 30px;
            font-weight: 600; cursor: pointer;
        }
        .search-box button:hover { background: var(--accent-hover); }

        .hot-deals-strip {
            max-width: 1300px; margin: -50px auto 0; padding: 0 40px; position: relative; z-index: 3;
        }
        .hot-deals-card {
            background: var(--card-bg); border-radius: 16px; padding: 16px; box-shadow: 0 8px 24px rgba(0,0,0,0.4);
            display: flex; align-items: center; gap: 20px; max-width: 480px; margin-left: auto;
        }
        .hot-deals-card img { width: 100px; height: 100px; object-fit: cover; border-radius: 10px; flex-shrink: 0; }
        .hot-deals-card h3 { margin: 0 0 4px; font-size: 1.05rem; }
        .hot-deals-card p { color: var(--text-muted); font-size: 0.85rem; margin: 0; }

        .popular-section { max-width: 1300px; margin: 60px auto 60px; padding: 0 40px; }
        .popular-section h2 { font-size: 1.6rem; margin-bottom: 6px; }
        .popular-section > p { color: var(--text-muted); margin-bottom: 28px; font-size: 0.92rem; }

        .restaurant-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(230px, 1fr)); gap: 24px; }
        .restaurant-card {
            background: var(--card-bg); border-radius: 12px; overflow: hidden; box-shadow: 0 6px 18px rgba(0,0,0,0.25);
            position: relative; transition: transform 0.2s ease;
        }
        .restaurant-card:hover { transform: translateY(-3px); }
        .card-link { text-decoration: none; color: inherit; display: block; }
        .card-image-wrap { position: relative; width: 100%; height: 140px; }
        .card-image-wrap img { width: 100%; height: 100%; object-fit: cover; display: block; }
        .card-body { padding: 14px; }
        .card-title { font-size: 1rem; font-weight: 700; margin-bottom: 6px; }
        .card-location { font-size: 0.78rem; color: var(--text-muted); margin-bottom: 6px; display: flex; align-items: center; gap: 4px; }
        .card-meta-row { display: flex; justify-content: space-between; align-items: center; font-size: 0.8rem; color: var(--text-muted); }
        .card-rating {
            display: inline-flex; align-items: center; gap: 4px; background: var(--accent-red); color: white;
            padding: 2px 9px; border-radius: 12px; font-size: 0.78rem; font-weight: 600; margin-top: 8px;
        }

        @media (max-width: 768px) {
            .hero-video-wrap { height: 65vh; }
            .hero-video-content .hero-headline { font-size: 2rem; }
            .hot-deals-strip { margin-top: -40px; }
            .hot-deals-card { margin: 0 auto; }
        }
    </style>
</head>
<body>

    <header>
        <h1>Food<span>Hub</span></h1>
        <nav>
            <a href="home" class="active">Home</a>
            <a href="RestaurantServlet">Restaurants</a>
            <a href="cart.jsp">Cart</a>
            <% if (loggedInUser != null) { %>
                <a href="orderHistory">Orders</a>
                <a href="profile.jsp" class="profile-pill">
                    <% if (profileImage != null && !profileImage.isEmpty()) { %>
                        <img src="${pageContext.request.contextPath}/<%= profileImage %>" alt="" class="profile-avatar">
                    <% } else { %>
                        <span class="profile-icon"><i class="fa-regular fa-user"></i></span>
                    <% } %>
                    <%= username %>
                </a>
                <a href="logout">Logout</a>
            <% } else { %>
                <a href="login.jsp">Login</a>
                <a href="register.jsp" class="signup-pill">Sign Up</a>
            <% } %>
        </nav>
    </header>

    <div class="hero-video-wrap">
        <video autoplay muted loop playsinline poster="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1200&q=60">
            <source src="https://assets.mixkit.co/videos/9286/9286-720.mp4" type="video/mp4">
        </video>
        <div class="hero-video-overlay"></div>
        <div class="hero-video-content">
            <h1 class="hero-headline">Discover the Best <span>Restaurants</span> Near You</h1>
            <p class="hero-subtext">Order your favorite food from top-rated restaurants with fast delivery, delicious taste, and a smooth online food ordering experience.</p>

            <form action="search" method="GET" class="search-box">
                <input type="text" name="query" placeholder="Search for restaurant, cuisine or dish">
                <button type="submit">Search</button>
            </form>
        </div>
    </div>

    <div class="hot-deals-strip">
        <div class="hot-deals-card">
            <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=300&q=60" alt="Hot Deals">
            <div>
                <h3>Hot Deals Today</h3>
                <p>Get up to 50% off on selected restaurants.</p>
            </div>
        </div>
    </div>

    <div class="popular-section">
        <h2>Popular Restaurants</h2>
        <p>Choose from the best restaurants available around your location.</p>

        <% if (popularRestaurants != null && !popularRestaurants.isEmpty()) { %>
            <div class="restaurant-grid">
                <% for (Restaurant r : popularRestaurants) { %>
                    <div class="restaurant-card">
                        <a href="MenuServlet?restaurantId=<%= r.getId() %>" class="card-link">
                            <div class="card-image-wrap">
                                <img src="<%= r.getImagePath() %>" alt="<%= r.getName() %>"
                                     onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=400&q=60';">
                            </div>
                            <div class="card-body">
                                <div class="card-title"><%= r.getName() %></div>
                                <div class="card-meta-row">
                                    <span><%= r.getCuisineType() %></span>
                                </div>
                                <% if (r.getLocation() != null && !r.getLocation().isEmpty()) { %>
                                    <div class="card-location">
                                        <i class="fa-solid fa-location-dot"></i> <%= r.getLocation() %>
                                    </div>
                                <% } %>
                                <div class="card-meta-row" style="margin-top: 6px;">
                                    <span><i class="fa-regular fa-clock"></i> <%= r.getDeliveryTime() %> mins</span>
                                    <span><%= r.getCostForTwo() %></span>
                                </div>
                                <span class="card-rating"><i class="fa-solid fa-star"></i> <%= r.getRating() %></span>
                            </div>
                        </a>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

</body>
</html>