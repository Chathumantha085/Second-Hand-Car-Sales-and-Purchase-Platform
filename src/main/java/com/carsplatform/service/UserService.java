package com.carsplatform.service;

import com.carsplatform.filehandler.FileHandler;
import com.carsplatform.model.AdminUser;
import com.carsplatform.model.RegularUser;
import com.carsplatform.model.User;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

public class UserService {

    private static final String FILE = "users.txt";

    private List<User> parseAll() {
        return FileHandler.readAllLines(FILE).stream()
                .filter(l -> l != null && !l.trim().isEmpty())
                .map(User::fromFileString)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    public boolean registerUser(User user) {
        if (findUserByEmail(user.getEmail()) != null) return false;
        user.setUserId(FileHandler.generateId(FILE, "U"));
        return FileHandler.appendLine(FILE, user.toFileString());
    }

    public List<User> getAllUsers() {
        return parseAll();
    }

    public User findUserById(String userId) {
        String record = FileHandler.findById(FILE, userId);
        return record != null ? User.fromFileString(record) : null;
    }

    public User findUserByEmail(String email) {
        return parseAll().stream()
                .filter(u -> u.getEmail().equalsIgnoreCase(email))
                .findFirst().orElse(null);
    }

    public User authenticateUser(String email, String password) {
        User user = findUserByEmail(email);
        return (user != null && user.authenticate(email, password)) ? user : null;
    }

    public boolean updateUser(User user) {
        return FileHandler.updateRecord(FILE, user.getUserId(), user.toFileString());
    }

    public boolean deleteUser(String userId) {
        return FileHandler.deleteRecord(FILE, userId);
    }

    public List<User> getAllRegularUsers() {
        return parseAll().stream()
                .filter(u -> u instanceof RegularUser)
                .collect(Collectors.toList());
    }

    public List<User> getAllAdminUsers() {
        return parseAll().stream()
                .filter(u -> u instanceof AdminUser)
                .collect(Collectors.toList());
    }

    public List<User> searchUsersByName(String name) {
        return parseAll().stream()
                .filter(u -> u.getName().toLowerCase().contains(name.toLowerCase()))
                .collect(Collectors.toList());
    }
}
