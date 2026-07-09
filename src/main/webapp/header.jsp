<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fooddelivery.model.Cart" %>
<%@ page import="com.fooddelivery.model.CartItem" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>FoodHub - Your Cart</title>
    <link href="https://fonts.googleapis.com/css2?family=Baloo+2:wght@700;800&family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Space+Mono:wght@700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-color: #050508;
            --card-bg: #0e0e14;
            --card-glass: rgba(14, 14, 20, 0.75);
            --text-main: #ffffff;
            --text-muted: #9494b0;
            --accent-coral: #ff5566;
            --accent-orange: #ff8844;
            --border-color: rgba(255, 255, 255, 0.06);
            --lightning-cyan: #00f3ff;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body { 
            background: radial-gradient(circle at 50% 0%, #171126 0%, var(--bg-color) 70%); 
            color: var(--text-main); 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            min-height: 100vh;
            overflow-x: hidden;
        }

        header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            padding: 20px 8%; 
            background-color: rgba(14, 14, 20, 0.4); 
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border-bottom: 1px solid var(--border-color); 
        }
        header h1 { font-family: 'Baloo 2', sans-serif; font-weight: 800; font-size: 1.8rem; letter-spacing: -0.5px; }
        header h1 span { background: linear-gradient(90deg, var(--accent-coral), var(--accent-orange)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        nav a { color: var(--text-muted); text-decoration: none; margin-left: 25px; font-weight: 500; transition: color 0.3s ease; }
        nav a:hover { color: var(--text-main); text-shadow: 0 0 10px rgba(255, 255, 255, 0.3); }

        .page-heading { max-width: 1200px; margin: 50px auto 0; padding: 0 24px; }
        .page-heading h2 { font-family: 'Baloo 2', sans-serif; font-size: 2.2rem; font-weight: 800; margin-bottom: 4px; text-shadow: 0 0 20px rgba(255, 85, 102, 0.15); }
        .page-heading p { color: var(--text-muted); font-size: 0.95rem; font-weight: 500; }

        /* HIGH-VOLTAGE DYNAMIC LIGHTNING CONIC CONTAINER PANELS */
        .lightning-panel-track {
            max-width: 1200px;
            margin: 30px auto;
            position: relative;
            border-radius: 20px;
            padding: 3px;
            overflow: hidden;
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.6);
            display: flex;
        }

        .lightning-panel-track::before {
            content: '';
            position: absolute;
            width: 140%;
            height: 300%;
            top: -100%;
            left: -20%;
            background: conic-gradient(
                transparent, 
                var(--accent-coral), 
                var(--lightning-cyan), 
                var(--accent-orange), 
                transparent 30%
            );
            animation: lightningRotate 6s linear infinite;
            z-index: 0;
        }

        @keyframes lightningRotate {
            100% { transform: rotate(360deg); }
        }

        .cart-panel {
            width: 100%;
            padding: 35px;
            background: var(--card-glass);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border-radius: 18px;
            position: relative;
            z-index: 1;
        }

        .cart-table { width: 100%; border-collapse: collapse; }
        .cart-table th { text-align: left; color: var(--text-muted); font-weight: 600; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1px; padding-bottom: 18px; border-bottom: 1px solid var(--border-color); }
        .cart-row td { padding: 24px 10px; border-bottom: 1px solid var(--border-color); vertical-align: middle; }

        .item-name { font-weight: 700; font-size: 1.1rem; color: rgba(255, 255, 255, 0.95); }
        .item-price { color: var(--accent-coral); font-size: 1rem; font-weight: 600; margin-top: 4px; font-family: 'Space Mono', monospace; }
        .row-total-val { font-family: 'Space Mono', monospace; font-weight: 700; font-size: 1.05rem; }

        .qty-control {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .qty-btn {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            border: 1px solid var(--border-color);
            background: linear-gradient(135deg, rgba(255,255,255,0.08), rgba(255,255,255,0.02));
            color: white;
            cursor: pointer;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            padding-bottom: 2px;
            transition: all 0.2s ease;
        }
        .qty-btn:hover { border-color: var(--lightning-cyan); color: var(--lightning-cyan); box-shadow: 0 0 10px rgba(0, 243, 255, 0.2); }
        .qty-form { display: inline; }
        .qty-value { min-width: 24px; text-align: center; font-weight: 700; font-family: 'Space Mono', monospace; font-size: 1.05rem; }

        .btn-remove-pill {
            background: transparent;
            border: 1px solid rgba(255, 85, 102, 0.3);
            color: var(--accent-coral);
            padding: 7px 20px;
            border-radius: 30px;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 600;
            transition: all 0.25s ease;
        }
        .btn-remove-pill:hover {
            background: var(--accent-coral);
            color: white;
            border-color: var(--accent-coral);
            box-shadow: 0 0 15px rgba(255, 85, 102, 0.3);
        }

        .grand-total-row td {
            border-bottom: none;
            padding-top: 30px;
            font-family: 'Baloo 2', sans-serif;
            font-size: 1.5rem;
            font-weight: 800;
        }
        .grand-total-value { color: var(--lightning-cyan); font-family: 'Space Mono', monospace; text-shadow: 0 0 15px rgba(0, 243, 255, 0.3); }

        .cart-actions {
            max-width: 1200px;
            margin: 10px auto 70px;
            padding: 0 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .btn-outline-pill {
            background: transparent;
            border: 1px solid var(--border-color);
            color: var(--text-muted);
            padding: 14px 30px;
            border-radius: 30px;
            cursor: pointer;
            font-size: 0.95rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.25s ease;
        }
        .btn-outline-pill:hover {
            border-color: var(--text-main);
            color: var(--text-main);
            background: rgba(255, 255, 255, 0.02);
        }

        .btn-checkout-pill {
            position: relative;
            background: linear-gradient(135deg, var(--accent-coral), var(--accent-orange));
            color: white;
            border: none;
            padding: 15px 38px;
            border-radius: 30px;
            font-size: 1.05rem;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(255, 85, 102, 0.3);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-checkout-pill:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 30px rgba(255, 85, 102, 0.5);
        }

        /* Empty Track Frame Layout */
        .lightning-empty-track {
            max-width: 520px;
            margin: 90px auto;
            position: relative;
            border-radius: 20px;
            padding: 3px;
            overflow: hidden;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.5);
        }
        .lightning-empty-track::before {
            content: '';
            position: absolute;
            width: 180%;
            height: 180%;
            top: -40%; left: -40%;
            background: conic-gradient(transparent, var(--accent-coral), var(--lightning-cyan), transparent 45%);
            animation: lightningRotate 4s linear infinite;
        }

        .empty-container { 
            width: 100%;
            background-color: var(--card-bg); 
            padding: 60px 40px; 
            border-radius: 18px; 
            text-align: center; 
            position: relative;
            z-index: 1;
        }
        .empty-icon { font-size: 4.5rem; color: rgba(255, 255, 255, 0.05); margin-bottom: 24px; display: block; }
        
        .btn-browse { 
            position: relative;
            display: inline-block; 
            background: linear-gradient(135deg, var(--accent-coral), var(--accent-orange)); 
            color: white; 
            padding: 14px 36px; 
            border-radius: 12px; 
            text-decoration: none; 
            font-weight: 700; 
            margin-top: 24px; 
            overflow: hidden;
            box-shadow: 0 6px 20px rgba(255, 85, 102, 0.25);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .btn-browse:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(255, 85, 102, 0.4); }

        /* Dynamic High-Voltage Laser Wave Sparks */
        .shockwave-sparks {
            position: absolute;
            background: radial-gradient(circle, rgba(0, 243, 255, 0.75) 0%, transparent 70%);
            border-radius: 50%;
            pointer-events: none;
            transform: translate(-50%, -50%);
            animation: kineticExpand 0.5s ease-out forwards;
        }

        @keyframes kineticExpand {
            0% { width: 0px; height: 0px; opacity: 1; }
            100% { width: 400px; height: 400px; opacity: 0; }
        }
    </style>
</head>
<body>

    <header>
        <h1>Food<span>Hub</span></h1>
        <nav>
            <a href="home"><i class="fa-solid fa-house" style="margin-right: 5px;"></i> Home</a>
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

        <div class="lightning-panel-track">
            <div class="cart-panel">
                <table class="cart-table">
                    <thead>
                        <tr>
                            <th style="width: 35%;">Item</th>
                            <th style="width: 15%;">Price</th>
                            <th style="width: 15%;">Total</th>
                            <th style="width: 20%;">Quantity</th>
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
                                <td class="row-total-val">₹<%= (int)(item.getPrice() * qty) %></td>
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
        </div>

        <div class="cart-actions">
            <a href="home" class="btn-outline-pill">Add More Items</a>
            <a href="checkout.jsp" class="btn-checkout-pill actionable-lightning">Proceed to Checkout <i class="fa-solid fa-arrow-right"></i></a>
        </div>
    <% } else { %>
        <div class="lightning-empty-track">
            <div class="empty-container">
                <i class="fa-solid fa-basket-shopping empty-icon"></i>
                <h2 style="font-family: 'Baloo 2', sans-serif; font-weight: 800; margin-bottom: 10px;">Your Cart is Empty</h2>
                <p style="color: var(--text-muted); font-size: 0.95rem;">Add items from our restaurant menu to place an order.</p>
                <a href="home" class="btn-browse actionable-lightning">Browse Menu</a>
            </div>
        </div>
    <% } %>

    <script>
        // Injects dynamic high-voltage interactive click ripples on active conversion paths
        document.querySelectorAll('.actionable-lightning').forEach(btn => {
            btn.addEventListener('click', function(e) {
                const spark = document.createElement('div');
                spark.className = 'shockwave-sparks';
                
                const matrix = this.getBoundingClientRect();
                spark.style.left = `${e.clientX - matrix.left}px`;
                spark.style.top = `${e.clientY - matrix.top}px`;
                
                this.appendChild(spark);
                setTimeout(() => spark.remove(), 500);
            });
        });
    </script>
</body>
</html>