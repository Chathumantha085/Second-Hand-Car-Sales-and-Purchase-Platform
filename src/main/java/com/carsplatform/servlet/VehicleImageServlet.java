package com.carsplatform.servlet;

import com.carsplatform.filehandler.FileHandler;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet("/vehicle-image")
public class VehicleImageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String imageName = request.getParameter("name");

        if (imageName == null || imageName.trim().isEmpty() || imageName.contains("..") || imageName.contains("/")
                || imageName.contains("\\")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        Path imageDir = Paths.get(FileHandler.getDataDirectory(), "vehicle-images");
        Path imagePath = imageDir.resolve(imageName).normalize();

        if (!imagePath.startsWith(imageDir) || !Files.exists(imagePath) || !Files.isRegularFile(imagePath)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = Files.probeContentType(imagePath);
        if (contentType == null) {
            contentType = "application/octet-stream";
        }

        response.setContentType(contentType);
        response.setHeader("Cache-Control", "public, max-age=86400");
        response.setContentLengthLong(Files.size(imagePath));

        Files.copy(imagePath, response.getOutputStream());
    }
}
