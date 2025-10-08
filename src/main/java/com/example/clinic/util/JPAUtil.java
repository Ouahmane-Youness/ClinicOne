package com.example.clinic.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JPAUtil {

    private static EntityManagerFactory emf;

    static {
        try {
            emf = Persistence.createEntityManagerFactory("clinicPU");
        } catch (Exception e) {
            e.printStackTrace();
            throw new ExceptionInInitializerError("EntityManagerFactory creation failed: " + e.getMessage());
        }
    }

    public static EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public static void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}