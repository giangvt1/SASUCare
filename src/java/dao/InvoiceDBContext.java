package dao;

import dal.DBContext;
import model.Invoice;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Customer;
import model.Service;

public class InvoiceDBContext extends DBContext<Invoice> {
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
                + "[appointment_id] "
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
    public void update(Invoice model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
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
