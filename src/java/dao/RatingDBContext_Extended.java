<<<<<<< Updated upstream
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

=======
package dao;

import dal.DBContext;
import model.Rating;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;

public class RatingDBContext_Extended extends RatingDBContext {
    private static final java.util.logging.Logger LOGGER = java.util.logging.Logger.getLogger(RatingDBContext_Extended.class.getSimpleName());

    // Lấy tất cả đánh giá
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
    public void deleteRating(int ratingId) {
        String sql = "DELETE FROM Rating WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, ratingId);
=======
    // Xóa đánh giá
    public void deleteRating(int doctorId, String username) {
        String sql = "DELETE FROM Rating WHERE doctor_id = ? AND username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ps.setString(2, username);
>>>>>>> Stashed changes
            ps.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting rating", ex);
        }
    }

<<<<<<< Updated upstream
    public void toggleVisibility(int ratingId, boolean visible) {
        String sql = "UPDATE Rating SET visible = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, visible);
            ps.setInt(2, ratingId);
=======
    // Chuyển đổi trạng thái hiển thị của đánh giá
    public void toggleVisibility(int doctorId, String username, boolean visible) {
        String sql = "UPDATE Rating SET visible = ? WHERE doctor_id = ? AND username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, visible);
            ps.setInt(2, doctorId);
            ps.setString(3, username);
>>>>>>> Stashed changes
            ps.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error toggling rating visibility", ex);
        }
    }

<<<<<<< Updated upstream
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

=======
    // Thêm một đánh giá
    @Override
    public void insert(Rating model) {
        String sql = "INSERT INTO Rating (doctor_id, username, rating, comment, created_at) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, model.getDoctorId());
            ps.setString(2, model.getCustomerUsername());
            ps.setFloat(3, model.getRating());
            ps.setString(4, model.getComment());
            ps.setDate(5, new java.sql.Date(System.currentTimeMillis())); // Đặt thời gian hiện tại
            ps.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting rating", ex);
        }
    }

    // Cập nhật một đánh giá
    @Override
    public void update(Rating model) {
        String sql = "UPDATE Rating SET rating = ?, comment = ? WHERE doctor_id = ? AND username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setFloat(1, model.getRating());
            ps.setString(2, model.getComment());
            ps.setInt(3, model.getDoctorId());
            ps.setString(4, model.getCustomerUsername());
            ps.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating rating", ex);
        }
    }

    // Xóa một đánh giá
    @Override
    public void delete(Rating model) {
        String sql = "DELETE FROM Rating WHERE doctor_id = ? AND username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, model.getDoctorId());
            ps.setString(2, model.getCustomerUsername());
            ps.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting rating", ex);
        }
    }

    // Lấy danh sách đánh giá
    @Override
    public ArrayList<Rating> list() {
        ArrayList<Rating> ratings = new ArrayList<>();
        String sql = "SELECT * FROM Rating ORDER BY created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ratings.add(new Rating(rs.getInt("doctor_id"), rs.getString("username"),
                        rs.getFloat("rating"), rs.getString("comment"), rs.getDate("created_at")));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving ratings list", ex);
        }
        return ratings;
    }

    // Lấy một đánh giá theo doctorId và username
    public Rating get(String doctorId, String username) {
        String sql = "SELECT * FROM Rating WHERE doctor_id = ? AND username = ?";
        Rating rating = null;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, doctorId);
            ps.setString(2, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                rating = new Rating(rs.getInt("doctor_id"), rs.getString("username"),
                        rs.getFloat("rating"), rs.getString("comment"), rs.getDate("created_at"));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving rating by doctorId and username", ex);
        }
        return rating;
    }
}
>>>>>>> Stashed changes
