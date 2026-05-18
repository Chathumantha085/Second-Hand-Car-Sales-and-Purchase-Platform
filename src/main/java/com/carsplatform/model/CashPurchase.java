package com.carsplatform.model;

import java.time.LocalDate;

/**
 * Cash Purchase class - full payment upfront
 * Demonstrates: Inheritance and Polymorphism
 */
public class CashPurchase extends PurchaseTransaction {

    public CashPurchase() {
        super();
    }

    public CashPurchase(String purchaseId, String userId, String vehicleId,
                        LocalDate purchaseDate, double amount, String status, String paymentType) {
        super(purchaseId, userId, vehicleId, purchaseDate, amount, status, paymentType);
    }

    /**
     * Polymorphic implementation of calculateFinalAmount
     * Cash purchases have no additional charges
     */
    @Override
    public double calculateFinalAmount() {
        return getAmount(); // No interest for cash purchases
    }

    /**
     * Polymorphic implementation of processPayment
     * For cash purchases, payment is immediate
     */
    @Override
    public boolean processPayment() {
        if ("APPROVED".equals(getStatus())) {
            System.out.println("Processing cash payment of $" + getAmount());
            return true;
        }
        return false;
    }

    @Override
    public String toString() {
        return "CashPurchase{" +
                "purchaseId='" + getPurchaseId() + '\'' +
                ", amount=" + getAmount() +
                ", finalAmount=" + calculateFinalAmount() +
                ", status='" + getStatus() + '\'' +
                '}';
    }
}
