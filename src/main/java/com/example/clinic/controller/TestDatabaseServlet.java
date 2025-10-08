package com.example.clinic.controller;

import com.example.clinic.entities.*;
import com.example.clinic.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/test-db")
public class TestDatabaseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html lang='fr'>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<title>Test Base de Données</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; padding: 20px; background: #f5f5f5; }");
        out.println(".container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }");
        out.println("h1 { color: #667eea; }");
        out.println(".success { color: #10b981; padding: 10px; background: #d1fae5; border-radius: 5px; margin: 10px 0; }");
        out.println(".error { color: #ef4444; padding: 10px; background: #fee2e2; border-radius: 5px; margin: 10px 0; }");
        out.println(".info { color: #3b82f6; padding: 10px; background: #dbeafe; border-radius: 5px; margin: 10px 0; }");
        out.println(".test-step { margin: 15px 0; padding: 10px; border-left: 3px solid #667eea; }");
        out.println(".back-btn { display: inline-block; margin-top: 20px; padding: 10px 20px; background: #667eea; color: white; text-decoration: none; border-radius: 5px; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container'>");
        out.println("<h1>🔌 Test de Connexion à la Base de Données</h1>");

        EntityManager em = null;
        EntityTransaction transaction = null;

        try {
            out.println("<div class='test-step'>");
            out.println("<strong>Étape 1:</strong> Création de l'EntityManager...");
            out.println("</div>");

            em = JPAUtil.getEntityManager();
            out.println("<div class='success'>✓ EntityManager créé avec succès!</div>");

            out.println("<div class='test-step'>");
            out.println("<strong>Étape 2:</strong> Démarrage de la transaction...");
            out.println("</div>");

            transaction = em.getTransaction();
            transaction.begin();
            out.println("<div class='success'>✓ Transaction démarrée!</div>");

            out.println("<div class='test-step'>");
            out.println("<strong>Étape 3:</strong> Création d'un département de test...");
            out.println("</div>");

            Departement dept = new Departement("Cardiologie - Test Web");
            em.persist(dept);
            out.println("<div class='success'>✓ Département créé: " + dept.getNom() + "</div>");

            out.println("<div class='test-step'>");
            out.println("<strong>Étape 4:</strong> Création d'un docteur de test...");
            out.println("</div>");

            Docteur docteur = new Docteur(
                    "Alami",
                    "Hassan",
                    "h.alami.web@clinic.com",
                    "password123",
                    "Cardiologue",
                    dept
            );
            em.persist(docteur);
            out.println("<div class='success'>✓ Docteur créé: Dr. " + docteur.getNom() + " " + docteur.getPrenom() + "</div>");

            out.println("<div class='test-step'>");
            out.println("<strong>Étape 5:</strong> Création d'un patient de test...");
            out.println("</div>");

            Patient patient = new Patient(
                    "Bennani",
                    "Fatima",
                    "f.bennani.web@email.com",
                    "password123",
                    65.5,
                    1.68
            );
            em.persist(patient);
            out.println("<div class='success'>✓ Patient créé: " + patient.getPrenom() + " " + patient.getNom() + "</div>");
            out.println("<div class='info'>Poids: " + patient.getPoids() + " kg | Taille: " + patient.getTaille() + " m</div>");

            out.println("<div class='test-step'>");
            out.println("<strong>Étape 6:</strong> Création d'une salle de test...");
            out.println("</div>");

            Salle salle = new Salle("Salle 101 - Web Test", 1);
            em.persist(salle);
            out.println("<div class='success'>✓ Salle créée: " + salle.getNomSalle() + "</div>");

            out.println("<div class='test-step'>");
            out.println("<strong>Étape 7:</strong> Commit de la transaction...");
            out.println("</div>");

            transaction.commit();
            out.println("<div class='success'>✓ Transaction validée avec succès!</div>");

            out.println("<div class='test-step'>");
            out.println("<strong>Étape 8:</strong> Vérification de la lecture des données...");
            out.println("</div>");

            Departement foundDept = em.find(Departement.class, dept.getIdDepartement());
            out.println("<div class='success'>✓ Département retrouvé: " + foundDept.getNom() + "</div>");
            out.println("<div class='info'>Nombre de docteurs dans ce département: " + foundDept.getDocteurs().size() + "</div>");

            Patient foundPatient = em.find(Patient.class, patient.getId());
            out.println("<div class='success'>✓ Patient retrouvé: " + foundPatient.getPrenom() + " " + foundPatient.getNom() + "</div>");

            out.println("<br><br>");
            out.println("<div style='padding: 20px; background: #10b981; color: white; border-radius: 10px; text-align: center;'>");
            out.println("<h2>🎉 TOUS LES TESTS SONT RÉUSSIS!</h2>");
            out.println("<p>La connexion à PostgreSQL fonctionne parfaitement!</p>");
            out.println("<p>Hibernate a créé toutes les tables automatiquement.</p>");
            out.println("</div>");

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
                out.println("<div class='error'>✗ Transaction annulée (rollback)</div>");
            }

            out.println("<div class='error'>");
            out.println("<h3>❌ ERREUR!</h3>");
            out.println("<p><strong>Message:</strong> " + e.getMessage() + "</p>");
            out.println("<p><strong>Type:</strong> " + e.getClass().getName() + "</p>");
            out.println("<h4>Stack Trace:</h4>");
            out.println("<pre style='background: #1f2937; color: #10b981; padding: 10px; border-radius: 5px; overflow: auto;'>");
            e.printStackTrace(out);
            out.println("</pre>");
            out.println("</div>");

            out.println("<div class='info'>");
            out.println("<h4>💡 Solutions possibles:</h4>");
            out.println("<ul>");
            out.println("<li>Vérifier que PostgreSQL Docker est démarré: <code>docker ps</code></li>");
            out.println("<li>Vérifier persistence.xml (url, user, password)</li>");
            out.println("<li>Vérifier que le port 5432 est accessible</li>");
            out.println("</ul>");
            out.println("</div>");

        } finally {
            if (em != null && em.isOpen()) {
                em.close();
                out.println("<div class='info'>✓ EntityManager fermé</div>");
            }
        }

        out.println("<a href='" + request.getContextPath() + "/' class='back-btn'>← Retour à l'accueil</a>");
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }
}