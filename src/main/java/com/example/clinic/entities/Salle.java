package com.example.clinic.entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Salle {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idSalle;

    private String nomSalle;
    private Integer capacite;

    @ElementCollection
    @CollectionTable(name = "salle_creneaux", joinColumns = @JoinColumn(name = "salle_id"))
    @Column(name = "creneau")
    private List<LocalDateTime> creneauxOccupes = new ArrayList<>();

    @OneToMany(mappedBy = "salle")
    private List<Consultation> consultations = new ArrayList<>();

    public Salle() {
    }

    public Salle(String nomSalle, Integer capacite) {
        this.nomSalle = nomSalle;
        this.capacite = capacite;
    }

    public Long getIdSalle() {
        return idSalle;
    }

    public void setIdSalle(Long idSalle) {
        this.idSalle = idSalle;
    }

    public String getNomSalle() {
        return nomSalle;
    }

    public void setNomSalle(String nomSalle) {
        this.nomSalle = nomSalle;
    }

    public Integer getCapacite() {
        return capacite;
    }

    public void setCapacite(Integer capacite) {
        this.capacite = capacite;
    }

    public List<LocalDateTime> getCreneauxOccupes() {
        return creneauxOccupes;
    }

    public void setCreneauxOccupes(List<LocalDateTime> creneauxOccupes) {
        this.creneauxOccupes = creneauxOccupes;
    }

    public List<Consultation> getConsultations() {
        return consultations;
    }

    public void setConsultations(List<Consultation> consultations) {
        this.consultations = consultations;
    }
}
