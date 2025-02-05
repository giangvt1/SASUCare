package dao;

import dal.DBContext;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Customer;
import model.GoogleAccount;

public class CustomerDBContext extends DBContext<Customer> {

    private static final Logger LOGGER = Logger.getLogger(CustomerDBContext.class.getName());

//    public Role getRole(String username) {
//        Role role = null;
//        String sql = "SELECT r.* FROM roles r JOIN users u ON r.rid = u.role_id where u.username=?";
//        try (PreparedStatement stm = connection.prepareStatement(sql)) {
//            stm.setString(1, username);
//            ResultSet rs = stm.executeQuery();
//            if (rs.next()) {
//                role = new Role();
//                role.setId(rs.getInt("id"));
//                role.setName(rs.getString("name"));
//
//                // Fetch features for the role
//                ArrayList<Feature> features = new ArrayList<>();
//                String featureSql = "SELECT f.* FROM features f JOIN role_features rf ON f.id = rf.feature_id WHERE rf.role_id = ?";
//                try (PreparedStatement featureStm = connection.prepareStatement(featureSql)) {
//                    featureStm.setInt(1, role.getId());
//                    ResultSet featureRs = featureStm.executeQuery();
//                    while (featureRs.next()) {
//                        Feature feature = new Feature();
//                        feature.setId(featureRs.getInt("id"));
//                        feature.setName(featureRs.getString("name"));
//                        feature.setUrl(featureRs.getString("url"));
//                        features.add(feature);
//                    }
//                }
//
//                role.setFeatures(features); // Set the features for the role
//            }
//        } catch (SQLException ex) {
//            LOGGER.log(Level.SEVERE, "Error retrieving role for user: {0}", ex.getMessage());
//        }
//        return role;
//    }

//    public ArrayList<Feature> getRoleFeatures(int roleId) {
//        ArrayList<Feature> features = new ArrayList<>();
//        String sql = "SELECT * FROM features WHERE role_id = ?";
//        try (PreparedStatement stm = connection.prepareStatement(sql)) {
//            stm.setInt(1, roleId);
//            ResultSet rs = stm.executeQuery();
//            while (rs.next()) {
//                Feature feature = new Feature();
//                feature.setId(rs.getInt("feature_id"));
//                feature.setName(rs.getString("name"));
//                features.add(feature);
//            }
//        } catch (SQLException ex) {
//            LOGGER.log(Level.SEVERE, "Error retrieving features: {0}", ex.getMessage());
//        }
//        return features;
//    }

