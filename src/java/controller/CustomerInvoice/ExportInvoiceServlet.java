/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.CustomerInvoice;

import dao.InvoiceDBContext;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.Invoice;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

@WebServlet("/customer/invoices/export")
public class ExportInvoiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        Customer customer = (Customer) session.getAttribute("currentCustomer");

        String format = request.getParameter("format"); // Can be 'excel' or 'csv'

        if (format == null || format.isEmpty()) {
            format = "csv"; // Default format
        }

        // Create DAO and get filtered invoices
        InvoiceDBContext invoiceDAO = new InvoiceDBContext();
        List<Invoice> invoices = invoiceDAO.getInvoicesByCustomerId(
                customer.getId());

        // Export based on format
        if ("csv".equalsIgnoreCase(format)) {
            exportToCSV(response, invoices);
        } else {
            // exportToExcel(response, invoices);
        }
    }

    private void exportToCSV(HttpServletResponse response, List<Invoice> invoices)
            throws IOException {    
        // Set response headers
        response.setContentType("text/csv");
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        String fileName = "invoices_export_" + dateFormat.format(new Date()) + ".csv";
        response.setHeader("Content-Disposition", "attachment; filename=" + fileName);

        // Write CSV data
        StringBuilder csv = new StringBuilder();

        // Add header
        csv.append("Invoice ID,Order Info,Created Date,Due Date,Appointment ID,Status,Amount (VND)\n");

        // Add data rows
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        for (Invoice invoice : invoices) {
            csv.append(invoice.getId()).append(",");

            // Handle commas in text fields
            String orderInfo = invoice.getOrderInfo().replace("\"", "\"\"");
            if (orderInfo.contains(",")) {
                csv.append("\"").append(orderInfo).append("\"");
            } else {
                csv.append(orderInfo);
            }
            csv.append(",");

            csv.append(invoice.getCreatedDate() != null
                    ? sdf.format(invoice.getCreatedDate()) : "").append(",");
            csv.append(invoice.getExpireDate() != null
                    ? sdf.format(invoice.getExpireDate()) : "").append(",");

            // Fix: Convert appointment ID to String to avoid type mismatch
            csv.append(invoice.getAppointmentId() != 0
                    ? String.valueOf(invoice.getAppointmentId()) : "N/A").append(",");

            csv.append(invoice.getStatus()).append(",");
            csv.append(invoice.getAmount()).append("\n");
        }

        // Write to response output stream
        response.getWriter().write(csv.toString());
    }

}
