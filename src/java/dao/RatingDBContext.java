/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Rating;
import dal.DBContext;
import java.lang.System.Logger;
import java.lang.System.Logger.Level;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RatingDBContext extends DBContext<Rating> {
<<<<<<< Updated upstream
private static final java.util.logging.Logger LOGGER = java.util.logging.Logger.getLogger(DoctorDBContext.class.getName());
=======
private static final java.util.logging.Logger LOGGER = java.util.logging.Logger.getLogger(DoctorRatingDBContext.class.getName());
>>>>>>> Stashed changes
    @Override
    public void insert(Rating rating) {
        String sql = "INSERT INTO Rating (doctor_id, , rating, comment) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, rating.getDoctorId());
            ps.setString(2, rating.getCustomerUsername());
            ps.setFloat(3, rating.getRating());
            ps.setString(4, rating.getComment());
            ps.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Error inserting rating", ex);
        }
    }

    @Override
    public void update(Rating rating) {
        String sql = "UPDATE Rating SET rating = ?, comment = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setFloat(1, rating.getRating());
            ps.setString(2, rating.getComment());
//            ps.setInt(3, rating.getId());
            ps.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Error updating rating", ex);
        }
    }

    public static void main(String[] args) {
        RatingDBContext db = new RatingDBContext();
//        db.saveOrUpdateRating(new Rating(1, "abcabc", 1, "laimotlannua2"));
        System.out.println(db.getRatingsByDoctorId(1));
    }

    public void saveOrUpdateRating(Rating rating) {
        String checkQuery = "SELECT COUNT(*) FROM Rating WHERE doctor_id = ? AND username = ?";
        String updateQuery = "UPDATE Rating SET rating = ?, comment = ? WHERE doctor_id = ? AND username = ?";
        String insertQuery = "INSERT INTO Rating (doctor_id, username, rating, comment) VALUES (?, ?, ?, ?)";

        try (Connection conn = connection; PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
            checkStmt.setInt(1, rating.getDoctorId());
            checkStmt.setString(2, rating.getCustomerUsername());
            ResultSet rs = checkStmt.executeQuery();
            rs.next();
            boolean exists = rs.getInt(1) > 0;
            if (exists) {
                // Nếu đã có đánh giá, thì cập nhật
                PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
                updateStmt.setFloat(1, rating.getRating());
                updateStmt.setString(2, rating.getComment());
                updateStmt.setInt(3, rating.getDoctorId());
                updateStmt.setString(4, rating.getCustomerUsername());
                updateStmt.executeUpdate();

            } else {
                // Nếu chưa có đánh giá, thì thêm mới
                PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
                insertStmt.setInt(1, rating.getDoctorId());
                insertStmt.setString(2, rating.getCustomerUsername());
                insertStmt.setFloat(3, rating.getRating());
                insertStmt.setString(4, rating.getComment());
                insertStmt.executeUpdate();
            }

        } catch (SQLException e) {
            LOGGER.log(java.util.logging.Level.SEVERE, e.toString());
        }

    }

    public List<Rating> getRatingsByDoctorId(int doctorId) {
        List<Rating> ratings = new ArrayList<>();
        String sql = "SELECT * FROM Rating WHERE doctor_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ratings.add(new Rating(rs.getInt("doctor_id"), rs.getString("username"),
                        rs.getFloat("rating"), rs.getString("comment"), rs.getDate("created_at")));
            }
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Error getting ratings for doctor", ex);
        }
        return ratings;
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
