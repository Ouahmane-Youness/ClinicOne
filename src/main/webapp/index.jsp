<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion Clinique - Accueil</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .container {
            background: white;
            padding: 3rem;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            text-align: center;
            max-width: 500px;
        }

        h1 {
            color: #667eea;
            margin-bottom: 1rem;
            font-size: 2.5rem;
        }

        .success-icon {
            font-size: 4rem;
            color: #10b981;
            margin-bottom: 1rem;
        }

        .info {
            background: #f0f9ff;
            padding: 1.5rem;
            border-radius: 10px;
            margin-top: 2rem;
            border-left: 4px solid #667eea;
        }

        .info h3 {
            color: #667eea;
            margin-bottom: 0.5rem;
        }

        .info p {
            color: #6b7280;
            line-height: 1.6;
        }

        .server-info {
            margin-top: 2rem;
            padding: 1rem;
            background: #fef3c7;
            border-radius: 8px;
            font-size: 0.9rem;
            color: #92400e;
        }

        .links {
            margin-top: 2rem;
            display: flex;
            gap: 1rem;
            justify-content: center;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: transform 0.2s;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        .btn-primary {
            background: #667eea;
            color: white;
        }

        .btn-secondary {
            background: #e5e7eb;
            color: #374151;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="success-icon">✅</div>
    <h1>Connexion Réussie !</h1>
    <p style="color: #6b7280; font-size: 1.1rem; margin-top: 0.5rem;">
        Votre application Java EE est correctement déployée sur Tomcat
    </p>

    <div class="info">
        <h3>📋 Informations du Serveur</h3>
        <p>
            <strong>Servlet Container:</strong> <%= application.getServerInfo() %><br>
            <strong>Context Path:</strong> <%= request.getContextPath() %><br>
            <strong>Session ID:</strong> <%= session.getId() %><br>
            <strong>Date/Heure:</strong> <%= new java.util.Date() %>
        </p>
    </div>

    <div class="server-info">
        <strong>⚙️ Statut du Projet:</strong><br>
        ✅ Tomcat configuré et déployé<br>
        ✅ Entités JPA créées<br>
        ✅ PostgreSQL prêt à être testé<br>
        🔜 Développement des repositories et services
    </div>

    <div class="links">
        <a href="${pageContext.request.contextPath}/test-db" class="btn btn-primary">🔌 Tester PostgreSQL</a>
        <a href="#" class="btn btn-secondary">📚 Documentation</a>
    </div>
</div>
</body>
</html>