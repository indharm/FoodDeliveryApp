package com.fooddelivery.model;

public class Menu {
    private int id;
    private int restaurantId;
    private String itemName;  // Maps to DB column: item_name
    private String description;
    private double price;
    private double rating;
    private String imagePath;
    private String category;// Maps to DB column: image_url

    public Menu() {}

    public Menu(int id, int restaurantId, String itemName, String description, double price, double rating, String imagePath) {
        this.id = id;
        this.restaurantId = restaurantId;
        this.itemName = itemName;
        this.description = description;
        this.price = price;
        this.rating = rating;
        this.imagePath = imagePath;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
}