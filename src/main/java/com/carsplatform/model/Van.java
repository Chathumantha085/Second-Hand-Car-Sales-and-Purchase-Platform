package com.carsplatform.model;

/**
 * Van vehicle class
 * Demonstrates: Inheritance and Polymorphism
 */
public class Van extends Vehicle {

    public Van() {
        super();
    }

    public Van(String vehicleId, String brand, String model, int year, double price,
            String type, String status, int mileage, String ownerId, double dailyRate) {
        super(vehicleId, brand, model, year, price, type, status, mileage, ownerId, dailyRate);
    }

    public Van(String vehicleId, String brand, String model, int year, double price,
            String type, String status, int mileage, String ownerId, double dailyRate,
            String imageFileName) {
        super(vehicleId, brand, model, year, price, type, status, mileage, ownerId, dailyRate, imageFileName);
    }

    /**
     * Polymorphic implementation of getDescription
     * Returns van-specific formatted description
     */
    @Override
    public String getDescription() {
        return String.format("Van: %s %s (%d) - Ideal for group travel and cargo transportation. " +
                "Mileage: %,d km | Price: $%,.2f | Daily Rate: $%.2f",
                getBrand(), getModel(), getYear(), getMileage(), getPrice(), getDailyRate());
    }

    @Override
    public String toString() {
        return "Van{" +
                "vehicleId='" + getVehicleId() + '\'' +
                ", brand='" + getBrand() + '\'' +
                ", model='" + getModel() + '\'' +
                ", year=" + getYear() +
                ", price=" + getPrice() +
                ", status='" + getStatus() + '\'' +
                '}';
    }
}
