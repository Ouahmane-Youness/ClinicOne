package com.example.clinic.service;

import com.example.clinic.entities.*;
import com.example.clinic.repository.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

public class ConsultationService {

    private final ConsultationRepository consultationRepository;
    private final PatientRepository patientRepository;
    private final DocteurRepository docteurRepository;
    private final SalleRepository salleRepository;

    public ConsultationService() {
        this.consultationRepository = new ConsultationRepository();
        this.patientRepository = new PatientRepository();
        this.docteurRepository = new DocteurRepository();
        this.salleRepository = new SalleRepository();
    }

    public Consultation bookConsultation(Long patientId, Long docteurId, Long salleId,
                                         LocalDate date, LocalTime time) {

        if (patientId == null || docteurId == null || salleId == null || date == null || time == null) {
            throw new IllegalArgumentException("All parameters are required");
        }

        if (date.isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("Cannot book consultation in the past");
        }

        Optional<Patient> patient = patientRepository.findById(patientId);
        if (patient.isEmpty()) {
            throw new IllegalArgumentException("Patient not found with ID: " + patientId);
        }

        Optional<Docteur> docteur = docteurRepository.findById(docteurId);
        if (docteur.isEmpty()) {
            throw new IllegalArgumentException("Doctor not found with ID: " + docteurId);
        }

        Optional<Salle> salle = salleRepository.findById(salleId);
        if (salle.isEmpty()) {
            throw new IllegalArgumentException("Room not found with ID: " + salleId);
        }

        if (!salleRepository.isRoomAvailable(salleId, date.atTime(time))) {
            throw new IllegalStateException("Room is not available at the requested time");
        }

        Consultation consultation = new Consultation(
                date, time, StatutConsultation.RESERVEE,
                patient.get(), docteur.get(), salle.get()
        );

        consultation = consultationRepository.save(consultation);

        salleRepository.addOccupiedSlot(salleId, date.atTime(time));

        return consultation;
    }

    public Consultation bookConsultationWithAutoRoom(Long patientId, Long docteurId,
                                                     LocalDate date, LocalTime time) {

        List<Salle> availableRooms = salleRepository.findAvailableRooms(date.atTime(time));

        if (availableRooms.isEmpty()) {
            throw new IllegalStateException("No rooms available for the requested time");
        }

        return bookConsultation(patientId, docteurId, availableRooms.get(0).getIdSalle(), date, time);
    }

    public Consultation validateConsultation(Long consultationId, Long docteurId) {
        Optional<Consultation> consultationOpt = consultationRepository.findById(consultationId);

        if (consultationOpt.isEmpty()) {
            throw new IllegalArgumentException("Consultation not found with ID: " + consultationId);
        }

        Consultation consultation = consultationOpt.get();

        if (!consultation.getDocteur().getId().equals(docteurId)) {
            throw new IllegalArgumentException("Only the assigned doctor can validate this consultation");
        }

        if (consultation.getStatut() != StatutConsultation.RESERVEE) {
            throw new IllegalStateException("Only reserved consultations can be validated");
        }

        consultation.setStatut(StatutConsultation.VALIDEE);
        return consultationRepository.update(consultation);
    }

    public Consultation refuseConsultation(Long consultationId, Long docteurId) {
        Optional<Consultation> consultationOpt = consultationRepository.findById(consultationId);

        if (consultationOpt.isEmpty()) {
            throw new IllegalArgumentException("Consultation not found with ID: " + consultationId);
        }

        Consultation consultation = consultationOpt.get();

        if (!consultation.getDocteur().getId().equals(docteurId)) {
            throw new IllegalArgumentException("Only the assigned doctor can refuse this consultation");
        }

        if (consultation.getStatut() != StatutConsultation.RESERVEE) {
            throw new IllegalStateException("Only reserved consultations can be refused");
        }

        consultation.setStatut(StatutConsultation.ANNULEE);
        Consultation updated = consultationRepository.update(consultation);

        salleRepository.removeOccupiedSlot(
                consultation.getSalle().getIdSalle(),
                consultation.getDate().atTime(consultation.getHeure())
        );

        return updated;
    }

    public Consultation cancelConsultation(Long consultationId, Long patientId) {
        Optional<Consultation> consultationOpt = consultationRepository.findById(consultationId);

        if (consultationOpt.isEmpty()) {
            throw new IllegalArgumentException("Consultation not found with ID: " + consultationId);
        }

        Consultation consultation = consultationOpt.get();

        if (!consultation.getPatient().getId().equals(patientId)) {
            throw new IllegalArgumentException("Only the patient can cancel their own consultation");
        }

        if (consultation.getStatut() == StatutConsultation.TERMINEE) {
            throw new IllegalStateException("Cannot cancel a completed consultation");
        }

        if (consultation.getStatut() == StatutConsultation.ANNULEE) {
            throw new IllegalStateException("Consultation is already cancelled");
        }

        consultation.setStatut(StatutConsultation.ANNULEE);
        Consultation updated = consultationRepository.update(consultation);

        salleRepository.removeOccupiedSlot(
                consultation.getSalle().getIdSalle(),
                consultation.getDate().atTime(consultation.getHeure())
        );

        return updated;
    }

