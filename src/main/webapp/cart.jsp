<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fooddelivery.model.Cart" %>
<%@ page import="com.fooddelivery.model.CartItem" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>FoodHub - Your Cart</title>
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

        header {
            display: flex; justify-content: space-between; align-items: center; padding: 15px 8%;
            background-color: var(--card-bg); box-shadow: 0 4px 12px rgba(0,0,0,0.5);
        }
        header h1 { margin: 0; font-size: 1.6rem; }
        header h1 span { color: var(--accent-red); }
        nav a { color: var(--text-muted); text-decoration: none; margin-left: 25px; font-weight: 500; }
        nav a:hover { color: var(--accent-red); }

        .page-heading { max-width: 1200px; margin: 40px auto 0; padding: 0 20px; }
        .page-heading h2 { font-size: 1.9rem; margin: 0 0 8px; }
        .page-heading p { color: var(--text-muted); margin: 0; font-size: 0.95rem; }

        .cart-panel {
            max-width: 1200px; margin: 25px auto 40px; padding: 30px; background-color: var(--card-bg);
            border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.3);
        }

        .cart-table { width: 100%; border-collapse: collapse; }
        .cart-table th { text-align: left; color: var(--text-muted); font-weight: 500; font-size: 0.85rem; text-transform: uppercase; padding-bottom: 15px; border-bottom: 1px solid var(--border-color); }
        .cart-row td { padding: 20px 10px; border-bottom: 1px solid var(--border-color); vertical-align: middle; }

        .item-name { font-weight: 600; font-size: 1.05rem; }
        .item-price { color: var(--text-muted); font-size: 0.9rem; margin-top: 4px; }

        .qty-control { display: flex; align-items: center; gap: 10px; }
        .qty-btn {
            width: 30px; height: 30px; border-radius: 50%; border: 1px solid #444; background-color: #252525;
            color: white; cursor: pointer; font-size: 0.95rem; display: flex; align-items: center; justify-content: center; padding: 0;
        }
        .qty-btn:hover { border-color: white; }
        .qty-form { display: inline; }
        .qty-value { min-width: 20px; text-align: center; font-weight: 600; }

        .btn-remove-pill {
            background-color: transparent; border: 1px solid #444; color: var(--text-muted); padding: 6px 16px;
            border-radius: 20px; cursor: pointer; font-size: 0.85rem;
        }
        .btn-remove-pill:hover { border-color: var(--accent-red); color: var(--accent-red); }

        .grand-total-row td { border-bottom: none; padding-top: 20px; font-size: 1.25rem; font-weight: 700; }
        .grand-total-value { color: var(--accent-red); }

        .cart-actions { max-width: 1200px; margin: 0 auto 60px; padding: 0 20px; display: flex; justify-content: space-between; align-items: center; }
        .btn-outline-pill {
            background: transparent; border: 1px solid var(--accent-red); color: var(--accent-red); padding: 11px 24px;
            border-radius: 30px; cursor: pointer; font-size: 0.95rem; font-weight: 600; text-decoration: none;
        }
        .btn-outline-pill:hover { background: var(--accent-red); color: white; }
        .btn-checkout-pill {
            background: var(--accent-red); color: white; border: none; padding: 13px 32px; border-radius: 30px;
            font-size: 1rem; font-weight: 600; cursor: pointer; text-decoration: none;
        }
        .btn-checkout-pill:hover { background: var(--accent-hover); }

        .empty-container {
            max-width: 500px; margin: 80px auto; background-color: var(--card-bg); padding: 50px 40px;
            border-radius: 12px; text-align: center; box-shadow: 0 8px 24px rgba(0,0,0,0.3);
        }
        .empty-icon { font-size: 4rem; color: #333; margin-bottom: 20px; }
        .btn-browse { display: inline-block; background-color: var(--accent-red); color: white; padding: 12px 30px; border-radius: 6px; text-decoration: none; font-weight: 600; margin-top: 20px; }
    </style>
</head>
<body>

    <header>
        <h1>Food<span>Hub</span></h1>
        <nav>
            <a href="home"><i class="fa-solid fa-house"></i> Home</a>
        </nav>
    </header>

    <%
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart != null && !cart.getItems().isEmpty()) {
            double grandTotal = cart.getTotal();
    %>
        <div class="page-heading">
            <h2>Your Cart</h2>
            <p>Review your selected food items</p>
        </div>

        <div class="cart-panel">
            <table class="cart-table">
                <thead>
                    <tr>
                        <th style="width: 30%;">Item</th>
                        <th style="width: 15%;">Price</th>
                        <th style="width: 15%;">Total</th>
                        <th style="width: 25%;">Quantity</th>
                        <th style="width: 15%; text-align: center;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (Map.Entry<Integer, CartItem> entry : cart.getItems().entrySet()) {
                            CartItem item = entry.getValue();
                            int qty = item.getQuantity();
                    %>
                        <tr class="cart-row">
                            <td class="item-name"><%= item.getName() %></td>
                            <td class="item-price">₹<%= (int)item.getPrice() %></td>
                            <td style="font-weight: 600;">₹<%= (int)(item.getPrice() * qty) %></td>
                            <td>
                                <div class="qty-control">
                                    <form action="cart" method="POST" class="qty-form">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="itemId" value="<%= item.getItemId() %>">
                                        <input type="hidden" name="quantity" value="<%= Math.max(1, qty - 1) %>">
                                        <button type="submit" class="qty-btn">−</button>
                                    </form>
                                    <span class="qty-value"><%= qty %></span>
                                    <form action="cart" method="POST" class="qty-form">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="itemId" value="<%= item.getItemId() %>">
                                        <input type="hidden" name="quantity" value="<%= qty + 1 %>">
                                        <button type="submit" class="qty-btn">+</button>
                                    </form>
                                </div>
                            </td>
                            <td style="text-align: center;">
                                <form action="cart" method="POST">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="itemId" value="<%= item.getItemId() %>">
                                    <button type="submit" class="btn-remove-pill">Remove</button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                    <tr class="grand-total-row">
                        <td colspan="2">Grand Total</td>
                        <td colspan="3" class="grand-total-value" style="text-align: right;">₹<%= (int)grandTotal %></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="cart-actions">
            <a href="RestaurantServlet" class="btn-outline-pill">Add More Items</a>
            <a href="checkout.jsp" class="btn-checkout-pill">Proceed to Checkout <i class="fa-solid fa-arrow-right"></i></a>
        </div>
    <% } else { %>
        <div class="empty-container">
            <i class="fa-solid fa-basket-shopping empty-icon"></i>
            <h2 style="margin-bottom: 10px;">Your Cart is Empty</h2>
            <p style="color: var(--text-muted);">Add items from our restaurant menu to place an order.</p>
            <a href="RestaurantServlet" class="btn-browse">Browse Menu</a>
        </div>
    <% } %>

</body>
</html>
