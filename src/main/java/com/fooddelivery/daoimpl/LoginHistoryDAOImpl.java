package com.fooddelivery.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.fooddelivery.dao.LoginHistoryDAO;
import com.fooddelivery.model.LoginHistory;
import com.fooddelivery.util.DBConnection;

public class LoginHistoryDAOImpl implements LoginHistoryDAO {

    @Override
    public void logLogin(int userId, String username, String email) {
        String query = "INSERT INTO login_history (user_id, username, email) VALUES (?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setString(2, username);
            ps.setString(3, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<LoginHistory> getAllLoginHistory() {
        List<LoginHistory> historyList = new ArrayList<>();
        String query = "SELECT * FROM login_history ORDER BY login_time DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                LoginHistory log = new LoginHistory(
                    rs.getInt("id"),
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getTimestamp("login_time")
                );
                historyList.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return historyList;
    }
}