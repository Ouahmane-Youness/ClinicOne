package com.example.clinic.service;

import com.example.clinic.entities.Departement;
import com.example.clinic.entities.Docteur;
import com.example.clinic.entities.Salle;
import com.example.clinic.repository.DepartementRepository;
import com.example.clinic.repository.DocteurRepository;
import com.example.clinic.repository.SalleRepository;
import com.example.clinic.service.Interface.IDocteurService;

import java.util.List;
import java.util.Optional;

public class DocteurService implements IDocteurService {

    private final DocteurRepository docteurRepository;
    private final DepartementRepository departementRepository;
    private final SalleRepository salleRepository;

    public DocteurService() {
        this.docteurRepository = new DocteurRepository();
        this.departementRepository = new DepartementRepository();
        this.salleRepository = new SalleRepository();
    }

    @Override
    public Docteur registerDocteur(String nom, String prenom, String email, String motDePasse,
                                   String specialite, Long departementId, Long salleId) {

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

        Salle salle = null;
        if (salleId != null) {
            Optional<Salle> salleOpt = salleRepository.findById(salleId);
            if (salleOpt.isEmpty()) {
                throw new IllegalArgumentException("Room not found with ID: " + salleId);
            }

            Optional<Docteur> existingAssignment = docteurRepository.findBySalle(salleId);
            if (existingAssignment.isPresent()) {
                throw new IllegalArgumentException("Room already assigned to Dr. " +
                        existingAssignment.get().getNom());
            }

            salle = salleOpt.get();
        }

        Docteur docteur = new Docteur(nom, prenom, email, motDePasse, specialite, departement.get(), salle);
        return docteurRepository.save(docteur);
    }

    @Override
    public Optional<Docteur> authenticate(String email, String motDePasse) {
        Optional<Docteur> docteur = docteurRepository.findByEmail(email);

        if (docteur.isPresent() && docteur.get().getMotDePasse().equals(motDePasse)) {
            return docteur;
        }

        return Optional.empty();
    }

    @Override
    public Optional<Docteur> getDocteurById(Long id) {
        return docteurRepository.findById(id);
    }

    @Override
    public List<Docteur> getAllDocteurs() {
        return docteurRepository.findAll();
    }

    @Override
    public List<Docteur> getDocteursByDepartement(Long departementId) {
        return docteurRepository.findByDepartement(departementId);
    }

    @Override
    public List<Docteur> getDocteursBySpecialite(String specialite) {
        if (specialite == null || specialite.trim().isEmpty()) {
            return List.of();
        }
        return docteurRepository.findBySpecialite(specialite.trim());
    }

    @Override
    public Docteur updateDocteur(Long id, String nom, String prenom, String specialite, Long departementId, Long salleId) {
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

        if (salleId != null) {
            Optional<Salle> salle = salleRepository.findById(salleId);
            if (salle.isEmpty()) {
                throw new IllegalArgumentException("Room not found with ID: " + salleId);
            }

            Optional<Docteur> existingAssignment = docteurRepository.findBySalle(salleId);
            if (existingAssignment.isPresent() && !existingAssignment.get().getId().equals(id)) {
                throw new IllegalArgumentException("Room already assigned to Dr. " +
                        existingAssignment.get().getNom());
            }

            docteur.setSalle(salle.get());
        }

        return docteurRepository.update(docteur);
    }

    @Override
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

    @Override
    public Docteur getDocteurWithConsultations(Long id) {
        return docteurRepository.findByIdWithConsultations(id);
    }

    @Override
    public void deleteDocteur(Long id) {
        Optional<Docteur> docteur = docteurRepository.findById(id);
        if (docteur.isEmpty()) {
            throw new IllegalArgumentException("Doctor not found with ID: " + id);
        }
        docteurRepository.delete(id);
    }

    @Override
    public long getTotalDocteurs() {
        return docteurRepository.count();
    }

    @Override
    public boolean emailExists(String email) {
        return docteurRepository.findByEmail(email).isPresent();
    }

    @Override
    public boolean assignRoom(Long docteurId, Long salleId) {
        Optional<Docteur> docteurOpt = docteurRepository.findById(docteurId);
        if (docteurOpt.isEmpty()) {
            throw new IllegalArgumentException("Doctor not found with ID: " + docteurId);
        }

        Optional<Salle> salleOpt = salleRepository.findById(salleId);
        if (salleOpt.isEmpty()) {
            throw new IllegalArgumentException("Room not found with ID: " + salleId);
        }

        Optional<Docteur> existingAssignment = docteurRepository.findBySalle(salleId);
        if (existingAssignment.isPresent()) {
            throw new IllegalArgumentException("Room already assigned to Dr. " +
                    existingAssignment.get().getNom());
        }

        Docteur docteur = docteurOpt.get();
        docteur.setSalle(salleOpt.get());
        docteurRepository.update(docteur);
        return true;
    }

    @Override
    public boolean unassignRoom(Long docteurId) {
        Optional<Docteur> docteurOpt = docteurRepository.findById(docteurId);
        if (docteurOpt.isEmpty()) {
            throw new IllegalArgumentException("Doctor not found with ID: " + docteurId);
        }

        Docteur docteur = docteurOpt.get();
        docteur.setSalle(null);
        docteurRepository.update(docteur);
        return true;
    }

    @Override
    public List<Docteur> getDoctorsWithoutRoom() {
        return docteurRepository.findDoctorsWithoutRoom();
    }

    @Override
    public Optional<Docteur> getDoctorByRoom(Long salleId) {
        return docteurRepository.findBySalle(salleId);
    }
}