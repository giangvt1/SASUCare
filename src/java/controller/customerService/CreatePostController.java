/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customerService;

import dao.PostDAO;
import dao.UserDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import model.Post;
import model.system.Staff;
import model.system.User;

/**
 *
 * @author admin
 */
@WebServlet(name = "CreatePostController", urlPatterns = {"/hr/create-post"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 5, // 5 MB
        maxRequestSize = 1024 * 1024 * 10 // 10 MB
)
public class CreatePostController extends HttpServlet {

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
        request.getRequestDispatcher("/customer_service/CreatePost.jsp").forward(request, response);
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
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    public static final String UPLOAD_IMAGES_DIR = "images";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy và trim các giá trị đầu vào
            String title = request.getParameter("title") != null ? request.getParameter("title").trim() : "";
            String content = request.getParameter("content") != null ? request.getParameter("content").trim() : "";

            // Xử lý file image upload
            Part filePart = request.getPart("image");
            String imageFilePath = null;
            String imageFile = null;
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = extractFileName(filePart);
                String applicationPath = getServletContext().getRealPath("");
                String uploadFilePath = applicationPath + File.separator + UPLOAD_IMAGES_DIR;

                // Tạo thư mục nếu chưa tồn tại
                File uploadDir = new File(uploadFilePath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                // Lưu file hình ảnh
                imageFilePath = uploadFilePath + File.separator + fileName;
                try (InputStream fileContent = filePart.getInputStream()) {
                    // Nếu file chưa tồn tại thì lưu ảnh
                    Path destinationPath = Paths.get(imageFilePath);
                    if (!Files.exists(destinationPath)) {
                        Files.copy(fileContent, new File(imageFilePath).toPath());
                    }
                }
                //get link image
                imageFile = UPLOAD_IMAGES_DIR + File.separator + fileName;
            }

            HttpSession session = request.getSession();
            Staff staff = (Staff) session.getAttribute("staff");
            PostDAO dao = new PostDAO();
            Post post = new Post(title, content, staff.getId(), imageFile);
            dao.insert(post);
            request.getRequestDispatcher("/hr/posts").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 2, token.length() - 1);
            }
        }
        return "";
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
