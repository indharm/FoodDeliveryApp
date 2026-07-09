package com.fooddelivery.servlet;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.fooddelivery.dao.RestaurantDAO;
import com.fooddelivery.daoimpl.RestaurantDAOImpl;
import com.fooddelivery.model.Restaurant;
@WebServlet("/home")
public class HomeController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantDAO restaurantDAO;
    @Override
    public void init() throws ServletException {
        restaurantDAO = new RestaurantDAOImpl();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<Restaurant> restaurantList = restaurantDAO.getTopRatedRestaurants(8);
            request.setAttribute("restaurantList", restaurantList);
            
            request.getRequestDispatcher("/home.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database context failure.");
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}