package com.fooddelivery.dao;

import com.fooddelivery.model.User;

public interface UserDAO {
    boolean addUser(User user);
    User validateUser(String email, String password);
    boolean updatePassword(int userId, String newPassword);
    boolean updateUser(User user);
}