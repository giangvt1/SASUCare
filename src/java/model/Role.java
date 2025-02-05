
package model;

import java.util.ArrayList;

/**
 *
 * @author acer
 */
public class Role {
    private int id;
    private String name;
    private ArrayList<Feature> features;

    public Role(int id, String name, ArrayList<Feature> features) {
        this.id = id;
        this.name = name;
        this.features = features;
    }

    public Role() {
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

    public ArrayList<Feature> getFeatures() {
        return features;
    }

    public void setFeatures(ArrayList<Feature> features) {
        this.features = features;
    }
    
}
