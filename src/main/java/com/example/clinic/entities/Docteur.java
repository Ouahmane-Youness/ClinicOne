package com.example.clinic.entities;
import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Docteur extends Personne {

    private String specialite;

    @ManyToOne
    @JoinColumn(name = "departement_id")
    private Departement departement;

    @OneToMany(mappedBy = "docteur", cascade = CascadeType.ALL)
    private List<Consultation> consultations = new ArrayList<>();

    public Docteur() {
    }

    public Docteur(String nom, String prenom, String email, String motDePasse, String specialite, Departement departement) {
        super(nom, prenom, email, motDePasse);
        this.specialite = specialite;
        this.departement = departement;
    }

    public String getSpecialite() {
        return specialite;
    }

    public void setSpecialite(String specialite) {
        this.specialite = specialite;
    }

    public Departement getDepartement() {
        return departement;
    }

    public void setDepartement(Departement departement) {
        this.departement = departement;
    }

    public List<Consultation> getConsultations() {
        return consultations;
    }

    public void setConsultations(List<Consultation> consultations) {
        this.consultations = consultations;
    }
}