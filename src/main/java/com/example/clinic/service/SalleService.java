package com.example.clinic.service;

import com.example.clinic.entities.Salle;
import com.example.clinic.repository.SalleRepository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

public class SalleService {

    private final SalleRepository salleRepository;

    public SalleService() {
        this.salleRepository = new SalleRepository();
    }

    public Salle createSalle(String nomSalle, Integer capacite) {
        if (nomSalle == null || nomSalle.trim().isEmpty()) {
            throw new IllegalArgumentException("Room name cannot be empty");
        }

        if (capacite == null || capacite <= 0) {
            throw new IllegalArgumentException("Capacity must be greater than 0");
        }

        Optional<Salle> existing = salleRepository.findByNomSalle(nomSalle.trim());
        if (existing.isPresent()) {
            throw new IllegalArgumentException("Room with name '" + nomSalle + "' already exists");
        }

        Salle salle = new Salle(nomSalle.trim(), capacite);
        return salleRepository.save(salle);
    }

    public Optional<Salle> getSalleById(Long id) {
        return salleRepository.findById(id);
    }

    public List<Salle> getAllSalles() {
        return salleRepository.findAll();
    }

    public Salle updateSalle(Long id, String nomSalle, Integer capacite) {
        Optional<Salle> existingSalle = salleRepository.findById(id);

        if (existingSalle.isEmpty()) {
            throw new IllegalArgumentException("Room not found with ID: " + id);
        }

        Salle salle = existingSalle.get();

        if (nomSalle != null && !nomSalle.trim().isEmpty()) {
            Optional<Salle> duplicateCheck = salleRepository.findByNomSalle(nomSalle.trim());
            if (duplicateCheck.isPresent() && !duplicateCheck.get().getIdSalle().equals(id)) {
                throw new IllegalArgumentException("Another room with name '" + nomSalle + "' already exists");
            }
            salle.setNomSalle(nomSalle.trim());
        }

        if (capacite != null && capacite > 0) {
            salle.setCapacite(capacite);
        }

        return salleRepository.update(salle);
    }

    public void deleteSalle(Long id) {
        Optional<Salle> salle = salleRepository.findById(id);
        if (salle.isEmpty()) {
            throw new IllegalArgumentException("Room not found with ID: " + id);
        }
        salleRepository.delete(id);
    }

    public boolean isRoomAvailable(Long salleId, LocalDate date, LocalTime time) {
        if (salleId == null || date == null || time == null) {
            throw new IllegalArgumentException("Room ID, date, and time cannot be null");
        }

        LocalDateTime dateTime = LocalDateTime.of(date, time);
        return salleRepository.isRoomAvailable(salleId, dateTime);
    }

    public List<Salle> findAvailableRooms(LocalDate date, LocalTime time) {
        if (date == null || time == null) {
            throw new IllegalArgumentException("Date and time cannot be null");
        }

        LocalDateTime dateTime = LocalDateTime.of(date, time);
        return salleRepository.findAvailableRooms(dateTime);
    }

    public void blockTimeSlot(Long salleId, LocalDate date, LocalTime time) {
        if (salleId == null || date == null || time == null) {
            throw new IllegalArgumentException("Room ID, date, and time cannot be null");
        }

        Optional<Salle> salle = salleRepository.findById(salleId);
        if (salle.isEmpty()) {
            throw new IllegalArgumentException("Room not found with ID: " + salleId);
        }

        LocalDateTime dateTime = LocalDateTime.of(date, time);

        if (!salleRepository.isRoomAvailable(salleId, dateTime)) {
            throw new IllegalStateException("Time slot is already occupied");
        }

        salleRepository.addOccupiedSlot(salleId, dateTime);
    }

    public void freeTimeSlot(Long salleId, LocalDate date, LocalTime time) {
        if (salleId == null || date == null || time == null) {
            throw new IllegalArgumentException("Room ID, date, and time cannot be null");
        }

        LocalDateTime dateTime = LocalDateTime.of(date, time);
        salleRepository.removeOccupiedSlot(salleId, dateTime);
    }

    public Salle findAnyAvailableRoom(LocalDate date, LocalTime time) {
        List<Salle> availableRooms = findAvailableRooms(date, time);

        if (availableRooms.isEmpty()) {
            throw new IllegalStateException("No rooms available for the requested time slot");
        }

        return availableRooms.get(0);
    }

    public long getTotalSalles() {
        return salleRepository.count();
    }

    public List<LocalDateTime> getOccupiedSlots(Long salleId) {
        Optional<Salle> salle = salleRepository.findById(salleId);
        if (salle.isEmpty()) {
            throw new IllegalArgumentException("Room not found with ID: " + salleId);
        }
        return salle.get().getCreneauxOccupes();
    }
}