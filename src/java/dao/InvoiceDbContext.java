package dao;

import dal.DBContext;
import model.Invoice;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Customer;
import model.Service;

public class InvoiceDBContext extends DBContext<Invoice> {

    public int getInvoiceIdByTxnRef(String vnp_TxnRef) {
        int invoiceId = -1;
        String sql = "SELECT id FROM Invoices WHERE vnp_TxnRef = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, vnp_TxnRef);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    invoiceId = rs.getInt("id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return invoiceId;
    }

    public List<Invoice> getInvoicesByCustomerId(int customerId, String status, String startDate, String endDate,
            String sortBy, String sortDirection, int currentPage, int pageSize) {
        List<Invoice> invoices = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT [id], [order_info], [created_date], [expire_date], [customer_id], "
                + "[service_id], [vnp_TxnRef], [status], [appointment_id], amount "
                + "FROM [Invoices] WHERE customer_id = ?");

        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
        }
        if (startDate != null && !startDate.isEmpty()) {
            sql.append(" AND created_date >= ?");
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql.append(" AND created_date <= DATEADD(day, 1, ?)");
        }

        sql.append(" ORDER BY ");
        switch (sortBy != null ? sortBy.toLowerCase() : "") {
            case "amount":
                sql.append("[amount]");
                break; // Note: amount column is missing in your schema
            case "duedate":
                sql.append("[expire_date]");
                break;
            default:
                sql.append("[created_date]");
        }
        sql.append(sortDirection != null && "asc".equalsIgnoreCase(sortDirection) ? " ASC" : " DESC");

        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, customerId);

            if (status != null && !status.isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            if (startDate != null && !startDate.isEmpty()) {
                ps.setDate(paramIndex++, Date.valueOf(startDate));
            }
            if (endDate != null && !endDate.isEmpty()) {
                ps.setDate(paramIndex++, Date.valueOf(endDate));
            }

            ps.setInt(paramIndex++, (currentPage - 1) * pageSize);
            ps.setInt(paramIndex++, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invoice invoice = new Invoice();
                    invoice.setId(rs.getInt("id"));
                    invoice.setOrderInfo(rs.getString("order_info"));
//                    invoice.setCustomerId(rs.getInt("customer_id"));
//                    invoice.setServiceId(rs.getInt("service_id"));
                    invoice.setCreatedDate(rs.getTimestamp("created_date"));
                    invoice.setExpireDate(rs.getTimestamp("expire_date"));
                    invoice.setTxnRef(rs.getString("vnp_TxnRef"));
                    invoice.setStatus(rs.getString("status"));
                    invoice.setAmount(rs.getFloat("amount"));
                    invoice.setAppointmentId(rs.getInt("appointment_id"));
                    invoices.add(invoice);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return invoices;
    }

    public int getInvoiceCountByCustomerId(int customerId, String status, String startDate, String endDate) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM [Invoices] WHERE customer_id = ?");

        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
        }
        if (startDate != null && !startDate.isEmpty()) {
            sql.append(" AND created_date >= ?");
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql.append(" AND created_date <= DATEADD(day, 1, ?)");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, customerId);

            if (status != null && !status.isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            if (startDate != null && !startDate.isEmpty()) {
                ps.setDate(paramIndex++, Date.valueOf(startDate));
            }
            if (endDate != null && !endDate.isEmpty()) {
                ps.setDate(paramIndex++, Date.valueOf(endDate));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    // Method to get invoice by appointment ID
    public Invoice getInvoiceByAppointmentId(int appointmentId) {
        String sql = "SELECT * FROM Invoices WHERE appointment_id = ?";
        Invoice invoice = null;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, appointmentId); // Set appointmentId parameter

            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                invoice = new Invoice();
                invoice.setId(rs.getInt("id"));
                invoice.setOrderInfo(rs.getString("order_info"));
//                invoice.setOrderType(rs.getString("order_type"));
                Customer customer = new Customer();
                customer.setId(rs.getInt("customer_id"));
                invoice.setCustomer(customer);

                Service service = new Service();
                service.setId(rs.getInt("service_id"));
                invoice.setService(service);

                invoice.setCreatedDate(rs.getTimestamp("created_date"));
                invoice.setExpireDate(rs.getTimestamp("expire_date"));
                invoice.setTxnRef(rs.getString("vnp_TxnRef"));
                invoice.setStatus(rs.getString("status"));
                invoice.setAppointmentId(rs.getInt("appointment_id"));
            }
        } catch (SQLException ex) {
            System.err.println("Error while retrieving invoice by appointment ID: " + ex.getMessage());
        }

        return invoice;
    }

    // Method to insert a new invoice into the database
    public void insert(Invoice invoice) {
        String sql = "INSERT INTO Invoices (order_info, amount, created_date, expire_date, customer_id, vnp_TxnRef, status, appointment_id) "
                + "VALUES (?,?, GETDATE(), ?, ?, ?, ?, ?)";  // Service ID is removed

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, invoice.getOrderInfo());
            stm.setFloat(2, invoice.getAmount());
            stm.setTimestamp(3, new Timestamp(invoice.getExpireDate().getTime())); // Expiry date
            stm.setInt(4, invoice.getCustomer().getId());
            stm.setString(5, invoice.getTxnRef());
            stm.setString(6, invoice.getStatus());
            stm.setInt(7, invoice.getAppointmentId());

            int affectedRows = stm.executeUpdate();
            if (affectedRows > 0) {
                System.out.println("Invoice created successfully.");
            } else {
                System.out.println("Invoice creation failed.");
            }
        } catch (SQLException ex) {
            System.err.println("Error while inserting invoice: " + ex.getMessage());
        }
    }

    public Invoice get(int id) {
        String sql = "SELECT [id], "
                + "[order_info], "
                + "[created_date], "
                + "[expire_date], "
                + "[customer_id], "
                + "[service_id], "
                + "[vnp_TxnRef], "
                + "[status], "
                + "[appointment_id], "
                + "amount "
                + "FROM [Invoices] WHERE id = ?";
        Invoice invoice = null;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id); // Set the invoice ID parameter

            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                invoice = new Invoice();
                invoice.setId(rs.getInt("id"));
                invoice.setOrderInfo(rs.getString("order_info"));  // Corrected column name
                invoice.setCreatedDate(rs.getDate("created_date")); // Corrected column name
                invoice.setExpireDate(rs.getDate("expire_date"));  // Corrected column name
                invoice.setAmount(rs.getFloat("amount"));
                Customer customer = new Customer();
                customer.setId(rs.getInt("customer_id"));
                invoice.setCustomer(customer);
                Service service = new Service();
                service.setId(rs.getInt("service_id"));
                invoice.setService(service);   // Corrected column name
                invoice.setTxnRef(rs.getString("vnp_TxnRef"));
                invoice.setStatus(rs.getString("status"));         // Corrected column name
                invoice.setAppointmentId(rs.getInt("appointment_id")); // Corrected column name
            }
        } catch (SQLException ex) {
            System.err.println("Error while retrieving invoice: " + ex.getMessage());
        }

        return invoice;
    }

    // Optional: Method to retrieve a list of invoices for a customer
    public List<Invoice> getInvoicesByCustomerId(int customerId) {
        String sql = "SELECT * FROM Invoice sWHERE customer_id = ?";
        List<Invoice> invoices = new ArrayList<>();

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, customerId);

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Invoice invoice = new Invoice();
                invoice.setId(rs.getInt("id"));
