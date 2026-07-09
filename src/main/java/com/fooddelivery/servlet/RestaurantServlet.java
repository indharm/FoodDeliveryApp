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

@WebServlet("/RestaurantServlet")
public class RestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantDAO restaurantDAO;

    @Override
    public void init() throws ServletException {
        restaurantDAO = new RestaurantDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Restaurant> restaurantList = restaurantDAO.getAllRestaurants();
        request.setAttribute("restaurantList", restaurantList);
        request.getRequestDispatcher("/restaurants.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}