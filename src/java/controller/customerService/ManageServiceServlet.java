/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customerService;

import model.Package;
import dao.PackageDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author admin
 */
public class ManageServiceServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ManageServiceServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ManageServiceServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PackageDBContext db = new PackageDBContext();

        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");

        if (keyword != null) {
            keyword = keyword.trim().replaceAll("\\s+", " ").replace(" ", "%");
        }
        String view = request.getParameter("view");
        if (view == null || view.trim().isEmpty()) {
            view = "extended";
        }

        int pageIndex = 1;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                pageIndex = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException ex) {
            pageIndex = 1;
        }

        List<Package> packages = db.searchPackages(keyword, category, pageIndex, PAGE_SIZE);
        List<String> categories = db.getAllCategories1();
        int totalRecords = db.countTotalPackages(keyword, category);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (pageIndex > totalPages) {
            pageIndex = totalPages;
        }
        if (category == null || category.isEmpty()) {
            category = "all";
        }

        request.setAttribute("packages", packages);
        request.setAttribute("categories", categories);
        request.setAttribute("keyword", keyword);
        request.setAttribute("category", category);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("view", view);

        if ("edit".equals(action) && idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                Package pkg = db.get(String.valueOf(id));
                request.setAttribute("editPackage", pkg);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID không hợp lệ");
            }
        } else if ("delete".equals(action) && idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                db.delete(new Package(id, "", "", 0, 0, ""));
                response.sendRedirect("ManageService");
                return;
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID không hợp lệ");
            }
        }

        request.getRequestDispatcher("/hr/SearchPackageForm.jsp").forward(request, response);
    }


    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
  @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    PackageDBContext db = new PackageDBContext();
        try {
            int id = 0, duration = 0, serviceId = 0;
            double price = 0.0;

            // Retrieve form data
            if (request.getParameter("id") != null && !request.getParameter("id").isEmpty()) {
                id = Integer.parseInt(request.getParameter("id"));
            }
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String category = request.getParameter("category");

            try {
                // Kiểm tra price có phải là số hợp lệ không và không âm
            String priceStr = request.getParameter("price");
            price = Double.parseDouble(priceStr);
            if (price < 0 || price > 1000000000) { // Giới hạn max có thể điều chỉnh
                request.setAttribute("error", "Giá phải là số dương và không quá lớn.");
                request.getRequestDispatcher("/hr/SearchPackageForm.jsp").forward(request, response);
                return;
            }

            // Kiểm tra duration có phải là số hợp lệ không và không âm
            String durationStr = request.getParameter("duration");
            duration = Integer.parseInt(durationStr);
            if (duration < 0 || duration > 1440) { // Giới hạn max có thể điều chỉnh
                request.setAttribute("error", "Thời gian phải là số dương và không quá lớn.");
                request.getRequestDispatcher("/hr/SearchPackageForm.jsp").forward(request, response);
                return;
            }
                serviceId = Integer.parseInt(request.getParameter("service_id"));
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Dữ liệu không hợp lệ: " + e.getMessage());
                request.getRequestDispatcher("/hr/SearchPackageForm.jsp").forward(request, response);
                return;
            }

            // Validation
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin.");
                request.getRequestDispatcher("/hr/SearchPackageForm.jsp").forward(request, response);
                return;
            }

            // Create a new Package object
            Package pkg = new Package(id, name, description, price, duration, category, serviceId);

<<<<<<< Updated upstream
            // Insert or update based on ID
//            if (id == 0) {
//                db.insert(pkg);
//            } else {
//                db.update(pkg);
//            }
            db.save(pkg);
=======
//             Insert or update based on ID
            if (id == 0) {
                db.insert(pkg);
            } else {
                db.update(pkg);
            }
//            db.save(pkg);
>>>>>>> Stashed changes
            response.sendRedirect("ManageService");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi xử lý dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/hr/SearchPackageForm.jsp").forward(request, response);
        }
    
}


    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
