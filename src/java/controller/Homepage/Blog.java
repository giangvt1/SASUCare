/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.Homepage;

import dao.ContentDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import model.Content;

/**
 *
 * @author admin
 */
@WebServlet("/blog")
public class Blog extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy danh sách nội dung từ ContentDBContext
        ContentDBContext contentDBContext = new ContentDBContext();
        ArrayList<Content> contents = contentDBContext.list(); // Giả sử method list() trả về danh sách bài viết
        
        // Gắn dữ liệu vào request
        request.setAttribute("contents", contents);
        
        // Chuyển tiếp yêu cầu tới Blog.jsp mà không thay đổi URL trong thanh địa chỉ
        request.getRequestDispatcher("/Blog.jsp").forward(request, response);
    }
}

