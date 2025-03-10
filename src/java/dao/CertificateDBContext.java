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
import java.util.logging.Logger;
import model.Application;
import model.Certificate;

/**
 *
 * @author TRUNG
 */
public class CertificateDBContext extends DBContext<Certificate> {

    private static final Logger LOGGER = Logger.getLogger(CertificateDBContext.class.getName());

    public List<Certificate> getCertificatesByDoctorID(int doctorId, int page, String sort, int size) {
        List<Certificate> certificates = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT c.CertificateID, c.DoctorID, c.CertificateName, c.IssuingAuthority, "
                + "c.IssueDate, c.ExpirationDate, c.DocumentPath, c.Status, "
                + "t.name AS TypeName "
                + "FROM Certificate c "
                + "JOIN Type_Certificate t ON c.typeId = t.id "
                + "WHERE c.DoctorID = ?"
        );

        // Thêm sắp xếp theo yêu cầu
        switch (sort) {
            case "dateLTH" ->
                sqlBuilder.append(" ORDER BY c.IssueDate ASC");
            case "dateHTL" ->
                sqlBuilder.append(" ORDER BY c.IssueDate DESC");
            default ->
                sqlBuilder.append(" ORDER BY c.CertificateID");
        }

        // Thêm phân trang
        sqlBuilder.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement stm = connection.prepareStatement(sqlBuilder.toString())) {
            int paramIndex = 1;
            stm.setInt(paramIndex++, doctorId); // Lọc theo DoctorID

            // Set pagination parameters
            int offset = (page - 1) * size;
            stm.setInt(paramIndex++, offset);
            stm.setInt(paramIndex++, size);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Certificate cert = new Certificate();
                    cert.setCertificateId(rs.getInt("CertificateID"));
                    cert.setDoctorId(rs.getInt("DoctorID"));
                    cert.setCertificateName(rs.getString("CertificateName"));
                    cert.setIssuingAuthority(rs.getString("IssuingAuthority"));
                    cert.setIssueDate(rs.getDate("IssueDate"));
                    cert.setExpirationDate(rs.getDate("ExpirationDate"));
                    cert.setStatus(rs.getString("Status"));
                    cert.setTypeName(rs.getString("TypeName")); // Lấy tên loại chứng chỉ

                    certificates.add(cert);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return certificates;
    }

    public int getCertificateCountByDoctorID(int doctorId) {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Certificate WHERE DoctorID = ?";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, doctorId);

            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    @Override
    public void insert(Certificate model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void update(Certificate model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void delete(Certificate model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public ArrayList<Certificate> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Certificate get(String id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
