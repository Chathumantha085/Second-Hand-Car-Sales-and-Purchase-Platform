# Second-Hand-Car-Sales-and-Purchase-Platform

1. Introduction

1.1 Purpose
This Software Requirements Specification (SRS) describes the functional and non-functional requirements for the Second-Hand Car Rental & Purchasing Platform. The system is a Java web-based application developed using Java Servlets, JSP (JavaServer Pages), HTML/CSS, and Bootstrap 5, deployed on Apache Tomcat. Data is stored using file read/write operations (text files) in compliance with the SE1020 project requirements.
The document serves as a reference for the development team, lecturers, and evaluators during the viva presentation.

1.2 Project Scope
The Second-Hand Car Rental & Purchasing Platform enables users to browse, rent, and purchase second-hand vehicles through a web interface. The system is composed of four core modules:
•	User Management - Handles registration, login, profile updates, and account deletion.
•	Vehicle Listing Management - Allows administrators/sellers to add, view, update, and remove vehicle listings.
•	Vehicle Purchase Management - Manages purchase requests, approvals, and purchase records.
•	Rental Booking Management - Handles rental bookings, availability checks, and booking cancellations.



1.3 Definitions and Acronyms

#Term#	            #Definition#
SRS	          Software Requirements Specification
OOP	          Object-Oriented Programming
CRUD       	  Create, Read, Update, Delete
JSP	          JavaServer Pages
UI	          User Interface
Admin	        Administrator - manages vehicles and platform settings
User	        Registered customer who can rent or purchase vehicles
TXT File	    Plain text file used as data storage (.txt)
Spring Boot	  Java framework for building web applications

1.4 Technologies Used
•	Backend: Java, JSP (JavaServer Pages), Servlets (javax.servlet.HttpServlet)
•	Frontend: HTML, CSS, Bootstrap 5, JavaScript
•	Web Container: Apache Tomcat 9 (runs inside IntelliJ IDEA)
•	Data Storage: Text files (.txt) - users.txt, vehicles.txt, purchases.txt, rentals.txt
•	IDE: IntelliJ IDEA (Ultimate recommended for JSP/Servlet support)
•	Build Tool: Maven (pom.xml) with jakarta.servlet-api dependency
•	Version Control: Git & GitHub



