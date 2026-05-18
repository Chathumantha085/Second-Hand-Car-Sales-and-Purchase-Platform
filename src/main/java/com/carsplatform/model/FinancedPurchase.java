package com.carsplatform.model;

import java.time.LocalDate;

/**
 * Financed Purchase class - payment with interest
 * Demonstrates: Inheritance and Polymorphism
 */
public class FinancedPurchase extends PurchaseTransaction {
    private static final double INTEREST_RATE = 0.08; // 8% annual interest

    public FinancedPurchase() {
        super();
    }

    public FinancedPurchase(String purchaseId, String userId, String vehicleId,
                            LocalDate purchaseDate, double amount, String status, String paymentType) {
        super(purchaseId, userId, vehicleId, purchaseDate, amount, status, paymentType);
    }

    /**
     * Polymorphic implementation of calculateFinalAmount
     * Financed purchases include interest
     */
    @Override
    public double calculateFinalAmount() {
        return getAmount() * (1 + INTEREST_RATE);
    }

    /**
     * Polymorphic implementation of processPayment
     * For financed purchases, payment is processed over time
     */
    @Override
    public boolean processPayment() {
        if ("APPROVED".equals(getStatus())) {
            double finalAmount = calculateFinalAmount();
            System.out.println("Processing financed payment. Total amount with interest: $" + finalAmount);
            return true;
        }
        return false;
    }

    public double getInterestRate() {
        return INTEREST_RATE;
    }

    public double getInterestAmount() {
        return getAmount() * INTEREST_RATE;
    }

    @Override
    public String toString() {
        return "FinancedPurchase{" +
                "purchaseId='" + getPurchaseId() + '\'' +
                ", amount=" + getAmount() +
                ", interest=" + getInterestAmount() +
                ", finalAmount=" + calculateFinalAmount() +
                ", status='" + getStatus() + '\'' +
                '}';
    }
}
