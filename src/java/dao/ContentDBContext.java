/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import dal.DBContext;
import model.Content;

public class ContentDBContext extends DBContext<Content> {

    @Override
    public void insert(Content content) {
        String sql = "INSERT INTO blog_posts (title, content, image) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, content.getTitle());
            stmt.setString(2, content.getContent());
            stmt.setString(3, content.getImage());
            stmt.executeUpdate();
            System.out.println("✅ Nội dung đã được lưu vào database.");
        } catch (SQLException e) {
            System.out.println("❌ Lỗi khi lưu nội dung: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void update(Content content) {
        String sql = "UPDATE blog_posts SET title = ?, content = ?, image = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, content.getTitle());
            stmt.setString(2, content.getContent());
            stmt.setString(3, content.getImage());
            stmt.setInt(4, content.getId());
            stmt.executeUpdate();
            System.out.println("✅ Nội dung đã được cập nhật.");
        } catch (SQLException e) {
            System.out.println("❌ Lỗi khi cập nhật nội dung: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void delete(Content content) {
        String sql = "DELETE FROM blog_posts WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, content.getId());
            stmt.executeUpdate();
            System.out.println("✅ Nội dung đã được xoá.");
        } catch (SQLException e) {
            System.out.println("❌ Lỗi khi xoá nội dung: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public ArrayList<Content> list() {
        ArrayList<Content> contents = new ArrayList<>();
        String sql = "SELECT * FROM blog_posts";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            var resultSet = stmt.executeQuery();
            while (resultSet.next()) {
                Content content = new Content();
                content.setId(resultSet.getInt("id"));
                content.setTitle(resultSet.getString("title"));
                content.setContent(resultSet.getString("content"));
                content.setImage(resultSet.getString("image"));
                contents.add(content);
            }
            System.out.println("✅ Đã lấy danh sách nội dung từ database.");
        } catch (SQLException e) {
            System.out.println("❌ Lỗi khi lấy danh sách nội dung: " + e.getMessage());
            e.printStackTrace();
        }

        return contents;
    }

    @Override
    public Content get(String id) {
        return null; // Viết sau nếu cần lấy bài viết theo ID
    }
}
