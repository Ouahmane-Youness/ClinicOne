package com.example.clinic.repository;

import com.example.clinic.entities.Admin;
import com.example.clinic.repository.Irepository.Repository;
import com.example.clinic.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

public class AdminRepository implements Repository<Admin, Long> {

    @Override
    public Admin save(Admin admin) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = null;

        try {
            transaction = em.getTransaction();
            transaction.begin();

            em.persist(admin);

            transaction.commit();
            return admin;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Error saving admin: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<Admin> findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            Admin admin = em.find(Admin.class, id);
            return Optional.ofNullable(admin);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Admin> findAll() {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Admin> query = em.createQuery(
                    "SELECT a FROM Admin a",
                    Admin.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public Admin update(Admin admin) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = null;

        try {
            transaction = em.getTransaction();
            transaction.begin();

            Admin updated = em.merge(admin);

            transaction.commit();
            return updated;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Error updating admin: " + e.getMessage(), e);
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

            Admin admin = em.find(Admin.class, id);
            if (admin != null) {
                em.remove(admin);
            }

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Error deleting admin: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public void deleteEntity(Admin admin) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = null;

        try {
            transaction = em.getTransaction();
            transaction.begin();

            Admin managed = em.merge(admin);
            em.remove(managed);

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Error deleting admin entity: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public long count() {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(a) FROM Admin a",
                    Long.class
            );
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    public Optional<Admin> findByEmail(String email) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Admin> query = em.createQuery(
                    "SELECT a FROM Admin a WHERE a.email = :email",
                    Admin.class
            );
            query.setParameter("email", email);

            List<Admin> results = query.getResultList();
            return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
        } finally {
            em.close();
        }
    }

    public Optional<Admin> findByUsername(String username) {
        EntityManager em = JPAUtil.getEntityManager();

        try {
            TypedQuery<Admin> query = em.createQuery(
                    "SELECT a FROM Admin a WHERE a.username = :username",
                    Admin.class
            );
            query.setParameter("username", username);

            List<Admin> results = query.getResultList();
            return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
        } finally {
            em.close();
        }
    }
}