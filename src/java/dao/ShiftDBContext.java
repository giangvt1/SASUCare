package dao;

import dal.DBContext;
import model.Shift;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ShiftDBContext extends DBContext<Shift> {
    private static final Logger LOGGER = Logger.getLogger(ShiftDBContext.class.getName());

    public List<Shift> getAllShifts() {
        List<Shift> shifts = new ArrayList<>();
        String sql = "SELECT id, time_start, time_end FROM Shift ORDER BY id";

        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Shift shift = new Shift(
                    rs.getInt("id"),
                    rs.getTime("time_start"),
                    rs.getTime("time_end")
                );
                shifts.add(shift);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving shifts: {0}", ex.getMessage());
        }
        return shifts;
    }

    @Override
    public void insert(Shift model) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public Shift get(String id) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void update(Shift model) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void delete(Shift model) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public ArrayList<Shift> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

} 