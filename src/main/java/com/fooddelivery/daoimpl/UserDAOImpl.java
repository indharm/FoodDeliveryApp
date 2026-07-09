package com.fooddelivery.daoimpl;

import com.fooddelivery.dao.UserDAO;
import com.fooddelivery.model.User;
import com.fooddelivery.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAOImpl implements UserDAO {

    private static final String INSERT_USER_SQL =
        "INSERT INTO users (username, email, password, profileImage) VALUES (?, ?, ?, ?)";
    private static final String SELECT_USER_FOR_LOGIN =
        "SELECT * FROM users WHERE email = ? AND password = ?";
    private static final String UPDATE_PASSWORD_SQL =
        "UPDATE users SET password = ? WHERE id = ?";
    private static final String CHECK_EMAIL_EXISTS_SQL =
        "SELECT id FROM users WHERE email = ?";
    private static final String UPDATE_USER_SQL =
        "UPDATE users SET username = ?, email = ?, profileImage = ? WHERE id = ?";

    @Override
    public boolean addUser(User user) {
        // Guard: reject registration if email is already taken
        if (emailExists(user.getEmail())) {
            return false;
        }

        int rowsAffected = 0;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_USER_SQL)) {

            preparedStatement.setString(1, user.getUsername());
            preparedStatement.setString(2, user.getEmail());
            preparedStatement.setString(3, user.getPassword());
            preparedStatement.setString(4, user.getProfileImage() != null
                    ? user.getProfileImage() : "images/default-avatar.png");

            rowsAffected = preparedStatement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rowsAffected > 0;
    }

    /**
     * Checks whether a user with the given email already exists.
     * Used by addUser() to prevent duplicate-email registrations,
     * which previously caused old passwords to keep working after re-registration.
     */
    private boolean emailExists(String email) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(CHECK_EMAIL_EXISTS_SQL)) {

            preparedStatement.setString(1, email);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                return resultSet.next(); // true if a row was found
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Fail safe: if we can't verify, don't block registration outright,
            // but this should be logged/monitored in production.
            return false;
        }
    }

    @Override
    public User validateUser(String email, String password) {
        User user = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USER_FOR_LOGIN)) {

            preparedStatement.setString(1, email);
            preparedStatement.setString(2, password);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    user = new User();
                    user.setId(resultSet.getInt("id"));
                    user.setUsername(resultSet.getString("username"));
                    user.setEmail(resultSet.getString("email"));
                    user.setPassword(resultSet.getString("password"));
                    user.setProfileImage(resultSet.getString("profileImage"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    @Override
    public boolean updatePassword(int userId, String newPassword) {
        int rowsAffected = 0;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_PASSWORD_SQL)) {

            preparedStatement.setString(1, newPassword);
            preparedStatement.setInt(2, userId);

            rowsAffected = preparedStatement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rowsAffected > 0;
    }

    @Override
    public boolean updateUser(User user) {
        int rowsAffected = 0;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_USER_SQL)) {

            preparedStatement.setString(1, user.getUsername());
            preparedStatement.setString(2, user.getEmail());
            preparedStatement.setString(3, user.getProfileImage());
            preparedStatement.setInt(4, user.getId());

            rowsAffected = preparedStatement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rowsAffected > 0;
    }
}