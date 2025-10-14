package com.example.clinic.service;

import com.example.clinic.entities.Departement;
import com.example.clinic.repository.DepartementRepository;
import com.example.clinic.service.Interface.IDepartementService;

import java.util.List;
import java.util.Optional;

public class DepartementService implements IDepartementService {

    private final DepartementRepository departementRepository;

    public DepartementService() {
        this.departementRepository = new DepartementRepository();
    }

    @Override
    public Departement createDepartement(String nom) {
        if (nom == null || nom.trim().isEmpty()) {
            throw new IllegalArgumentException("Department name cannot be empty");
        }

        Optional<Departement> existing = departementRepository.findByNom(nom.trim());
        if (existing.isPresent()) {
            throw new IllegalArgumentException("Department with name '" + nom + "' already exists");
        }

        Departement departement = new Departement(nom.trim());
        return departementRepository.save(departement);
    }

    @Override
    public Optional<Departement> getDepartementById(Long id) {
        return departementRepository.findById(id);
    }

    @Override
    public Optional<Departement> getDepartementByNom(String nom) {
        if (nom == null || nom.trim().isEmpty()) {
            return Optional.empty();
        }
        return departementRepository.findByNom(nom.trim());
    }

    @Override
    public List<Departement> getAllDepartements() {
        return departementRepository.findAll();
    }

    @Override
    public List<Departement> searchDepartementsByNom(String nom) {
        if (nom == null || nom.trim().isEmpty()) {
            return List.of();
        }
        return departementRepository.searchByNom(nom.trim());
    }

    @Override
    public Departement getDepartementWithDocteurs(Long id) {
        Departement departement = departementRepository.findByIdWithDocteurs(id);
        if (departement == null) {
            throw new IllegalArgumentException("Department not found with ID: " + id);
        }
        return departement;
    }

    @Override
    public Departement updateDepartement(Long id, String nom) {
        Optional<Departement> existingDept = departementRepository.findById(id);

        if (existingDept.isEmpty()) {
            throw new IllegalArgumentException("Department not found with ID: " + id);
        }

        if (nom == null || nom.trim().isEmpty()) {
            throw new IllegalArgumentException("Department name cannot be empty");
        }

        Optional<Departement> duplicateCheck = departementRepository.findByNom(nom.trim());
        if (duplicateCheck.isPresent() && !duplicateCheck.get().getIdDepartement().equals(id)) {
            throw new IllegalArgumentException("Another department with name '" + nom + "' already exists");
        }

        Departement departement = existingDept.get();
        departement.setNom(nom.trim());

        return departementRepository.update(departement);
    }

    @Override
    public void deleteDepartement(Long id) {
        Optional<Departement> departement = departementRepository.findById(id);

        if (departement.isEmpty()) {
            throw new IllegalArgumentException("Department not found with ID: " + id);
        }

        Departement dept = getDepartementWithDocteurs(id);
        if (!dept.getDocteurs().isEmpty()) {
            throw new IllegalStateException("Cannot delete department with assigned doctors. " +
                    "Reassign or remove doctors first.");
        }

        departementRepository.delete(id);
    }

    @Override
    public long getTotalDepartements() {
        return departementRepository.count();
    }

    @Override
    public boolean departementExists(String nom) {
        return departementRepository.findByNom(nom).isPresent();
    }

    @Override
    public int getDocteurCount(Long departementId) {
        Departement dept = getDepartementWithDocteurs(departementId);
        return dept.getDocteurs().size();
    }
}