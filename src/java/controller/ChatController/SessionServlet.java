/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.ChatController;

// SessionServlet.java
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class SessionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Lấy HttpSession, nếu chưa có thì tạo mới
        HttpSession session = request.getSession(true);
        String sessionId = session.getId();
        
        System.out.println("session: " + sessionId);
        
        // Thiết lập kiểu dữ liệu trả về là text/plain
        response.setContentType("text/plain");
        response.getWriter().write(sessionId);
    }
}   
