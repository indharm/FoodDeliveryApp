<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fooddelivery.model.User" %>
<%@ page import="com.fooddelivery.model.Restaurant" %>
<%@ page import="java.util.List" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    String username = (loggedInUser != null) ? loggedInUser.getUsername() : null;
    String profileImage = (loggedInUser != null) ? loggedInUser.getProfileImage() : null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>FoodHub - Restaurants</title>
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

        /* ---------- Header ---------- */
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
        nav { display: flex; align-items: center; gap: 25px; }
        nav a { color: var(--text-muted); text-decoration: none; margin-left: 0; font-weight: 500; transition: color 0.2s ease; position: relative; }
        nav a:hover, nav a.active { color: var(--accent-red); }
        nav a.active::after {
            content: ''; position: absolute; left: 0; right: 0; bottom: -6px; height: 2px;
            background: linear-gradient(90deg, var(--accent-red), var(--accent-orange)); border-radius: 2px;
        }
        .profile-pill {
            background: linear-gradient(90deg, var(--accent-red), var(--accent-orange));
            color: white !important;
            padding: 6px 18px 6px 6px;
            border-radius: 30px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .profile-pill:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(231,76,60,0.4); }
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

        /* ---------- Page heading ---------- */
        .page-heading {
            max-width: 1300px; margin: 40px auto 0; padding: 0 20px;
            display: flex; justify-content: space-between; align-items: flex-end; flex-wrap: wrap; gap: 16px;
            animation: fadeSlideUp 0.6s ease both;
        }
        @keyframes fadeSlideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .page-heading h2 { font-size: 1.8rem; margin: 0 0 6px; font-weight: 800; }
        .page-heading p { color: var(--text-muted); margin: 0; font-size: 0.92rem; }

        .sort-select {
            background: var(--card-bg); color: var(--text-main); border: 1px solid var(--border-color);
            padding: 9px 14px; border-radius: 8px; font-size: 0.88rem; cursor: pointer;
            transition: border-color 0.2s ease;
        }
        .sort-select:hover { border-color: var(--accent-red); }

        /* ---------- Grid ---------- */
        .restaurant-grid {
            max-width: 1300px; margin: 28px auto 60px; padding: 0 20px;
            display: grid; grid-template-columns: repeat(auto-fill, minmax(230px, 1fr)); gap: 24px;
        }
        .restaurant-card {
            background-color: var(--card-bg); border-radius: 12px; overflow: hidden;
            box-shadow: 0 6px 18px rgba(0,0,0,0.25); position: relative;
            transition: transform 0.25s ease, box-shadow 0.25s ease;
            opacity: 0; animation: cardIn 0.5s ease forwards;
        }
        .restaurant-card:hover { transform: translateY(-6px); box-shadow: 0 16px 34px rgba(0,0,0,0.45); }
        @keyframes cardIn {
            from { opacity: 0; transform: translateY(18px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .card-link { text-decoration: none; color: inherit; display: block; }
        .card-image-wrap { position: relative; width: 100%; height: 140px; overflow: hidden; }
        .card-image-wrap img { width: 100%; height: 100%; object-fit: cover; display: block; transition: transform 0.4s ease; }
        .restaurant-card:hover .card-image-wrap img { transform: scale(1.08); }
        .card-body { padding: 14px; }
        .card-title { font-size: 1rem; font-weight: 700; margin-bottom: 6px; }
        .card-location { font-size: 0.78rem; color: var(--text-muted); margin-bottom: 6px; display: flex; align-items: center; gap: 4px; }
        .card-meta-row { display: flex; justify-content: space-between; align-items: center; font-size: 0.8rem; color: var(--text-muted); }
        .card-rating {
            display: inline-flex; align-items: center; gap: 4px;
            background: linear-gradient(90deg, var(--accent-red), var(--accent-orange));
            color: white;
            padding: 2px 9px; border-radius: 12px; font-size: 0.78rem; font-weight: 700; margin-top: 8px;
        }

        .empty-state {
            max-width: 500px; margin: 100px auto; text-align: center; color: var(--text-muted);
            animation: fadeSlideUp 0.6s ease both;
        }
        .empty-state i { font-size: 2.6rem; color: var(--accent-red); margin-bottom: 14px; display: block; }
    </style>
</head>
<body>

    <header>
        <h1>Food<span>Hub</span></h1>
        <nav>
            <a href="home">Home</a>
            <a href="RestaurantServlet" class="active">Restaurants</a>
            <a href="cart.jsp">Cart</a>
            <% if (username != null) { %>
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
            <% } %>
        </nav>
    </header>

    <%
        String lastSearchQuery = (String) request.getAttribute("lastSearchQuery");
        String currentSort = (String) request.getAttribute("currentSort");
    %>
    <div class="page-heading">
        <div>
            <% if (lastSearchQuery != null && !lastSearchQuery.trim().isEmpty()) { %>
                <h2>Results for "<%= lastSearchQuery %>"</h2>
                <p>Showing restaurants matching your search.</p>
            <% } else { %>
                <h2>Restaurants</h2>
                <p>All restaurants available around your location.</p>
            <% } %>
        </div>

        <form action="search" method="GET">
            <% if (lastSearchQuery != null) { %>
                <input type="hidden" name="query" value="<%= lastSearchQuery %>">
            <% } %>
            <select name="sort" class="sort-select" onchange="this.form.submit()">
                <option value="">Sort by</option>
                <option value="rating" <%= "rating".equals(currentSort) ? "selected" : "" %>>Rating: High to Low</option>
            </select>
        </form>
    </div>

    <%
        List<Restaurant> restaurantList = (List<Restaurant>) request.getAttribute("restaurantList");
    %>

    <% if (restaurantList != null && !restaurantList.isEmpty()) { %>
        <div class="restaurant-grid">
            <% int idx = 0; for (Restaurant r : restaurantList) { idx++; %>
                <div class="restaurant-card" style="animation-delay: <%= (idx * 0.05) %>s;">
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
    <% } else { %>
        <div class="empty-state">
            <i class="fa-solid fa-utensils"></i>
            <p>No restaurants available right now. Please check back later.</p>
        </div>
    <% } %>

</body>
</html>
