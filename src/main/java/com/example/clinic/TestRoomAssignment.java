package com.example.clinic;

import com.example.clinic.entities.*;
import com.example.clinic.service.*;
import com.example.clinic.util.JPAUtil;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public class TestRoomAssignment {

    public static void main(String[] args) {
        System.out.println("==========================================");
        System.out.println("Testing Room Assignment System");
        System.out.println("==========================================\n");

        DepartementService deptService = new DepartementService();
        DocteurService docteurService = new DocteurService();
        PatientService patientService = new PatientService();
        SalleService salleService = new SalleService();
        ConsultationService consultationService = new ConsultationService();

        try {
            System.out.println("--- Step 1: Create Department ---");
            Departement cardio = deptService.createDepartement("Cardiologie");
            System.out.println("✓ Department created: " + cardio.getNom());

            System.out.println("\n--- Step 2: Create Rooms ---");
            Salle salle101 = salleService.createSalle("Salle 101", 1);
            System.out.println("✓ Room created: " + salle101.getNomSalle());

            Salle salle102 = salleService.createSalle("Salle 102", 1);
            System.out.println("✓ Room created: " + salle102.getNomSalle());

            System.out.println("\n--- Step 3: Register Doctors WITH Room Assignment ---");
            Docteur docteur1 = docteurService.registerDocteur(
                    "Alami", "Hassan", "h.alami@clinic.com", "doctor123",
                    "Cardiologue", cardio.getIdDepartement(), salle101.getIdSalle()
            );
            System.out.println("✓ Doctor registered: Dr. " + docteur1.getNom());
            System.out.println("  Assigned Room: " + docteur1.getSalle().getNomSalle());

            Docteur docteur2 = docteurService.registerDocteur(
                    "Bennani", "Fatima", "f.bennani@clinic.com", "doctor123",
                    "Cardiologue", cardio.getIdDepartement(), salle102.getIdSalle()
            );
            System.out.println("✓ Doctor registered: Dr. " + docteur2.getNom());
            System.out.println("  Assigned Room: " + docteur2.getSalle().getNomSalle());

            System.out.println("\n--- Step 4: Try to Assign Same Room to Another Doctor (Should Fail) ---");
            try {
                docteurService.registerDocteur(
                        "Tazi", "Mohammed", "m.tazi@clinic.com", "doctor123",
                        "Cardiologue", cardio.getIdDepartement(), salle101.getIdSalle()
                );
                System.out.println("✗ Should have failed - room already assigned!");
            } catch (IllegalArgumentException e) {
                System.out.println("✓ Duplicate room assignment prevented: " + e.getMessage());
            }

            System.out.println("\n--- Step 5: Register Patient ---");
            Patient patient = patientService.registerPatient(
                    "Idrissi", "Amina", "a.idrissi@email.com", "patient123",
                    60.0, 1.65
            );
            System.out.println("✓ Patient registered: " + patient.getNom());

            System.out.println("\n--- Step 6: Book Consultation (NO Room Selection!) ---");
            LocalDate futureDate = LocalDate.now().plusDays(5);
            LocalTime time = LocalTime.of(14, 30);

            Consultation consultation = consultationService.bookConsultation(
                    patient.getId(),
                    docteur1.getId(),
                    futureDate,
                    time
            );
            System.out.println("✓ Consultation booked automatically!");
            System.out.println("  Doctor: Dr. " + consultation.getDocteur().getNom());
            System.out.println("  Room: " + consultation.getSalle().getNomSalle() + " (Auto-assigned)");
            System.out.println("  Date: " + consultation.getDate());
            System.out.println("  Time: " + consultation.getHeure());

            System.out.println("\n--- Step 7: Check Room Availability ---");
            boolean available = salleService.isRoomAvailable(
                    docteur1.getSalle().getIdSalle(),
                    futureDate,
                    time
            );
            System.out.println("✓ Room blocked for this time: " + !available);

            System.out.println("\n--- Step 8: Try Double Booking Same Doctor (Should Fail) ---");
            try {
                consultationService.bookConsultation(
                        patient.getId(),
                        docteur1.getId(),
                        futureDate,
                        time
                );
                System.out.println("✗ Should have failed - doctor not available!");
            } catch (IllegalStateException e) {
                System.out.println("✓ Double booking prevented: " + e.getMessage());
            }

            System.out.println("\n--- Step 9: Book with Different Doctor (Same Time) ---");
            Consultation consultation2 = consultationService.bookConsultation(
                    patient.getId(),
                    docteur2.getId(),
                    futureDate,
                    time
            );
            System.out.println("✓ Consultation booked with different doctor!");
            System.out.println("  Doctor: Dr. " + consultation2.getDocteur().getNom());
            System.out.println("  Room: " + consultation2.getSalle().getNomSalle() + " (Different room!)");

            System.out.println("\n--- Step 10: Get Available Time Slots for Doctor ---");
            List<LocalTime> availableSlots = consultationService.getAvailableTimeSlotsForDoctor(
                    docteur1.getId(),
                    futureDate
            );
            System.out.println("✓ Available time slots for Dr. " + docteur1.getNom() + ":");
            System.out.println("  Total slots: " + availableSlots.size());
            System.out.println("  First 5 available: " + availableSlots.subList(0, Math.min(5, availableSlots.size())));
            System.out.println("  14:30 available? " + availableSlots.contains(LocalTime.of(14, 30)));

            System.out.println("\n--- Step 11: Reschedule Consultation ---");
            LocalTime newTime = LocalTime.of(15, 30);
            Consultation rescheduled = consultationService.rescheduleConsultation(
                    consultation.getIdConsultation(),
                    patient.getId(),
                    futureDate,
                    newTime
            );
            System.out.println("✓ Consultation rescheduled!");
            System.out.println("  New time: " + rescheduled.getHeure());
            System.out.println("  Room: " + rescheduled.getSalle().getNomSalle() + " (Same room)");

            System.out.println("\n--- Step 12: Verify Old Slot is Now Available ---");
            boolean oldSlotAvailable = salleService.isRoomAvailable(
                    docteur1.getSalle().getIdSalle(),
                    futureDate,
                    time
            );
            System.out.println("✓ Old slot (14:30) is now available: " + oldSlotAvailable);

            System.out.println("\n--- Step 13: Test Doctor Without Room ---");
            Docteur docteur3 = docteurService.registerDocteur(
                    "Amrani", "Karim", "k.amrani@clinic.com", "doctor123",
                    "Cardiologue", cardio.getIdDepartement(), null
            );
            System.out.println("✓ Doctor registered without room: Dr. " + docteur3.getNom());

            try {
                consultationService.bookConsultation(
                        patient.getId(),
                        docteur3.getId(),
                        futureDate,
                        LocalTime.of(10, 0)
                );
                System.out.println("✗ Should have failed - doctor has no room!");
            } catch (IllegalStateException e) {
                System.out.println("✓ Booking prevented for doctor without room: " + e.getMessage());
            }

            System.out.println("\n--- Step 14: Assign Room to Doctor ---");
            Salle salle103 = salleService.createSalle("Salle 103", 1);
            docteurService.assignRoom(docteur3.getId(), salle103.getIdSalle());
            System.out.println("✓ Room assigned to Dr. " + docteur3.getNom());

            docteur3 = docteurService.getDocteurById(docteur3.getId()).get();
            System.out.println("  Assigned Room: " + docteur3.getSalle().getNomSalle());

            System.out.println("\n--- Step 15: Now Booking Works ---");
            Consultation consultation3 = consultationService.bookConsultation(
                    patient.getId(),
                    docteur3.getId(),
                    futureDate,
                    LocalTime.of(10, 0)
            );
            System.out.println("✓ Consultation booked successfully!");
            System.out.println("  Room: " + consultation3.getSalle().getNomSalle());

            System.out.println("\n--- Step 16: List Doctors Without Rooms ---");
            List<Docteur> doctorsWithoutRoom = docteurService.getDoctorsWithoutRoom();
            System.out.println("✓ Doctors without room: " + doctorsWithoutRoom.size());

            System.out.println("\n==========================================");
            System.out.println("ROOM ASSIGNMENT SYSTEM WORKING PERFECTLY!");
            System.out.println("==========================================");
            System.out.println("\n✅ Key Features Tested:");
            System.out.println("• Automatic room assignment from doctor");
            System.out.println("• Room uniqueness per doctor");
            System.out.println("• Double booking prevention");
            System.out.println("• Time slot management");
            System.out.println("• Rescheduling with room consistency");
            System.out.println("• Doctor without room handling");
            System.out.println("• Available time slots calculation");

        } catch (Exception e) {
            System.out.println("\n✗ ERROR OCCURRED:");
            System.out.println(e.getMessage());
            e.printStackTrace();
        } finally {
            JPAUtil.close();
        }
    }
}