package com.carsplatform.service;

import com.carsplatform.filehandler.FileHandler;
import com.carsplatform.model.PurchaseTransaction;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

public class PurchaseService {

    private static final String FILE = "purchases.txt";
    private final VehicleService vehicleService = new VehicleService();

    private List<PurchaseTransaction> parseAll() {
        return FileHandler.readAllLines(FILE).stream()
                .filter(l -> l != null && !l.trim().isEmpty())
                .map(PurchaseTransaction::fromFileString)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    public boolean createPurchase(PurchaseTransaction purchase) {
        purchase.setPurchaseId(FileHandler.generateId(FILE, "P"));
        purchase.setStatus("PENDING");
        vehicleService.updateVehicleStatus(purchase.getVehicleId(), "PENDING");
        return FileHandler.appendLine(FILE, purchase.toFileString());
    }

    public List<PurchaseTransaction> getAllPurchases() {
        return parseAll();
    }

    public PurchaseTransaction findPurchaseById(String purchaseId) {
        String record = FileHandler.findById(FILE, purchaseId);
        return record != null ? PurchaseTransaction.fromFileString(record) : null;
    }

    public List<PurchaseTransaction> getPurchasesByUser(String userId) {
        return parseAll().stream()
                .filter(p -> p.getUserId().equals(userId))
                .collect(Collectors.toList());
    }

    public List<PurchaseTransaction> getPurchasesByStatus(String status) {
        return parseAll().stream()
                .filter(p -> p.getStatus().equalsIgnoreCase(status))
                .collect(Collectors.toList());
    }

    public List<PurchaseTransaction> getPendingPurchases() {
        return getPurchasesByStatus("PENDING");
    }

    public boolean updatePurchaseStatus(String purchaseId, String newStatus) {
        PurchaseTransaction purchase = findPurchaseById(purchaseId);
        if (purchase == null) return false;
        purchase.setStatus(newStatus);
        if ("APPROVED".equals(newStatus)) {
            vehicleService.updateVehicleStatus(purchase.getVehicleId(), "SOLD");
        } else if ("REJECTED".equals(newStatus) || "CANCELLED".equals(newStatus)) {
            vehicleService.updateVehicleStatus(purchase.getVehicleId(), "AVAILABLE");
        }
        return FileHandler.updateRecord(FILE, purchaseId, purchase.toFileString());
    }

    public boolean approvePurchase(String purchaseId) {
        return updatePurchaseStatus(purchaseId, "APPROVED");
    }

    public boolean rejectPurchase(String purchaseId) {
        return updatePurchaseStatus(purchaseId, "REJECTED");
    }

    public boolean cancelPurchase(String purchaseId) {
        PurchaseTransaction purchase = findPurchaseById(purchaseId);
        if (purchase == null || !"PENDING".equals(purchase.getStatus())) return false;
        vehicleService.updateVehicleStatus(purchase.getVehicleId(), "AVAILABLE");
        return FileHandler.deleteRecord(FILE, purchaseId);
    }

    public double getTotalPurchaseAmountByUser(String userId) {
        return getPurchasesByUser(userId).stream()
                .filter(p -> "APPROVED".equals(p.getStatus()))
                .mapToDouble(PurchaseTransaction::calculateFinalAmount)
                .sum();
    }
}
