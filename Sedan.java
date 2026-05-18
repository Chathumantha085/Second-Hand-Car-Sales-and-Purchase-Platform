package com.carsplatform.model;

/**
 * Sedan vehicle class
 * Demonstrates: Inheritance and Polymorphism
 */
public class Sedan extends Vehicle {

    public Sedan() {
        super();
    }

    public Sedan(String vehicleId, String brand, String model, int year, double price,
            String type, String status, int mileage, String ownerId, double dailyRate) {
        super(vehicleId, brand, model, year, price, type, status, mileage, ownerId, dailyRate);
    }

    public Sedan(String vehicleId, String brand, String model, int year, double price,
            String type, String status, int mileage, String ownerId, double dailyRate,
            String imageFileName) {
        super(vehicleId, brand, model, year, price, type, status, mileage, ownerId, dailyRate, imageFileName);
    }

    /**
     * Polymorphic implementation of getDescription
     * Returns sedan-specific formatted description
     */
    @Override
    public String getDescription() {
        return String.format("Sedan: %s %s (%d) - Perfect for city driving and daily commutes. " +
                "Mileage: %,d km | Price: $%,.2f | Daily Rate: $%.2f",
                getBrand(), getModel(), getYear(), getMileage(), getPrice(), getDailyRate());
    }

    @Override
    public String toString() {
        return "Sedan{" +
                "vehicleId='" + getVehicleId() + '\'' +
                ", brand='" + getBrand() + '\'' +
                ", model='" + getModel() + '\'' +
                ", year=" + getYear() +
                ", price=" + getPrice() +
                ", status='" + getStatus() + '\'' +
                '}';
    }
}
