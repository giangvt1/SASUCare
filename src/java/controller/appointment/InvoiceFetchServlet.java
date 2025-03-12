/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.appointment;

import com.google.gson.Gson;
import dao.InvoiceDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Invoice;

/**
 *
 * @author Golden Lightning
 */
@WebServlet("/invoice/*")
public class InvoiceFetchServlet extends HttpServlet {
    private final InvoiceDBContext invoiceDB = new InvoiceDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String invoiceId = request.getPathInfo().substring(1); // Get the invoice ID from URL path
        if (invoiceId != null && !invoiceId.isEmpty()) {
            Invoice invoice = invoiceDB.get(Integer.parseInt(invoiceId));
            if (invoice != null) {
                response.setContentType("application/json");
                response.getWriter().write(new Gson().toJson(invoice));  // Assuming Gson for JSON conversion
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Invoice not found\"}");
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid invoice ID\"}");
        }
    }}
