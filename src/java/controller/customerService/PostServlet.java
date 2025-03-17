package controller.customerService;

import dao.PostDAO;
import model.Post;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

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

        // Xử lý sửa bài đăng
        if ("edit".equals(action) && idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                Post p = postDAO.get(String.valueOf(id)); // Lấy bài đăng theo ID từ DAO
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
        } 
        // Xử lý xóa bài đăng
        else if ("delete".equals(action) && idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                postDAO.delete(new Post(id, "", "", null, null, false, 0)); // Xóa bài đăng theo ID
                response.sendRedirect("post"); // Chuyển hướng sau khi xóa
                return;
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID không hợp lệ!");
            }
        }

        // Luôn hiển thị danh sách bài đăng kèm theo tên nhân viên
        List<Post> posts = postDAO.list(); // Lấy tất cả bài đăng từ DAO

        // Tìm kiếm bài đăng theo tiêu đề
        if (search != null && !search.trim().isEmpty()) {
            posts = postDAO.search(search);
        }
        // Lọc bài đăng theo trạng thái
        else if (filter != null) {
            boolean statusFilter = "1".equals(filter);
            posts = postDAO.filterByStatus(statusFilter);
        }
        // Sắp xếp bài đăng theo tiêu đề
        else if (sort != null) {
            boolean ascending = "asc".equals(sort);
            posts = postDAO.sortByTitle(ascending);
        }

        // Truyền danh sách bài đăng kèm theo tên nhân viên đến JSP
        request.setAttribute("posts", posts);
        request.getRequestDispatcher("Post.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // Thêm bài đăng
        if ("add".equals(action)) {
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            int staffId = Integer.parseInt(request.getParameter("staffId"));
            boolean status = "1".equals(request.getParameter("status"));
            postDAO.insert(new Post(0, title, content, null, null, status, staffId));  // Thêm bài đăng mới
        } 
        // Cập nhật bài đăng
        else if ("update".equals(action)) {
            String idStr = request.getParameter("id");

            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr);
                    String title = request.getParameter("title");
                    String content = request.getParameter("content");
                    int staffId = Integer.parseInt(request.getParameter("staffId"));
                    boolean status = "1".equals(request.getParameter("status"));

                    postDAO.update(new Post(id, title, content, null, null, status, staffId)); // Cập nhật bài đăng
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "ID không hợp lệ!");
                }
            } else {
                request.setAttribute("error", "Thiếu ID bài đăng để cập nhật!");
            }
        } 
        // Xóa bài đăng
        else if ("delete".equals(action)) {
            String idStr = request.getParameter("id");

            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr);
                    postDAO.delete(new Post(id, "", "", null, null, false, 0));  // Xóa bài đăng
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
