package controller.HRController;

import controller.ChatController.ChatEndpoint;
import controller.systemaccesscontrol.BaseRBACController;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.websocket.Session;
import model.UserInfo;

import java.io.IOException;
import java.util.Map;
import model.system.User;

@WebServlet("/chatbox")
public class ChatBoxController extends BaseRBACController {

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Map<Session, UserInfo> onlineDoctors = ChatEndpoint.getOnlineDoctors();
        session.setAttribute("onlineDoctors", onlineDoctors.values());
        System.out.println("onlineDoctors: " + onlineDoctors);
        request.getRequestDispatcher("./hr/chatbox.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
}