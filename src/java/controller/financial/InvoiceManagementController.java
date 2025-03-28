package controller.financial;

import controller.systemaccesscontrol.BaseRBACController;
import dao.InvoiceDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Invoice;
import model.system.User;

@WebServlet("/InvoiceManagement")
public class InvoiceManagementController extends BaseRBACController {

    private InvoiceDBContext invoiceDAO = new InvoiceDBContext();

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        // Kiểm tra nếu xuất CSV
        String export = request.getParameter("export");
        if ("csv".equalsIgnoreCase(export)) {
            response.setContentType("text/csv");
            response.setHeader("Content-Disposition", "attachment; filename=\"invoices.csv\"");
            PrintWriter out = response.getWriter();
            
            // Ghi tiêu đề CSV
            out.println("Order Info,Created Date,Expire Date,Customer Name,Customer Gmail,Service Name,Price,VNPAY Id,Status");
            
            // Lấy các tham số filter
            String search = request.getParameter("search");
            if (search != null) {
                search = search.trim();
            }
            String startDateStr = request.getParameter("startDate");
            if (startDateStr != null) {
                startDateStr = startDateStr.trim();
            }
            String endDateStr = request.getParameter("endDate");
            if (endDateStr != null) {
                endDateStr = endDateStr.trim();
            }
            String sortField = request.getParameter("sortField");
            if (sortField != null) {
                sortField = sortField.trim();
            }
            String sortDir = request.getParameter("sortDir");
            if (sortDir != null) {
                sortDir = sortDir.trim();
            }
            
            // Xử lý ngày
            Date startDate = (startDateStr != null && !startDateStr.isEmpty())
                    ? Date.valueOf(startDateStr)
                    : new Date(System.currentTimeMillis() - 30L * 24 * 60 * 60 * 1000);
            Date endDate = (endDateStr != null && !endDateStr.isEmpty())
                    ? Date.valueOf(endDateStr)
                    : new Date(System.currentTimeMillis());
            
            // Xuất toàn bộ dữ liệu, không phân trang
            List<Invoice> invoiceList = invoiceDAO.getInvoiceDetails(startDate, endDate, search, sortField, sortDir, 0, Integer.MAX_VALUE);
            
            // Xuất dữ liệu CSV, escape dữ liệu nếu cần
            for (Invoice inv : invoiceList) {
                String orderInfo = escapeCSV(inv.getOrderInfo());
                String createdDate = inv.getCreatedDate() != null ? inv.getCreatedDate().toString() : "";
                String expireDate = inv.getExpireDate() != null ? inv.getExpireDate().toString() : "";
                String customerName = (inv.getCustomer() != null) ? escapeCSV(inv.getCustomer().getFullname()) : "";
                String customerGmail = (inv.getCustomer() != null) ? escapeCSV(inv.getCustomer().getGmail()) : "";
                String serviceName = (inv.getService() != null) ? escapeCSV(inv.getService().getName()) : "";
                String price = (inv.getService() != null) ? String.valueOf(inv.getService().getPrice()) : "0";
                String txnRef = escapeCSV(inv.getTxnRef());
                String status = escapeCSV(inv.getStatus());
                
                String line = orderInfo + "," + createdDate + "," + expireDate + "," 
                        + customerName + "," + customerGmail + "," + serviceName + ","
                        + price + "," + txnRef + "," + status;
                out.println(line);
            }
            out.flush();
            return; // Kết thúc nếu xuất CSV
        }
        
        // Nếu không xuất CSV, xử lý giao diện bình thường
        
        String search = request.getParameter("search");
        if (search != null) {
            search = search.trim();
        }
        String startDateStr = request.getParameter("startDate");
        if (startDateStr != null) {
            startDateStr = startDateStr.trim();
        }
        String endDateStr = request.getParameter("endDate");
        if (endDateStr != null) {
            endDateStr = endDateStr.trim();
        }
        String sortField = request.getParameter("sortField");
        if (sortField != null) {
            sortField = sortField.trim();
        }
        String sortDir = request.getParameter("sortDir");
        if (sortDir != null) {
            sortDir = sortDir.trim();
        }
        String pageStr = request.getParameter("page");
        if (pageStr != null) {
            pageStr = pageStr.trim();
        }
        String pageSizeStr = request.getParameter("pageSize");
        if (pageSizeStr != null) {
            pageSizeStr = pageSizeStr.trim();
        }
        
        // Xử lý giá trị mặc định cho ngày lọc
        Date startDate, endDate;
        if (startDateStr != null && !startDateStr.isEmpty()) {
            startDate = Date.valueOf(startDateStr);
        } else {
            startDate = new Date(System.currentTimeMillis() - 30L * 24 * 60 * 60 * 1000);
            startDateStr = startDate.toString();
        }
        if (endDateStr != null && !endDateStr.isEmpty()) {
            endDate = Date.valueOf(endDateStr);
        } else {
            endDate = new Date(System.currentTimeMillis());
            endDateStr = endDate.toString();
        }
        
        // Xử lý phân trang
        int page = 1;
        int pageSize = 10;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException ex) {
                page = 1;
            }
        }
        if (pageSizeStr != null && !pageSizeStr.isEmpty()) {
            try {
                pageSize = Integer.parseInt(pageSizeStr);
            } catch (NumberFormatException ex) {
                pageSize = 10;
            }
        }
        int offset = (page - 1) * pageSize;
        
        // Gọi DAO để lấy danh sách hóa đơn với filter, search, sort và phân trang
        List<Invoice> invoiceList = invoiceDAO.getInvoiceDetails(startDate, endDate, search, sortField, sortDir, offset, pageSize);
        int totalRecords = invoiceDAO.countInvoiceDetails(startDate, endDate, search);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        
        // Đưa các tham số vào request attributes
        request.setAttribute("invoiceList", invoiceList);
        request.setAttribute("search", search);
        request.setAttribute("startDate", startDateStr);
        request.setAttribute("endDate", endDateStr);
        request.setAttribute("sortField", sortField);
        request.setAttribute("sortDir", sortDir);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        
        request.getRequestDispatcher("../finance/invoiceManagement.jsp").forward(request, response);
    }

    // Khai báo hàm escapeCSV để xử lý dữ liệu xuất CSV
    private String escapeCSV(String field) {
        if (field == null) {
            return "";
        }
        field = field.replace("\"", "\"\"");
        if (field.contains(",") || field.contains("\"") || field.contains("\n")) {
            return "\"" + field + "\"";
        }
        return field;
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        doAuthorizedGet(request, response, logged);
    }
}
