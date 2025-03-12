package controller.ChatController;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import org.json.JSONArray;
import org.json.JSONObject;
import model.UserInfo;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.*;

@ServerEndpoint(value = "/chat")
public class ChatEndpoint {
    // Các tập hợp và map để quản lý sessions và thông tin người dùng
    private static final Set<Session> clients = Collections.synchronizedSet(new HashSet<>());
    private static final Map<String, Set<Session>> userSessions = Collections.synchronizedMap(new HashMap<>());
    private static final Map<String, UserInfo> onlineUsers = Collections.synchronizedMap(new HashMap<>());
    private static final Map<Session, UserInfo> onlineHRs = Collections.synchronizedMap(new HashMap<>());
    private static final Map<Session, UserInfo> onlineDoctors = Collections.synchronizedMap(new HashMap<>());
    private static final Map<Session, Session> userToHR = Collections.synchronizedMap(new HashMap<>());

    // Khi một kết nối WebSocket được mở
    @OnOpen
    public void onOpen(Session session, EndpointConfig config) {
        clients.add(session);
        System.out.println("New session opened: " + session.getId());
    }

    // Khi một kết nối WebSocket bị đóng
    @OnClose
    public void onClose(Session session) {
        clients.remove(session);
        // Xóa session khỏi userSessions và cập nhật trạng thái người dùng
        for (Set<Session> sessions : userSessions.values()) {
            sessions.remove(session);
        }
        onlineHRs.remove(session);
        userToHR.remove(session);
        updateOnlineUsers(); // Cập nhật danh sách người dùng trực tuyến
    }

    // Khi nhận được tin nhắn từ client
    @OnMessage
    public void onMessage(String message, Session session) {
        JSONObject json = new JSONObject(message);
        String action = json.optString("action");

        switch (action) {
            case "userInfo":
                handleUserInfo(json, session);
                break;
            case "sendMessage":
                handleSendMessage(json, session);
                break;
            case "deleteMessage":
                handleDeleteMessage(json, session);
                break;
            case "exportChat":  // Chức năng xuất lịch sử chat
                handleExportChat(json, session);
                break;
            default:
                System.out.println("Unrecognized action: " + action);
        }
    }

    // Xử lý thông tin người dùng khi họ kết nối
    private void handleUserInfo(JSONObject json, Session session) {
        String email = json.getString("email");
        String fullName = json.getString("fullName");
        String role = json.getString("role");
        UserInfo user = new UserInfo(email, fullName, role);

        if ("HR".equals(role)) {
            onlineHRs.put(session, user);
        } else if ("Doctor".equals(role)) {
            onlineDoctors.put(session, user);
        } else {
            // Thêm session vào tập hợp session của người dùng
            userSessions.computeIfAbsent(email, k -> new HashSet<>()).add(session);
            // Thêm vào danh sách người dùng trực tuyến nếu chưa có
            if (!onlineUsers.containsKey(email)) {
                onlineUsers.put(email, user);
            }
        }
        broadcastOnlineUsers(); // Gửi danh sách người dùng trực tuyến cập nhật
    }

