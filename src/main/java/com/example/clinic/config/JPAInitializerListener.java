package com.example.clinic.config;

import com.example.clinic.util.JPAUtil;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class JPAInitializerListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=== Application Starting - Initializing JPA ===");
        try {
            // This will trigger the static block in JPAUtil and create the EntityManagerFactory
            // which in turn will create the database tables based on entities
            JPAUtil.getEntityManager().close();
            System.out.println("=== JPA Initialized Successfully - Database tables should be created ===");
        } catch (Exception e) {
            System.err.println("=== ERROR: Failed to initialize JPA ===");
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=== Application Shutting Down - Closing JPA ===");
        try {
            JPAUtil.close();
            System.out.println("=== JPA Closed Successfully ===");
        } catch (Exception e) {
            System.err.println("=== ERROR: Failed to close JPA ===");
            e.printStackTrace();
        }
    }
}
