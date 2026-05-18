package com.carsplatform.model;

/**
 * Regular User class - can rent and purchase vehicles
 * Demonstrates: Inheritance and Polymorphism
 */
public class RegularUser extends User {

    public RegularUser() {
        super();
    }

    public RegularUser(String userId, String name, String email, String password, String phone, String role) {
        super(userId, name, email, password, phone, role);
    }

    /**
     * Polymorphic implementation of authenticate method
     * Regular users have standard authentication
     */
    @Override
    public boolean authenticate(String email, String password) {
        return this.getEmail().equals(email) && this.getPassword().equals(password);
    }

    /**
     * Check if user can rent a vehicle
     */
    public boolean canRent() {
        return true; // All regular users can rent
    }

    /**
     * Check if user can purchase a vehicle
     */
    public boolean canPurchase() {
        return true; // All regular users can purchase
    }

    @Override
    public String toString() {
        return "RegularUser{" +
                "userId='" + getUserId() + '\'' +
                ", name='" + getName() + '\'' +
                ", email='" + getEmail() + '\'' +
                '}';
    }
}
