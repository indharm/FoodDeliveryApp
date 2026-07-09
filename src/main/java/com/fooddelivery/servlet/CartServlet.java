package com.fooddelivery.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.fooddelivery.dao.MenuDAO;
import com.fooddelivery.daoimpl.MenuDAOImpl;
import com.fooddelivery.model.Cart;
import com.fooddelivery.model.CartItem;
import com.fooddelivery.model.Menu;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MenuDAO menuDAO = new MenuDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                int itemId = Integer.parseInt(request.getParameter("itemId"));

                // Look up real name/price from the DB — never trust client-supplied price
                Menu menuItem = menuDAO.getMenuById(itemId);
                if (menuItem != null) {
                    CartItem item = new CartItem(itemId, menuItem.getItemName(), menuItem.getPrice(), 1);
                    cart.addItem(item);
                }

            } else if ("update".equals(action)) {
                int itemId = Integer.parseInt(request.getParameter("itemId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                cart.updateQuantity(itemId, quantity);
                
            } else if ("remove".equals(action)) {
                int itemId = Integer.parseInt(request.getParameter("itemId"));
                cart.removeItem(itemId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/cart.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}