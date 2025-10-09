package com.example.clinic.repository;

import com.example.clinic.entities.Departement;
import com.example.clinic.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import java.util.List;
import java.util.Optional;

public class DepartmentRepository implements Repository<Departement, Long>{


    @Override
    public Departement save(Departement departement) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = null;

        try{
            transaction = em.getTransaction();
            transaction.begin();

            em.persist(departement);
            transaction.commit();
            return departement;
        } catch (Exception e) {
            if(transaction != null && transaction.isActive())
            {
                transaction.rollback();
            }
            throw new RuntimeException("error saving patient" + e.getMessage());
        }finally {

        }

    }

    @Override
    public Optional<Departement> findById(Long aLong) {
        return Optional.empty();
    }

    @Override
    public List<Departement> findAll() {
        return List.of();
    }

    @Override
    public Departement update(Departement entity) {
        return null;
    }

    @Override
    public void delete(Long aLong) {

    }

    @Override
    public void deleteEntity(Departement entity) {

    }

    @Override
    public long count() {
        return 0;
    }
}
