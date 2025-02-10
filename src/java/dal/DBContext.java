package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.sql.*;
public abstract class DBContext<T> {

    private static final Logger LOGGER = Logger.getLogger(DBContext.class.getName());

    protected Connection connection;

    public DBContext() {
        try {
<<<<<<< Updated upstream
            String user = "giang";
            String pass = "1";
            String url = "jdbc:sqlserver://localhost\\SQLEXPRESS:1433;databaseName=test1;encrypt=true;trustServerCertificate=true;";
=======
            String user = "pvchiu";
            String pass = "123";
            String url = "jdbc:sqlserver://localhost\\SQLEXPRESS:1433;databaseName=HealthDB1;encrypt=true;trustServerCertificate=true;";
>>>>>>> Stashed changes
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, user, pass);
            if (connection != null) {
                System.out.println("Database connection established successfully.");
            }
        } catch (ClassNotFoundException | SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database connection error", ex);
        }
    }

    public abstract void insert(T model);

    public abstract void update(T model);

    public abstract void delete(T model);

    public abstract ArrayList<T> list();

    public abstract T get(String id);

    // Optional: Method to close the connection
    public void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "Error closing connection", e);
            }
        }
    }
    public void testConnection() {
        if (connection == null) {
            System.out.println("❌ Connection is NULL. Check your database configuration.");
            return;
        }

        System.out.println("✅ Database connected successfully!");

        String sql = "SELECT COUNT(*) AS total FROM packages"; // Kiểm tra bảng `packages`
        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                int total = rs.getInt("total");
                System.out.println("📊 Số lượng gói khám trong database: " + total);
            } else {
                System.out.println("⚠ Không thể lấy dữ liệu từ bảng packages!");
            }
        } catch (SQLException e) {
            System.out.println("❌ SQL Query Error: " + e.getMessage());
        }
    }
    public static void main(String[] args) {
        DBContext<?> dbContext = new DBContext<Object>() {
            @Override public void insert(Object model) {}
            @Override public void update(Object model) {}
            @Override public void delete(Object model) {}
            @Override public ArrayList<Object> list() { return null; }
            @Override public Object get(String id) { return null; }
        };
        
        dbContext.testConnection(); // Gọi phương thức test kết nối
        dbContext.closeConnection();
    }
}
