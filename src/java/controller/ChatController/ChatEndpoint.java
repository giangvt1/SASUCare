package controller.ChatController;

//import org.json.JSONObject;
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
    private static final Map<Session, String> userRoles = Collections.synchronizedMap(new HashMap<>());

    @OnOpen
    public void onOpen(Session session, EndpointConfig config) {
        HttpSession httpSession = (HttpSession) config.getUserProperties().get("httpSession");
        if (httpSession != null) {
            String role = (String) httpSession.getAttribute("userRoles");  
            if ("HR".equals(role)) {
                userRoles.put(session, "HR");
            } else {
                userRoles.put(session, "guest");
            }
        } else {
            userRoles.put(session, "guest");
        }
        clients.add(session);
    }

    @OnMessage
    public void onMessage(String message, Session senderSession) {
        if (message.trim().startsWith("{") && message.trim().endsWith("}")) {
//            JSONObject json = new JSONObject(message);
//            if ("setRole".equals(json.optString("action"))) {
//                String role = json.optString("role");
//                userRoles.put(senderSession, role);
//                return;
//            }
        } 

        String senderRole = userRoles.getOrDefault(senderSession, "guest");
        if ("guest".equals(senderRole)) {
            // Gửi tin nhắn của guest đến tất cả HR
            for (Session session : clients) {
                if ("HR".equals(userRoles.get(session)) && session.isOpen()) {
                    sendMessageToUser(session, message);
                }
            }
        } else if ("HR".equals(senderRole)) {
            // HR gửi tin nhắn, gửi lại cho tất cả guest
            for (Session session : clients) {
                if ("guest".equals(userRoles.get(session)) && session.isOpen()) {
                    sendMessageToUser(session, message);
                }
            }
        }
    }

    @OnClose
    public void onClose(Session session) {
        clients.remove(session);
        userRoles.remove(session);
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("WebSocket Error: " + throwable.getMessage());
    }
    
    private void sendMessageToUser(Session session, String message) {
        try {
            session.getBasicRemote().sendText(message);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