//                invoice.setAmount(rs.getLong("amount"));
                invoice.setOrderInfo(rs.getString("orderInfo"));
                invoice.setOrderType(rs.getString("orderType"));
                Customer customer = new Customer();
                customer.setId(rs.getInt("customer_id"));
                invoice.setCustomer(customer);
                Service service = new Service();
                service.setId(rs.getInt("service_id"));
                invoice.setService(service);
                invoice.setCreatedDate(rs.getDate("createdDate"));
                invoice.setExpireDate(rs.getDate("expireDate"));
                invoice.setTxnRef(rs.getString("txnRef"));
                invoices.add(invoice);
            }
        } catch (SQLException ex) {
            System.err.println("Error while retrieving invoices by customer ID: " + ex.getMessage());
        }

        return invoices;
    }

    @Override
    public void update(Invoice invoice) {
        StringBuilder sql = new StringBuilder("UPDATE Invoices SET ");
        List<Object> params = new ArrayList<>();

        if (invoice.getOrderInfo() != null) {
            sql.append("order_info = ?, ");
            params.add(invoice.getOrderInfo());
        }
        if (invoice.getAmount() != 0) {
            sql.append("amount = ?, ");
            params.add(invoice.getAmount());
        }
        if (invoice.getExpireDate() != null) {
            sql.append("expire_date = ?, ");
            params.add(new Timestamp(invoice.getExpireDate().getTime()));
        }
        if (invoice.getCustomer() != null && invoice.getCustomer().getId() > 0) {
            sql.append("customer_id = ?, ");
            params.add(invoice.getCustomer().getId());
        }
        if (invoice.getTxnRef() != null) {
            sql.append("vnp_TxnRef = ?, ");
            params.add(invoice.getTxnRef());
        }
        if (invoice.getStatus() != null && !invoice.getStatus().trim().isEmpty()) {
            sql.append("status = ?, ");
            params.add(invoice.getStatus());
        }
        if (invoice.getAppointmentId() > 0) {
            sql.append("appointment_id = ?, ");
            params.add(invoice.getAppointmentId());
        }

        // Nếu không có gì để cập nhật thì không chạy SQL
        if (params.isEmpty()) {
            System.out.println("Update skipped: No valid fields to update.");
            return;
        }

        // Xóa dấu phẩy cuối và thêm điều kiện WHERE
        sql.delete(sql.length() - 2, sql.length());
        sql.append(" WHERE id = ?");
        params.add(invoice.getId());

        try (PreparedStatement stm = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stm.setObject(i + 1, params.get(i));
            }

            int affectedRows = stm.executeUpdate();
            if (affectedRows > 0) {
                System.out.println("Invoice updated successfully.");
            } else {
                System.out.println("Invoice update failed. No invoice found with ID: " + invoice.getId());
            }
        } catch (SQLException ex) {
            System.err.println("Error while updating invoice: " + ex.getMessage());
        }
    }

    @Override
    public void delete(Invoice model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public ArrayList<Invoice> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Invoice get(String id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public List<Invoice> getAllInvoices() {
        List<Invoice> invoices = new ArrayList<>();
        String sql = """
                     SELECT [id]
                           ,[order_info]
                           ,[created_date]
                           ,[expire_date]
                           ,[customer_id]
                           ,[service_id]
                           ,[vnp_TxnRef]
                           ,[status]
                           ,[appointment_id]
                       FROM [dbo].[Invoices]
                     """;
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Invoice inv = new Invoice();
                inv.setId(rs.getInt("id"));
                inv.setOrderInfo(rs.getString("order_info"));
                inv.setCreatedDate(rs.getTimestamp("created_date"));
                inv.setExpireDate(rs.getTimestamp("expire_date"));
                Customer customer = new Customer();
                customer.setId(rs.getInt("customer_id"));
                inv.setCustomer(customer);
                Service service = new Service();
                service.setId(rs.getInt("service_id"));
                inv.setService(service);
                inv.setTxnRef(rs.getString("vnp_TxnRef"));
                inv.setStatus(rs.getString("status"));
                inv.setAppointmentId(rs.getInt("appointment_id"));
                invoices.add(inv);
            }
        } catch (SQLException ex) {
            System.err.println("Error while retrieving invoices: " + ex.getMessage());
        }
        return invoices;
    }

}
