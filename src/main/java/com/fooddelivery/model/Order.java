package com.fooddelivery.model;

import java.sql.Timestamp;

public class Order {
    private int id;
    private int userId;
    private Integer restaurantId; // nullable in DB — wrapper type, not primitive
    private double totalAmount;
    private String status;
    private String paymentMode;
    private String deliveryAddress;
    private Timestamp createdAt;
    private String fullName;
    private String mobileNumber;

    public Order() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Integer getRestaurantId() { return restaurantId; }
    public void setRestaurantId(Integer restaurantId) { this.restaurantId = restaurantId; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPaymentMode() { return paymentMode; }
    public void setPaymentMode(String paymentMode) { this.paymentMode = paymentMode; }

    public String getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getMobileNumber() { return mobileNumber; }
    public void setMobileNumber(String mobileNumber) { this.mobileNumber = mobileNumber; }
}