package com.fooddelivery.daoimpl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.fooddelivery.dao.RestaurantDAO;
import com.fooddelivery.model.Restaurant;
import com.fooddelivery.util.DBConnection;
public class RestaurantDAOImpl implements RestaurantDAO {
    @Override
    public List<Restaurant> getAllRestaurants() {
        List<Restaurant> restaurantList = new ArrayList<>();
        String query = "SELECT * FROM restaurants";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                restaurantList.add(mapRowToRestaurant(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return restaurantList;
    }

    @Override
    public List<Restaurant> searchRestaurants(String keyword) {
        List<Restaurant> restaurantList = new ArrayList<>();
        String query = "SELECT * FROM restaurants WHERE name LIKE ? OR cuisine_type LIKE ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    restaurantList.add(mapRowToRestaurant(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return restaurantList;
    }

    @Override
    public List<Restaurant> getTopRatedRestaurants(int limit) {
        List<Restaurant> restaurantList = new ArrayList<>();
        String query = "SELECT * FROM restaurants ORDER BY rating DESC LIMIT ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    restaurantList.add(mapRowToRestaurant(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return restaurantList;
    }

    private Restaurant mapRowToRestaurant(ResultSet rs) throws Exception {
        Restaurant restaurant = new Restaurant();
        restaurant.setId(rs.getInt("id"));
        restaurant.setName(rs.getString("name"));
        restaurant.setCuisineType(rs.getString("cuisine_type"));
        restaurant.setDeliveryTime(rs.getString("delivery_time"));
        restaurant.setCostForTwo(rs.getString("price_bracket"));
        restaurant.setRating(rs.getDouble("rating"));
        restaurant.setImagePath(rs.getString("image_url"));
        restaurant.setLocation(rs.getString("location"));
        return restaurant;
    }
    @Override
    public Restaurant getRestaurantById(int restaurantId) {
        Restaurant restaurant = null;
        String query = "SELECT * FROM restaurants WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, restaurantId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    restaurant = mapRowToRestaurant(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return restaurant;
    }
}