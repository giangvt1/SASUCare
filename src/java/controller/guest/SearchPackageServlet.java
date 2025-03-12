package controller.guest;





/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */


import dao.PackageDBContext;
import model.Package;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author admin
 */
@WebServlet(urlPatterns={"/SearchPackage"})
public class SearchPackageServlet extends HttpServlet {
   private final PackageDBContext db = new PackageDBContext();
   private static final int PAGE_SIZE = 10;
    
    
    
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet SearchPackageServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SearchPackageServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
            
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
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
//        String search = request.getParameter("search");
        if (keyword != null) {
            keyword = keyword.trim().replaceAll("\\s+", " ").replace(" ", "%");
        }

        // Xử lý view (mặc định là extended)
        String view = request.getParameter("view");
        if (view == null || view.trim().isEmpty()) {
            view = "extended";
        }

        // Xử lý số trang, mặc định là 1
        int pageIndex = 1; // Mặc định là trang 1
try {
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.trim().isEmpty()) {
        pageIndex = Integer.parseInt(pageParam);
    }
} catch (NumberFormatException ex) {
    pageIndex = 1; // Nếu lỗi thì giữ nguyên trang 1
}

int totalRecords = db.countTotalPackages(keyword, category);
int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        // Lấy danh sách gói khám và danh mục
        ArrayList<Package> packages = (ArrayList<Package>) db.searchPackages(keyword, "Packages", pageIndex, PAGE_SIZE);
        List<String> categories = db.getAllCategories();
        request.setAttribute("packages", packages);
        request.setAttribute("categories", categories);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("currentPage", pageIndex);
request.setAttribute("totalPages", totalPages);
request.setAttribute("view", view);
        

//        if ("edit".equals(action) && idStr != null) {
//            int id = Integer.parseInt(idStr);
//            Package pkg = db.get(String.valueOf(id));
//            request.setAttribute("editPackage", pkg);
//        } else if ("delete".equals(action) && idStr != null) {
//            int id = Integer.parseInt(idStr);
//            db.delete(new Package(id, "", "", 0, 0, ""));
//            response.sendRedirect("SearchPackageServlet"); // Quay lại trang chính
//            return;
//        }

        request.getRequestDispatcher("./guest/GusPackage.jsp").forward(request, response);

            
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
          
int id = request.getParameter("id") != null && !request.getParameter("id").isEmpty() ? Integer.parseInt(request.getParameter("id")) : 0;
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        int duration = Integer.parseInt(request.getParameter("duration"));
        String category = request.getParameter("category");

        Package pkg = new Package(id, name, description, price, duration, category);

        if (id == 0) {
            db.insert(pkg); // Thêm mới
        } else {
            db.update(pkg); // Cập nhật
        }

        response.sendRedirect("SearchPackageServlet");
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
