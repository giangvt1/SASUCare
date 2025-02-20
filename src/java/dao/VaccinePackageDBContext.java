/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Vaccine;

/**
 *
 * @author admin
 */
public class VaccinePackageDBContext extends DBContext<Vaccine>{
    
    private static final java.util.logging.Logger LOGGER = java.util.logging.Logger.getLogger(DBContext.class.getName());
    
    
    
    
    
    

    @Override
    public void insert(Vaccine model) {
        String sql = "INSERT INTO VaccinePackages (name, description, price, duration_minutes, category) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, model.getName());
            ps.setString(2, model.getDescription());
            ps.setDouble(3, model.getPrice());
            ps.setInt(4, model.getDuration_minutes());
            ps.setString(5, model.getCategory());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(Vaccine model) {
 String sql = "UPDATE VaccinePackages SET name=?, description=?, price=?, duration_minutes=?, category=? WHERE id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, model.getName());
            ps.setString(2, model.getDescription());
            ps.setDouble(3, model.getPrice());
            ps.setInt(4, model.getDuration_minutes());
            ps.setString(5, model.getCategory());
            ps.setInt(6, model.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(Vaccine model) {
        String sql = "DELETE FROM VaccinePackages WHERE id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, model.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public ArrayList<Vaccine> list() {
        ArrayList<Vaccine> vaccines = new ArrayList<>();
        String sql = "SELECT * FROM VaccinePackages";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                vaccines.add(new Vaccine(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getInt("duration_minutes"),
                    rs.getString("category")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vaccines;
    }

    @Override
    public Vaccine get(String id) {
        String sql = "select * from VaccinePackages where id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, Integer.parseInt(id));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                    return new Vaccine(rs.getInt("id")
                            , rs.getString("name")
                            , rs.getString("description")
                            , rs.getDouble("price")
                            , rs.getInt("duration_minutes")
                            , rs.getString("category"));
            }
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Database connection error", ex);
        }
        return null;
    }
    
    
    public List<Vaccine> searchPackages(String keyword, String category) {
        List<Vaccine> Vaccine = new ArrayList<>();
        String sql = "SELECT * FROM VaccinePackages WHERE name LIKE ?";

        if (category != null && !category.isEmpty() && !category.equals("all")) {
            sql += " AND category = ?";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
//            ps.setString(2, "%" + keyword + "%");

            if (category != null && !category.isEmpty() && !category.equals("all")) {
                ps.setString(2, category);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Vaccine v = new Vaccine(rs.getInt("id")
                            , rs.getString("name")
                            , rs.getString("description")
                            , rs.getDouble("price")
                            , rs.getInt("duration_minutes")
                            , rs.getString("category"));
                Vaccine.add(v);
            }
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Database connection error", ex);
        }
        return Vaccine;
    }
    
    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM VaccinePackages";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                categories.add(rs.getString("category"));
            }
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Database connection error", ex);
        }
        return categories;
    }


    
    
    
}
