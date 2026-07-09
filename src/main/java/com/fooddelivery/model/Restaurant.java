package com.fooddelivery.model;

public class Restaurant {
    // 1. Private Fields matching your database columns
    private int id;
    private String name;
    private String cuisineType;
    private String deliveryTime;   // change from int to String
    private String costForTwo;     // change from int to String
    private String address;
    private double rating;
    private String imagePath;
    private String location; 

    // 2. Default Constructor (Required by Java Beans specification)
    public Restaurant() {
    }

    // 3. Full Parameterized Constructor for quick object building
    public Restaurant(int id, String name, String cuisineType, String deliveryTime, 
                      String costForTwo, String address, double rating, String imagePath) {
        this.id = id;
        this.name = name;
        this.cuisineType = cuisineType;
        this.deliveryTime = deliveryTime;
        this.costForTwo = costForTwo;
        this.address = address;
        this.rating = rating;
        this.imagePath = imagePath;
    }

    // 4. Standard Getters and Setters

    public int getId() { 
        return id; 
    }
    public void setId(int id) { 
        this.id = id; 
    }

    public String getName() { 
        return name; 
    }
    public void setName(String name) { 
        this.name = name; 
    }

    public String getCuisineType() { 
        return cuisineType; 
    }
    public void setCuisineType(String cuisineType) { 
        this.cuisineType = cuisineType; 
    }

    public String getDeliveryTime() { return deliveryTime; }
    public void setDeliveryTime(String deliveryTime) { this.deliveryTime = deliveryTime; }

    public String getCostForTwo() { return costForTwo; }
    public void setCostForTwo(String costForTwo) { this.costForTwo = costForTwo; }

    public String getAddress() { 
        return address; 
    }
    public void setAddress(String address) { 
        this.address = address; 
    }

    public double getRating() { 
        return rating; 
    }
    public void setRating(double rating) { 
        this.rating = rating; 
    }

    public String getImagePath() { 
        return imagePath; 
    }
    public void setImagePath(String imagePath) { 
        this.imagePath = imagePath; 
    }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
}