    // Xử lý gửi tin nhắn
    private void handleSendMessage(JSONObject json, Session session) {
        String msg = json.getString("message");
        String senderEmail = json.getString("email");
        System.out.println("msg: " + msg);
        System.out.println("senderEmail: " + senderEmail);

        // Xác định thông tin người gửi
        UserInfo senderInfo = onlineUsers.get(senderEmail) != null ? onlineUsers.get(senderEmail)
                                                                   : onlineHRs.get(session);
        if (senderInfo != null && "HR".equals(senderInfo.getRole())) {
            // HR gửi tin nhắn đến người dùng
            String receiverEmail = json.optString("receiverEmail");
            Set<Session> receiverSessions = userSessions.get(receiverEmail);
            if (receiverSessions != null) {
                for (Session userSession : receiverSessions) {
                    if (userSession.isOpen()) {
                        try {
                            JSONObject messageToUser = new JSONObject();
                            messageToUser.put("action", "sendMessage");
                            messageToUser.put("message", msg);
                            messageToUser.put("senderEmail", senderEmail);
                            userSession.getBasicRemote().sendText(messageToUser.toString());
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        } else {
            // Người dùng gửi tin nhắn đến HR
            Session hrSession = userToHR.get(session);
            if (hrSession == null) {
                // Gán HR đầu tiên có sẵn nếu chưa có HR nào được gán
                if (!onlineHRs.isEmpty()) {
                    hrSession = onlineHRs.keySet().iterator().next();
                    userToHR.put(session, hrSession);
                    System.out.println("Assigned HR: " + hrSession.getId() + " to user: " + session.getId());
                } else {
                    try {
                        JSONObject noHRMessage = new JSONObject();
                        noHRMessage.put("action", "noHR");
                        noHRMessage.put("message", "No HR is currently online.");
                        session.getBasicRemote().sendText(noHRMessage.toString());
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    return;
                }
            }

            // Gửi tin nhắn đến HR được gán
            if (hrSession != null && hrSession.isOpen()) {
                try {
                    JSONObject messageToHR = new JSONObject();
                    messageToHR.put("action", "sendMessage");
                    messageToHR.put("message", msg);
                    messageToHR.put("senderEmail", senderEmail);
                    hrSession.getBasicRemote().sendText(messageToHR.toString());
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    // Xử lý xóa tin nhắn (chỉ HR được phép)
    private void handleDeleteMessage(JSONObject json, Session session) {
        if (onlineHRs.containsKey(session)) {
            String email = json.getString("email");
            Set<Session> sessions = userSessions.get(email);
            if (sessions != null) {
                for (Session userSession : new HashSet<>(sessions)) {
                    try {
                        userSession.close(new CloseReason(CloseReason.CloseCodes.NORMAL_CLOSURE, "Chat session ended by admin"));
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        } else {
            System.out.println("Non-HR tried to delete message.");
        }
    }

    // Xử lý xuất lịch sử chat ra file
    private void handleExportChat(JSONObject json, Session session) {
        if (onlineHRs.containsKey(session)) {
            String email = json.getString("email");
            String fullName = json.getString("fullName");
            String chatContent = json.getString("chatContent");
            System.out.println("chatContent: " + chatContent);
            exportToFile(email, fullName, chatContent, session);
        } else {
            System.out.println("Non-HR tried to export chat.");
            try {
                JSONObject errorMsg = new JSONObject();
                errorMsg.put("action", "exportError");
                errorMsg.put("message", "Only HR can export chat history.");
                session.getBasicRemote().sendText(errorMsg.toString());
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    // Ghi lịch sử chat ra file
    private void exportToFile(String email, String fullName, String chatContent, Session session) {
        try {
            String directoryPath = "C:\\chat_logs\\"; // Đường dẫn thư mục trên server
            String safeEmail = email.replaceAll("[^a-zA-Z0-9]", "_"); // Làm sạch email cho tên file
            String fileName = "chat_with_" + safeEmail + ".txt";
            File file = new File(directoryPath + fileName);

            // Tạo thư mục nếu chưa tồn tại
            file.getParentFile().mkdirs();

            FileWriter writer = new FileWriter(file);
            writer.write(chatContent);
            writer.close();
            System.out.println("Chat exported to " + file.getAbsolutePath());

            // Gửi thông báo thành công về client
            JSONObject successMsg = new JSONObject();
            successMsg.put("action", "exportSuccess");
            successMsg.put("message", "Chat exported successfully to " + fileName);
            session.getBasicRemote().sendText(successMsg.toString());
        } catch (IOException e) {
            e.printStackTrace();
            // Gửi thông báo lỗi về client
            try {
                JSONObject errorMsg = new JSONObject();
                errorMsg.put("action", "exportError");
                errorMsg.put("message", "Failed to export chat: " + e.getMessage());
                session.getBasicRemote().sendText(errorMsg.toString());
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }

    // Cập nhật danh sách người dùng trực tuyến
    private void updateOnlineUsers() {
        Iterator<String> iterator = onlineUsers.keySet().iterator();
        while (iterator.hasNext()) {
            String email = iterator.next();
            if (userSessions.containsKey(email) && userSessions.get(email).isEmpty()) {
                iterator.remove();
                userSessions.remove(email);
            }
        }
        broadcastOnlineUsers();
    }

    // Gửi danh sách người dùng trực tuyến đến tất cả HR
    private void broadcastOnlineUsers() {
        JSONObject json = new JSONObject();
        json.put("action", "updateOnlineUsers");
        JSONArray usersArray = new JSONArray();
        for (UserInfo user : onlineUsers.values()) {
            JSONObject userJson = new JSONObject();
            userJson.put("email", user.getEmail());
            userJson.put("fullName", user.getFullName());
            usersArray.put(userJson);
        }
        json.put("onlineUsers", usersArray);

        for (Session hrSession : onlineHRs.keySet()) {
            if (hrSession.isOpen()) {
                try {
                    hrSession.getBasicRemote().sendText(json.toString());
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    // Getter cho phép Servlet truy cập
    public static Map<String, UserInfo> getOnlineUsers() {
        return onlineUsers;
    }

    public static Map<Session, UserInfo> getOnlineDoctors() {
        return onlineDoctors;
    }
}