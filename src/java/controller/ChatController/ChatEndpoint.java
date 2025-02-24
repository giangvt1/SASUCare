/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.ChatController;

/**
 *
 * @author ngoch
 */
import org.json.JSONObject;
import jakarta.servlet.http.HttpSession;
import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

@ServerEndpoint(value = "/chat", configurator = ChatConfigurator.class)
public class ChatEndpoint {

    private static final Set<Session> clients = Collections.synchronizedSet(new HashSet<>());
    private static final Map<Session, String> userRoles = Collections.synchronizedMap(new HashMap<>()); // Lưu role của session
    private static final Map<Session, Session> chatPairs = Collections.synchronizedMap(new HashMap<>()); // Ghép user với staff

    @OnOpen
    public void onOpen(Session session, EndpointConfig config) {
        HttpSession httpSession = (HttpSession) config.getUserProperties().get("httpSession");
        if (httpSession != null) {
            String role = (String) httpSession.getAttribute("userRoles");  
            System.out.println("🔹 HttpSession found, role: " + role);

            if ("HR".equals(role)) {
                userRoles.put(session, "HR");
                System.out.println("🔵 HR Staff connected: " + session.getId());
            } else {
                userRoles.put(session, "guest");
                System.out.println("🟢 Guest connected: " + session.getId());
            }
        } else {
            userRoles.put(session, "guest");
            System.out.println("⚪ No HttpSession found, set as guest: " + session.getId());
        }
        clients.add(session);
        assignChat(session);
    }


    @OnMessage
    public void onMessage(String message, Session senderSession) {
        if (message.trim().startsWith("{") && message.trim().endsWith("}")) {
            JSONObject json = new JSONObject(message);
            if ("setRole".equals(json.optString("action"))) {
                String role = json.optString("role");
                userRoles.put(senderSession, role);
                System.out.println("🆔 Cập nhật role: " + role + " cho session " + senderSession.getId());
                return;
            }
        } 

        // Gửi tin nhắn đến người đối diện trong cặp chat
        Session receiverSession = chatPairs.get(senderSession);
        if (receiverSession != null && receiverSession.isOpen()) {
            sendMessageToUser(receiverSession, message);
        } else {
            sendMessageToUser(senderSession, "⚠️ Không có người nhận tin nhắn.");
        }
    }


    @OnClose
    public void onClose(Session session) {
        clients.remove(session);
        userRoles.remove(session);

        // Nếu session này đang trong một cặp chat
        Session pairedSession = chatPairs.remove(session);
        if (pairedSession != null) {
            chatPairs.remove(pairedSession); // Xóa luôn phía còn lại
            sendMessageToUser(pairedSession, "⚠️ HR đã ngắt kết nối. Đang tìm HR khác...");
            assignChat(pairedSession); // Tìm HR khác cho user này
        }

        System.out.println("🔴 Session closed: " + session.getId());
    }


    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("WebSocket Error: " + throwable.getMessage());
    }
    
    private void assignChat(Session userSession) {
    String role = userRoles.getOrDefault(userSession, "guest");

    // Nếu là guest và chưa có cặp
    if ("guest".equals(role) && !chatPairs.containsKey(userSession)) {
        for (Session staffSession : clients) {
            if ("HR".equals(userRoles.get(staffSession)) && !chatPairs.containsKey(staffSession) && staffSession.isOpen()) {
                // Ghép đôi guest với HR
                chatPairs.put(userSession, staffSession);
                chatPairs.put(staffSession, userSession);

                // Gửi thông báo
                sendMessageToUser(userSession, "✅ Bạn đã được kết nối với một HR.");
                sendMessageToUser(staffSession, "📢 Một khách hàng đã được gán cho bạn.");

                return; // Thoát khỏi vòng lặp khi đã ghép thành công
            }
        }

        // Nếu không tìm thấy HR nào rảnh
        sendMessageToUser(userSession, "⏳ Không có HR nào sẵn sàng. Vui lòng đợi...");
    }
}

    
    private void sendMessageToUser(Session session, String message) {
        try {
            session.getBasicRemote().sendText(message);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
