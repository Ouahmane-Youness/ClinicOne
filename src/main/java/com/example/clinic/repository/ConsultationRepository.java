package com.example.clinic.repository;

import com.example.clinic.entities.Consultation;
import com.example.clinic.entities.StatutConsultation;
import com.example.clinic.repository.Irepository.Repository;
import com.example.clinic.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public class ConsultationRepository implements Repository<Consultation, Long> {

    @Override
    public Consultation save(Consultation consultation) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = null;

        try {
            transaction = em.getTransaction();
            transaction.begin();

            em.persist(consultation);

            transaction.commit();
            return consultation;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Error saving consultation: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<Consultation> findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            Consultation consultation = em.find(Consultation.class, id);
            return Optional.ofNullable(consultation);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Consultation> findAll() {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Consultation> query = em.createQuery(
                    "SELECT c FROM Consultation c ORDER BY c.date DESC, c.heure DESC",
                    Consultation.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public Consultation update(Consultation consultation) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = null;

        try {
            transaction = em.getTransaction();
            transaction.begin();

            Consultation updated = em.merge(consultation);

            transaction.commit();
            return updated;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Error updating consultation: " + e.getMessage(), e);
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

            Consultation consultation = em.find(Consultation.class, id);
            if (consultation != null) {
                em.remove(consultation);
            }

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Error deleting consultation: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public void deleteEntity(Consultation consultation) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = null;

        try {
            transaction = em.getTransaction();
            transaction.begin();

            Consultation managed = em.merge(consultation);
            em.remove(managed);

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Error deleting consultation entity: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public long count() {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(c) FROM Consultation c",
                    Long.class
            );
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    public List<Consultation> findByPatient(Long patientId) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Consultation> query = em.createQuery(
                    "SELECT c FROM Consultation c WHERE c.patient.id = :patientId ORDER BY c.date DESC, c.heure DESC",
                    Consultation.class
            );
            query.setParameter("patientId", patientId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Consultation> findByDocteur(Long docteurId) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Consultation> query = em.createQuery(
                    "SELECT c FROM Consultation c WHERE c.docteur.id = :docteurId ORDER BY c.date DESC, c.heure DESC",
                    Consultation.class
            );
            query.setParameter("docteurId", docteurId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Consultation> findByStatut(StatutConsultation statut) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Consultation> query = em.createQuery(
                    "SELECT c FROM Consultation c WHERE c.statut = :statut ORDER BY c.date DESC, c.heure DESC",
                    Consultation.class
            );
            query.setParameter("statut", statut);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Consultation> findByDate(LocalDate date) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Consultation> query = em.createQuery(
                    "SELECT c FROM Consultation c WHERE c.date = :date ORDER BY c.heure",
                    Consultation.class
            );
            query.setParameter("date", date);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Consultation> findByDateRange(LocalDate startDate, LocalDate endDate) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Consultation> query = em.createQuery(
                    "SELECT c FROM Consultation c WHERE c.date BETWEEN :startDate AND :endDate ORDER BY c.date, c.heure",
                    Consultation.class
            );
            query.setParameter("startDate", startDate);
            query.setParameter("endDate", endDate);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Consultation> findUpcomingByPatient(Long patientId, LocalDate currentDate) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Consultation> query = em.createQuery(
                    "SELECT c FROM Consultation c WHERE c.patient.id = :patientId AND c.date >= :currentDate ORDER BY c.date, c.heure",
                    Consultation.class
            );
            query.setParameter("patientId", patientId);
            query.setParameter("currentDate", currentDate);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Consultation> findUpcomingByDocteur(Long docteurId, LocalDate currentDate) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Consultation> query = em.createQuery(
                    "SELECT c FROM Consultation c WHERE c.docteur.id = :docteurId AND c.date >= :currentDate ORDER BY c.date, c.heure",
                    Consultation.class
            );
            query.setParameter("docteurId", docteurId);
            query.setParameter("currentDate", currentDate);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Consultation> findPastByPatient(Long patientId, LocalDate currentDate) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Consultation> query = em.createQuery(
                    "SELECT c FROM Consultation c WHERE c.patient.id = :patientId AND c.date < :currentDate ORDER BY c.date DESC, c.heure DESC",
                    Consultation.class
            );
            query.setParameter("patientId", patientId);
            query.setParameter("currentDate", currentDate);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public long countByStatut(StatutConsultation statut) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(c) FROM Consultation c WHERE c.statut = :statut",
                    Long.class
            );
            query.setParameter("statut", statut);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    public List<Consultation> findCompletedByPatient(Long patientId) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Consultation> query = em.createQuery(
                    "SELECT c FROM Consultation c WHERE c.patient.id = :patientId AND (c.statut = 'TERMINEE' OR c.statut = 'ANNULEE') ORDER BY c.date DESC, c.heure DESC",
                    Consultation.class
            );
            query.setParameter("patientId", patientId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public Consultation findByIdWithDetails(Long id) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Consultation> query = em.createQuery(
                    "SELECT c FROM Consultation c " +
                            "LEFT JOIN FETCH c.patient " +
                            "LEFT JOIN FETCH c.docteur " +
                            "LEFT JOIN FETCH c.salle " +
                            "WHERE c.idConsultation = :id",
                    Consultation.class
            );
            query.setParameter("id", id);

            List<Consultation> results = query.getResultList();
            return results.isEmpty() ? null : results.get(0);
        } finally {
            em.close();
        }
    }
}