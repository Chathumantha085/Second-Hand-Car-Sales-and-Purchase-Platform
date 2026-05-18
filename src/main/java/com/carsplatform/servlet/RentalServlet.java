package com.carsplatform.servlet;

import com.carsplatform.model.*;
import com.carsplatform.service.RentalService;
import com.carsplatform.service.VehicleService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/rental")
public class RentalServlet extends HttpServlet {
    private RentalService rentalService = new RentalService();
    private VehicleService vehicleService = new VehicleService();

    @Override                      //override section
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {              //status
            case "list":
                listRentals(request, response);
                break;
            case "book":
                showBookingForm(request, response);
                break;
            case "complete":
                completeRental(request, response);
                break;
            case "cancel":
                cancelRental(request, response);
                break;
            default:
                listRentals(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action != null && action.equals("create")) {
            handleCreate(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/rental");
        }
    }

    private void listRentals(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        List<RentalBooking> rentals;
        if ("ADMIN".equals(user.getRole())) {
            rentals = rentalService.getAllRentals();
        } else {
            rentals = rentalService.getRentalsByUser(user.getUserId());
        }

        request.setAttribute("rentals", rentals);
        request.getRequestDispatcher("/WEB-INF/views/rentalList.jsp").forward(request, response);
    }

    private void showBookingForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String vehicleId = request.getParameter("vehicleId");
        Vehicle vehicle = vehicleService.findVehicleById(vehicleId);
        request.setAttribute("vehicle", vehicle);
        request.getRequestDispatcher("/WEB-INF/views/rentalBooking.jsp").forward(request, response);
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        String vehicleId = request.getParameter("vehicleId");
        LocalDate startDate = LocalDate.parse(request.getParameter("startDate"));
        LocalDate endDate = LocalDate.parse(request.getParameter("endDate"));
        String rentalType = request.getParameter("rentalType");

        RentalBooking rental;
        if ("WEEKLY".equals(rentalType)) {
            rental = new WeeklyRental(null, user.getUserId(), vehicleId,
                    startDate, endDate, 0, "ACTIVE", rentalType);
        } else {
            rental = new DailyRental(null, user.getUserId(), vehicleId,
                    startDate, endDate, 0, "ACTIVE", rentalType);
        }

        boolean success = rentalService.createBooking(rental);

        HttpSession flashSession = request.getSession();
        if (success) {
            flashSession.setAttribute("flashMsg", "Rental booking created successfully!");
            flashSession.setAttribute("flashType", "success");
        } else {
            flashSession.setAttribute("flashMsg", "Failed to create rental booking. Vehicle may not be available.");
            flashSession.setAttribute("flashType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/rental?action=list");
    }

    private void completeRental(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String rentalId = request.getParameter("id");
        rentalService.completeRental(rentalId);
        HttpSession session = request.getSession();
        session.setAttribute("flashMsg", "Rental marked as completed.");
        session.setAttribute("flashType", "success");
        response.sendRedirect(request.getContextPath() + "/rental?action=list");
    }

    private void cancelRental(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String rentalId = request.getParameter("id");
        rentalService.cancelBooking(rentalId);
        HttpSession session = request.getSession();
        session.setAttribute("flashMsg", "Rental booking cancelled.");
        session.setAttribute("flashType", "success");
        response.sendRedirect(request.getContextPath() + "/rental?action=list");
    }
}
