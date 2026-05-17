package com.carsplatform.filehandler;

import java.io.*;
import java.nio.file.*;
import java.util.*;

public class FileHandler {

    private static String dataDirectory = "src/main/webapp/data";

    public static synchronized void setDataDirectory(String directory) {
        if (directory != null && !directory.trim().isEmpty()) {
            dataDirectory = directory;
        }
    }

    public static synchronized String getDataDirectory() {
        return dataDirectory;
    }

    // ── Read ──────────────────────────────────────────────────────────────────

    public static List<String> readAllLines(String fileName) {
        Path path = Paths.get(dataDirectory, fileName);
        try {
            if (!Files.exists(path)) {
                Files.createDirectories(path.getParent());
                Files.createFile(path);
                return new ArrayList<>();
            }
            return Files.readAllLines(path);
        } catch (IOException e) {
            System.err.println("FileHandler: cannot read " + path + " — " + e.getMessage());
            return new ArrayList<>();
        }
    }

    public static String findById(String fileName, String id) {
        for (String line : readAllLines(fileName)) {
            if (line.trim().isEmpty()) continue;
            String[] f = line.split("\\|");
            if (f.length > 0 && f[0].equals(id)) return line;
        }
        return null;
    }

    // ── Write ─────────────────────────────────────────────────────────────────

    public static boolean appendLine(String fileName, String record) {
        Path path = Paths.get(dataDirectory, fileName);
        try {
            if (!Files.exists(path)) {
                Files.createDirectories(path.getParent());
                Files.createFile(path);
            }
            try (BufferedWriter bw = new BufferedWriter(new FileWriter(path.toFile(), true))) {
                bw.write(record);
                bw.newLine();
            }
            return true;
        } catch (IOException e) {
            System.err.println("FileHandler: cannot append to " + path + " — " + e.getMessage());
            return false;
        }
    }

    public static boolean rewriteFile(String fileName, List<String> lines) {
        Path path = Paths.get(dataDirectory, fileName);
        try {
            if (!Files.exists(path)) {
                Files.createDirectories(path.getParent());
            }
            Files.write(path, lines);
            return true;
        } catch (IOException e) {
            System.err.println("FileHandler: cannot rewrite " + path + " — " + e.getMessage());
            return false;
        }
    }

    // ── Update / Delete ───────────────────────────────────────────────────────

    public static boolean updateRecord(String fileName, String id, String newRecord) {
        List<String> lines = readAllLines(fileName);
        List<String> updated = new ArrayList<>();
        boolean found = false;
        for (String line : lines) {
            if (line.trim().isEmpty()) continue;
            String[] f = line.split("\\|");
            if (f.length > 0 && f[0].equals(id)) {
                updated.add(newRecord);
                found = true;
            } else {
                updated.add(line);
            }
        }
        return found && rewriteFile(fileName, updated);
    }

    public static boolean deleteRecord(String fileName, String id) {
        List<String> lines = readAllLines(fileName);
        List<String> updated = new ArrayList<>();
        boolean found = false;
        for (String line : lines) {
            if (line.trim().isEmpty()) continue;
            String[] f = line.split("\\|");
            if (f.length > 0 && f[0].equals(id)) {
                found = true;
            } else {
                updated.add(line);
            }
        }
        return found && rewriteFile(fileName, updated);
    }

    // ── ID generation ─────────────────────────────────────────────────────────

    public static String generateId(String fileName, String prefix) {
        int max = 1000;
        for (String line : readAllLines(fileName)) {
            if (line.trim().isEmpty()) continue;
            String[] f = line.split("\\|");
            if (f.length > 0) {
                try {
                    int n = Integer.parseInt(f[0].replaceAll("[^0-9]", ""));
                    if (n > max) max = n;
                } catch (NumberFormatException ignored) {}
            }
        }
        return prefix + (max + 1);
    }
}
