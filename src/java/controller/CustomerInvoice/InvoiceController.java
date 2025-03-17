package controller.CustomerInvoice;

import dao.InvoiceDBContext;
import dao.TransactionDBContext;
import model.Invoice;
import model.Transaction;
import model.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/customer/invoice-details/*")
public class InvoiceController extends HttpServlet {

    private final InvoiceDBContext invoiceDB = new InvoiceDBContext();
    private final TransactionDBContext transactionDB = new TransactionDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        try {
            // Get the customer from session
//            HttpSession session = request.getSession();
//            Customer customer = (Customer) session.getAttribute("currentCustomer");
//            if (customer == null) {
//                response.sendRedirect(request.getContextPath() + "/Home.jsp");
//                return;
//            }

            // Extract the invoice ID from the URL path
            String pathInfo = request.getPathInfo();
            String[] pathParts = pathInfo.split("/");
            int invoiceId = Integer.parseInt(pathParts[1]);

            // Fetch the invoice based on the ID
            Invoice invoice = invoiceDB.get(invoiceId);

            if (invoice == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invoice not found");
                return;
            }

            // Fetch related transactions for the invoice
            List<Transaction> transactions = transactionDB.getTransactionsByInvoiceId(invoiceId);

            // Set the invoice and related transactions to the request
            request.setAttribute("invoice", invoice);
            request.setAttribute("transactions", transactions);

            // Forward to JSP page to display invoice details
            request.getRequestDispatcher("/customer/customer-invoice-details.jsp").forward(request, response);
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while fetching the invoice details.");
//        }
    }
}
