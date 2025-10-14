package com.example.clinic.service.Interface;

import com.example.clinic.entities.Docteur;

import java.util.List;
import java.util.Optional;

public interface IDocteurService {

    Docteur registerDocteur(String nom, String prenom, String email, String motDePasse,
                            String specialite, Long departementId, Long salleId);

    Optional<Docteur> authenticate(String email, String motDePasse);

    Optional<Docteur> getDocteurById(Long id);

    List<Docteur> getAllDocteurs();

    List<Docteur> getDocteursByDepartement(Long departementId);

    List<Docteur> getDocteursBySpecialite(String specialite);

    Docteur updateDocteur(Long id, String nom, String prenom, String specialite, Long departementId, Long salleId);

    boolean updatePassword(Long docteurId, String oldPassword, String newPassword);

    Docteur getDocteurWithConsultations(Long id);

    void deleteDocteur(Long id);

    long getTotalDocteurs();

    boolean emailExists(String email);

    boolean assignRoom(Long docteurId, Long salleId);

    boolean unassignRoom(Long docteurId);

    List<Docteur> getDoctorsWithoutRoom();

    Optional<Docteur> getDoctorByRoom(Long salleId);
}