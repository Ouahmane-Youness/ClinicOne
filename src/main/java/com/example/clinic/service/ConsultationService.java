package com.example.clinic.service;

import com.example.clinic.entities.*;
import com.example.clinic.repository.*;
import com.example.clinic.service.Interface.IConsultationService;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ConsultationService implements IConsultationService {

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

    @Override
    public Consultation bookConsultation(Long patientId, Long docteurId,
                                         LocalDate date, LocalTime time) {

        if (patientId == null || docteurId == null || date == null || time == null) {
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

        Salle doctorRoom = docteur.get().getSalle();
        if (doctorRoom == null) {
            throw new IllegalStateException("Doctor has no assigned room. Please contact administration.");
        }

        if (!salleRepository.isRoomAvailable(doctorRoom.getIdSalle(), date.atTime(time))) {
            throw new IllegalStateException("Doctor is not available at the requested time");
        }

        Consultation consultation = new Consultation(
                date, time, StatutConsultation.RESERVEE,
                patient.get(), docteur.get(), doctorRoom
        );

        consultation = consultationRepository.save(consultation);

        salleRepository.addOccupiedSlot(doctorRoom.getIdSalle(), date.atTime(time));

        return consultation;
    }

    @Override
    public Consultation bookConsultationWithAutoRoom(Long patientId, Long docteurId,
                                                     LocalDate date, LocalTime time) {

        return bookConsultation(patientId, docteurId, date, time);
    }

    @Override
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

    @Override
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

    @Override
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

    @Override
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

    @Override
    public Optional<Consultation> getConsultationById(Long id) {
        return consultationRepository.findById(id);
    }

    @Override
    public Consultation getConsultationWithDetails(Long id) {
        Consultation consultation = consultationRepository.findByIdWithDetails(id);
        if (consultation == null) {
            throw new IllegalArgumentException("Consultation not found with ID: " + id);
        }
        return consultation;
    }

    @Override
    public List<Consultation> getAllConsultations() {
        return consultationRepository.findAll();
    }

    @Override
    public List<Consultation> getPatientConsultations(Long patientId) {
        return consultationRepository.findByPatient(patientId);
    }

    @Override
    public List<Consultation> getDocteurConsultations(Long docteurId) {
        return consultationRepository.findByDocteur(docteurId);
    }

    @Override
    public List<Consultation> getConsultationsByStatut(StatutConsultation statut) {
        return consultationRepository.findByStatut(statut);
    }

    @Override
    public List<Consultation> getConsultationsByDate(LocalDate date) {
        return consultationRepository.findByDate(date);
    }

    @Override
    public List<Consultation> getConsultationsInDateRange(LocalDate startDate, LocalDate endDate) {
        return consultationRepository.findByDateRange(startDate, endDate);
    }

    @Override
    public List<Consultation> getUpcomingConsultationsForPatient(Long patientId) {
        return consultationRepository.findUpcomingByPatient(patientId, LocalDate.now());
    }

    @Override
    public List<Consultation> getUpcomingConsultationsForDocteur(Long docteurId) {
        return consultationRepository.findUpcomingByDocteur(docteurId, LocalDate.now());
    }

    @Override
    public List<Consultation> getPastConsultationsForPatient(Long patientId) {
        return consultationRepository.findPastByPatient(patientId, LocalDate.now());
    }

    @Override
    public long getTotalConsultations() {
        return consultationRepository.count();
    }

    @Override
    public long getConsultationCountByStatut(StatutConsultation statut) {
        return consultationRepository.countByStatut(statut);
    }

    @Override
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

    @Override
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

    @Override
    public Consultation rescheduleConsultation(Long consultationId, Long patientId,
                                               LocalDate newDate, LocalTime newTime) {

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

        Salle doctorRoom = consultation.getDocteur().getSalle();
        if (doctorRoom == null) {
            throw new IllegalStateException("Doctor has no assigned room");
        }

        if (!salleRepository.isRoomAvailable(doctorRoom.getIdSalle(), newDate.atTime(newTime))) {
            throw new IllegalStateException("Doctor is not available at the new requested time");
        }

        salleRepository.removeOccupiedSlot(
                consultation.getSalle().getIdSalle(),
                consultation.getDate().atTime(consultation.getHeure())
        );

        consultation.setDate(newDate);
        consultation.setHeure(newTime);
        consultation.setSalle(doctorRoom);
        consultation.setStatut(StatutConsultation.RESERVEE);

        Consultation updated = consultationRepository.update(consultation);

        salleRepository.addOccupiedSlot(doctorRoom.getIdSalle(), newDate.atTime(newTime));

        return updated;
    }
    public List<Consultation> getCompletedConsultationsForPatient(Long patientId) {
        return consultationRepository.findCompletedByPatient(patientId);
    }

    @Override
    public List<LocalTime> getAvailableTimeSlotsForDoctor(Long docteurId, LocalDate date) {
        Optional<Docteur> docteurOpt = docteurRepository.findByIdWithSalle(docteurId);
        if (docteurOpt.isEmpty()) {
            throw new IllegalArgumentException("Doctor not found with ID: " + docteurId);
        }

        Docteur docteur = docteurOpt.get();
        Salle doctorRoom = docteur.getSalle();

        if (doctorRoom == null) {
            throw new IllegalStateException("Doctor has no assigned room");
        }

        List<java.time.LocalDateTime> occupiedSlots = doctorRoom.getCreneauxOccupes().stream()
                .filter(slot -> slot.toLocalDate().equals(date))
                .toList();

        List<LocalTime> allTimeSlots = new ArrayList<>();
        LocalTime start = LocalTime.of(9, 0);
        LocalTime end = LocalTime.of(17, 0);

        while (start.isBefore(end)) {
            allTimeSlots.add(start);
            start = start.plusMinutes(30);
        }

        return allTimeSlots.stream()
                .filter(time -> !occupiedSlots.contains(date.atTime(time)))
                .toList();
    }
}