package com.fooddelivery.servlet;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.fooddelivery.daoimpl.MenuDAOImpl;
import com.fooddelivery.daoimpl.RestaurantDAOImpl;
import com.fooddelivery.dao.MenuDAO;
import com.fooddelivery.dao.RestaurantDAO;
import com.fooddelivery.model.Menu;
import com.fooddelivery.model.Restaurant;
@WebServlet("/MenuServlet")
public class MenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MenuDAO menuDAO;
    private RestaurantDAO restaurantDAO;
    @Override
    public void init() throws ServletException {
        menuDAO = new MenuDAOImpl();
        restaurantDAO = new RestaurantDAOImpl();
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String restIdParam = request.getParameter("restaurantId");
            if (restIdParam == null || restIdParam.isEmpty()) {
                response.sendRedirect("RestaurantServlet");
                return;
            }
            
            int restaurantId = Integer.parseInt(restIdParam);
            
            List<Menu> menuList = menuDAO.getMenuByRestaurant(restaurantId);
            Restaurant restaurant = restaurantDAO.getRestaurantById(restaurantId);
            
            request.setAttribute("menuItems", menuList);
            request.setAttribute("restaurantId", restaurantId);
            request.setAttribute("restaurant", restaurant);
            
            request.getRequestDispatcher("menu.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("RestaurantServlet");
        }
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}