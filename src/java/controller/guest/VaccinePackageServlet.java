package controller.guest;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */



import dao.PackageDBContext;
import dao.VaccinePackageDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Vaccine;

/**
 *
 * @author admin
 */
@WebServlet(name="VaccinePackageServlet", urlPatterns={"/VaccinePackage"})
public class VaccinePackageServlet extends HttpServlet {
   
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
            out.println("<title>Servlet VaccinePackageServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet VaccinePackageServlet at " + request.getContextPath () + "</h1>");
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
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");
        
        VaccinePackageDBContext db = new VaccinePackageDBContext();
        List<Vaccine> vaccines = db.list();
        List<String> categories = db.getAllCategories();
        
        request.setAttribute("vaccines", vaccines);
        request.setAttribute("categories", categories);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedCategory", category);
        
        if ("edit".equals(action) && idStr != null) {
            int id = Integer.parseInt(idStr);
            Vaccine vaccine = db.get(String.valueOf(id));
            request.setAttribute("editVaccine", vaccine);
        } else if ("delete".equals(action) && idStr != null) {
            int id = Integer.parseInt(idStr);
            db.delete(new Vaccine(id, "", "", 0, 0, ""));
            response.sendRedirect("VaccinePackage");
            return;
        }
        
        request.getRequestDispatcher("GusVaccine.jsp").forward(request, response);
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
        VaccinePackageDBContext db = new VaccinePackageDBContext();
        
        int id = request.getParameter("id") != null && !request.getParameter("id").isEmpty() ? Integer.parseInt(request.getParameter("id")) : 0;
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        int duration = Integer.parseInt(request.getParameter("duration"));
        String category = request.getParameter("category");
        
        Vaccine vaccine = new Vaccine(id, name, description, price, duration, category);
        
        if (id == 0) {
            db.insert(vaccine);
        } else {
            db.update(vaccine);
        }
        
        response.sendRedirect("VaccinePackage");
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
