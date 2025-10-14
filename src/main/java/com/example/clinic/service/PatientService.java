package com.example.clinic.service;

import com.example.clinic.entities.Patient;
import com.example.clinic.repository.PatientRepository;
import com.example.clinic.service.Interface.IPatientService;

import java.util.List;
import java.util.Optional;

public class PatientService implements IPatientService {

    private final PatientRepository patientRepository;

    public PatientService() {
        this.patientRepository = new PatientRepository();
    }

    @Override
    public Patient registerPatient(String nom, String prenom, String email, String motDePasse,
                                   Double poids, Double taille) {

        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email cannot be empty");
        }

        Optional<Patient> existingPatient = patientRepository.findByEmail(email);
        if (existingPatient.isPresent()) {
            throw new IllegalArgumentException("Email already registered");
        }

        if (motDePasse == null || motDePasse.length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters");
        }

        Patient patient = new Patient(nom, prenom, email, motDePasse, poids, taille);
        return patientRepository.save(patient);
    }

    @Override
    public Optional<Patient> authenticate(String email, String motDePasse) {
        Optional<Patient> patient = patientRepository.findByEmail(email);

        if (patient.isPresent() && patient.get().getMotDePasse().equals(motDePasse)) {
            return patient;
        }

        return Optional.empty();
    }

    @Override
    public Optional<Patient> getPatientById(Long id) {
        return patientRepository.findById(id);
    }

    @Override
    public List<Patient> getAllPatients() {
        return patientRepository.findAll();
    }

    @Override
    public List<Patient> searchPatientsByNom(String nom) {
        if (nom == null || nom.trim().isEmpty()) {
            return List.of();
        }
        return patientRepository.findByNom(nom.trim());
    }

    @Override
    public Patient updatePatient(Long id, String nom, String prenom, Double poids, Double taille) {
        Optional<Patient> existingPatient = patientRepository.findById(id);

        if (existingPatient.isEmpty()) {
            throw new IllegalArgumentException("Patient not found with ID: " + id);
        }

        Patient patient = existingPatient.get();

        if (nom != null && !nom.trim().isEmpty()) {
            patient.setNom(nom);
        }
        if (prenom != null && !prenom.trim().isEmpty()) {
            patient.setPrenom(prenom);
        }
        if (poids != null && poids > 0) {
            patient.setPoids(poids);
        }
        if (taille != null && taille > 0) {
            patient.setTaille(taille);
        }

        return patientRepository.update(patient);
    }

    @Override
    public boolean updatePassword(Long patientId, String oldPassword, String newPassword) {
        Optional<Patient> patientOpt = patientRepository.findById(patientId);

        if (patientOpt.isEmpty()) {
            return false;
        }

        Patient patient = patientOpt.get();

        if (!patient.getMotDePasse().equals(oldPassword)) {
            return false;
        }

        if (newPassword == null || newPassword.length() < 6) {
            throw new IllegalArgumentException("New password must be at least 6 characters");
        }

        patient.setMotDePasse(newPassword);
        patientRepository.update(patient);
        return true;
    }

    @Override
    public void deletePatient(Long id) {
        Optional<Patient> patient = patientRepository.findById(id);
        if (patient.isEmpty()) {
            throw new IllegalArgumentException("Patient not found with ID: " + id);
        }
        patientRepository.delete(id);
    }

    @Override
    public long getTotalPatients() {
        return patientRepository.count();
    }

    @Override
    public boolean emailExists(String email) {
        return patientRepository.findByEmail(email).isPresent();
    }
}