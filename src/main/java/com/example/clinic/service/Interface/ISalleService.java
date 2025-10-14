package com.example.clinic.service.Interface;

import com.example.clinic.entities.Salle;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

public interface ISalleService {

    Salle createSalle(String nomSalle, Integer capacite);

    Optional<Salle> getSalleById(Long id);

    List<Salle> getAllSalles();

    Salle updateSalle(Long id, String nomSalle, Integer capacite);

    void deleteSalle(Long id);

    boolean isRoomAvailable(Long salleId, LocalDate date, LocalTime time);

    List<Salle> findAvailableRooms(LocalDate date, LocalTime time);

    void blockTimeSlot(Long salleId, LocalDate date, LocalTime time);

    void freeTimeSlot(Long salleId, LocalDate date, LocalTime time);

    Salle findAnyAvailableRoom(LocalDate date, LocalTime time);

    long getTotalSalles();

    List<LocalDateTime> getOccupiedSlots(Long salleId);
}