    public Consultation completeConsultation(Long consultationId, Long docteurId, String compteRendu) {
        Optional<Consultation> consultationOpt = consultationRepository.findById(consultationId);

        if (consultationOpt.isEmpty()) {
            throw new IllegalArgumentException("Consultation not found with ID: " + consultationId);
        }

        Consultation consultation = consultationOpt.get();

        if (!consultation.getDocteur().getId().equals(docteurId)) {
            throw new IllegalArgumentException("Only the assigned doctor can complete this consultation");
        }

        if (consultation.getStatut() != StatutConsultation.VALIDEE) {
            throw new IllegalStateException("Only validated consultations can be completed");
        }

        if (compteRendu == null || compteRendu.trim().isEmpty()) {
            throw new IllegalArgumentException("Medical report cannot be empty");
        }

        consultation.setStatut(StatutConsultation.TERMINEE);
        consultation.setCompteRendu(compteRendu.trim());

        return consultationRepository.update(consultation);
    }

    public Optional<Consultation> getConsultationById(Long id) {
        return consultationRepository.findById(id);
    }

    public Consultation getConsultationWithDetails(Long id) {
        Consultation consultation = consultationRepository.findByIdWithDetails(id);
        if (consultation == null) {
            throw new IllegalArgumentException("Consultation not found with ID: " + id);
        }
        return consultation;
    }

    public List<Consultation> getAllConsultations() {
        return consultationRepository.findAll();
    }

    public List<Consultation> getPatientConsultations(Long patientId) {
        return consultationRepository.findByPatient(patientId);
    }

    public List<Consultation> getDocteurConsultations(Long docteurId) {
        return consultationRepository.findByDocteur(docteurId);
    }

    public List<Consultation> getConsultationsByStatut(StatutConsultation statut) {
        return consultationRepository.findByStatut(statut);
    }

    public List<Consultation> getConsultationsByDate(LocalDate date) {
        return consultationRepository.findByDate(date);
    }

    public List<Consultation> getConsultationsInDateRange(LocalDate startDate, LocalDate endDate) {
        return consultationRepository.findByDateRange(startDate, endDate);
    }

    public List<Consultation> getUpcomingConsultationsForPatient(Long patientId) {
        return consultationRepository.findUpcomingByPatient(patientId, LocalDate.now());
    }

    public List<Consultation> getUpcomingConsultationsForDocteur(Long docteurId) {
        return consultationRepository.findUpcomingByDocteur(docteurId, LocalDate.now());
    }

    public List<Consultation> getPastConsultationsForPatient(Long patientId) {
        return consultationRepository.findPastByPatient(patientId, LocalDate.now());
    }

    public long getTotalConsultations() {
        return consultationRepository.count();
    }

    public long getConsultationCountByStatut(StatutConsultation statut) {
        return consultationRepository.countByStatut(statut);
    }

    public void deleteConsultation(Long id) {
        Optional<Consultation> consultationOpt = consultationRepository.findById(id);

        if (consultationOpt.isEmpty()) {
            throw new IllegalArgumentException("Consultation not found with ID: " + id);
        }

        Consultation consultation = consultationOpt.get();

        salleRepository.removeOccupiedSlot(
                consultation.getSalle().getIdSalle(),
                consultation.getDate().atTime(consultation.getHeure())
        );

        consultationRepository.delete(id);
    }

    public boolean canPatientBook(Long patientId, LocalDate date, LocalTime time) {
        List<Consultation> patientConsultations = consultationRepository.findByPatient(patientId);

        for (Consultation consultation : patientConsultations) {
            if (consultation.getDate().equals(date) &&
                    consultation.getHeure().equals(time) &&
                    (consultation.getStatut() == StatutConsultation.RESERVEE ||
                            consultation.getStatut() == StatutConsultation.VALIDEE)) {
                return false;
            }
        }

        return true;
    }

    public Consultation rescheduleConsultation(Long consultationId, Long patientId,
                                               LocalDate newDate, LocalTime newTime, Long newSalleId) {

        Optional<Consultation> consultationOpt = consultationRepository.findById(consultationId);

        if (consultationOpt.isEmpty()) {
            throw new IllegalArgumentException("Consultation not found with ID: " + consultationId);
        }

        Consultation consultation = consultationOpt.get();

        if (!consultation.getPatient().getId().equals(patientId)) {
            throw new IllegalArgumentException("Only the patient can reschedule their own consultation");
        }

        if (consultation.getStatut() == StatutConsultation.TERMINEE) {
            throw new IllegalStateException("Cannot reschedule a completed consultation");
        }

        if (consultation.getStatut() == StatutConsultation.ANNULEE) {
            throw new IllegalStateException("Cannot reschedule a cancelled consultation");
        }

        if (newDate.isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("Cannot reschedule to a past date");
        }

        Optional<Salle> newSalle = salleRepository.findById(newSalleId);
        if (newSalle.isEmpty()) {
            throw new IllegalArgumentException("Room not found with ID: " + newSalleId);
        }

        if (!salleRepository.isRoomAvailable(newSalleId, newDate.atTime(newTime))) {
            throw new IllegalStateException("New room is not available at the requested time");
        }

        salleRepository.removeOccupiedSlot(
                consultation.getSalle().getIdSalle(),
                consultation.getDate().atTime(consultation.getHeure())
        );

        consultation.setDate(newDate);
        consultation.setHeure(newTime);
        consultation.setSalle(newSalle.get());
        consultation.setStatut(StatutConsultation.RESERVEE);

        Consultation updated = consultationRepository.update(consultation);

        salleRepository.addOccupiedSlot(newSalleId, newDate.atTime(newTime));

        return updated;
    }
}