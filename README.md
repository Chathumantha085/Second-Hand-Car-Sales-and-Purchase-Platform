# Second-Hand-Car-Sales-and-Purchase-Platform

1. Introduction

A Java web application for managing second-hand car rentals and purchases using Jakarta EE Servlets, JSP, and text file storage.

## 📋 Project Overview

This platform enables users to browse, rent, and purchase second-hand vehicles through a web interface with four core modules:

1. **User Management** - Registration, login, profile updates, and account deletion
2. **Vehicle Listing Management** - Add, view, update, and remove vehicle listings
3. **Vehicle Purchase Management** - Purchase requests, approvals, and transaction records
4. **Rental Booking Management** - Rental bookings, availability checks, and booking management

## 🛠 Technologies Used

- **Backend:** Java 17, Jakarta EE Servlets 6.0
- **Frontend:** JSP, HTML5, CSS3, Bootstrap 5.3, JavaScript
- **Data Storage:** Text files (.txt) with file I/O operations
- **Build Tool:** Maven 3.x
- **Server:** Apache Tomcat 10.1+
- **IDE:** IntelliJ IDEA / VS Code

## 🏗 Project Structure

```
car-rental-purchase/
├── src/
│   ├── main/
│   │   ├── java/com/carsplatform/
│   │   │   ├── model/          # Entity classes (User, Vehicle, etc.)
│   │   │   ├── service/        # Business logic (CRUD operations)
│   │   │   ├── servlet/        # HTTP request handlers
│   │   │   ├── filehandler/    # File I/O utility classes
│   │   │   └── util/           # Helper utilities
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── views/      # JSP pages
│   │       │   └── web.xml     # Deployment descriptor
│   │       ├── css/            # Custom stylesheets
│   │       ├── js/             # JavaScript files
│   │       └── data/           # Text file storage
│   │           ├── users.txt
│   │           ├── vehicles.txt
│   │           ├── purchases.txt
│   │           └── rentals.txt
│   └── test/java/              # Unit tests
├── pom.xml                     # Maven configuration
└── README.md                   # This file
```



