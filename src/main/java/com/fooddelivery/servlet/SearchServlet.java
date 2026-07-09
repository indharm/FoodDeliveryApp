package com.fooddelivery.servlet;
import java.io.IOException;
import java.util.Comparator;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.fooddelivery.dao.RestaurantDAO;
import com.fooddelivery.daoimpl.RestaurantDAOImpl;
import com.fooddelivery.model.Restaurant;
@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantDAO restaurantDAO;
    @Override
    public void init() throws ServletException {
        restaurantDAO = new RestaurantDAOImpl();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String searchQuery = request.getParameter("query");
        String sortBy = request.getParameter("sort"); // ✅ new sort parameter
        
        try {
            List<Restaurant> searchResults;
            
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                searchResults = restaurantDAO.searchRestaurants(searchQuery.trim());
            } else {
                searchResults = restaurantDAO.getAllRestaurants();
            }
            
            // ✅ Sort by rating (high to low) if requested
            if ("rating".equals(sortBy)) {
                searchResults.sort(Comparator.comparingDouble(Restaurant::getRating).reversed());
            }
            
            request.setAttribute("restaurantList", searchResults);
            request.setAttribute("lastSearchQuery", searchQuery);
            request.setAttribute("currentSort", sortBy); // ✅ keep selected sort in dropdown
            
            request.getRequestDispatcher("/restaurants.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Search engine processing failed.");
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}