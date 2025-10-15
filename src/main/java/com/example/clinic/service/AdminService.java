package com.example.clinic.service;

import com.example.clinic.entities.Admin;
import com.example.clinic.repository.AdminRepository;

import java.util.List;
import java.util.Optional;

public class AdminService {

    private final AdminRepository adminRepository;

    public AdminService() {
        this.adminRepository = new AdminRepository();
    }

    public Admin registerAdmin(String nom, String prenom, String email, String motDePasse, String username) {

        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email cannot be empty");
        }

        Optional<Admin> existingAdmin = adminRepository.findByEmail(email);
        if (existingAdmin.isPresent()) {
            throw new IllegalArgumentException("Email already registered");
        }

        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username cannot be empty");
        }

        Optional<Admin> existingUsername = adminRepository.findByUsername(username);
        if (existingUsername.isPresent()) {
            throw new IllegalArgumentException("Username already taken");
        }

        if (motDePasse == null || motDePasse.length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters");
        }

        Admin admin = new Admin(nom, prenom, email, motDePasse, username);
        return adminRepository.save(admin);
    }

    public Optional<Admin> authenticate(String email, String motDePasse) {
        Optional<Admin> admin = adminRepository.findByEmail(email);

        if (admin.isPresent() && admin.get().getMotDePasse().equals(motDePasse)) {
            return admin;
        }

        return Optional.empty();
    }

    public Optional<Admin> getAdminById(Long id) {
        return adminRepository.findById(id);
    }

    public List<Admin> getAllAdmins() {
        return adminRepository.findAll();
    }

    public Admin updateAdmin(Long id, String nom, String prenom) {
        Optional<Admin> existingAdmin = adminRepository.findById(id);

        if (existingAdmin.isEmpty()) {
            throw new IllegalArgumentException("Admin not found with ID: " + id);
        }

        Admin admin = existingAdmin.get();

        if (nom != null && !nom.trim().isEmpty()) {
            admin.setNom(nom);
        }
        if (prenom != null && !prenom.trim().isEmpty()) {
            admin.setPrenom(prenom);
        }

        return adminRepository.update(admin);
    }

    public boolean updatePassword(Long adminId, String oldPassword, String newPassword) {
        Optional<Admin> adminOpt = adminRepository.findById(adminId);

        if (adminOpt.isEmpty()) {
            return false;
        }

        Admin admin = adminOpt.get();

        if (!admin.getMotDePasse().equals(oldPassword)) {
            return false;
        }

        if (newPassword == null || newPassword.length() < 6) {
            throw new IllegalArgumentException("New password must be at least 6 characters");
        }

        admin.setMotDePasse(newPassword);
        adminRepository.update(admin);
        return true;
    }

    public void deleteAdmin(Long id) {
        Optional<Admin> admin = adminRepository.findById(id);
        if (admin.isEmpty()) {
            throw new IllegalArgumentException("Admin not found with ID: " + id);
        }
        adminRepository.delete(id);
    }

    public long getTotalAdmins() {
        return adminRepository.count();
    }

    public boolean emailExists(String email) {
        return adminRepository.findByEmail(email).isPresent();
    }

    public boolean usernameExists(String username) {
        return adminRepository.findByUsername(username).isPresent();
    }
}