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
        String sql = "SELECT  [id]\n"
                + "      ,[order_info]\n"
                + "      ,[created_date]\n"
                + "      ,[expire_date]\n"
                + "      ,[customer_id]\n"
                + "      ,[service_id]\n"
                + "      ,[vnp_TxnRef]\n"
                + "      ,[status]\n"
                + "      ,[appointment_id]\n"
                + "      ,[amount]\n"
                + "  FROM [Invoices] WHERE appointment_id = ?";
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

    public List<Invoice> getInvoicesByCustomerId(int customerId) {
        String sql = "SELECT id, order_info, created_date, expire_date, customer_id, service_id, vnp_TxnRef, status, appointment_id, amount FROM Invoices WHERE customer_id = ?";
        List<Invoice> invoices = new ArrayList<>();

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, customerId);

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Invoice invoice = new Invoice();
                invoice.setId(rs.getInt("id"));
                invoice.setOrderInfo(rs.getString("order_info"));
                invoice.setCreatedDate(rs.getDate("created_date"));
                invoice.setExpireDate(rs.getDate("expire_date"));
                invoice.setTxnRef(rs.getString("vnp_TxnRef"));
                invoice.setStatus(rs.getString("status")); // Ensure you have a setter in Invoice class

                // Handling `amount` column (assuming it's a BigDecimal or double)
                invoice.setAmount(rs.getFloat("amount"));

                // Set customer
                Customer customer = new Customer();
                customer.setId(rs.getInt("customer_id"));
                invoice.setCustomer(customer);

                // Set service
                Service service = new Service();
                service.setId(rs.getInt("service_id"));
                invoice.setService(service);

                // Set appointment ID (assuming it's an integer)
                invoice.setAppointmentId(rs.getInt("appointment_id"));

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
    public void delete(Invoice invoice) {
        String sql = "DELETE FROM Invoices WHERE id = ?";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, invoice.getId());

            int affectedRows = stm.executeUpdate();
            if (affectedRows > 0) {
                System.out.println("Invoice deleted successfully.");
            } else {
                System.out.println("Invoice deletion failed. No invoice found with ID: " + invoice.getId());
            }
        } catch (SQLException ex) {
            System.err.println("Error while deleting invoice: " + ex.getMessage());
        }
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

    public List<Invoice> getInvoiceDetails(Date start, Date end, String rawSearch,
            String sortField, String sortDir, int offset, int pageSize) {
        List<Invoice> invoices = new ArrayList<>();

        // Xử lý search: loại bỏ khoảng trắng thừa và thay thế nhiều khoảng trắng thành '%'
        String searchPattern = null;
        if (rawSearch != null) {
            rawSearch = rawSearch.trim().replaceAll("\\s+", "%");
            if (!rawSearch.isEmpty()) {
                searchPattern = "%" + rawSearch + "%";
            }
        }

        String sql = """
        SELECT c.fullname as Customer_Name,
               c.gmail as Customer_Gmail,
               s.name as Service_Name,
               i.order_info as Order_Info,
               i.status as Status,
               i.vnp_TxnRef as VNPAY_Id,
               i.created_date,
               i.expire_date,
               s.price
        FROM [test1].[dbo].[Invoices] i
        LEFT JOIN Appointment a ON a.id = i.appointment_id
        LEFT JOIN Customer c ON a.customer_id = c.id
        LEFT JOIN Service s ON s.id = i.service_id
        WHERE 1=1
    """;

        // Lọc theo khoảng thời gian (theo i.created_date)
        if (start != null && end != null) {
            sql += " AND i.created_date BETWEEN ? AND ? ";
        }

        // Tìm kiếm (trong fullname, order_info, service name)
        if (searchPattern != null && !searchPattern.isEmpty()) {
            sql += " AND (c.fullname LIKE ? OR i.order_info LIKE ? OR s.name LIKE ?) ";
        }

        // Xử lý sắp xếp: chỉ cho phép sắp xếp theo các trường cụ thể
        if (sortField != null && !sortField.trim().isEmpty()) {
            switch (sortField) {
                case "orderInfo":
                    sql += " ORDER BY i.order_info " + ("desc".equalsIgnoreCase(sortDir) ? "DESC" : "ASC");
                    break;
                case "createdDate":
                    sql += " ORDER BY i.created_date " + ("desc".equalsIgnoreCase(sortDir) ? "DESC" : "ASC");
                    break;
                case "expireDate":
                    sql += " ORDER BY i.expire_date " + ("desc".equalsIgnoreCase(sortDir) ? "DESC" : "ASC");
                    break;
                case "Customer_Name":
                    sql += " ORDER BY c.fullname " + ("desc".equalsIgnoreCase(sortDir) ? "DESC" : "ASC");
                    break;
                case "Service_Name":
                    sql += " ORDER BY s.name " + ("desc".equalsIgnoreCase(sortDir) ? "DESC" : "ASC");
                    break;
                case "Status":
                    sql += " ORDER BY i.status " + ("desc".equalsIgnoreCase(sortDir) ? "DESC" : "ASC");
                    break;
                case "VNPAY_Id":
                    sql += " ORDER BY i.vnp_TxnRef " + ("desc".equalsIgnoreCase(sortDir) ? "DESC" : "ASC");
                    break;
                default:
                    sql += " ORDER BY i.created_date ASC";
                    break;
            }
        } else {
            sql += " ORDER BY i.created_date ASC";
        }

        // Áp dụng phân trang: OFFSET FETCH
        sql += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            int index = 1;
            if (start != null && end != null) {
                stm.setDate(index++, start);
                stm.setDate(index++, end);
            }
            if (searchPattern != null && !searchPattern.isEmpty()) {
                // 3 placeholder cho fullname, order_info và service name
                stm.setString(index++, searchPattern);
                stm.setString(index++, searchPattern);
                stm.setString(index++, searchPattern);
            }
            stm.setInt(index++, offset);
            stm.setInt(index++, pageSize);

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Invoice inv = new Invoice();
                inv.setOrderInfo(rs.getString("Order_Info"));
                inv.setStatus(rs.getString("Status"));
                inv.setTxnRef(rs.getString("VNPAY_Id"));
                inv.setCreatedDate(rs.getTimestamp("created_date"));
                inv.setExpireDate(rs.getTimestamp("expire_date"));

                // Mapping thông tin khách hàng
                Customer customer = new Customer();
                customer.setFullname(rs.getString("Customer_Name"));
                customer.setGmail(rs.getString("Customer_Gmail"));
                inv.setCustomer(customer);

                // Mapping thông tin dịch vụ
                Service service = new Service();
                service.setName(rs.getString("Service_Name"));
                service.setPrice(rs.getDouble("price"));
                inv.setService(service);

                invoices.add(inv);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return invoices;
    }

    public int countInvoiceDetails(Date start, Date end, String rawSearch) {
        int total = 0;
        // Xử lý searchPattern: loại bỏ khoảng trắng thừa và thay thế nhiều khoảng trắng liên tiếp bằng '%'
        String searchPattern = null;
        if (rawSearch != null) {
            rawSearch = rawSearch.trim().replaceAll("\\s+", "%");
            if (!rawSearch.isEmpty()) {
                searchPattern = "%" + rawSearch + "%";
            }
        }

        String sql = """
         SELECT COUNT(*) as Total
         FROM (
            SELECT i.id
            FROM [test1].[dbo].[Invoices] i
            LEFT JOIN Appointment a ON a.id = i.appointment_id
            LEFT JOIN Customer c ON a.customer_id = c.id
            LEFT JOIN Service s ON s.id = i.service_id
            WHERE 1=1
    """;
        if (start != null && end != null) {
            sql += " AND i.created_date BETWEEN ? AND ? ";
        }
        if (searchPattern != null && !searchPattern.isEmpty()) {
            sql += " AND (c.fullname LIKE ? OR i.order_info LIKE ? OR s.name LIKE ?) ";
        }
        sql += " GROUP BY i.id ) AS T";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            int index = 1;
            if (start != null && end != null) {
                stm.setDate(index++, start);
                stm.setDate(index++, end);
            }
            if (searchPattern != null && !searchPattern.isEmpty()) {
                stm.setString(index++, searchPattern);
                stm.setString(index++, searchPattern);
                stm.setString(index++, searchPattern);
            }
            ResultSet rs = stm.executeQuery();
            // Vì SELECT COUNT(*) trả về 1 dòng, lấy trực tiếp giá trị của "Total"
            if (rs.next()) {
                total = rs.getInt("Total");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return total;
    }

}
