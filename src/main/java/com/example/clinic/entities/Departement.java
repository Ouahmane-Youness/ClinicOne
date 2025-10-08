package com.example.clinic.entities;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Departement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idDepartement;

    private String nom;

    @OneToMany(mappedBy = "departement", cascade = CascadeType.ALL)
    private List<Docteur> docteurs = new ArrayList<>();

    public Departement() {
    }

    public Departement(String nom) {
        this.nom = nom;
    }

    public Long getIdDepartement() {
        return idDepartement;
    }

    public void setIdDepartement(Long idDepartement) {
        this.idDepartement = idDepartement;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public List<Docteur> getDocteurs() {
        return docteurs;
    }

    public void setDocteurs(List<Docteur> docteurs) {
        this.docteurs = docteurs;
    }
}