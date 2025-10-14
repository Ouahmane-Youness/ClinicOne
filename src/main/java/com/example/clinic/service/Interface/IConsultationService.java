package com.example.clinic.service.Interface;

import com.example.clinic.entities.Consultation;
import com.example.clinic.entities.StatutConsultation;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

public interface IConsultationService {

    Consultation bookConsultation(Long patientId, Long docteurId,
                                  LocalDate date, LocalTime time);

    Consultation bookConsultationWithAutoRoom(Long patientId, Long docteurId,
                                              LocalDate date, LocalTime time);

    Consultation validateConsultation(Long consultationId, Long docteurId);

    Consultation refuseConsultation(Long consultationId, Long docteurId);

    Consultation cancelConsultation(Long consultationId, Long patientId);

    Consultation completeConsultation(Long consultationId, Long docteurId, String compteRendu);

    Optional<Consultation> getConsultationById(Long id);

    Consultation getConsultationWithDetails(Long id);

    List<Consultation> getAllConsultations();

    List<Consultation> getPatientConsultations(Long patientId);

    List<Consultation> getDocteurConsultations(Long docteurId);

    List<Consultation> getConsultationsByStatut(StatutConsultation statut);

    List<Consultation> getConsultationsByDate(LocalDate date);

    List<Consultation> getConsultationsInDateRange(LocalDate startDate, LocalDate endDate);

    List<Consultation> getUpcomingConsultationsForPatient(Long patientId);

    List<Consultation> getUpcomingConsultationsForDocteur(Long docteurId);

    List<Consultation> getPastConsultationsForPatient(Long patientId);

    long getTotalConsultations();

    long getConsultationCountByStatut(StatutConsultation statut);

    void deleteConsultation(Long id);

    boolean canPatientBook(Long patientId, LocalDate date, LocalTime time);

    Consultation rescheduleConsultation(Long consultationId, Long patientId,
                                        LocalDate newDate, LocalTime newTime);

    List<LocalTime> getAvailableTimeSlotsForDoctor(Long docteurId, LocalDate date);
}