package com.carsplatform.service;

import com.carsplatform.filehandler.FileHandler;
import com.carsplatform.model.Vehicle;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

public class VehicleService {

    private static final String FILE = "vehicles.txt";

    private List<Vehicle> parseAll() {
        return FileHandler.readAllLines(FILE).stream()
                .filter(l -> l != null && !l.trim().isEmpty())
                .map(Vehicle::fromFileString)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    public boolean addVehicle(Vehicle vehicle) {
        vehicle.setVehicleId(FileHandler.generateId(FILE, "V"));
        return FileHandler.appendLine(FILE, vehicle.toFileString());
    }

    public List<Vehicle> getAllVehicles() {
        return parseAll();
    }

    public Vehicle findVehicleById(String vehicleId) {
        String record = FileHandler.findById(FILE, vehicleId);
        return record != null ? Vehicle.fromFileString(record) : null;
    }

    public boolean updateVehicle(Vehicle vehicle) {
        return FileHandler.updateRecord(FILE, vehicle.getVehicleId(), vehicle.toFileString());
    }

    public boolean deleteVehicle(String vehicleId) {
        return FileHandler.deleteRecord(FILE, vehicleId);
    }

    public boolean updateVehicleStatus(String vehicleId, String status) {
        Vehicle vehicle = findVehicleById(vehicleId);
        if (vehicle == null) return false;
        vehicle.setStatus(status);
        return updateVehicle(vehicle);
    }

    public List<Vehicle> getAvailableVehicles() {
        return getVehiclesByStatus("AVAILABLE");
    }

    public List<Vehicle> getVehiclesByStatus(String status) {
        return parseAll().stream()
                .filter(v -> v.getStatus().equalsIgnoreCase(status))
                .collect(Collectors.toList());
    }

    public List<Vehicle> getVehiclesByType(String type) {
        return parseAll().stream()
                .filter(v -> v.getType().equalsIgnoreCase(type))
                .collect(Collectors.toList());
    }

    public List<Vehicle> searchByBrand(String brand) {
        return parseAll().stream()
                .filter(v -> v.getBrand().toLowerCase().contains(brand.toLowerCase()))
                .collect(Collectors.toList());
    }

    public List<Vehicle> searchByModel(String model) {
        return parseAll().stream()
                .filter(v -> v.getModel().toLowerCase().contains(model.toLowerCase()))
                .collect(Collectors.toList());
    }

    public List<Vehicle> filterByPriceRange(double min, double max) {
        return parseAll().stream()
                .filter(v -> v.getPrice() >= min && v.getPrice() <= max)
                .collect(Collectors.toList());
    }
}
