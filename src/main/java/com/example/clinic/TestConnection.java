package com.example.clinic;


import com.example.clinic.util.JPAUtil;

import com.example.clinic.entities.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

public class TestConnection {

    public static void main(String[] args) {
        System.out.println("========== Testing Database Connection ==========");

        EntityManager em = null;
        EntityTransaction transaction = null;

        try {
            em = JPAUtil.getEntityManager();
            System.out.println("✓ EntityManager created successfully!");

            transaction = em.getTransaction();
            transaction.begin();
            System.out.println("✓ Transaction started!");

            Departement cardio = new Departement("Cardiologie");
            em.persist(cardio);
            System.out.println("✓ Department saved: " + cardio.getNom());

            Docteur docteur = new Docteur(
                    "Alami",
                    "Hassan",
                    "h.alami@clinic.com",
                    "password123",
                    "Cardiologue",
                    cardio
            );
            em.persist(docteur);
            System.out.println("✓ Doctor saved: Dr. " + docteur.getNom());

            Patient patient = new Patient(
                    "Bennani",
                    "Fatima",
                    "f.bennani@email.com",
                    "password123",
                    65.5,
                    1.68
            );
            em.persist(patient);
            System.out.println("✓ Patient saved: " + patient.getPrenom() + " " + patient.getNom());

            Salle salle = new Salle("Salle 101", 1);
            em.persist(salle);
            System.out.println("✓ Room saved: " + salle.getNomSalle());

            transaction.commit();
            System.out.println("✓ Transaction committed successfully!");

            System.out.println("\n========== Testing Data Retrieval ==========");

            Departement foundDept = em.find(Departement.class, cardio.getIdDepartement());
            System.out.println("✓ Found department: " + foundDept.getNom());
            System.out.println("  Number of doctors: " + foundDept.getDocteurs().size());

            Patient foundPatient = em.find(Patient.class, patient.getId());
            System.out.println("✓ Found patient: " + foundPatient.getPrenom() + " " + foundPatient.getNom());
            System.out.println("  Weight: " + foundPatient.getPoids() + " kg");
            System.out.println("  Height: " + foundPatient.getTaille() + " m");

            System.out.println("\n========== ALL TESTS PASSED! ==========");

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
                System.out.println("✗ Transaction rolled back due to error");
            }
            System.out.println("✗ ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
                System.out.println("✓ EntityManager closed");
            }
            JPAUtil.close();
            System.out.println("✓ EntityManagerFactory closed");
        }
    }
}
