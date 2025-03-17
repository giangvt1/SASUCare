package controller.financial;

import controller.systemaccesscontrol.BaseRBACController;
import dao.InvoiceDBContext;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Invoice;
import model.system.User;

public class InvoiceManagementController extends BaseRBACController {

    private InvoiceDBContext invoiceDAO = new InvoiceDBContext();

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        // Lấy các tham số filter, tìm kiếm, sort và phân trang từ request
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

        // Xử lý giá trị mặc định cho ngày lọc:
        Date startDate, endDate;
        if (startDateStr != null && !startDateStr.isEmpty()) {
            startDate = Date.valueOf(startDateStr);
        } else {
            // Mặc định: 30 ngày trước
            startDate = new Date(System.currentTimeMillis() - 30L * 24 * 60 * 60 * 1000);
            startDateStr = startDate.toString();
        }
        if (endDateStr != null && !endDateStr.isEmpty()) {
            endDate = Date.valueOf(endDateStr);
        } else {
            // Mặc định: ngày hiện tại
            endDate = new Date(System.currentTimeMillis());
            endDateStr = endDate.toString();
        }

        // Xử lý phân trang: trang hiện tại và số dòng trên trang
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
        // Đếm tổng số hóa đơn để tính số trang
        int totalRecords = invoiceDAO.countInvoiceDetails(startDate, endDate, search);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // Đưa các tham số và dữ liệu vào request attributes để JSP sử dụng
        request.setAttribute("invoiceList", invoiceList);
        request.setAttribute("search", search);
        request.setAttribute("startDate", startDateStr);
        request.setAttribute("endDate", endDateStr);
        request.setAttribute("sortField", sortField);
        request.setAttribute("sortDir", sortDir);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);

        // Forward đến JSP hiển thị giao diện quản lý hóa đơn
        request.getRequestDispatcher("../finance/invoiceManagement.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        doAuthorizedGet(request, response, logged);
    }
}
