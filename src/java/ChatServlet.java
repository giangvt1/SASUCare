import jakarta.websocket.OnClose;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import java.util.Collections;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/chat")
public class ChatServlet {
    private static Set<Session> userSessions = Collections.newSetFromMap(new ConcurrentHashMap<Session, Boolean>());

    @OnOpen
    public void onOpen(Session session) {
        userSessions.add(session);
    }

    @OnClose
    public void onClose(Session session){
        userSessions.remove(session);
    }

    @OnMessage
    public void onMessage(String message, Session session){
        // Nếu client gửi SET_NAME:<tên>, ta lưu tên này
        if(message.startsWith("SET_NAME:")){
            String userName = message.substring("SET_NAME:".length());
            session.getUserProperties().put("username", userName);
            return;
        }
        
        // Lấy tên từ session
        String userName = (String) session.getUserProperties().get("username");
        if(userName == null || userName.isEmpty()){
            // Nếu chưa đặt, gán mặc định theo ID của session
            userName = "Guest-" + session.getId();
        }

        // Tạo chuỗi gửi cho các client: "UserName: Nội dung"
        String fullMessage = userName + ": " + message;

        // Gửi tin nhắn cho tất cả session
        for(Session s : userSessions){
            s.getAsyncRemote().sendText(fullMessage);
        }
    }
}