    /**
     *
     * @param model
     */
    @Override
    public void insert(Customer model) {
        java.util.Date now = new java.util.Date();
        String sql = "INSERT INTO [Customer] (username, password, gmail, gender, dob, address, phone_number, google_id, fullname) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, model.getUsername());
            stm.setString(2, model.getPassword());
            stm.setString(3, model.getGmail());
            stm.setBoolean(4, model.isGender());
            stm.setDate(5, new Date(now.getTime()));
            stm.setString(6, model.getAddress());
            stm.setString(7, model.getPhone_number());
            stm.setString(8, model.getFullname());

            // Kiểm tra GoogleAccount và thêm ID nếu có
            if (model.getGoogle_id() != null) {
                stm.setString(8, model.getGoogle_id().getId());
            } else {
                stm.setNull(8, java.sql.Types.VARCHAR);
            }

            int rowsAffected = stm.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Customer inserted successfully.");
            } else {
                System.out.println("Customer insert failed.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting customer: {0}", ex.getMessage());
        }
    }

    @Override
    public void update(Customer model) {
    String sql = "UPDATE [Customer] SET username = ?, password = ?, gmail = ?, gender = ?, dob = ?, address = ?, phone_number = ?, google_id = ? WHERE id = ?";
    try (PreparedStatement stm = connection.prepareStatement(sql)) {
        stm.setString(1, model.getUsername());
        stm.setString(2, model.getPassword());
        stm.setString(3, model.getGmail());
        stm.setBoolean(4, model.isGender());
        stm.setDate(5, new java.sql.Date(model.getDob().getTime()));
        stm.setString(6, model.getAddress());
        stm.setString(7, model.getPhone_number());

        // Kiểm tra GoogleAccount và thêm ID nếu có
        if (model.getGoogle_id() != null) {
            stm.setString(8, model.getGoogle_id().getId());
        } else {
            stm.setNull(8, java.sql.Types.VARCHAR);
        }

        // Cập nhật dựa trên ID
        stm.setInt(9, model.getId());

        int rowsAffected = stm.executeUpdate();
        if (rowsAffected > 0) {
            System.out.println("Customer updated successfully.");
        } else {
            System.out.println("Customer update failed.");
        }
    } catch (SQLException ex) {
        LOGGER.log(Level.SEVERE, "Error updating customer: {0}", ex.getMessage());
    }
}

    @Override
    public void delete(Customer model) {
        String sql = "DELETE FROM [Customer] WHERE id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, model.getId()); // Sử dụng `customer_id` thay vì `id`
            int rowsAffected = stm.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Customer deleted successfully.");
            } else {
                System.out.println("No customer found with the given ID.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting customer: {0}", ex.getMessage());
        }
    }

    @Override
    public ArrayList<Customer> list() {
        ArrayList<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM [Customer]";
        try (Statement stm = connection.createStatement(); ResultSet rs = stm.executeQuery(sql)) {
            while (rs.next()) {
                Customer customer = new Customer();
                customer.setId(rs.getInt("id")); // Cột khóa chính mới là `id`
                customer.setUsername(rs.getString("username"));
                customer.setPassword(rs.getString("password"));
                customer.setGmail(rs.getString("gmail"));
                customer.setGender(rs.getBoolean("gender"));
                customer.setDob(rs.getDate("dob")); // Chuyển đổi từ SQL date sang Java date
                customer.setAddress(rs.getString("address"));
                customer.setPhone_number(rs.getString("phone_number"));

                // Nếu có GoogleAccount
                if (rs.getString("google_id") != null) {
                    GoogleAccount googleAccount = new GoogleAccount();
                    googleAccount.setId(rs.getString("google_id"));
                    customer.setGoogle_id(googleAccount);
                }

                customers.add(customer);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error listing customers: {0}", ex.getMessage());
        }
        return customers;
    }

    public Customer get(String id) {
        Customer customer = null;
        String sql = "SELECT * FROM [Customer] WHERE id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                customer = new Customer();
                customer.setId(rs.getInt("id")); // Sử dụng cột `id` thay vì `customer_id`
                customer.setUsername(rs.getString("username"));
                customer.setPassword(rs.getString("password"));
                customer.setGmail(rs.getString("gmail"));
                customer.setGender(rs.getBoolean("gender"));
                customer.setDob(rs.getDate("dob")); // Chuyển đổi từ SQL Date sang Java Date
                customer.setAddress(rs.getString("address"));
                customer.setPhone_number(rs.getString("phone_number"));

                // Nếu GoogleAccount tồn tại
                if (id != null) {
                    GoogleAccount googleAccount = new GoogleAccount();
                    googleAccount.setId(id); // Gán giá trị `google_id`
                    customer.setGoogle_id(googleAccount);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching customer data: {0}", ex.getMessage());
        }
        return customer;
    }

    public Customer login(String username, String password) {
        String sql = """
                SELECT *
                FROM [test1].[dbo].[Customer]
                WHERE username = ? AND [password] = ?
                """;
        PreparedStatement stm = null;
        Customer customer = null;
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, username);
            stm.setString(2, hashPassword(password));
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                customer = new Customer();
                customer.setFullname(rs.getString("fullname"));
                customer.setUsername(rs.getString("username"));
                customer.setPassword(rs.getString("password")); // Lấy password
                customer.setGmail(rs.getString("gmail"));
                customer.setGender(rs.getBoolean("gender"));
                customer.setDob(rs.getDate("dob")); // Lấy ngày sinh
                customer.setAddress(rs.getString("address"));
                customer.setPhone_number(rs.getString("phone_number"));

                // Nếu GoogleAccount tồn tại, ánh xạ giá trị
                if (rs.getString("google_id") != null) {
                    GoogleAccount googleAccount = new GoogleAccount();
                    googleAccount.setId(rs.getString("google_id"));
                    customer.setGoogle_id(googleAccount);
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(CustomerDBContext.class.getName()).log(Level.SEVERE, "Login error: {0}", e);
        } finally {
            try {
                if (stm != null) {
                    stm.close();
                }
                if (connection != null) {
                    connection.close(); // Đảm bảo đóng kết nối nếu không sử dụng Connection Pool
                }
            } catch (SQLException e) {
                Logger.getLogger(CustomerDBContext.class.getName()).log(Level.SEVERE, "Error closing resources: {0}", e);
            }
        }
        return customer; // Trả về null nếu không tìm thấy người dùng
    }
    
    public List<String> listEmail() {
        ArrayList<String> listEmails = new ArrayList<>();
        String sql = "SELECT [gmail] FROM [Customer]"; // Sử dụng cột 'gmail' thay vì 'email'
        try (Statement stm = connection.createStatement(); ResultSet rs = stm.executeQuery(sql)) {
            while (rs.next()) {
                listEmails.add(rs.getString("gmail")); // Lấy giá trị từ cột 'gmail'
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error listing emails: {0}", ex.getMessage());
        }
        return listEmails;
    }
    
    public boolean isCustomerExisted(String gmail) {
        String sql = "SELECT * FROM [Customer] WHERE gmail = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, gmail);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return true;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding user by email: {0}", ex.getMessage());
        }
        return false;
    }
    
    public void changePass(Customer customer, String newPassword) {

        String sql = "UPDATE [Customer] SET password = ? WHERE username = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            // Mã hóa mật khẩu mới trước khi lưu
            stm.setString(1, newPassword);
            stm.setString(2, customer.getUsername());
            System.out.println("customer.getUsername: " + customer.getUsername());

            int rowsAffected = stm.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Password updated successfully.");
            } else {
                System.out.println("Password update failed. No rows affected.");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating password: {0}", ex.getMessage());
        }
    }
    
