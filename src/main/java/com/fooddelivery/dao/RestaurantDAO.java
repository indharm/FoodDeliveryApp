package com.fooddelivery.dao;

import java.util.List;
import com.fooddelivery.model.Restaurant;

public interface RestaurantDAO {
    List<Restaurant> getAllRestaurants();
    List<Restaurant> searchRestaurants(String keyword);
    List<Restaurant> getTopRatedRestaurants(int limit);
    Restaurant getRestaurantById(int restaurantId);
}