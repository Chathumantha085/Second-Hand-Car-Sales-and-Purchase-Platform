package com.carsplatform.model;

import java.time.LocalDate;

/**
 * Weekly Rental class - discounted rate for weekly bookings
 * Demonstrates: Inheritance and Polymorphism
 */
public class WeeklyRental extends RentalBooking {
    private static final double WEEKLY_DISCOUNT = 0.15; // 15% discount for weekly rentals

    public WeeklyRental() {
        super();
    }

    public WeeklyRental(String rentalId, String userId, String vehicleId,
                        LocalDate startDate, LocalDate endDate, double totalCost,
                        String status, String rentalType) {
        super(rentalId, userId, vehicleId, startDate, endDate, totalCost, status, rentalType);
    }

    /**
     * Polymorphic implementation of calculateCost
     * Weekly rentals: (daily rate * 7 days) with 15% discount
     */
    @Override
    public double calculateCost(double dailyRate) {
        long days = getDuration();
        long weeks = days / 7;
        long remainingDays = days % 7;

        double weeklyRate = (dailyRate * 7) * (1 - WEEKLY_DISCOUNT);
        double totalCost = (weeklyRate * weeks) + (dailyRate * remainingDays);

        return totalCost;
    }

    public double getWeeklyDiscount() {
        return WEEKLY_DISCOUNT;
    }

    public double getSavings(double dailyRate) {
        long days = getDuration();
        double normalCost = dailyRate * days;
        double discountedCost = calculateCost(dailyRate);
        return normalCost - discountedCost;
    }

    @Override
    public String toString() {
        return "WeeklyRental{" +
                "rentalId='" + getRentalId() + '\'' +
                ", duration=" + getDuration() + " days" +
                ", totalCost=" + getTotalCost() +
                ", discount=" + (WEEKLY_DISCOUNT * 100) + "%" +
                ", status='" + getStatus() + '\'' +
                '}';
    }
}
