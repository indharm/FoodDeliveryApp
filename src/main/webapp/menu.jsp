<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.fooddelivery.model.Menu" %>
<%@ page import="com.fooddelivery.model.Restaurant" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurant Menu | FoodHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --bg-color: #121212;
            --card-bg: #1a1a1a;
            --text-main: #ffffff;
            --text-muted: #aaaaaa;
            --accent-red: #e74c3c;
            --border-color: #2a2a2a;
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            padding: 0;
            background-color: var(--bg-color);
            color: var(--text-main);
            font-family: 'Inter', sans-serif;
            scroll-behavior: smooth;
        }

        .simple-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 8%;
            background-color: var(--card-bg);
            box-shadow: 0 4px 12px rgba(0,0,0,0.5);
        }
        .simple-nav .brand-logo {
            font-weight: 700;
            font-size: 1.6rem;
            color: var(--text-main);
            text-decoration: none;
        }
        .simple-nav .brand-logo span { color: var(--accent-red); }
        .simple-nav .nav-links { display: flex; align-items: center; gap: 25px; }
        .simple-nav .nav-links a {
            color: var(--text-muted);
            text-decoration: none;
            font-weight: 500;
            font-size: 0.95rem;
        }
        .simple-nav .nav-links a:hover { color: var(--accent-red); }

        .menu-container {
            max-width: 850px;
            margin: 20px auto 60px auto;
            padding: 0 20px;
        }

        .page-heading {
            padding: 20px 0 10px;
        }
        .page-heading h1 {
            font-size: 1.7rem;
            font-weight: 700;
            margin: 0 0 4px;
        }
        .page-heading p {
            color: var(--text-muted);
            margin: 0;
            font-size: 0.92rem;
        }

        .zomato-filter-bar {
            position: sticky;
            top: 0;
            background-color: rgba(18, 18, 18, 0.96);
            backdrop-filter: blur(10px);
            z-index: 100;
            padding: 16px 0;
            margin-bottom: 30px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            gap: 12px;
            overflow-x: auto;
            white-space: nowrap;
        }
        .zomato-filter-bar::-webkit-scrollbar { display: none; }

        .filter-pill {
            background: var(--card-bg);
            color: var(--text-muted);
            border: 1px solid var(--border-color);
            padding: 8px 18px;
            border-radius: 8px;
            font-size: 0.88rem;
            font-weight: 500;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease-in-out;
        }
        .filter-pill:hover {
            border-color: var(--text-muted);
            color: var(--text-main);
        }
        .filter-pill.active {
            background: rgba(231, 76, 60, 0.15);
            color: var(--accent-red);
            border-color: var(--accent-red);
            font-weight: 600;
        }

        .bar-separator {
            width: 1px;
            background: var(--border-color);
            align-self: stretch;
            margin: 2px 4px;
        }

        .category-block {
            margin-bottom: 35px;
            background: var(--card-bg);
            border-radius: 12px;
            padding: 25px;
            border: 1px solid var(--border-color);
        }

        .category-heading {
            font-size: 1.35rem;
            font-weight: 700;
            color: var(--text-main);
            margin-top: 0;
            margin-bottom: 20px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 10px;
        }

        .menu-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 0;
            border-bottom: 1px solid #222222;
        }
        .menu-row:last-child { border-bottom: none; }

        .item-meta {
            flex: 1;
            padding-right: 25px;
        }

        .item-title {
            font-size: 1.15rem;
            font-weight: 600;
            margin: 0 0 6px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .food-indicator {
            font-size: 0.75rem;
            padding: 2px 6px;
            border-radius: 4px;
            font-weight: 700;
            text-transform: uppercase;
        }
        .veg-tag {
            border: 1px solid #257D3D;
            color: #2baf53;
            background: rgba(37, 125, 61, 0.1);
        }
        .nonveg-tag {
            border: 1px solid #C83232;
            color: #ff4d4d;
            background: rgba(200, 50, 50, 0.1);
        }

        .item-price {
            font-size: 1.05rem;
            font-weight: 600;
            color: var(--text-main);
            margin: 0 0 8px 0;
        }

        .item-desc {
            font-size: 0.88rem;
            color: var(--text-muted);
            margin: 0;
            line-height: 1.5;
        }

        .btn-add {
            background-color: var(--card-bg);
            color: var(--accent-red);
            border: 1px solid var(--accent-red);
            padding: 8px 28px;
            font-size: 0.9rem;
            font-weight: 700;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-add:hover {
            background-color: var(--accent-red);
            color: var(--text-main);
        }
        
        .empty-state-box {
            text-align: center; 
            padding: 60px 20px;
            background-color: var(--card-bg);
            border-radius: 12px;
            border: 1px solid var(--border-color);
        }
    </style>
</head>
<body>

    <nav class="simple-nav">
        <a href="${pageContext.request.contextPath}/home" class="brand-logo">Food<span>Hub</span></a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <a href="${pageContext.request.contextPath}/RestaurantServlet">Restaurants</a>
            <a href="${pageContext.request.contextPath}/cart.jsp">Cart</a>
        </div>
    </nav>

    <div class="menu-container">

        <%
            Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
        %>
        <div class="page-heading">
            <h1><%= (restaurant != null) ? restaurant.getName() : "Restaurant Menu" %></h1>
            <p><%= (restaurant != null && restaurant.getCuisineType() != null) ? restaurant.getCuisineType() : "Choose your favorite dishes and add them to your cart." %></p>
        </div>
        
        <%
            List<Menu> menuItems = (List<Menu>) request.getAttribute("menuItems");
            if (menuItems == null || menuItems.isEmpty()) {
        %>
            <div class="empty-state-box">
                <i class="fa-solid fa-utensils" style="font-size: 3rem; color: var(--accent-red); margin-bottom: 15px;"></i>
                <h3>No options available for this restaurant ID right now.</h3>
                <a href="RestaurantServlet" class="btn-add" style="text-decoration:none; display:inline-block; margin-top:15px;">Back to Restaurants</a>
            </div>
        <%
            } else {
                String[] knownCategories = {"Starters", "Main Course", "Desserts", "Beverages"};
                String[] categories = {"Starters", "Main Course", "Desserts", "Beverages", "Other"};
        %>
            <div class="zomato-filter-bar">
                <button class="filter-pill active" onclick="applyVegFilter('all', this)"><i class="fa-solid fa-utensils"></i> All</button>
                <button class="filter-pill" onclick="applyVegFilter('veg', this)"><i class="fa-solid fa-circle-stop" style="color:#2baf53;"></i> Pure Veg</button>
                <button class="filter-pill" onclick="applyVegFilter('nonveg', this)"><i class="fa-solid fa-square-caret-up" style="color:#ff4d4d;"></i> Non-Veg</button>
                
                <div class="bar-separator"></div>
                
                <% 
                    for (String section : categories) {
                        boolean sectionPopulated = false;
                        for (Menu item : menuItems) {
                            String itemCat = (item.getCategory() != null && !item.getCategory().trim().isEmpty())
                                    ? item.getCategory().trim() : "Other";
                            boolean isKnown = false;
                            for (String c : knownCategories) {
                                if (c.equalsIgnoreCase(itemCat)) { isKnown = true; break; }
                            }
                            String effectiveCat = isKnown ? itemCat : "Other";
                            if (section.equalsIgnoreCase(effectiveCat)) {
                                sectionPopulated = true; break;
                            }
                        }
                        if (sectionPopulated) {
                %>
                        <button class="filter-pill" onclick="jumpToSection('sec-<%= section.toLowerCase().replace(" ", "-") %>')"><%= section %></button>
                <% 
                        }
                    }
                %>
            </div>

        <%
                for (String currentCategory : categories) {
                    boolean hasItems = false;
                    for (Menu item : menuItems) {
                        String itemCat = (item.getCategory() != null && !item.getCategory().trim().isEmpty())
                                ? item.getCategory().trim() : "Other";
                        boolean isKnown = false;
                        for (String c : knownCategories) {
                            if (c.equalsIgnoreCase(itemCat)) { isKnown = true; break; }
                        }
                        String effectiveCat = isKnown ? itemCat : "Other";
                        if (currentCategory.equalsIgnoreCase(effectiveCat)) {
                            hasItems = true; break;
                        }
                    }
                    
                    if (hasItems) {
        %>
                    <div class="category-block" id="sec-<%= currentCategory.toLowerCase().replace(" ", "-") %>">
                        <h2 class="category-heading"><%= currentCategory %></h2>
                        
                        <% 
                            for (Menu item : menuItems) { 
                                String itemCat = (item.getCategory() != null && !item.getCategory().trim().isEmpty())
                                        ? item.getCategory().trim() : "Other";
                                boolean isKnown = false;
                                for (String c : knownCategories) {
                                    if (c.equalsIgnoreCase(itemCat)) { isKnown = true; break; }
                                }
                                String effectiveCat = isKnown ? itemCat : "Other";
                                if (currentCategory.equalsIgnoreCase(effectiveCat)) {
                                    
                                    String name = item.getItemName().toLowerCase();
                                    String desc = (item.getDescription() != null) ? item.getDescription().toLowerCase() : "";
                                    boolean isNonVeg = name.contains("chicken") || name.contains("kebab") || name.contains("65") || name.contains("pepperoni") || name.contains("meat") || desc.contains("chicken");
                        %>
                                <div class="menu-row <%= isNonVeg ? "item-nonveg" : "item-veg" %>">
                                    <div class="item-meta">
                                        <h3 class="item-title">
                                            <% if (isNonVeg) { %>
                                                <span class="food-indicator nonveg-tag"><i class="fa-solid fa-square-caret-up"></i> Non-Veg</span>
                                            <% } else { %>
                                                <span class="food-indicator veg-tag"><i class="fa-solid fa-circle-stop"></i> Veg</span>
                                            <% } %>
                                            <%= item.getItemName() %>
                                        </h3>
                                        <p class="item-price">₹<%= (int)item.getPrice() %></p>
                                        <p class="item-desc"><%= (item.getDescription() != null) ? item.getDescription() : "Freshly prepared signature dish served hot." %></p>
                                    </div>
                                    <div>
                                        <form action="${pageContext.request.contextPath}/cart" method="POST">
                                            <input type="hidden" name="itemId" value="<%= item.getId() %>">
                                            <input type="hidden" name="action" value="add">
                                            <button type="submit" class="btn-add">ADD</button>
                                        </form>
                                    </div>
                                </div>
                        <% 
                                }
                            } 
                        %>
                    </div>
        <% 
                    }
                }
            } 
        %>
    </div>

    <script>
        function applyVegFilter(filterType, button) {
            document.querySelectorAll('.zomato-filter-bar .filter-pill').forEach(el => el.classList.remove('active'));
            button.classList.add('active');

            const vegRows = document.querySelectorAll('.menu-row.item-veg');
            const nonVegRows = document.querySelectorAll('.menu-row.item-nonveg');
            const blocks = document.querySelectorAll('.category-block');

            if (filterType === 'all') {
                document.querySelectorAll('.menu-row').forEach(r => r.style.display = 'flex');
                blocks.forEach(b => b.style.display = 'block');
            } else if (filterType === 'veg') {
                vegRows.forEach(r => r.style.display = 'flex');
                nonVegRows.forEach(r => r.style.display = 'none');
                evaluateBlocks();
            } else if (filterType === 'nonveg') {
                vegRows.forEach(r => r.style.display = 'none');
                nonVegRows.forEach(r => r.style.display = 'flex');
                evaluateBlocks();
            }
        }

        function evaluateBlocks() {
            document.querySelectorAll('.category-block').forEach(b => {
                const hiddenRows = Array.from(b.querySelectorAll('.menu-row')).filter(r => r.style.display !== 'none');
                b.style.display = hiddenRows.length === 0 ? 'none' : 'block';
            });
        }

        function jumpToSection(targetId) {
            const section = document.getElementById(targetId);
            if (section) {
                const scrollOffset = 85; 
                const finalPosition = section.getBoundingClientRect().top + window.pageYOffset - scrollOffset;
                window.scrollTo({ top: finalPosition, behavior: 'smooth' });
            }
        }
    </script>

</body>
</html>