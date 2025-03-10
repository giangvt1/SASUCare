/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dal.DBContext;
import java.util.ArrayList;
import model.Rating;
import java.sql.*;
import java.util.List;
import java.util.logging.Level;

/**
 *
 * @author admin
 */
public class RatingDBContext_Extended extends RatingDBContext {
    private static final java.util.logging.Logger LOGGER = java.util.logging.Logger.getLogger(RatingDBContext_Extended.class.getSimpleName());

    public List<Rating> getAllRatings() {
        List<Rating> ratings = new ArrayList<>();
        String sql = "SELECT * FROM Rating ORDER BY created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ratings.add(new Rating(rs.getInt("doctor_id"), rs.getString("username"),
                        rs.getFloat("rating"), rs.getString("comment"), rs.getDate("created_at")));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving all ratings", ex);
        }
        return ratings;
    }

    public void deleteRating(int ratingId) {
        String sql = "DELETE FROM Rating WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, ratingId);
            ps.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting rating", ex);
        }
    }

    public void toggleVisibility(int ratingId, boolean visible) {
        String sql = "UPDATE Rating SET visible = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, visible);
            ps.setInt(2, ratingId);
            ps.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error toggling rating visibility", ex);
        }
    }

    @Override
    public void insert(Rating model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void update(Rating model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void delete(Rating model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public ArrayList<Rating> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Rating get(String id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}

