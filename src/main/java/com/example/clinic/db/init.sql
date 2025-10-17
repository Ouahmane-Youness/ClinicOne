-- ==========================================================
--  Init script with generic sample data
--  For PostgreSQL (Clinic JEE project)
-- ==========================================================

-- 1️⃣ Departements
INSERT INTO departement (nom) VALUES
                                  ('Cardiologie'),
                                  ('Dermatologie'),
                                  ('Pédiatrie'),
                                  ('Radiologie');

-- 2️⃣ Salles
INSERT INTO salle (capacite, nomsalle) VALUES
                                           (10, 'Salle A'),
                                           (8,  'Salle B'),
                                           (6,  'Salle C');

-- 3️⃣ Personnes
INSERT INTO personne (email, motdepasse, nom, prenom) VALUES
                                                          ('docteur1@docteur.com', 'pass', 'Docteur', 'One'),
                                                          ('docteur2@docteur.com', 'pass', 'Docteur', 'Two'),
                                                          ('patient1@patient.com', 'pass', 'Patient', 'One'),
                                                          ('patient2@patient.com', 'pass', 'Patient', 'Two'),
                                                          ('admin@admin.com', 'pass', 'Admin', 'User');

-- 4️⃣ Patients (inherit from personne)
-- IDs 3 and 4 from personne
INSERT INTO patient (id, poids, taille) VALUES
                                            (3, 72.5, 178.0),
                                            (4, 65.0, 165.0);

-- 5️⃣ Docteurs (inherit from personne)
-- IDs 1 and 2 from personne
INSERT INTO docteur (id, specialite, departement_id, salle_id) VALUES
                                                                   (1, 'Cardiologue', 1, 1),
                                                                   (2, 'Pédiatre', 3, 2);

-- 6️⃣ Admin user
-- ID 5 from personne
INSERT INTO admin (id, username) VALUES
    (5, 'admin');

-- 7️⃣ Salle créneaux (disponibilités)
INSERT INTO salle_creneaux (salle_id, creneau) VALUES
                                                   (1, '2025-10-17 09:00:00'),
                                                   (1, '2025-10-17 11:00:00'),
                                                   (2, '2025-10-17 10:00:00');

-- 8️⃣ Consultations
INSERT INTO consultation (compterendu, date, heure, statut, docteur_id, patient_id, salle_id)
VALUES
    ('Consultation générale', '2025-10-10', '10:00', 'TERMINEE', 1, 3, 1),
    ('Contrôle annuel', '2025-10-11', '14:00', 'RESERVEE', 2, 4, 2),
    ('Consultation annulée', '2025-10-12', '15:00', 'ANNULEE', 2, 3, 2);
