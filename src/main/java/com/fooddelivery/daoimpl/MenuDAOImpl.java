package com.fooddelivery.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.fooddelivery.dao.MenuDAO;
import com.fooddelivery.model.Menu;
import com.fooddelivery.util.DBConnection;

public class MenuDAOImpl implements MenuDAO {

    @Override
    public List<Menu> getAllMenus() {
        List<Menu> list = new ArrayList<>();
        String query = "SELECT * FROM menus";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRowToMenu(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Menu> getMenuByRestaurant(int restaurantId) {
        List<Menu> list = new ArrayList<>();
        String query = "SELECT * FROM menus WHERE restaurant_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, restaurantId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToMenu(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Menu> getMenuByCategory(String category) {
        List<Menu> list = new ArrayList<>();
        String query = "SELECT * FROM menus WHERE category = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, category);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToMenu(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public Menu getMenuById(int itemId) {
        Menu item = null;
        String query = "SELECT * FROM menus WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, itemId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    item = mapRowToMenu(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return item;
    }

    private Menu mapRowToMenu(ResultSet rs) throws Exception {
        Menu item = new Menu();
        item.setId(rs.getInt("id"));
        item.setRestaurantId(rs.getInt("restaurant_id"));
        item.setItemName(rs.getString("item_name"));
        item.setPrice(rs.getDouble("price"));
        item.setDescription(rs.getString("description"));
        item.setRating(rs.getDouble("rating"));
        item.setImagePath(rs.getString("image_url"));
        item.setCategory(rs.getString("category"));
        return item;
    }
}