/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import model.Certificate;
import model.TypeCertificate;

/**
 *
 * @author TRUNG
 */
public class CertificateDBContext extends DBContext<Certificate> {

    private static final Logger LOGGER = Logger.getLogger(CertificateDBContext.class.getName());

    public static void main(String[] args) {
        CertificateDBContext c = new CertificateDBContext();
        System.out.println(c.getCertificatesByDoctorID(null, null, null, 16, 1, "default", 10).size());
    }

    public boolean createTypeCertificate(TypeCertificate typeCer) {
        String sql = "INSERT INTO Type_Certificate (name, staff_manage_id) VALUES (?, ?)";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, typeCer.getName());
            stm.setInt(2, typeCer.getStaffManageId());

            int rowsAffected = stm.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateTypeCertificate(TypeCertificate typeCer) {
        String sql = "UPDATE Type_Certificate SET name = ?, staff_manage_id = ? WHERE id = ?";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, typeCer.getName());
            stm.setInt(2, typeCer.getStaffManageId());
            stm.setInt(3, typeCer.getId());

            int rowsAffected = stm.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCertificateForDoctor(Certificate certificate) {
        String sql = "UPDATE Certificate SET checkNote = ?, checkedByStaffId = ?, checkedDate = ?, status = ? WHERE certificateId = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, certificate.getCheckNote());
            stm.setInt(2, certificate.getCheckedByStaffId());
            stm.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            stm.setString(4, certificate.getStatus());
            stm.setInt(5, certificate.getCertificateId());
            int rowsUpdated = stm.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Certificate getCertificateById(int id) {
        Certificate cert = null;
        String sql = "SELECT c.certificateId, c.doctorId, c.certificateName, c.issuingAuthority, "
                + "c.issueDate, c.expirationDate, c.documentPath, c.status, "
                + "c.checkedByStaffId, c.checkedDate, c.checkNote, "
                + "t.name AS typeName, s.fullname AS doctorName "
                + "FROM Certificate c "
                + "JOIN Type_Certificate t ON c.typeId = t.id "
                + "JOIN Doctor d ON c.doctorId = d.id "
                + "JOIN Staff s ON d.staff_id = s.id "
                + "WHERE c.certificateId = ?";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    cert = new Certificate();
                    cert.setCertificateId(rs.getInt("certificateId"));
                    cert.setDoctorId(rs.getInt("doctorId"));
                    cert.setCertificateName(rs.getString("certificateName"));
                    cert.setIssuingAuthority(rs.getString("issuingAuthority"));
                    cert.setIssueDate(rs.getDate("issueDate"));
                    cert.setExpirationDate(rs.getDate("expirationDate"));
                    cert.setStatus(rs.getString("status"));
                    cert.setDocumentPath(rs.getString("documentPath"));
                    cert.setCheckedByStaffId(rs.getInt("checkedByStaffId"));
                    cert.setCheckedDate(rs.getDate("checkedDate"));
                    cert.setCheckNote(rs.getString("checkNote"));
                    cert.setTypeName(rs.getString("typeName"));
                    cert.setDoctorName(rs.getString("doctorName"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cert;
    }

    public List<Certificate> getCertificatesByStaffManageID(String certificateName, String doctorName, String typeName, String status, int staffManagerId, int page, String sort, int size) {
        List<Certificate> certificates = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT c.certificateId, c.doctorId, c.certificateName, c.issuingAuthority, "
                + "c.issueDate, c.expirationDate,c.checkNote, c.documentPath, c.status, "
                + "t.name AS typeName, s.fullname AS doctorName "
                + "FROM Certificate c "
                + "JOIN Type_Certificate t ON c.typeId = t.id "
                + "JOIN Doctor d ON c.doctorId = d.id "
                + "JOIN Staff s ON d.staff_id = s.id "
                + "WHERE t.staff_manage_id = ?"
        );

        if (certificateName != null && !certificateName.isEmpty()) {
            sqlBuilder.append(" AND c.certificateName COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ?");
        }
        if (doctorName != null && !doctorName.isEmpty()) {
            sqlBuilder.append(" AND s.fullname COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ?");
        }
        if (typeName != null) {
            sqlBuilder.append(" AND t.name LIKE ?");
        }
        if (status != null) {
            sqlBuilder.append(" AND c.status LIKE ?");
        }

        switch (sort) {
            case "default" ->
                sqlBuilder.append(" ORDER BY c.certificateId");
            case "certificateNameAZ" ->
                sqlBuilder.append(" ORDER BY c.certificateName ASC");
            case "certificateNameZA" ->
                sqlBuilder.append(" ORDER BY c.certificateName DESC");
            case "IDOTN" ->
                sqlBuilder.append(" ORDER BY c.issueDate DESC");
            case "IDNTO" ->
                sqlBuilder.append(" ORDER BY c.issueDate ASC");
            case "EDOTN" ->
                sqlBuilder.append(" ORDER BY c.expirationDate DESC");
            case "EDNTO" ->
                sqlBuilder.append(" ORDER BY c.expirationDate ASC");
            default ->
                throw new AssertionError("Invalid sort type: " + sort);
        }

        sqlBuilder.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement stm = connection.prepareStatement(sqlBuilder.toString())) {
            int paramIndex = 1;
            stm.setInt(paramIndex++, staffManagerId);

            if (certificateName != null && !certificateName.isEmpty()) {
                stm.setString(paramIndex++, "%" + certificateName + "%");
            }
            if (doctorName != null && !doctorName.isEmpty()) {
                stm.setString(paramIndex++, "%" + doctorName + "%");
            }
            if (typeName != null) {
                stm.setString(paramIndex++, "%" + typeName + "%");
            }
            if (status != null) {
                stm.setString(paramIndex++, "%" + status + "%");
            }

            int offset = (page - 1) * size;
            stm.setInt(paramIndex++, offset);
            stm.setInt(paramIndex++, size);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Certificate cert = new Certificate();
                    cert.setCertificateId(rs.getInt("certificateId"));
                    cert.setDoctorId(rs.getInt("doctorId"));
                    cert.setCertificateName(rs.getString("certificateName"));
                    cert.setIssuingAuthority(rs.getString("issuingAuthority"));
                    cert.setIssueDate(rs.getDate("issueDate"));
                    cert.setExpirationDate(rs.getDate("expirationDate"));
                    cert.setStatus(rs.getString("status"));
                    cert.setTypeName(rs.getString("typeName"));
                    cert.setCheckNote(rs.getString("checkNote"));
                    cert.setDocumentPath(rs.getString("documentPath"));
                    cert.setDoctorName(rs.getString("doctorName"));
                    certificates.add(cert);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return certificates;
    }

    public int getCertificateCountByStaffManageID(String certificateName, String doctorName, String typeName, String status, int staffManagerId) {
        int total = 0;
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT COUNT(*) AS total FROM Certificate c "
                + "JOIN Type_Certificate t ON c.typeId = t.id "
                + "JOIN Doctor d ON c.doctorId = d.id "
                + "JOIN Staff s ON d.staff_id = s.id "
                + "WHERE t.staff_manage_id = ?"
        );

        if (certificateName != null && !certificateName.isEmpty()) {
            sqlBuilder.append(" AND c.certificateName COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ?");
        }
        if (doctorName != null && !doctorName.isEmpty()) {
            sqlBuilder.append(" AND s.fullname LIKE ?");
        }
        if (typeName != null && !typeName.isEmpty()) {
            sqlBuilder.append(" AND t.name LIKE ?");
        }
        if (status != null && !status.isEmpty()) {
            sqlBuilder.append(" AND c.status LIKE ?");
        }

        try (PreparedStatement stm = connection.prepareStatement(sqlBuilder.toString())) {
            int paramIndex = 1;
            stm.setInt(paramIndex++, staffManagerId);

            if (certificateName != null && !certificateName.isEmpty()) {
                stm.setString(paramIndex++, "%" + certificateName + "%");
            }
            if (doctorName != null && !doctorName.isEmpty()) {
                stm.setString(paramIndex++, "%" + doctorName + "%");
            }
            if (typeName != null && !typeName.isEmpty()) {
                stm.setString(paramIndex++, "%" + typeName + "%");
            }
            if (status != null && !status.isEmpty()) {
                stm.setString(paramIndex++, "%" + status + "%");
            }

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

    public boolean createCertificate(Certificate c) {
        String sql = "INSERT INTO Certificate(certificateName, issueDate, documentPath, status, typeId, doctorId, [file]) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            int paramIndex = 1;
            stm.setString(paramIndex++, c.getCertificateName());
            stm.setDate(paramIndex++, c.getIssueDate());
            stm.setString(paramIndex++, c.getDocumentPath());
            stm.setString(paramIndex++, "Pending");
            stm.setInt(paramIndex++, c.getTypeId());
            stm.setInt(paramIndex++, c.getDoctorId());
            stm.setString(paramIndex++, c.getFile());
            int rowsInserted = stm.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public List<Certificate> getCertificatesByDoctorID(String certificateName, String typeName, String status, int doctorId, int page, String sort, int size) {
        List<Certificate> certificates = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT c.certificateId, c.doctorId, c.certificateName, c.issuingAuthority, "
                + "c.issueDate, c.documentPath, c.status, "
                + "t.name AS typeName "
                + "FROM Certificate c "
                + "JOIN Type_Certificate t ON c.typeId = t.id "
                + "WHERE c.doctorId = ?"
        );
        if (certificateName != null && !certificateName.isEmpty()) {
            sqlBuilder.append(" AND c.CertificateName COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ?");
        }
        if (typeName != null) {
            sqlBuilder.append(" AND t.name like ?");
        }
        if (status != null) {
            sqlBuilder.append(" AND c.Status like ?");
        }
        switch (sort) {
            case "certificateNameAZ" ->
                sqlBuilder.append(" ORDER BY certificateName ASC");
            case "certificateNameZA" ->
                sqlBuilder.append(" ORDER BY certificateName DESC");
            case "IDOTN" ->
                sqlBuilder.append(" ORDER BY IssueDate DESC");
            case "IDNTO" ->
                sqlBuilder.append(" ORDER BY IssueDate ASC");
            case "EDOTN" ->
                sqlBuilder.append(" ORDER BY ExpirationDate DESC");
            case "EDNTO" ->
                sqlBuilder.append(" ORDER BY ExpirationDate ASC");
            default ->
                sqlBuilder.append(" ORDER BY id");
        }

        sqlBuilder.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement stm = connection.prepareStatement(sqlBuilder.toString())) {
            int paramIndex = 1;
            stm.setInt(paramIndex++, doctorId);
            if (certificateName != null && !certificateName.isEmpty()) {
                stm.setString(paramIndex++, "%" + certificateName + "%");
            }
            if (typeName != null) {
                stm.setString(paramIndex++, "%" + typeName + "%");
            }
            if (status != null) {
                stm.setString(paramIndex++, "%" + status + "%");
            }

            int offset = (page - 1) * size;
            stm.setInt(paramIndex++, offset);
            stm.setInt(paramIndex++, size);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Certificate cert = new Certificate();
                    cert.setCertificateId(rs.getInt("certificateId"));
                    cert.setDoctorId(rs.getInt("doctorId"));
                    cert.setCertificateName(rs.getString("certificateName"));
                    cert.setIssuingAuthority(rs.getString("issuingAuthority"));
                    cert.setIssueDate(rs.getDate("issueDate"));
                    cert.setStatus(rs.getString("status"));
                    cert.setTypeName(rs.getString("typeName"));
                    cert.setDocumentPath(rs.getString("documentPath"));
                    certificates.add(cert);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return certificates;
    }

    public int getCertificateCountByDoctorID(String certificateName, String typeName, String status, int doctorId) {
        int total = 0;
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT COUNT(*) AS total FROM Certificate c "
                + "JOIN Type_Certificate t ON c.typeId = t.id "
                + "WHERE c.DoctorID = ?"
        );

        if (certificateName != null && !certificateName.isEmpty()) {
            sqlBuilder.append(" AND c.CertificateName COLLATE SQL_Latin1_General_CP1_CI_AI LIKE ?");
        }
        if (typeName != null && !typeName.isEmpty()) {
            sqlBuilder.append(" AND t.name LIKE ?");
        }
        if (status != null && !status.isEmpty()) {
            sqlBuilder.append(" AND c.Status LIKE ?");
        }

        try (PreparedStatement stm = connection.prepareStatement(sqlBuilder.toString())) {
            int paramIndex = 1;
            stm.setInt(paramIndex++, doctorId);

            if (certificateName != null && !certificateName.isEmpty()) {
                stm.setString(paramIndex++, "%" + certificateName + "%");
            }
            if (typeName != null && !typeName.isEmpty()) {
                stm.setString(paramIndex++, "%" + typeName + "%");
            }
            if (status != null && !status.isEmpty()) {
                stm.setString(paramIndex++, "%" + status + "%");
            }

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

    public List<TypeCertificate> getAllTypes() {
        List<TypeCertificate> typeList = new ArrayList<>();
        String sql = "SELECT t.id, t.name, t.staff_manage_id, s.fullname AS staffManagerName "
                + "FROM Type_Certificate t "
                + "JOIN Staff s ON t.staff_manage_id = s.id";

        try (PreparedStatement stm = connection.prepareStatement(sql); ResultSet rs = stm.executeQuery()) {
            while (rs.next()) {
                TypeCertificate type = new TypeCertificate();
                type.setId(rs.getInt("id"));
                type.setName(rs.getString("name"));
                type.setStaffManageId(rs.getInt("staff_manage_id"));
                type.setStaffManageName(rs.getString("staffManagerName"));
                typeList.add(type);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return typeList;
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

    public List<Certificate> getCertificatesBelongDoctorId(int doctorId) {
        List<Certificate> certificates = new ArrayList<>();
        String sql = "SELECT  [CertificateID]\n"
                + "      ,[DoctorID]\n"
                + "      ,[CertificateName]\n"
                + "      ,[IssuingAuthority]\n"
                + "      ,[IssueDate]\n"
                + "      ,[ExpirationDate]\n"
                + "      ,[DocumentPath]\n"
                + "      ,[Status]\n"
                + "      ,[CheckedByStaffID]\n"
                + "      ,[CheckedDate]\n"
                + "      ,[CheckNote]\n"
                + "      ,[typeId]\n"
                + "  FROM [Certificate] "
                + " WHERE DoctorID = ? AND Status = 'Approved'";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Certificate cert = new Certificate();
                    cert.setCertificateId(rs.getInt("certificateId"));
                    cert.setDoctorId(rs.getInt("DoctorID"));
                    cert.setCertificateName(rs.getString("CertificateName"));
                    cert.setIssuingAuthority(rs.getString("IssuingAuthority"));
                    cert.setDocumentPath(rs.getString("DocumentPath"));
                    cert.setStatus(rs.getString("status"));
                    cert.setIssueDate(rs.getDate("issueDate"));
                    cert.setExpirationDate(rs.getDate("expirationDate"));
                    System.out.println(cert.getCertificateName());
                    certificates.add(cert);

                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return certificates;
    }

    @Override
    public Certificate get(String id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
