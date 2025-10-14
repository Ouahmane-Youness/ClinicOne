package com.example.clinic.service.Interface;

import com.example.clinic.entities.Departement;

import java.util.List;
import java.util.Optional;

public interface IDepartementService {

    Departement createDepartement(String nom);

    Optional<Departement> getDepartementById(Long id);

    Optional<Departement> getDepartementByNom(String nom);

    List<Departement> getAllDepartements();

    List<Departement> searchDepartementsByNom(String nom);

    Departement getDepartementWithDocteurs(Long id);

    Departement updateDepartement(Long id, String nom);

    void deleteDepartement(Long id);

    long getTotalDepartements();

    boolean departementExists(String nom);

    int getDocteurCount(Long departementId);
}