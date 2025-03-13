/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dal.DBContext;
import model.Post;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author admin
 */
public class PostDAO extends DBContext<Post> {
    private static final java.util.logging.Logger LOGGER = java.util.logging.Logger.getLogger(DBContext.class.getName());
    public List<Post> search(String keyword) {
        List<Post> posts = new ArrayList<>();
        String sql = "SELECT * FROM Post WHERE title LIKE ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                posts.add(mapResultSetToPost(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Error inserting rating", ex);
        }
        return posts;
    }

    public List<Post> filterByStatus(boolean status) {
        List<Post> posts = new ArrayList<>();
        String sql = "SELECT * FROM Post WHERE status=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setBoolean(1, status);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                posts.add(mapResultSetToPost(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Error inserting rating", ex);
        }
        return posts;
    }

    public List<Post> sortByTitle(boolean ascending) {
        List<Post> posts = new ArrayList<>();
        String sql = "SELECT * FROM Post ORDER BY title " + (ascending ? "ASC" : "DESC");
        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                posts.add(mapResultSetToPost(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Error inserting rating", ex);
        }
        return posts;
    }

    public List<Post> sortByDate(boolean ascending) {
        List<Post> posts = new ArrayList<>();
        String sql = "SELECT * FROM Post ORDER BY created_at " + (ascending ? "ASC" : "DESC");
        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                posts.add(mapResultSetToPost(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Error inserting rating", ex);
        }
        return posts;
    }

    private Post mapResultSetToPost(ResultSet rs) throws SQLException {
        return new Post(
                rs.getInt("id"),
                rs.getString("title"),
                rs.getString("content"),
                rs.getTimestamp("created_at"),
                rs.getTimestamp("updated_at"),
                rs.getString("manager_username"),
                rs.getBoolean("status")
        );
    }


    @Override
    public void insert(Post post) {
        String sql = "INSERT INTO Post (title, content, created_at, updated_at, manager_username, status) VALUES (?, ?, GETDATE(), GETDATE(), ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, post.getTitle());
            stmt.setString(2, post.getContent());
            stmt.setString(3, post.getManagerUsername());
            stmt.setBoolean(4, post.isStatus());
            stmt.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Error inserting rating", ex);
        }
    }

    @Override
    public void update(Post post) {
        String sql = "UPDATE Post SET title=?, content=?, updated_at=GETDATE(), status=? WHERE id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, post.getTitle());
            stmt.setString(2, post.getContent());
            stmt.setBoolean(3, post.isStatus());
            stmt.setInt(4, post.getId());
            stmt.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Error inserting rating", ex);
        }
    }

    @Override
    public void delete(Post post) {
        String sql = "DELETE FROM Post WHERE id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, post.getId());
            stmt.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Error inserting rating", ex);
        }
    }

    @Override
    public ArrayList<Post> list() {
         ArrayList<Post> posts = new ArrayList<>();
    String sql = "SELECT * FROM Post";
    try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
        while (rs.next()) {
            Post post = new Post(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getTimestamp("created_at"),
                    rs.getTimestamp("updated_at"),
                    rs.getString("manager_username"),
                    rs.getBoolean("status")
            );
            posts.add(post);
        }
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Error inserting rating", ex);
        }
        return posts;
    }

    @Override
    public Post get(String id) {
        String sql = "SELECT * FROM Post WHERE id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(id));
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Post(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at"),
                        rs.getString("manager_username"),
                        rs.getBoolean("status")
                );
            }
        } catch (SQLException ex) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Error inserting rating", ex);
        }
        return null;
    }
    public static void main(String[] args) {
        PostDAO postDAO = new PostDAO();

        // 1. Thêm dữ liệu mẫu
        Post newPost = new Post(0, "Bài viết test", "Nội dung test", null, null, "admin", true);
        postDAO.insert(newPost);
        System.out.println("Thêm bài đăng thành công!");

        // 2. Lấy danh sách bài đăng
        ArrayList<Post> posts = postDAO.list();
        System.out.println("Danh sách bài đăng:");
        for (Post post : posts) {
            System.out.println(post.getId() + " - " + post.getTitle() + " - " + post.getManagerUsername());
        }

        // 3. Cập nhật bài đăng đầu tiên
        if (!posts.isEmpty()) {
            Post updatePost = posts.get(0);
            updatePost.setTitle("Bài viết cập nhật");
            updatePost.setContent("Nội dung đã cập nhật");
            updatePost.setStatus(false);
            postDAO.update(updatePost);
            System.out.println("Cập nhật bài đăng thành công!");
        }

        // 4. Xóa bài đăng cuối cùng
        if (!posts.isEmpty()) {
            Post deletePost = posts.get(posts.size() - 1);
            postDAO.delete(deletePost);
            System.out.println("Xóa bài đăng thành công!");
        }
    }
}

