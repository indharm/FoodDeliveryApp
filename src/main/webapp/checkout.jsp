<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fooddelivery.model.Cart" %>
<%@ page import="com.fooddelivery.model.CartItem" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>FoodHub - Checkout</title>
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
        nav a { color: var(--text-muted); text-decoration: none; font-weight: 500; transition: color 0.2s ease; }
        nav a:hover { color: var(--accent-red); }

        @keyframes fadeSlideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .page-heading { max-width: 1200px; margin: 40px auto 0; padding: 0 20px; animation: fadeSlideUp 0.5s ease both; }
        .page-heading h2 { font-size: 2rem; margin: 0 0 8px; font-weight: 800; }
        .page-heading p { color: var(--text-muted); margin: 0; font-size: 0.95rem; }

        .checkout-wrapper { max-width: 1200px; margin: 25px auto 60px; padding: 0 20px; display: flex; gap: 30px; align-items: flex-start; }

        .delivery-section, .summary-section {
            background-color: var(--card-bg); border-radius: 14px; padding: 30px; box-shadow: 0 10px 28px rgba(0,0,0,0.3);
            border: 1px solid var(--border-color);
            animation: fadeSlideUp 0.55s ease both;
        }
        .delivery-section { flex: 1.4; }
        .summary-section { flex: 1; height: fit-content; animation-delay: 0.1s; }

        .section-title { margin-top: 0; margin-bottom: 25px; font-size: 1.3rem; font-weight: 700; }

        .form-group { margin-bottom: 18px; text-align: left; }
        .form-label { display: block; color: var(--text-muted); font-size: 0.85rem; text-transform: uppercase; margin-bottom: 6px; font-weight: 500; }
        .form-input, .form-textarea, .form-select {
            width: 100%; background-color: #252525; color: white; border: 1px solid #444; border-radius: 6px;
            padding: 12px; font-family: inherit; font-size: 0.9rem; outline: none;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }
        .form-input:focus, .form-textarea:focus, .form-select:focus {
            border-color: var(--accent-red);
            box-shadow: 0 0 0 3px rgba(231,76,60,0.15);
        }
        .form-textarea { resize: none; }
        .form-select { cursor: pointer; }

        .summary-item-row { display: flex; justify-content: space-between; margin-bottom: 15px; font-size: 0.95rem; }
        .summary-item-qty { color: var(--text-muted); font-size: 0.85rem; margin-left: 6px; }
        .summary-item-price { color: var(--accent-orange); font-weight: 600; }

        .summary-divider, .total-divider { border-top: 1px dashed var(--border-color); margin: 20px 0; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 15px; font-size: 0.95rem; color: var(--text-muted); }
        .grand-total-row { display: flex; justify-content: space-between; font-size: 1.35rem; font-weight: 800; margin-bottom: 25px; }
        .grand-total-value {
            background: linear-gradient(90deg, #f1c40f, var(--accent-orange));
            -webkit-background-clip: text; background-clip: text; color: transparent;
        }

        .btn-place-order {
            display: flex; justify-content: center; align-items: center; gap: 10px; width: 100%;
            background: linear-gradient(90deg, var(--accent-red), var(--accent-orange));
            color: white; border: none; padding: 14px; border-radius: 8px; font-size: 1.05rem; font-weight: 700; cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .btn-place-order:hover { transform: translateY(-2px); box-shadow: 0 10px 24px rgba(231,76,60,0.4); }

        .btn-back-cart {
            display: flex; justify-content: center; align-items: center; width: 100%; background: transparent;
            border: 1px solid var(--accent-red); color: var(--accent-red); padding: 12px; border-radius: 8px;
            font-size: 0.95rem; font-weight: 600; cursor: pointer; margin-top: 12px; text-decoration: none;
            transition: all 0.2s ease;
        }
        .btn-back-cart:hover { background: var(--accent-red); color: white; transform: translateY(-2px); }

        .empty-container {
            max-width: 500px; margin: 80px auto; background-color: var(--card-bg); padding: 50px 40px;
            border-radius: 14px; text-align: center; box-shadow: 0 10px 28px rgba(0,0,0,0.3);
            border: 1px solid var(--border-color); animation: fadeSlideUp 0.5s ease both;
        }
        .empty-icon { font-size: 4rem; color: var(--accent-red); margin-bottom: 20px; }
        .btn-browse {
            display: inline-block; background: linear-gradient(90deg, var(--accent-red), var(--accent-orange));
            color: white; padding: 12px 30px; border-radius: 6px; text-decoration: none; font-weight: 700; margin-top: 20px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .btn-browse:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(231,76,60,0.4); }
    </style>
</head>
<body>

    <header>
        <h1>Food<span>Hub</span></h1>
        <nav>
            <a href="home">Home</a>
            <a href="login.jsp">Login</a>
            <a href="register.jsp">Sign Up</a>
            <a href="profile.jsp">Profile</a>
        </nav>
    </header>

    <%
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart != null && !cart.getItems().isEmpty()) {
            double itemsTotal = cart.getTotal();
            double deliveryFee = 40.0;
            double platformFee = 5.0;
            double finalToPay = itemsTotal + deliveryFee + platformFee;
    %>
        <div class="page-heading">
            <h2>Checkout</h2>
            <p>Confirm your delivery details and place your order</p>
        </div>

        <div class="checkout-wrapper">
            <div class="delivery-section">
                <h2 class="section-title">Delivery Details</h2>

                <form action="OrderServlet" method="POST">
                    <div class="form-group">
                        <label class="form-label">Full Name</label>
                        <input type="text" name="fullName" class="form-input" placeholder="Enter your full name" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Mobile Number</label>
                        <input type="tel" name="mobileNumber" class="form-input" placeholder="Enter your mobile number" pattern="[0-9]{10}" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Delivery Address</label>
                        <textarea name="address" rows="3" class="form-textarea" placeholder="Enter your complete delivery address" required></textarea>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Payment Method</label>
                        <select name="paymentMethod" class="form-select">
                            <option value="COD">Cash on Delivery (COD)</option>
                            <option value="UPI">UPI</option>
                            <option value="CARD">Credit / Debit Card</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-place-order">Place Order</button>
                </form>
            </div>

            <div class="summary-section">
                <h2 class="section-title">Order Summary</h2>

                <%
                    for (Map.Entry<Integer, CartItem> entry : cart.getItems().entrySet()) {
                        CartItem item = entry.getValue();
                %>
                    <div class="summary-item-row">
                        <span><%= item.getName() %> <span class="summary-item-qty">x <%= item.getQuantity() %></span></span>
                        <span class="summary-item-price">₹<%= (int)(item.getPrice() * item.getQuantity()) %></span>
                    </div>
                <% } %>

                <div class="summary-divider"></div>

                <div class="summary-row"><span>Item Total</span><span>₹<%= (int)itemsTotal %></span></div>
                <div class="summary-row"><span>Delivery Fee</span><span>₹<%= (int)deliveryFee %></span></div>
                <div class="summary-row"><span>Platform Fee</span><span>₹<%= (int)platformFee %></span></div>

                <div class="total-divider"></div>

                <div class="grand-total-row">
                    <span>Total</span>
                    <span class="grand-total-value">₹<%= (int)finalToPay %></span>
                </div>

                <button type="submit" form="" class="btn-place-order" style="margin-bottom: 12px;" onclick="document.forms[0].submit(); return false;">Place Order</button>
                <a href="cart.jsp" class="btn-back-cart">Back to Cart</a>
            </div>
        </div>
    <% } else { %>
        <div class="empty-container">
            <i class="fa-solid fa-basket-shopping empty-icon"></i>
            <h2 style="margin-bottom: 10px;">Your Cart is Empty</h2>
            <p style="color: var(--text-muted);">Add items from our restaurant menu to place an order.</p>
            <a href="home" class="btn-browse">Browse Menu</a>
        </div>
    <% } %>

</body>
</html>
