package com.carsplatform.servlet;

import com.carsplatform.model.*;
import com.carsplatform.service.PurchaseService;
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

@WebServlet("/purchase")
public class PurchaseServlet extends HttpServlet {
    private PurchaseService purchaseService = new PurchaseService();
    private VehicleService vehicleService = new VehicleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listPurchases(request, response);
                break;
            case "request":
                showRequestForm(request, response);
                break;
            case "approve":
                approvePurchase(request, response);
                break;
            case "reject":
                rejectPurchase(request, response);
                break;
            case "cancel":
                cancelPurchase(request, response);
                break;
            default:
                listPurchases(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action != null && action.equals("create")) {
            handleCreate(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/purchase");
        }
    }

    private void listPurchases(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        List<PurchaseTransaction> purchases;
        if ("ADMIN".equals(user.getRole())) {
            purchases = purchaseService.getAllPurchases();
        } else {
            purchases = purchaseService.getPurchasesByUser(user.getUserId());
        }

        request.setAttribute("purchases", purchases);
        request.getRequestDispatcher("/WEB-INF/views/purchaseList.jsp").forward(request, response);
    }

    private void showRequestForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String vehicleId = request.getParameter("vehicleId");
        Vehicle vehicle = vehicleService.findVehicleById(vehicleId);
        request.setAttribute("vehicle", vehicle);
        request.getRequestDispatcher("/WEB-INF/views/purchaseRequest.jsp").forward(request, response);
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
        double amount = Double.parseDouble(request.getParameter("amount"));
        String paymentType = request.getParameter("paymentType");

        PurchaseTransaction purchase;
        if ("CASH".equals(paymentType)) {
            purchase = new CashPurchase(null, user.getUserId(), vehicleId,
                    LocalDate.now(), amount, "PENDING", paymentType);
        } else {
            purchase = new FinancedPurchase(null, user.getUserId(), vehicleId,
                    LocalDate.now(), amount, "PENDING", paymentType);
        }

        boolean success = purchaseService.createPurchase(purchase);

        HttpSession flashSession = request.getSession();
        if (success) {
            flashSession.setAttribute("flashMsg", "Purchase request submitted successfully!");
            flashSession.setAttribute("flashType", "success");
        } else {
            flashSession.setAttribute("flashMsg", "Failed to submit purchase request.");
            flashSession.setAttribute("flashType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/purchase?action=list");
    }

    private void approvePurchase(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String purchaseId = request.getParameter("id");
        purchaseService.approvePurchase(purchaseId);
        HttpSession session = request.getSession();
        session.setAttribute("flashMsg", "Purchase request approved.");
        session.setAttribute("flashType", "success");
        response.sendRedirect(request.getContextPath() + "/purchase?action=list");
    }

    private void rejectPurchase(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String purchaseId = request.getParameter("id");
        purchaseService.rejectPurchase(purchaseId);
        HttpSession session = request.getSession();
        session.setAttribute("flashMsg", "Purchase request rejected.");
        session.setAttribute("flashType", "error");
        response.sendRedirect(request.getContextPath() + "/purchase?action=list");
    }

    private void cancelPurchase(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String purchaseId = request.getParameter("id");
        purchaseService.cancelPurchase(purchaseId);
        HttpSession session = request.getSession();
        session.setAttribute("flashMsg", "Purchase request cancelled.");
        session.setAttribute("flashType", "success");
        response.sendRedirect(request.getContextPath() + "/purchase?action=list");
    }
}