//    public boolean checkPassword(Customer customer, String password, String confirmPassword) {
//        // Mẫu kiểm tra độ mạnh của mật khẩu
//        String passwordPattern = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>])[A-Za-z\\d!@#$%^&*(),.?\":{}|<>]{6,}$";
//
//        // Kiểm tra mật khẩu mới và xác nhận mật khẩu phải giống nhau
//        if (!password.equals(confirmPassword)) {
//            System.out.println("Passwords do not match.");
//            return false;
//        }
//
//        // Kiểm tra độ mạnh của mật khẩu
//        if (!password.matches(passwordPattern)) {
//            System.out.println("Password does not meet the strength requirements.");
//            return false;
//        }
//
//        // Kiểm tra mật khẩu mới không trùng với mật khẩu cũ
//        String sql = "SELECT [password] FROM customers WHERE username = ?";
//        try (PreparedStatement stm = connection.prepareStatement(sql)) {
//            stm.setString(1, customer.getUsername());
//            ResultSet rs = stm.executeQuery();
//            if (rs.next()) {
//                String oldPassword = rs.getString("password");
//
//                // So sánh mật khẩu đã mã hóa (nếu sử dụng BCrypt hoặc các thuật toán khác)
//                if (BCrypt.checkpw(password, oldPassword)) {
//                    System.out.println("New password cannot be the same as the old password.");
//                    return false;
//                }
//            }
//        } catch (SQLException ex) {
//            LOGGER.log(Level.SEVERE, "Error fetching old password: {0}", ex.getMessage());
//            return false; // Trong trường hợp lỗi, trả về false để không làm ảnh hưởng tới logic.
//        }
//
//        System.out.println("Password validation successful.");
//        return true;
//    }
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            System.out.println(sb.toString());
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}
