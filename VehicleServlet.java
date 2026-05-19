package com.carsplatform.servlet;

import com.carsplatform.filehandler.FileHandler;
import com.carsplatform.model.*;
import com.carsplatform.service.VehicleService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;

@WebServlet("/vehicle")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
public class VehicleServlet extends HttpServlet {
    private VehicleService vehicleService = new VehicleService();
    private static final Set<String> ALLOWED_IMAGE_EXTENSIONS = Set.of(".jpg", ".jpeg", ".png", ".gif", ".webp",
            ".bmp");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listVehicles(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "detail":
                showDetail(request, response);
                break;
            case "delete":
                handleDelete(request, response);
                break;
            default:
                listVehicles(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/vehicle");
            return;
        }

        switch (action) {
            case "add":
                handleAdd(request, response);
                break;
            case "update":
                handleUpdate(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/vehicle");
        }
    }

    private void listVehicles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String type = request.getParameter("type");
        String status = request.getParameter("status");

        List<Vehicle> vehicles;

        if (search != null && !search.trim().isEmpty()) {
            vehicles = vehicleService.searchByBrand(search);
            if (vehicles.isEmpty()) {
                vehicles = vehicleService.searchByModel(search);
            }
        } else if (type != null && !type.trim().isEmpty()) {
            vehicles = vehicleService.getVehiclesByType(type);
        } else if (status != null && !status.trim().isEmpty()) {
            vehicles = vehicleService.getVehiclesByStatus(status);
        } else {
            vehicles = vehicleService.getAllVehicles();
        }

        request.setAttribute("vehicles", vehicles);
        request.getRequestDispatcher("/WEB-INF/views/vehicleList.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null && "ADMIN".equals(user.getRole())) {
            request.getRequestDispatcher("/WEB-INF/views/addVehicle.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
        }
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        int year = Integer.parseInt(request.getParameter("year"));
        double price = Double.parseDouble(request.getParameter("price"));
        String type = request.getParameter("type");
        int mileage = Integer.parseInt(request.getParameter("mileage"));
        double dailyRate = Double.parseDouble(request.getParameter("dailyRate"));
        String imageFileName;

        try {
            imageFileName = saveVehicleImage(request.getPart("imageFile"));
        } catch (IllegalArgumentException ex) {
            session.setAttribute("flashMsg", ex.getMessage());
            session.setAttribute("flashType", "error");
            response.sendRedirect(request.getContextPath() + "/vehicle?action=add");
            return;
        } catch (RuntimeException ex) {
            session.setAttribute("flashMsg", "Image upload failed. Please use an image up to 5MB.");
            session.setAttribute("flashType", "error");
            response.sendRedirect(request.getContextPath() + "/vehicle?action=add");
            return;
        }

        Vehicle vehicle;
        switch (type) {
            case "SEDAN":
                vehicle = new Sedan(null, brand, model, year, price, type, "AVAILABLE", mileage, user.getUserId(),
                        dailyRate);
                break;
            case "SUV":
                vehicle = new SUV(null, brand, model, year, price, type, "AVAILABLE", mileage, user.getUserId(),
                        dailyRate);
                break;
            case "VAN":
                vehicle = new Van(null, brand, model, year, price, type, "AVAILABLE", mileage, user.getUserId(),
                        dailyRate);
                break;
            default:
                vehicle = new Sedan(null, brand, model, year, price, "SEDAN", "AVAILABLE", mileage, user.getUserId(),
                        dailyRate);
        }
        vehicle.setImageFileName(imageFileName);

        boolean success = vehicleService.addVehicle(vehicle);

        if (success) {
            session.setAttribute("flashMsg", "Vehicle added successfully!");
            session.setAttribute("flashType", "success");
        } else {
            session.setAttribute("flashMsg", "Failed to add vehicle. Please try again.");
            session.setAttribute("flashType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/vehicle?action=list");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null && "ADMIN".equals(user.getRole())) {
            String vehicleId = request.getParameter("id");
            Vehicle vehicle = vehicleService.findVehicleById(vehicleId);
            request.setAttribute("vehicle", vehicle);
            request.getRequestDispatcher("/WEB-INF/views/editVehicle.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String vehicleId = request.getParameter("vehicleId");
        Vehicle vehicle = vehicleService.findVehicleById(vehicleId);

        HttpSession session = request.getSession();
        if (vehicle != null) {
            vehicle.setBrand(request.getParameter("brand"));
            vehicle.setModel(request.getParameter("model"));
            vehicle.setYear(Integer.parseInt(request.getParameter("year")));
            vehicle.setPrice(Double.parseDouble(request.getParameter("price")));
            vehicle.setMileage(Integer.parseInt(request.getParameter("mileage")));
            vehicle.setDailyRate(Double.parseDouble(request.getParameter("dailyRate")));
            vehicle.setStatus(request.getParameter("status"));

            try {
                String newImageFileName = saveVehicleImage(request.getPart("imageFile"));
                if (newImageFileName != null) {
                    vehicle.setImageFileName(newImageFileName);
                }
            } catch (IllegalArgumentException ex) {
                session.setAttribute("flashMsg", ex.getMessage());
                session.setAttribute("flashType", "error");
                response.sendRedirect(request.getContextPath() + "/vehicle?action=edit&id=" + vehicleId);
                return;
            } catch (RuntimeException ex) {
                session.setAttribute("flashMsg", "Image upload failed. Please use an image up to 5MB.");
                session.setAttribute("flashType", "error");
                response.sendRedirect(request.getContextPath() + "/vehicle?action=edit&id=" + vehicleId);
                return;
            }

            boolean updated = vehicleService.updateVehicle(vehicle);
            if (updated) {
                session.setAttribute("flashMsg", "Vehicle updated successfully!");
                session.setAttribute("flashType", "success");
            } else {
                session.setAttribute("flashMsg", "Failed to update vehicle.");
                session.setAttribute("flashType", "error");
            }
        } else {
            session.setAttribute("flashMsg", "Vehicle not found.");
            session.setAttribute("flashType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/vehicle?action=list");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null && "ADMIN".equals(user.getRole())) {
            String vehicleId = request.getParameter("id");
            vehicleService.deleteVehicle(vehicleId);
            session.setAttribute("flashMsg", "Vehicle deleted successfully.");
            session.setAttribute("flashType", "success");
        }

        response.sendRedirect(request.getContextPath() + "/vehicle?action=list");
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String vehicleId = request.getParameter("id");
        Vehicle vehicle = vehicleService.findVehicleById(vehicleId);
        request.setAttribute("vehicle", vehicle);
        request.getRequestDispatcher("/WEB-INF/views/vehicleDetail.jsp").forward(request, response);
    }

    private String saveVehicleImage(Part imagePart) throws IOException {
        if (imagePart == null || imagePart.getSize() <= 0) {
            return null;
        }

        String submittedName = imagePart.getSubmittedFileName();
        if (submittedName == null || submittedName.trim().isEmpty()) {
            return null;
        }

        String contentType = imagePart.getContentType();
        if (contentType == null || !contentType.toLowerCase(Locale.ROOT).startsWith("image/")) {
            throw new IllegalArgumentException("Please upload a valid image file.");
        }

        String extension = extractAndValidateExtension(submittedName);
        String storedName = "veh_" + System.currentTimeMillis() + "_" +
                UUID.randomUUID().toString().substring(0, 8) + extension;

        Path imageDir = Paths.get(FileHandler.getDataDirectory(), "vehicle-images");
        Files.createDirectories(imageDir);
        Path target = imageDir.resolve(storedName);

        try (InputStream in = imagePart.getInputStream()) {
            Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
        }

        return storedName;
    }

    private String extractAndValidateExtension(String fileName) {
        String cleanName = Paths.get(fileName).getFileName().toString();
        int dotIndex = cleanName.lastIndexOf('.');

        if (dotIndex < 0 || dotIndex == cleanName.length() - 1) {
            throw new IllegalArgumentException("Image file must include an extension (jpg, png, webp, etc.).");
        }

        String extension = cleanName.substring(dotIndex).toLowerCase(Locale.ROOT);
        if (!ALLOWED_IMAGE_EXTENSIONS.contains(extension)) {
            throw new IllegalArgumentException("Supported image formats: jpg, jpeg, png, gif, webp, bmp.");
        }

        return extension;
    }
}
