package com.example.clinic.repository;

import com.example.clinic.entities.Salle;
import com.example.clinic.repository.Irepository.Repository;
import com.example.clinic.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class SalleRepository implements Repository<Salle, Long> {

    @Override
    public Salle save(Salle salle) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = null;

        try {
            transaction = em.getTransaction();
            transaction.begin();

            em.persist(salle);

            transaction.commit();
            return salle;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Error saving salle: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<Salle> findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            Salle salle = em.find(Salle.class, id);
            return Optional.ofNullable(salle);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Salle> findAll() {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Salle> query = em.createQuery(
                    "SELECT s FROM Salle s",
                    Salle.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public Salle update(Salle salle) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = null;

        try {
            transaction = em.getTransaction();
            transaction.begin();

            Salle updated = em.merge(salle);

            transaction.commit();
            return updated;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Error updating salle: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public void delete(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = null;

        try {
            transaction = em.getTransaction();
            transaction.begin();

            Salle salle = em.find(Salle.class, id);
            if (salle != null) {
                em.remove(salle);
            }

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Error deleting salle: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public void deleteEntity(Salle salle) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = null;

        try {
            transaction = em.getTransaction();
            transaction.begin();

            Salle managed = em.merge(salle);
            em.remove(managed);

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Error deleting salle entity: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public long count() {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(s) FROM Salle s",
                    Long.class
            );
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    public Optional<Salle> findByNomSalle(String nomSalle) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Salle> query = em.createQuery(
                    "SELECT s FROM Salle s WHERE s.nomSalle = :nomSalle",
                    Salle.class
            );
            query.setParameter("nomSalle", nomSalle);

            List<Salle> results = query.getResultList();
            return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
        } finally {
            em.close();
        }
    }

    public List<Salle> findAvailableRooms(LocalDateTime dateTime) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Salle> query = em.createQuery(
                    "SELECT s FROM Salle s WHERE :dateTime NOT IN elements(s.creneauxOccupes)",
                    Salle.class
            );
            query.setParameter("dateTime", dateTime);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public boolean isRoomAvailable(Long salleId, LocalDateTime dateTime) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            Salle salle = em.find(Salle.class, salleId);
            if (salle == null) {
                return false;
            }
            return !salle.getCreneauxOccupes().contains(dateTime);
        } finally {
            em.close();
        }
    }

    public void addOccupiedSlot(Long salleId, LocalDateTime dateTime) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = null;

        try {
            transaction = em.getTransaction();
            transaction.begin();

            Salle salle = em.find(Salle.class, salleId);
            if (salle != null && !salle.getCreneauxOccupes().contains(dateTime)) {
                salle.getCreneauxOccupes().add(dateTime);
                em.merge(salle);
            }

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Error adding occupied slot: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    public void removeOccupiedSlot(Long salleId, LocalDateTime dateTime) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = null;

        try {
            transaction = em.getTransaction();
            transaction.begin();

            Salle salle = em.find(Salle.class, salleId);
            if (salle != null) {
                salle.getCreneauxOccupes().remove(dateTime);
                em.merge(salle);
            }

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Error removing occupied slot: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }
}