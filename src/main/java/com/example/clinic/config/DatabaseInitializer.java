package com.example.clinic.config;

import com.example.clinic.entities.Departement;
import com.example.clinic.entities.Docteur;
import com.example.clinic.entities.Patient;
import com.example.clinic.entities.Salle;
import com.example.clinic.entities.Admin;
import com.example.clinic.service.*;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.time.LocalDate;
import java.time.LocalTime;

@WebListener
public class DatabaseInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("\n\n");
        System.out.println("╔════════════════════════════════════════════════╗");
        System.out.println("║   DATABASE INITIALIZER - STARTING              ║");
        System.out.println("╚════════════════════════════════════════════════╝");

        try {
            System.out.println("[STEP 1] Creating service instances...");
            AdminService adminService = new AdminService();
            System.out.println("  ✓ AdminService created");

            DepartementService departementService = new DepartementService();
            System.out.println("  ✓ DepartementService created");

            SalleService salleService = new SalleService();
            System.out.println("  ✓ SalleService created");

            DocteurService docteurService = new DocteurService();
            System.out.println("  ✓ DocteurService created");

            PatientService patientService = new PatientService();
            System.out.println("  ✓ PatientService created");

            ConsultationService consultationService = new ConsultationService();
            System.out.println("  ✓ ConsultationService created");

            System.out.println("\n[STEP 2] Checking if database is already populated...");
            long totalAdmins = adminService.getTotalAdmins();
            System.out.println("  Current admin count: " + totalAdmins);

            if (totalAdmins > 0) {
                System.out.println("  ⚠ Database already has data. Skipping initialization.");
                return;
            }

            System.out.println("  ✓ Database is empty. Proceeding with initialization...\n");

            System.out.println("[STEP 3] Creating departments...");
            Departement cardiology = departementService.createDepartement("Cardiology");
            System.out.println("  ✓ Cardiology - ID: " + cardiology.getIdDepartement());

            Departement dermatology = departementService.createDepartement("Dermatology");
            System.out.println("  ✓ Dermatology - ID: " + dermatology.getIdDepartement());

            Departement pediatrics = departementService.createDepartement("Pediatrics");
            System.out.println("  ✓ Pediatrics - ID: " + pediatrics.getIdDepartement());

            Departement neurology = departementService.createDepartement("Neurology");
            System.out.println("  ✓ Neurology - ID: " + neurology.getIdDepartement());

            Departement orthopedics = departementService.createDepartement("Orthopedics");
            System.out.println("  ✓ Orthopedics - ID: " + orthopedics.getIdDepartement());

            System.out.println("\n[STEP 4] Creating rooms...");
            Salle room101 = salleService.createSalle("Room 101", 1);
            System.out.println("  ✓ Room 101 - ID: " + room101.getIdSalle());

            Salle room102 = salleService.createSalle("Room 102", 1);
            System.out.println("  ✓ Room 102 - ID: " + room102.getIdSalle());

            Salle room103 = salleService.createSalle("Room 103", 1);
            System.out.println("  ✓ Room 103 - ID: " + room103.getIdSalle());

            Salle room104 = salleService.createSalle("Room 104", 1);
            System.out.println("  ✓ Room 104 - ID: " + room104.getIdSalle());

            Salle room105 = salleService.createSalle("Room 105", 1);
            System.out.println("  ✓ Room 105 - ID: " + room105.getIdSalle());

            Salle room106 = salleService.createSalle("Room 106", 1);
            System.out.println("  ✓ Room 106 - ID: " + room106.getIdSalle());

            Salle room107 = salleService.createSalle("Room 107", 1);
            System.out.println("  ✓ Room 107 - ID: " + room107.getIdSalle());

            Salle room108 = salleService.createSalle("Room 108", 1);
            System.out.println("  ✓ Room 108 - ID: " + room108.getIdSalle());

            System.out.println("\n[STEP 5] Creating admin account...");
            Admin admin = adminService.registerAdmin(
                    "Admin", "System", "admin@clinic.com", "pass123456", "admin"
            );
            System.out.println("  ✓ Admin created - ID: " + admin.getId() + " | Email: " + admin.getEmail());

            System.out.println("\n[STEP 6] Creating doctors...");
            Docteur docteur1 = docteurService.registerDocteur(
                    "Smith", "John", "docteur1@gmail.com", "pass12345",
                    "Cardiologist", cardiology.getIdDepartement(), room101.getIdSalle()
            );
            System.out.println("  ✓ Dr. John Smith - ID: " + docteur1.getId());

            Docteur docteur2 = docteurService.registerDocteur(
                    "Johnson", "Emily", "docteur2@gmail.com", "pass12345",
                    "Dermatologist", dermatology.getIdDepartement(), room102.getIdSalle()
            );
            System.out.println("  ✓ Dr. Emily Johnson - ID: " + docteur2.getId());

            Docteur docteur3 = docteurService.registerDocteur(
                    "Williams", "Michael", "docteur3@gmail.com", "pass12345",
                    "Pediatrician", pediatrics.getIdDepartement(), room103.getIdSalle()
            );
            System.out.println("  ✓ Dr. Michael Williams - ID: " + docteur3.getId());

            Docteur docteur4 = docteurService.registerDocteur(
                    "Brown", "Sarah", "docteur4@gmail.com", "pass12345",
                    "Neurologist", neurology.getIdDepartement(), room104.getIdSalle()
            );
            System.out.println("  ✓ Dr. Sarah Brown - ID: " + docteur4.getId());

            Docteur docteur5 = docteurService.registerDocteur(
                    "Jones", "David", "docteur5@gmail.com", "pass12345",
                    "Orthopedic Surgeon", orthopedics.getIdDepartement(), room105.getIdSalle()
            );
            System.out.println("  ✓ Dr. David Jones - ID: " + docteur5.getId());

            System.out.println("\n[STEP 7] Creating patients...");
            Patient patient1 = patientService.registerPatient(
                    "Anderson", "James", "patient1@gmail.com", "pass123456", 75.5, 178.0
            );
            System.out.println("  ✓ James Anderson - ID: " + patient1.getId());

            Patient patient2 = patientService.registerPatient(
                    "Taylor", "Emma", "patient2@gmail.com", "pass12345", 62.0, 165.0
            );
            System.out.println("  ✓ Emma Taylor - ID: " + patient2.getId());

            Patient patient3 = patientService.registerPatient(
                    "Martinez", "Daniel", "patient3@gmail.com", "pass123456", 82.3, 182.0
            );
            System.out.println("  ✓ Daniel Martinez - ID: " + patient3.getId());

            Patient patient4 = patientService.registerPatient(
                    "Garcia", "Olivia", "patient4@gmail.com", "pass12345", 58.5, 160.0
            );
            System.out.println("  ✓ Olivia Garcia - ID: " + patient4.getId());

            Patient patient5 = patientService.registerPatient(
                    "Rodriguez", "Sophia", "patient5@gmail.com", "pass12345", 65.0, 168.0
            );
            System.out.println("  ✓ Sophia Rodriguez - ID: " + patient5.getId());

            Patient patient6 = patientService.registerPatient(
                    "Wilson", "Liam", "patient6@gmail.com", "pass123456", 78.0, 175.0
            );
            System.out.println("  ✓ Liam Wilson - ID: " + patient6.getId());

            Patient patient7 = patientService.registerPatient(
                    "Lee", "Ava", "patient7@gmail.com", "pass123456", 60.0, 162.0
            );
            System.out.println("  ✓ Ava Lee - ID: " + patient7.getId());

            Patient patient8 = patientService.registerPatient(
                    "Davis", "Noah", "patient8@gmail.com", "pass123456", 85.0, 185.0
            );
            System.out.println("  ✓ Noah Davis - ID: " + patient8.getId());

            System.out.println("\n[STEP 8] Creating sample consultations...");

            consultationService.bookConsultation(
                    patient1.getId(), docteur1.getId(),
                    LocalDate.now().plusDays(1), LocalTime.of(9, 0)
            );
            System.out.println("  ✓ Consultation 1: James Anderson → Dr. Smith");

            consultationService.bookConsultation(
                    patient2.getId(), docteur2.getId(),
                    LocalDate.now().plusDays(1), LocalTime.of(10, 0)
            );
            System.out.println("  ✓ Consultation 2: Emma Taylor → Dr. Johnson");

            consultationService.bookConsultation(
                    patient3.getId(), docteur3.getId(),
                    LocalDate.now().plusDays(2), LocalTime.of(11, 0)
            );
            System.out.println("  ✓ Consultation 3: Daniel Martinez → Dr. Williams");

            consultationService.bookConsultation(
                    patient4.getId(), docteur4.getId(),
                    LocalDate.now().plusDays(2), LocalTime.of(14, 0)
            );
            System.out.println("  ✓ Consultation 4: Olivia Garcia → Dr. Brown");

            consultationService.bookConsultation(
                    patient5.getId(), docteur5.getId(),
                    LocalDate.now().plusDays(3), LocalTime.of(9, 30)
            );
            System.out.println("  ✓ Consultation 5: Sophia Rodriguez → Dr. Jones");

            System.out.println("\n╔════════════════════════════════════════════════╗");
            System.out.println("║   DATABASE INITIALIZATION - SUCCESS ✓          ║");
            System.out.println("╚════════════════════════════════════════════════╝");
            System.out.println("\n📋 TEST CREDENTIALS:");
            System.out.println("┌────────────────────────────────────────────────┐");
            System.out.println("│ ADMIN: admin@clinic.com / pass                 │");
            System.out.println("│ DOCTORS: docteur1-5@gmail.com / pass           │");
            System.out.println("│ PATIENTS: patient1-8@gmail.com / pass          │");
            System.out.println("└────────────────────────────────────────────────┘\n");

        } catch (Exception e) {
            System.err.println("\n╔════════════════════════════════════════════════╗");
            System.err.println("║   DATABASE INITIALIZATION - FAILED ✗           ║");
            System.err.println("╚════════════════════════════════════════════════╝");
            System.err.println("Error: " + e.getClass().getName());
            System.err.println("Message: " + e.getMessage());
            System.err.println("\nFull Stack Trace:");
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Application shutting down...");
    }
}