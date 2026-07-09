package com.fooddelivery.dao;

import java.util.List;
import com.fooddelivery.model.Menu;

public interface MenuDAO {
    List<Menu> getAllMenus();
    List<Menu> getMenuByRestaurant(int restaurantId);
    List<Menu> getMenuByCategory(String category);
    Menu getMenuById(int itemId);
}