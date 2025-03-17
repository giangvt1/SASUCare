package controller.CustomerInvoice;

import dao.InvoiceDBContext;
import model.Invoice;
import model.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/customer/invoices")
public class InvoiceListController extends HttpServlet {
    private final InvoiceDBContext invoiceDB = new InvoiceDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("currentCustomer");
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/Home.jsp");
            return;
        }

        // Pagination parameters
        int currentPage = 1;
        int pageSize = 10;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                currentPage = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }

        // Filter parameters
        String statusFilter = request.getParameter("status");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String sortBy = request.getParameter("sortBy");
        String sortDirection = request.getParameter("sortDirection");

        // Fetch data
        List<Invoice> invoices = invoiceDB.getInvoicesByCustomerId(
            customer.getId(), statusFilter, startDate, endDate, 
            sortBy, sortDirection, currentPage, pageSize
        );
        int totalCount = invoiceDB.getInvoiceCountByCustomerId(
            customer.getId(), statusFilter, startDate, endDate
        );
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        // Set request attributes
        request.setAttribute("invoices", invoices);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortDirection", sortDirection);
        request.setAttribute("invoiceSummary", getInvoiceSummary(invoices));

        request.getRequestDispatcher("/customer/customer-invoice.jsp")
               .forward(request, response);
    }

    private InvoiceSummary getInvoiceSummary(List<Invoice> invoices) {
        int total = invoices.size();
        int paid = 0;
        int unpaid = 0;
        int overdue = 0;

        for (Invoice invoice : invoices) {
            if (invoice.getStatus() != null) {
                switch (invoice.getStatus().toLowerCase()) {
                    case "paid": paid++; break;
                    case "pending": unpaid++; break;
                    case "overdue": overdue++; break;
                }
            }
        }

        return new InvoiceSummary(total, paid, unpaid, overdue);
    }

    public static class InvoiceSummary {
        private final int total;
        private final int paid;
        private final int unpaid;
        private final int overdue;

        public InvoiceSummary(int total, int paid, int unpaid, int overdue) {
            this.total = total;
            this.paid = paid;
            this.unpaid = unpaid;
            this.overdue = overdue;
        }

        public int getTotal() { return total; }
        public int getPaid() { return paid; }
        public int getUnpaid() { return unpaid; }
        public int getOverdue() { return overdue; }
    }
}