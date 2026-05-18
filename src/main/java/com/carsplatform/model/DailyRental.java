package com.carsplatform.model;

import java.time.LocalDate;

/**
 * Daily Rental class - standard daily rate calculation
 * Demonstrates: Inheritance and Polymorphism
 */
public class DailyRental extends RentalBooking {

    public DailyRental() {
        super();
    }

    public DailyRental(String rentalId, String userId, String vehicleId,
                       LocalDate startDate, LocalDate endDate, double totalCost,
                       String status, String rentalType) {
        super(rentalId, userId, vehicleId, startDate, endDate, totalCost, status, rentalType);
    }

    /**
     * Polymorphic implementation of calculateCost
     * Daily rentals: cost = daily rate * number of days
     */
    @Override
    public double calculateCost(double dailyRate) {
        long days = getDuration();
        return dailyRate * days;
    }

    @Override
    public String toString() {
        return "DailyRental{" +
                "rentalId='" + getRentalId() + '\'' +
                ", duration=" + getDuration() + " days" +
                ", totalCost=" + getTotalCost() +
                ", status='" + getStatus() + '\'' +
                '}';
    }
}
