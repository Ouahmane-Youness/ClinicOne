package com.example.clinic.service.Interface;

import com.example.clinic.entities.Patient;

import java.util.List;
import java.util.Optional;

public interface IPatientService {

    Patient registerPatient(String nom, String prenom, String email, String motDePasse,
                            Double poids, Double taille);

    Optional<Patient> authenticate(String email, String motDePasse);

    Optional<Patient> getPatientById(Long id);

    List<Patient> getAllPatients();

    List<Patient> searchPatientsByNom(String nom);

    Patient updatePatient(Long id, String nom, String prenom, Double poids, Double taille);

    boolean updatePassword(Long patientId, String oldPassword, String newPassword);

    void deletePatient(Long id);

    long getTotalPatients();

    boolean emailExists(String email);
}