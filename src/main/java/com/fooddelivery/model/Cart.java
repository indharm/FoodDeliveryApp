package com.fooddelivery.model;

import java.util.HashMap;
import java.util.Map;

public class Cart {
    // Stores items mapped by their unique Menu Item ID
    private Map<Integer, CartItem> items;

    public Cart() {
        this.items = new HashMap<>();
    }

    /**
     * Adds an item to the shopping cart. 
     * If the item already exists, it updates the quantity incremented by the new payload.
     */
    public void addItem(CartItem item) {
        int itemId = item.getItemId();
        if (items.containsKey(itemId)) {
            CartItem existingItem = items.get(itemId);
            existingItem.setQuantity(existingItem.getQuantity() + item.getQuantity());
        } else {
            items.put(itemId, item);
        }
    }

    /**
     * Updates the quantity of a specific item in the cart.
     * If the target quantity is reduced to 0 or below, the item is dropped automatically.
     */
    public void updateQuantity(int itemId, int quantity) {
        if (items.containsKey(itemId)) {
            if (quantity <= 0) {
                items.remove(itemId);
            } else {
                items.get(itemId).setQuantity(quantity);
            }
        }
    }

    /**
     * Completely removes an item from the shopping cart.
     */
    public void removeItem(int itemId) {
        items.remove(itemId);
    }

    /**
     * Returns the underlying collection map of items inside the cart.
     */
    public Map<Integer, CartItem> getItems() {
        return items;
    }

    /**
     * Calculates the raw subtotal sum of all individual item costs currently selected.
     * This ensures that downstream order controllers process math smoothly.
     */
    public double getTotal() {
        double total = 0.0;
        for (CartItem item : items.values()) {
            total += item.getPrice() * item.getQuantity();
        }
        return total;
    }
    public double getTotalAmount() {
        return getTotal();
    }

    /**
     * Wipes all keys from the collection map (e.g., following a successful checkout order placement).
     */
    public void clear() {
        items.clear();
    }
}