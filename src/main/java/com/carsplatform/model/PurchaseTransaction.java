package com.carsplatform.model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 * Abstract base class for purchase transactions
 * Demonstrates: Abstraction and Encapsulation
 */
public abstract class PurchaseTransaction {
    private String purchaseId;
    private String userId;
    private String vehicleId;
    private LocalDate purchaseDate;
    private double amount;
    private String status; // PENDING, APPROVED, REJECTED, CANCELLED
    private String paymentType; // CASH, FINANCED

    public PurchaseTransaction() {
    }

    public PurchaseTransaction(String purchaseId, String userId, String vehicleId,
                               LocalDate purchaseDate, double amount, String status, String paymentType) {
        this.purchaseId = purchaseId;
        this.userId = userId;
        this.vehicleId = vehicleId;
        this.purchaseDate = purchaseDate;
        this.amount = amount;
        this.status = status;
        this.paymentType = paymentType;
    }

    // Getters and Setters (Encapsulation)
    public String getPurchaseId() {
        return purchaseId;
    }

    public void setPurchaseId(String purchaseId) {
        this.purchaseId = purchaseId;
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

    public LocalDate getPurchaseDate() {
        return purchaseDate;
    }

    public void setPurchaseDate(LocalDate purchaseDate) {
        this.purchaseDate = purchaseDate;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    /**
     * Abstract method to calculate final amount (Polymorphism)
     * Cash and financed purchases calculate differently
     */
    public abstract double calculateFinalAmount();

    /**
     * Abstract method to process payment
     */
    public abstract boolean processPayment();

    /**
     * Converts purchase to file string format (pipe-delimited)
     * Format: purchaseId|userId|vehicleId|purchaseDate|amount|status|paymentType
     */
    public String toFileString() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        return purchaseId + "|" + userId + "|" + vehicleId + "|" +
               purchaseDate.format(formatter) + "|" + amount + "|" + status + "|" + paymentType;
    }

    /**
     * Creates a PurchaseTransaction object from a file string
     */
    public static PurchaseTransaction fromFileString(String line) {
        String[] fields = line.split("\\|");
        if (fields.length < 7) {
            return null;
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        String paymentType = fields[6];

        if ("CASH".equals(paymentType)) {
            return new CashPurchase(fields[0], fields[1], fields[2],
                    LocalDate.parse(fields[3], formatter), Double.parseDouble(fields[4]),
                    fields[5], fields[6]);
        } else {
            return new FinancedPurchase(fields[0], fields[1], fields[2],
                    LocalDate.parse(fields[3], formatter), Double.parseDouble(fields[4]),
                    fields[5], fields[6]);
        }
    }

    @Override
    public String toString() {
        return "PurchaseTransaction{" +
                "purchaseId='" + purchaseId + '\'' +
                ", userId='" + userId + '\'' +
                ", vehicleId='" + vehicleId + '\'' +
                ", purchaseDate=" + purchaseDate +
                ", amount=" + amount +
                ", status='" + status + '\'' +
                ", paymentType='" + paymentType + '\'' +
                '}';
    }
}
