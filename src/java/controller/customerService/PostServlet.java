package controller.customerService;

import dao.PostDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Post;

@WebServlet(name = "PostServlet", urlPatterns = {"/post"})
public class PostServlet extends HttpServlet {
    private final PostDAO postDAO = new PostDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        String search = request.getParameter("search");
        String filter = request.getParameter("filter");
        String sort = request.getParameter("sort");

        

        if ("edit".equals(action) && idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                Post p = postDAO.get(String.valueOf(id));
                if (p != null) {
                    request.setAttribute("editPost", p);
                    request.getRequestDispatcher("editPost.jsp").forward(request, response);
                    return; // Quan trọng: Tránh tiếp tục thực hiện các lệnh bên dưới
                } else {
                    request.setAttribute("error", "Bài đăng không tồn tại!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID không hợp lệ!");
            }
        } else if ("delete".equals(action) && idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                postDAO.delete(new Post(id, "", "", null, null, "", true));
                response.sendRedirect("post"); // Chuyển hướng sau khi xóa
                return;
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID không hợp lệ!");
            }
        }

        // Luôn hiển thị danh sách bài đăng
        List<Post> posts = postDAO.list();

        if (search != null && !search.trim().isEmpty()) {
            posts = postDAO.search(search);
        } else if (filter != null) {
            boolean statusFilter = "1".equals(filter);
            posts = postDAO.filterByStatus(statusFilter);
        } else if (sort != null) {
            boolean ascending = "asc".equals(sort);
            posts = postDAO.sortByTitle(ascending);
        } else {
            posts = postDAO.list();
        }
        System.out.println("Danh sách bài đăng: " + posts);
        request.setAttribute("posts", posts);
        request.getRequestDispatcher("Post.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String managerUsername = request.getParameter("managerUsername");
            boolean status = "1".equals(request.getParameter("status"));
            postDAO.insert(new Post(0, title, content, null, null, managerUsername, status));
        } else if ("update".equals(action)) {
            String idStr = request.getParameter("id");

            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr);
                    String title = request.getParameter("title");
                    String content = request.getParameter("content");
                    String managerUsername = request.getParameter("managerUsername");
                    boolean status = "1".equals(request.getParameter("status"));

                    postDAO.update(new Post(id, title, content, null, null, managerUsername, status));
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "ID không hợp lệ!");
                }
            } else {
                request.setAttribute("error", "Thiếu ID bài đăng để cập nhật!");
            }
        } else if ("delete".equals(action)) {
            String idStr = request.getParameter("id");

            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr);
                    postDAO.delete(new Post(id, null, null, null, null, "", false));
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "ID không hợp lệ!");
                }
            }
        }

        response.sendRedirect("post");
    }

    @Override
    public String getServletInfo() {
        return "Post Management Servlet";
    }
}
