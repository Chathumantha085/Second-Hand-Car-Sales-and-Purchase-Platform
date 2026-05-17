package com.carsplatform.service;

import com.carsplatform.filehandler.FileHandler;
import com.carsplatform.model.RentalBooking;
import com.carsplatform.model.Vehicle;

import java.time.LocalDate;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

public class RentalService {

    private static final String FILE = "rentals.txt";
    private final VehicleService vehicleService = new VehicleService();

    private List<RentalBooking> parseAll() {
        return FileHandler.readAllLines(FILE).stream()
                .filter(l -> l != null && !l.trim().isEmpty())
                .map(RentalBooking::fromFileString)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    public boolean createBooking(RentalBooking rental) {
        if (!isVehicleAvailable(rental.getVehicleId(), rental.getStartDate(), rental.getEndDate())) {
            return false;
        }
        rental.setRentalId(FileHandler.generateId(FILE, "R"));
        rental.setStatus("ACTIVE");

        Vehicle vehicle = vehicleService.findVehicleById(rental.getVehicleId());
        if (vehicle != null) {
            rental.setTotalCost(rental.calculateCost(vehicle.getDailyRate()));
        }

        vehicleService.updateVehicleStatus(rental.getVehicleId(), "RENTED");
        return FileHandler.appendLine(FILE, rental.toFileString());
    }

    public List<RentalBooking> getAllRentals() {
        return parseAll();
    }

    public RentalBooking findRentalById(String rentalId) {
        String record = FileHandler.findById(FILE, rentalId);
        return record != null ? RentalBooking.fromFileString(record) : null;
    }

    public List<RentalBooking> getRentalsByUser(String userId) {
        return parseAll().stream()
                .filter(r -> r.getUserId().equals(userId))
                .collect(Collectors.toList());
    }

    public List<RentalBooking> getRentalsByStatus(String status) {
        return parseAll().stream()
                .filter(r -> r.getStatus().equalsIgnoreCase(status))
                .collect(Collectors.toList());
    }

    public List<RentalBooking> getActiveRentals() {
        return getRentalsByStatus("ACTIVE");
    }

    public List<RentalBooking> getRentalsByVehicle(String vehicleId) {
        return parseAll().stream()
                .filter(r -> r.getVehicleId().equals(vehicleId))
                .collect(Collectors.toList());
    }

    public boolean updateRentalStatus(String rentalId, String newStatus) {
        RentalBooking rental = findRentalById(rentalId);
        if (rental == null) return false;
        rental.setStatus(newStatus);
        if ("COMPLETED".equals(newStatus) || "CANCELLED".equals(newStatus)) {
            vehicleService.updateVehicleStatus(rental.getVehicleId(), "AVAILABLE");
        }
        return FileHandler.updateRecord(FILE, rentalId, rental.toFileString());
    }

    public boolean completeRental(String rentalId) {
        return updateRentalStatus(rentalId, "COMPLETED");
    }

    public boolean cancelBooking(String rentalId) {
        RentalBooking rental = findRentalById(rentalId);
        if (rental == null || !"ACTIVE".equals(rental.getStatus())) return false;
        vehicleService.updateVehicleStatus(rental.getVehicleId(), "AVAILABLE");
        return FileHandler.deleteRecord(FILE, rentalId);
    }

    public boolean isVehicleAvailable(String vehicleId, LocalDate startDate, LocalDate endDate) {
        Vehicle vehicle = vehicleService.findVehicleById(vehicleId);
        if (vehicle == null || !"AVAILABLE".equals(vehicle.getStatus())) return false;

        return parseAll().stream()
                .filter(r -> r.getVehicleId().equals(vehicleId) && "ACTIVE".equals(r.getStatus()))
                .noneMatch(r -> !(endDate.isBefore(r.getStartDate()) || startDate.isAfter(r.getEndDate())));
    }

    public double getTotalRentalCostByUser(String userId) {
        return getRentalsByUser(userId).stream()
                .filter(r -> "COMPLETED".equals(r.getStatus()))
                .mapToDouble(RentalBooking::getTotalCost)
                .sum();
    }
}
