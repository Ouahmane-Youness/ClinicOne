
package com.example.clinic.entities;

import jakarta.persistence.*;

@Entity
public class Admin extends Personne {

    @Column(unique = true)
    private String username;

    public Admin() {
    }

    public Admin(String nom, String prenom, String email, String motDePasse, String username) {
        super(nom, prenom, email, motDePasse);
        this.username = username;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}