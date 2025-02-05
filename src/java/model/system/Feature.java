/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.system;

import java.util.ArrayList;

/**
 *
 * @author acer
 */
public class Feature {
    private int id;
    private String name;
    private String url;
    private ArrayList<Role> role=new ArrayList<>();

    public Feature(int id, String name, String url, ArrayList<Role> role) {
        this.id = id;
        this.name = name;
        this.url = url;
        this.role = role;
    }

    public ArrayList<Role> getRole() {
        return role;
    }

    public void setRole(ArrayList<Role> role) {
        this.role = role;
    }
    
    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Feature() {
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
    
}
