package com.example.clinic.entities;


import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
public class Consultation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idConsultation;

    private LocalDate date;
    private LocalTime heure;

    @Enumerated(EnumType.STRING)
    private StatutConsultation statut;

    @Column(length = 2000)
    private String compteRendu;

    @ManyToOne
    @JoinColumn(name = "patient_id")
    private Patient patient;

    @ManyToOne
    @JoinColumn(name = "docteur_id")
    private Docteur docteur;

    @ManyToOne
    @JoinColumn(name = "salle_id")
    private Salle salle;

    public Consultation() {
    }

    public Consultation(LocalDate date, LocalTime heure, StatutConsultation statut, Patient patient, Docteur docteur, Salle salle) {
        this.date = date;
        this.heure = heure;
        this.statut = statut;
        this.patient = patient;
        this.docteur = docteur;
        this.salle = salle;
    }

    public Long getIdConsultation() {
        return idConsultation;
    }

    public void setIdConsultation(Long idConsultation) {
        this.idConsultation = idConsultation;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public LocalTime getHeure() {
        return heure;
    }

    public void setHeure(LocalTime heure) {
        this.heure = heure;
    }

    public StatutConsultation getStatut() {
        return statut;
    }

    public void setStatut(StatutConsultation statut) {
        this.statut = statut;
    }

    public String getCompteRendu() {
        return compteRendu;
    }

    public void setCompteRendu(String compteRendu) {
        this.compteRendu = compteRendu;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public Docteur getDocteur() {
        return docteur;
    }

    public void setDocteur(Docteur docteur) {
        this.docteur = docteur;
    }

    public Salle getSalle() {
        return salle;
    }

    public void setSalle(Salle salle) {
        this.salle = salle;
    }
}