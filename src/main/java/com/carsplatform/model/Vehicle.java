package com.carsplatform.model;

/**
 * Abstract base class for all vehicles
 * Demonstrates: Abstraction and Encapsulation
 */
public abstract class Vehicle {
    private String vehicleId;
    private String brand;
    private String model;
    private int year;
    private double price;
    private String type; // SEDAN, SUV, VAN
    private String status; // AVAILABLE, SOLD, RENTED, PENDING
    private int mileage;
    private String ownerId;
    private double dailyRate;
    private String imageFileName;

    public Vehicle() {
    }

    public Vehicle(String vehicleId, String brand, String model, int year, double price,
            String type, String status, int mileage, String ownerId, double dailyRate) {
        this.vehicleId = vehicleId;
        this.brand = brand;
        this.model = model;
        this.year = year;
        this.price = price;
        this.type = type;
        this.status = status;
        this.mileage = mileage;
        this.ownerId = ownerId;
        this.dailyRate = dailyRate;
        this.imageFileName = null;
    }

    public Vehicle(String vehicleId, String brand, String model, int year, double price,
            String type, String status, int mileage, String ownerId, double dailyRate,
            String imageFileName) {
        this(vehicleId, brand, model, year, price, type, status, mileage, ownerId, dailyRate);
        this.imageFileName = imageFileName;
    }

    // Getters and Setters (Encapsulation)
    public String getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(String vehicleId) {
        this.vehicleId = vehicleId;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getMileage() {
        return mileage;
    }

    public void setMileage(int mileage) {
        this.mileage = mileage;
    }

    public String getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(String ownerId) {
        this.ownerId = ownerId;
    }

    public double getDailyRate() {
        return dailyRate;
    }

    public void setDailyRate(double dailyRate) {
        this.dailyRate = dailyRate;
    }

    public String getImageFileName() {
        return imageFileName;
    }

    public void setImageFileName(String imageFileName) {
        this.imageFileName = imageFileName;
    }

    /**
     * Abstract method to get formatted description (Polymorphism)
     * Each vehicle type will provide its own description format
     */
    public abstract String getDescription();

    /**
     * Converts vehicle object to file string format (pipe-delimited)
     * Format:
     * vehicleId|brand|model|year|price|type|status|mileage|ownerId|dailyRate
     */
    public String toFileString() {
        String safeImageName = imageFileName == null ? "" : imageFileName;
        return vehicleId + "|" + brand + "|" + model + "|" + year + "|" + price + "|" +
                type + "|" + status + "|" + mileage + "|" + ownerId + "|" + dailyRate + "|" + safeImageName;
    }

    /**
     * Creates a Vehicle object from a file string
     */
    public static Vehicle fromFileString(String line) {
        String[] fields = line.split("\\|");
        if (fields.length < 10) {
            return null;
        }

        String imageFileName = fields.length > 10 ? fields[10] : null;
        if (imageFileName != null && imageFileName.trim().isEmpty()) {
            imageFileName = null;
        }

        String type = fields[5];
        switch (type) {
            case "SEDAN":
                return new Sedan(fields[0], fields[1], fields[2], Integer.parseInt(fields[3]),
                        Double.parseDouble(fields[4]), fields[5], fields[6],
                        Integer.parseInt(fields[7]), fields[8], Double.parseDouble(fields[9]), imageFileName);
            case "SUV":
                return new SUV(fields[0], fields[1], fields[2], Integer.parseInt(fields[3]),
                        Double.parseDouble(fields[4]), fields[5], fields[6],
                        Integer.parseInt(fields[7]), fields[8], Double.parseDouble(fields[9]), imageFileName);
            case "VAN":
                return new Van(fields[0], fields[1], fields[2], Integer.parseInt(fields[3]),
                        Double.parseDouble(fields[4]), fields[5], fields[6],
                        Integer.parseInt(fields[7]), fields[8], Double.parseDouble(fields[9]), imageFileName);
            default:
                return null;
        }
    }

    @Override
    public String toString() {
        return "Vehicle{" +
                "vehicleId='" + vehicleId + '\'' +
                ", brand='" + brand + '\'' +
                ", model='" + model + '\'' +
                ", year=" + year +
                ", price=" + price +
                ", type='" + type + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
