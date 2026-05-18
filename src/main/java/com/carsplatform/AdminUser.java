package com.carsplatform.model;

/**
 * Admin User class - can manage vehicles and oversee all transactions
 * Demonstrates: Inheritance and Polymorphism
 */
public class AdminUser extends User {

    public AdminUser() {
        super();
    }

    public AdminUser(String userId, String name, String email, String password, String phone, String role) {
        super(userId, name, email, password, phone, role);
    }

    /**
     * Polymorphic implementation of authenticate method
     * Admins may have additional authentication logic in the future
     */
    @Override
    public boolean authenticate(String email, String password) {
        return this.getEmail().equals(email) &&
               this.getPassword().equals(password) &&
               "ADMIN".equals(this.getRole());
    }

    /**
     * Admin can manage all vehicle listings
     */
    public boolean canManageListings() {
        return true;
    }

    /**
     * Admin can view all users
     */
    public boolean canViewAllUsers() {
        return true;
    }

    /**
     * Admin can approve/reject purchases
     */
    public boolean canApprovePurchases() {
        return true;
    }

    /**
     * Admin can manage all rentals
     */
    public boolean canManageRentals() {
        return true;
    }

    @Override
    public String toString() {
        return "AdminUser{" +
                "userId='" + getUserId() + '\'' +
                ", name='" + getName() + '\'' +
                ", email='" + getEmail() + '\'' +
                ", role='ADMIN'" +
                '}';
    }
}
