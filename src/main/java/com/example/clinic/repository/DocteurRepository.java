package com.example.clinic.repository;

import com.example.clinic.entities.Docteur;
import com.example.clinic.repository.Irepository.Repository;
import com.example.clinic.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

public class DocteurRepository implements Repository<Docteur, Long> {

    @Override
    public Docteur save(Docteur docteur) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = null;

        try {
            transaction = em.getTransaction();
            transaction.begin();

            em.persist(docteur);

            transaction.commit();
            return docteur;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Error saving docteur: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<Docteur> findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            Docteur docteur = em.find(Docteur.class, id);
            return Optional.ofNullable(docteur);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Docteur> findAll() {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Docteur> query = em.createQuery(
                    "SELECT d FROM Docteur d",
                    Docteur.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public Docteur update(Docteur docteur) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = null;

        try {
            transaction = em.getTransaction();
            transaction.begin();

            Docteur updated = em.merge(docteur);

            transaction.commit();
            return updated;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Error updating docteur: " + e.getMessage(), e);
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

            Docteur docteur = em.find(Docteur.class, id);
            if (docteur != null) {
                em.remove(docteur);
            }

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Error deleting docteur: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public void deleteEntity(Docteur docteur) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = null;

        try {
            transaction = em.getTransaction();
            transaction.begin();

            Docteur managed = em.merge(docteur);
            em.remove(managed);

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Error deleting docteur entity: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public long count() {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(d) FROM Docteur d",
                    Long.class
            );
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    public Optional<Docteur> findByEmail(String email) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Docteur> query = em.createQuery(
                    "SELECT d FROM Docteur d WHERE d.email = :email",
                    Docteur.class
            );
            query.setParameter("email", email);

            List<Docteur> results = query.getResultList();
            return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
        } finally {
            em.close();
        }
    }

    public List<Docteur> findByDepartement(Long departementId) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Docteur> query = em.createQuery(
                    "SELECT d FROM Docteur d WHERE d.departement.idDepartement = :deptId",
                    Docteur.class
            );
            query.setParameter("deptId", departementId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Docteur> findBySpecialite(String specialite) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Docteur> query = em.createQuery(
                    "SELECT d FROM Docteur d WHERE LOWER(d.specialite) LIKE LOWER(:specialite)",
                    Docteur.class
            );
            query.setParameter("specialite", "%" + specialite + "%");
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public Docteur findByIdWithConsultations(Long id) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Docteur> query = em.createQuery(
                    "SELECT d FROM Docteur d LEFT JOIN FETCH d.consultations WHERE d.id = :id",
                    Docteur.class
            );
            query.setParameter("id", id);

            List<Docteur> results = query.getResultList();
            return results.isEmpty() ? null : results.get(0);
        } finally {
            em.close();
        }
    }

    // ✨ NEW: Find doctor assigned to a specific room
    public Optional<Docteur> findBySalle(Long salleId)
    {
        EntityManager em = JPAUtil.getEntityManager();

        try{
            TypedQuery<Docteur> query = em.createQuery(
                    "SELECT d FROM Docteur d WHERE d.salle.id = :salleId",
                    Docteur.class
            );
            query.setParameter("salleId", salleId);
            List<Docteur> results = query.getResultList();
            return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
        }finally {
            em.close();
        }
    }

    // ✨ NEW: Find all doctors without assigned rooms
    public List<Docteur> findDoctorsWithoutRoom()
    {
        EntityManager em = JPAUtil.getEntityManager();
        try{
            TypedQuery<Docteur> query = em.createQuery(
                    "SELECT d FROM Docteur d where d.salle IS NULL", Docteur.class
            );

            return query.getResultList();
        }finally {
            em.close();
        }
    }
}