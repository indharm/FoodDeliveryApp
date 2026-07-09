package com.fooddelivery.model;

import java.sql.Timestamp;

public class LoginHistory {
    private int id;
    private int userId;
    private String username;
    private String email;
    private Timestamp loginTime;

    public LoginHistory() {}

    public LoginHistory(int id, int userId, String username, String email, Timestamp loginTime) {
        this.id = id;
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.loginTime = loginTime;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public Timestamp getLoginTime() { return loginTime; }
    public void setLoginTime(Timestamp loginTime) { this.loginTime = loginTime; }
}