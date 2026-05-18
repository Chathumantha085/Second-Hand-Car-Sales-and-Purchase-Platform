package com.carsplatform.model;

/**
 * Abstract base class for all users in the system
 * Demonstrates: Abstraction and Encapsulation
 */
public abstract class User {
    private String userId;
    private String name;
    private String email;
    private String password;
    private String phone;
    private String role; // USER or ADMIN

    public User() {
    }

    public User(String userId, String name, String email, String password, String phone, String role) {
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.role = role;
    }

    // Getters and Setters (Encapsulation)
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    /**
     * Abstract method to authenticate user (Polymorphism)
     * Different user types may have different authentication logic
     */
    public abstract boolean authenticate(String email, String password);

    /**
     * Converts user object to file string format (pipe-delimited)
     * Format: userId|name|email|password|role|phone
     */
    public String toFileString() {
        return userId + "|" + name + "|" + email + "|" + password + "|" + role + "|" + phone;
    }

    /**
     * Creates a User object from a file string
     */
    public static User fromFileString(String line) {
        String[] fields = line.split("\\|");
        if (fields.length < 6) {
            return null;
        }

        String role = fields[4];
        if ("ADMIN".equals(role)) {
            return new AdminUser(fields[0], fields[1], fields[2], fields[3], fields[5], fields[4]);
        } else {
            return new RegularUser(fields[0], fields[1], fields[2], fields[3], fields[5], fields[4]);
        }
    }

    @Override
    public String toString() {
        return "User{" +
                "userId='" + userId + '\'' +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                ", phone='" + phone + '\'' +
                '}';
    }
}
