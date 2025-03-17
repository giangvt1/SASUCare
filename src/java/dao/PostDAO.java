package dao;

import dal.DBContext;
import model.Post;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.system.UserAccountDTO;

public class PostDAO extends DBContext<Post> {

    private static final Logger LOGGER = Logger.getLogger(PostDAO.class.getName());

    public List<Post> listPosts(String search, int pageIndex, int pageSize, Boolean status) {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT p.*, s.fullname AS staff_name "
                + "FROM Post p "
                + "JOIN Staff s ON p.staff_id = s.id "
                + "WHERE p.title LIKE ? ";
        if (status != null) {
            sql += "and p.status = 1 ";
        }
        sql += "ORDER BY p.id desc "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            // Nếu search là null, ta gán chuỗi rỗng, sau đó tạo pattern cho LIKE
            String filter = "%" + (search != null ? search.trim() : "") + "%";
            stm.setString(1, filter);
            // Tính toán offset
            stm.setInt(2, (pageIndex - 1) * pageSize);
            stm.setInt(3, pageSize);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Post post = mapResultSetToPost(rs);
                    post.setStaffName(rs.getString("staff_name"));
                    post.setImage(rs.getString("image"));
                    list.add(post);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error searching posts", ex);
        }
        return list;
    }

    public int getTotalPosts(String keyword, Boolean status) {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total "
                + "FROM Post p "
                + "JOIN Staff s ON p.staff_id = s.id "
                + "WHERE p.title LIKE ? ";
        if (status != null) {
            sql += "and p.status = 1 ";
        }
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            // Chuẩn hóa từ khóa tìm kiếm
            String filter = "%" + (keyword != null ? keyword.trim() : "") + "%";
            stm.setString(1, filter);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error searching posts", ex);
        }
        return total;
    }

    // Lấy danh sách bài đăng kèm theo tên nhân viên
    public List<Post> search(String keyword) {
        List<Post> posts = new ArrayList<>();
        String sql = "SELECT p.*, s.fullname AS staff_name "
                + "FROM Post p "
                + "JOIN Staff s ON p.staff_id = s.id "
                + "WHERE p.title LIKE ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Post post = mapResultSetToPost(rs);
                post.setStaffName(rs.getString("staff_name"));
                posts.add(post);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error searching posts", ex);
        }
        return posts;
    }

    // Lọc bài đăng theo trạng thái kèm theo tên nhân viên
    public List<Post> filterByStatus(boolean status) {
        List<Post> posts = new ArrayList<>();
        String sql = "SELECT p.*, s.fullname AS staff_name "
                + "FROM Post p "
                + "JOIN Staff s ON p.staff_id = s.id "
                + "WHERE p.status=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setBoolean(1, status);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Post post = mapResultSetToPost(rs);
                post.setStaffName(rs.getString("staff_name"));
                posts.add(post);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error filtering posts by status", ex);
        }
        return posts;
    }

    // Sắp xếp bài đăng theo tiêu đề kèm theo tên nhân viên
    public List<Post> sortByTitle(boolean ascending) {
        List<Post> posts = new ArrayList<>();
        String sql = "SELECT p.*, s.fullname AS staff_name "
                + "FROM Post p "
                + "JOIN Staff s ON p.staff_id = s.id "
                + "ORDER BY p.title " + (ascending ? "ASC" : "DESC");
        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Post post = mapResultSetToPost(rs);
                post.setStaffName(rs.getString("staff_name"));
                posts.add(post);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error sorting posts by title", ex);
        }
        return posts;
    }

    // Sắp xếp bài đăng theo ngày kèm theo tên nhân viên
    public List<Post> sortByDate(boolean ascending) {
        List<Post> posts = new ArrayList<>();
        String sql = "SELECT p.*, s.fullname AS staff_name "
                + "FROM Post p "
                + "JOIN Staff s ON p.staff_id = s.id "
                + "ORDER BY p.created_at " + (ascending ? "ASC" : "DESC");
        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Post post = mapResultSetToPost(rs);
                post.setStaffName(rs.getString("staff_name"));
                posts.add(post);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error sorting posts by date", ex);
        }
        return posts;
    }

    // Chuyển đổi dữ liệu từ ResultSet sang đối tượng Post
    private Post mapResultSetToPost(ResultSet rs) throws SQLException {
        return new Post(
                rs.getInt("id"),
                rs.getString("title"),
                rs.getString("content"),
                rs.getTimestamp("created_at"),
                rs.getTimestamp("updated_at"),
                rs.getBoolean("status"),
                rs.getInt("staff_id")
        );
    }

    @Override
    public void insert(Post post) {
        String sql = "INSERT INTO Post (title, content, created_at, status, staff_id, image) VALUES (?, ?, GETDATE(), 1, ?,?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, post.getTitle());
            stmt.setString(2, post.getContent());
            stmt.setInt(3, post.getStaffId());
            stmt.setString(4, post.getImage());
            stmt.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting post", ex);
        }
    }

    @Override
    public void update(Post post) {
        String sql = "UPDATE Post SET title=?, content=?, updated_at=GETDATE(), status=?, staff_id=?, image=? WHERE id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, post.getTitle());
            stmt.setString(2, post.getContent());
            stmt.setBoolean(3, post.isStatus());
            stmt.setInt(4, post.getStaffId());
            stmt.setString(5, post.getImage());
            stmt.setInt(6, post.getId());
            stmt.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating post", ex);
        }
    }

    @Override
    public void delete(Post post) {
        String sql = "DELETE FROM Post WHERE id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, post.getId());
            stmt.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting post", ex);
        }
    }

    @Override
    public Post get(String id) {
        String sql = "SELECT p.*, s.fullname AS staff_name "
                + "FROM Post p "
                + "JOIN Staff s ON p.staff_id = s.id "
                + "WHERE p.id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(id));
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Post post = mapResultSetToPost(rs);
                post.setStaffName(rs.getString("staff_name"));
                post.setImage(rs.getString("image"));
                return post;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching post by ID", ex);
        }
        return null;
    }

    @Override
    public ArrayList<Post> list() {
        ArrayList<Post> posts = new ArrayList<>();
        String sql = "SELECT p.*, s.fullname AS staff_name "
                + "FROM Post p "
                + "JOIN Staff s ON p.staff_id = s.id"; // Thực hiện JOIN bảng Post và Staff để lấy tên nhân viên

        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Post post = mapResultSetToPost(rs);
                post.setStaffName(rs.getString("staff_name")); // Lấy tên nhân viên từ kết quả truy vấn
                posts.add(post);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching posts", ex);
        }
        return posts;
    }
}
