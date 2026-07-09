package com.fooddelivery.dao;

import java.util.List;
import com.fooddelivery.model.LoginHistory;

public interface LoginHistoryDAO {
    void logLogin(int userId, String username, String email);
    List<LoginHistory> getAllLoginHistory();
}