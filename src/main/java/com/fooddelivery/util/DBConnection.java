package com.fooddelivery.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Adjust your database name, username, and password to match your MySQL setup
	private static final String URL = "jdbc:mysql://localhost:3306/fooddelivery";  // ✅ changed
	private static final String USERNAME = "root";
	private static final String PASSWORD = "root";
    public static Connection getConnection() {
        Connection connection = null;
        try {
            // Explicitly load the MySQL driver class
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver missing! Add the jar to your classpath.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Database connection failed! Check URL, username, or password.");
            e.printStackTrace();
        }
        return connection;
    }
}