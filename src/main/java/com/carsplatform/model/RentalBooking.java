package com.carsplatform.model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

/**
 * Abstract base class for rental bookings
 * Demonstrates: Abstraction and Encapsulation
 */
public abstract class RentalBooking {
    private String rentalId;
    private String userId;
    private String vehicleId;
    private LocalDate startDate;
    private LocalDate endDate;
    private double totalCost;
    private String status; // ACTIVE, COMPLETED, CANCELLED
    private String rentalType; // DAILY, WEEKLY

    public RentalBooking() {
    }

    public RentalBooking(String rentalId, String userId, String vehicleId,
                         LocalDate startDate, LocalDate endDate, double totalCost,
                         String status, String rentalType) {
        this.rentalId = rentalId;
        this.userId = userId;
        this.vehicleId = vehicleId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.totalCost = totalCost;
        this.status = status;
        this.rentalType = rentalType;
    }

    // Getters and Setters (Encapsulation)
    public String getRentalId() {
        return rentalId;
    }

    public void setRentalId(String rentalId) {
        this.rentalId = rentalId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(String vehicleId) {
        this.vehicleId = vehicleId;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public double getTotalCost() {
        return totalCost;
    }

    public void setTotalCost(double totalCost) {
        this.totalCost = totalCost;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRentalType() {
        return rentalType;
    }

    public void setRentalType(String rentalType) {
        this.rentalType = rentalType;
    }

    /**
     * Calculates the duration in days
     */
    public long getDuration() {
        return ChronoUnit.DAYS.between(startDate, endDate) + 1;
    }

    /**
     * Abstract method to calculate rental cost (Polymorphism)
     * Daily and weekly rentals calculate differently
     */
    public abstract double calculateCost(double dailyRate);

    /**
     * Converts rental to file string format (pipe-delimited)
     * Format: rentalId|userId|vehicleId|startDate|endDate|totalCost|status|rentalType
     */
    public String toFileString() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        return rentalId + "|" + userId + "|" + vehicleId + "|" +
               startDate.format(formatter) + "|" + endDate.format(formatter) + "|" +
               totalCost + "|" + status + "|" + rentalType;
    }

    /**
     * Creates a RentalBooking object from a file string
     */
    public static RentalBooking fromFileString(String line) {
        String[] fields = line.split("\\|");
        if (fields.length < 8) {
            return null;
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        String rentalType = fields[7];

        if ("DAILY".equals(rentalType)) {
            return new DailyRental(fields[0], fields[1], fields[2],
                    LocalDate.parse(fields[3], formatter), LocalDate.parse(fields[4], formatter),
                    Double.parseDouble(fields[5]), fields[6], fields[7]);
        } else {
            return new WeeklyRental(fields[0], fields[1], fields[2],
                    LocalDate.parse(fields[3], formatter), LocalDate.parse(fields[4], formatter),
                    Double.parseDouble(fields[5]), fields[6], fields[7]);
        }
    }

    @Override
    public String toString() {
        return "RentalBooking{" +
                "rentalId='" + rentalId + '\'' +
                ", userId='" + userId + '\'' +
                ", vehicleId='" + vehicleId + '\'' +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", totalCost=" + totalCost +
                ", status='" + status + '\'' +
                ", rentalType='" + rentalType + '\'' +
                '}';
    }
}
