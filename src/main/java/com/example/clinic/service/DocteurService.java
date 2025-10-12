package com.example.clinic.service;

import com.example.clinic.entities.Departement;
import com.example.clinic.entities.Docteur;
import com.example.clinic.repository.DepartementRepository;
import com.example.clinic.repository.DocteurRepository;

import java.util.List;
import java.util.Optional;

public class DocteurService {

    private final DocteurRepository docteurRepository;
    private final DepartementRepository departementRepository;

    public DocteurService() {
        this.docteurRepository = new DocteurRepository();
        this.departementRepository = new DepartementRepository();
    }

    public Docteur registerDocteur(String nom, String prenom, String email, String motDePasse,
                                   String specialite, Long departementId) {

        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email cannot be empty");
        }

        Optional<Docteur> existingDocteur = docteurRepository.findByEmail(email);
        if (existingDocteur.isPresent()) {
            throw new IllegalArgumentException("Email already registered");
        }

        if (motDePasse == null || motDePasse.length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters");
        }

        if (specialite == null || specialite.trim().isEmpty()) {
            throw new IllegalArgumentException("Specialite cannot be empty");
        }

        Optional<Departement> departement = departementRepository.findById(departementId);
        if (departement.isEmpty()) {
            throw new IllegalArgumentException("Department not found with ID: " + departementId);
        }

        Docteur docteur = new Docteur(nom, prenom, email, motDePasse, specialite, departement.get());
        return docteurRepository.save(docteur);
    }

    public Optional<Docteur> authenticate(String email, String motDePasse) {
        Optional<Docteur> docteur = docteurRepository.findByEmail(email);

        if (docteur.isPresent() && docteur.get().getMotDePasse().equals(motDePasse)) {
            return docteur;
        }

        return Optional.empty();
    }

    public Optional<Docteur> getDocteurById(Long id) {
        return docteurRepository.findById(id);
    }

    public List<Docteur> getAllDocteurs() {
        return docteurRepository.findAll();
    }

    public List<Docteur> getDocteursByDepartement(Long departementId) {
        return docteurRepository.findByDepartement(departementId);
    }

    public List<Docteur> getDocteursBySpecialite(String specialite) {
        if (specialite == null || specialite.trim().isEmpty()) {
            return List.of();
        }
        return docteurRepository.findBySpecialite(specialite.trim());
    }

    public Docteur updateDocteur(Long id, String nom, String prenom, String specialite, Long departementId) {
        Optional<Docteur> existingDocteur = docteurRepository.findById(id);

        if (existingDocteur.isEmpty()) {
            throw new IllegalArgumentException("Doctor not found with ID: " + id);
        }

        Docteur docteur = existingDocteur.get();

        if (nom != null && !nom.trim().isEmpty()) {
            docteur.setNom(nom);
        }
        if (prenom != null && !prenom.trim().isEmpty()) {
            docteur.setPrenom(prenom);
        }
        if (specialite != null && !specialite.trim().isEmpty()) {
            docteur.setSpecialite(specialite);
        }
        if (departementId != null) {
            Optional<Departement> departement = departementRepository.findById(departementId);
            if (departement.isEmpty()) {
                throw new IllegalArgumentException("Department not found with ID: " + departementId);
            }
            docteur.setDepartement(departement.get());
        }

        return docteurRepository.update(docteur);
    }

    public boolean updatePassword(Long docteurId, String oldPassword, String newPassword) {
        Optional<Docteur> docteurOpt = docteurRepository.findById(docteurId);

        if (docteurOpt.isEmpty()) {
            return false;
        }

        Docteur docteur = docteurOpt.get();

        if (!docteur.getMotDePasse().equals(oldPassword)) {
            return false;
        }

        if (newPassword == null || newPassword.length() < 6) {
            throw new IllegalArgumentException("New password must be at least 6 characters");
        }

        docteur.setMotDePasse(newPassword);
        docteurRepository.update(docteur);
        return true;
    }

    public Docteur getDocteurWithConsultations(Long id) {
        return docteurRepository.findByIdWithConsultations(id);
    }

    public void deleteDocteur(Long id) {
        Optional<Docteur> docteur = docteurRepository.findById(id);
        if (docteur.isEmpty()) {
            throw new IllegalArgumentException("Doctor not found with ID: " + id);
        }
        docteurRepository.delete(id);
    }

    public long getTotalDocteurs() {
        return docteurRepository.count();
    }

    public boolean emailExists(String email) {
        return docteurRepository.findByEmail(email).isPresent();
    }
}