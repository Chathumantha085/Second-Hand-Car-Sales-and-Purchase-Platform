package com.carsplatform.model;

/**
 * SUV vehicle class
 * Demonstrates: Inheritance and Polymorphism
 */
public class SUV extends Vehicle {

    public SUV() {
        super();
    }

    public SUV(String vehicleId, String brand, String model, int year, double price,
            String type, String status, int mileage, String ownerId, double dailyRate) {
        super(vehicleId, brand, model, year, price, type, status, mileage, ownerId, dailyRate);
    }

    public SUV(String vehicleId, String brand, String model, int year, double price,
            String type, String status, int mileage, String ownerId, double dailyRate,
            String imageFileName) {
        super(vehicleId, brand, model, year, price, type, status, mileage, ownerId, dailyRate, imageFileName);
    }

    /**
     * Polymorphic implementation of getDescription
     * Returns SUV-specific formatted description
     */
    @Override
    public String getDescription() {
        return String.format("SUV: %s %s (%d) - Spacious and powerful for family trips and off-road adventures. " +
                "Mileage: %,d km | Price: $%,.2f | Daily Rate: $%.2f",
                getBrand(), getModel(), getYear(), getMileage(), getPrice(), getDailyRate());
    }

    @Override
    public String toString() {
        return "SUV{" +
                "vehicleId='" + getVehicleId() + '\'' +
                ", brand='" + getBrand() + '\'' +
                ", model='" + getModel() + '\'' +
                ", year=" + getYear() +
                ", price=" + getPrice() +
                ", status='" + getStatus() + '\'' +
                '}';
    }
}
