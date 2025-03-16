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
    // Collections to manage sessions and user information
    private static final Set<Session> clients = Collections.synchronizedSet(new HashSet<>());
    private static final Map<String, Set<Session>> userSessions = Collections.synchronizedMap(new HashMap<>());
    private static final Map<String, UserInfo> onlineUsers = Collections.synchronizedMap(new HashMap<>());
    private static final Map<Session, UserInfo> onlineHRs = Collections.synchronizedMap(new HashMap<>());
    private static final Map<Session, UserInfo> onlineDoctors = Collections.synchronizedMap(new HashMap<>());
    private static final Map<Session, Session> userToHR = Collections.synchronizedMap(new HashMap<>());
    // New maps for doctor assignments
    private static final Map<String, String> assignedToDoctor = Collections.synchronizedMap(new HashMap<>()); // userEmail -> doctorEmail
    private static final Map<String, UserInfo> assignedUsers = Collections.synchronizedMap(new HashMap<>()); // userEmail -> UserInfo

    @OnOpen
    public void onOpen(Session session, EndpointConfig config) {
        clients.add(session);
        System.out.println("New session opened: " + session.getId());
    }

    @OnClose
    public void onClose(Session session) {
        clients.remove(session);
        onlineDoctors.remove(session);
        onlineHRs.remove(session);
        userToHR.remove(session);

        // Handle user disconnection
        String userEmail = null;
        for (Map.Entry<String, Set<Session>> entry : userSessions.entrySet()) {
            if (entry.getValue().contains(session)) {
                userEmail = entry.getKey();
                break;
            }
        }
        if (userEmail != null) {
            Set<Session> sessions = userSessions.get(userEmail);
            sessions.remove(session);
            if (sessions.isEmpty()) {
                userSessions.remove(userEmail);
                String doctorEmail = assignedToDoctor.get(userEmail);
                if (doctorEmail != null) {
                    // User was assigned to a doctor; notify doctor and clean up
                    assignedToDoctor.remove(userEmail);
                    assignedUsers.remove(userEmail);
                    notifyDoctorOfRemoval(doctorEmail, userEmail);
                } else {
                    onlineUsers.remove(userEmail);
                    // Gửi thông báo "clearChat" cho HR khi người dùng ngắt kết nối hoàn toàn
                    JSONObject clearChatMsg = new JSONObject();
                    clearChatMsg.put("action", "clearChat");
                    clearChatMsg.put("userEmail", userEmail);
                    broadcastToHRs(clearChatMsg);
                }
            }
        }
        broadcastOnlineUsers();
        broadcastOnlineDoctors();
    }

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
            case "exportChat":
                handleExportChat(json, session);
                break;
            case "assignDoctor":
                handleAssignDoctor(json, session);
                break;
            case "deleteUser":
                System.out.println("action deleteUser");
                handleDeleteUser(json, session);
                break;
            default:
                System.out.println("Unrecognized action: " + action);
        }
    }

    private void handleUserInfo(JSONObject json, Session session) {
        String email = json.getString("email");
        String fullName = json.getString("fullName");
        String role = json.getString("role");
        UserInfo user = new UserInfo(email, fullName, role);

        if ("HR".equals(role)) {
            onlineHRs.put(session, user);
        } else if ("Doctor".equals(role)) {
            onlineDoctors.put(session, user);
            // Send assigned users list to doctor upon connection
            sendAssignedUsersToDoctor(email, session);
        } else {
            userSessions.computeIfAbsent(email, k -> new HashSet<>()).add(session);
            // Chỉ thêm vào onlineUsers nếu email chưa tồn tại ở bất kỳ đâu
            if (!onlineUsers.containsKey(email) && !assignedToDoctor.containsKey(email)) {
                onlineUsers.put(email, user);
            }
            // Nếu email đã tồn tại, chỉ cập nhật danh sách phiên, không thêm mới
        }
        broadcastOnlineUsers();
        broadcastOnlineDoctors();
    }

    private void handleSendMessage(JSONObject json, Session session) {
        String msg = json.getString("message");
        String senderEmail = json.getString("email");

        UserInfo senderInfo = onlineHRs.get(session);
        if (senderInfo == null) {
            senderInfo = onlineDoctors.get(session);
        }

        if (senderInfo != null) {
            // HR or Doctor sending to user
            String receiverEmail = json.optString("receiverEmail");
            sendMessageToUser(receiverEmail, senderEmail, msg);
        } else {
            // User sending message
            String doctorEmail = assignedToDoctor.get(senderEmail);
            if (doctorEmail != null) {
                // Send to assigned doctor
                sendMessageToDoctor(doctorEmail, senderEmail, msg, session);
            } else {
                // Send to HR
                Session hrSession = userToHR.get(session);
                // Check if hrSession is null or closed
                if (hrSession == null || !hrSession.isOpen()) {
                    if (!onlineHRs.isEmpty()) {
                        // Assign a new HR from online HRs
                        hrSession = onlineHRs.keySet().iterator().next();
                        userToHR.put(session, hrSession);
                    } else {
                        hrSession = null;
                    }
                }
                if (hrSession != null && hrSession.isOpen()) {
                    sendMessage(hrSession, senderEmail, msg);
                } else {
                    sendError(session, "noHR", "No HR is currently online.");
                }
            }
        }
    }

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
        }
    }

    private void handleExportChat(JSONObject json, Session session) {
        if (onlineHRs.containsKey(session)) {
            String email = json.getString("email");
            String fullName = json.getString("fullName");
            String chatContent = json.getString("chatContent");
            exportToFile(email, fullName, chatContent, session);
        } else {
            sendError(session, "exportError", "Only HR can export chat history.");
        }
    }
    
    private void handleDeleteUser(JSONObject json, Session session) {
        String email = json.getString("email");
        System.out.println("email: delete: " + email);
        onlineUsers.remove(email);
        
        System.out.println("email account: " + onlineUsers.get(email));
        
        broadcastOnlineUsers();
    }

    private void exportToFile(String email, String fullName, String chatContent, Session session) {
        try {
            String fileName = "C:\\chat_logs\\chat_with_" + email.replaceAll("[^a-zA-Z0-9]", "_") + ".txt";
            File file = new File(fileName);
            file.getParentFile().mkdirs();
            try (FileWriter writer = new FileWriter(file)) {
                writer.write(chatContent);
            }
            sendSuccess(session, "exportSuccess", "Chat exported successfully to " + fileName);
        } catch (IOException e) {
            sendError(session, "exportError", "Failed to export chat: " + e.getMessage());
        }
    }

    private void handleAssignDoctor(JSONObject json, Session session) {
        if (!onlineHRs.containsKey(session)) {
            System.out.println("Non-HR tried to assign doctor.");
            return;
        }

        String doctorEmail = json.getString("doctor");
        String userEmail = json.getString("userEmail");

        // Validate doctor
        List<Session> doctorSessions = getDoctorSessions(doctorEmail);
        if (doctorSessions.isEmpty()) {
            sendError(session, "assignError", "Doctor not found or offline.");
            return;
        }

        // Validate user
        Set<Session> userSess = userSessions.get(userEmail);
        if (userSess == null || userSess.isEmpty()) {
            sendError(session, "assignError", "User not found or offline.");
            return;
        }

        // Perform assignment
        UserInfo userInfo = onlineUsers.get(userEmail);
        if (userInfo != null) {
            onlineUsers.remove(userEmail); // Remove from HR's view
            assignedUsers.put(userEmail, userInfo); // Store user info
            assignedToDoctor.put(userEmail, doctorEmail); // Track assignment

            // Notify HR
            sendSuccess(session, "assignSuccess", "User assigned to doctor.", userEmail, doctorEmail);

            // Notify doctor with updated list
            sendAssignedUserNotification(doctorSessions, userEmail, userInfo.getFullName());
            sendAssignedUsersToDoctor(doctorEmail, doctorSessions);

            // Notify user
            sendUserAssignmentNotification(userSess, doctorEmail);

            broadcastOnlineUsers();
        }
    }

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
        broadcastToHRs(json);
    }

    private void broadcastOnlineDoctors() {
        JSONObject json = new JSONObject();
        json.put("action", "updateOnlineDoctors");
        JSONArray doctorsArray = new JSONArray();
        for (UserInfo doctor : onlineDoctors.values()) {
            JSONObject doctorJson = new JSONObject();
            doctorJson.put("email", doctor.getEmail());
            doctorJson.put("fullName", doctor.getFullName());
            doctorsArray.put(doctorJson);
        }
        json.put("onlineDoctors", doctorsArray);
        broadcastToHRs(json);
    }

    // Helper methods
    private List<Session> getDoctorSessions(String doctorEmail) {
        List<Session> sessions = new ArrayList<>();
        for (Map.Entry<Session, UserInfo> entry : onlineDoctors.entrySet()) {
            if (entry.getValue().getEmail().equals(doctorEmail)) {
                sessions.add(entry.getKey());
            }
        }
        return sessions;
    }

    private void sendAssignedUserNotification(List<Session> doctorSessions, String userEmail, String fullName) {
        JSONObject notification = new JSONObject();
        notification.put("action", "assignedUser");
        notification.put("userEmail", userEmail);
        notification.put("fullName", fullName);
        for (Session docSession : doctorSessions) {
            if (docSession.isOpen()) {
                try {
                    docSession.getBasicRemote().sendText(notification.toString());
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private void sendAssignedUsersToDoctor(String doctorEmail, Session doctorSession) {
        List<Session> sessions = Collections.singletonList(doctorSession);
        sendAssignedUsersToDoctor(doctorEmail, sessions);
    }

    private void sendAssignedUsersToDoctor(String doctorEmail, List<Session> doctorSessions) {
        JSONArray usersArray = new JSONArray();
        for (Map.Entry<String, String> entry : assignedToDoctor.entrySet()) {
            if (entry.getValue().equals(doctorEmail)) {
                String userEmail = entry.getKey();
                UserInfo userInfo = assignedUsers.get(userEmail);
                if (userInfo != null) {
                    JSONObject userJson = new JSONObject();
                    userJson.put("email", userEmail);
                    userJson.put("fullName", userInfo.getFullName());
                    usersArray.put(userJson);
                }
            }
        }
        JSONObject json = new JSONObject();
        json.put("action", "updateAssignedUsers");
        json.put("assignedUsers", usersArray);
        for (Session docSession : doctorSessions) {
            if (docSession.isOpen()) {
                try {
                    docSession.getBasicRemote().sendText(json.toString());
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private void notifyDoctorOfRemoval(String doctorEmail, String userEmail) {
        List<Session> doctorSessions = getDoctorSessions(doctorEmail);
        JSONObject notification = new JSONObject();
        notification.put("action", "removeAssignedUser");
        notification.put("userEmail", userEmail);
        for (Session docSession : doctorSessions) {
            if (docSession.isOpen()) {
                try {
                    docSession.getBasicRemote().sendText(notification.toString());
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        sendAssignedUsersToDoctor(doctorEmail, doctorSessions);
    }

    private void sendUserAssignmentNotification(Set<Session> userSessions, String doctorEmail) {
        JSONObject notification = new JSONObject();
        notification.put("action", "assignedToDoctor");
        notification.put("doctorEmail", doctorEmail);
        for (Session userSession : userSessions) {
            if (userSession.isOpen()) {
                try {
                    userSession.getBasicRemote().sendText(notification.toString());
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private void sendMessageToUser(String receiverEmail, String senderEmail, String msg) {
        Set<Session> receiverSessions = userSessions.get(receiverEmail);
        if (receiverSessions != null) {
            JSONObject message = new JSONObject();
            message.put("action", "sendMessage");
            message.put("message", msg);
            message.put("senderEmail", senderEmail);
            for (Session userSession : receiverSessions) {
                if (userSession.isOpen()) {
                    try {
                        userSession.getBasicRemote().sendText(message.toString());
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }

    private void sendMessageToDoctor(String doctorEmail, String senderEmail, String msg, Session userSession) {
        List<Session> doctorSessions = getDoctorSessions(doctorEmail);
        if (!doctorSessions.isEmpty()) {
            JSONObject message = new JSONObject();
            message.put("action", "sendMessage");
            message.put("message", msg);
            message.put("senderEmail", senderEmail);
            for (Session docSession : doctorSessions) {
                if (docSession.isOpen()) {
                    try {
                        docSession.getBasicRemote().sendText(message.toString());
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        } else {
            sendError(userSession, "noDoctor", "Your assigned doctor is currently offline.");
        }
    }

    private void sendMessage(Session targetSession, String senderEmail, String msg) {
        JSONObject message = new JSONObject();
        message.put("action", "sendMessage");
        message.put("message", msg);
        message.put("senderEmail", senderEmail);
        try {
            targetSession.getBasicRemote().sendText(message.toString());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void sendError(Session session, String action, String message) {
        JSONObject error = new JSONObject();
        error.put("action", action);
        error.put("message", message);
        try {
            session.getBasicRemote().sendText(error.toString());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void sendSuccess(Session session, String action, String message) {
        JSONObject success = new JSONObject();
        success.put("action", action);
        success.put("message", message);
        try {
            session.getBasicRemote().sendText(success.toString());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void sendSuccess(Session session, String action, String message, String userEmail, String doctorEmail) {
        JSONObject success = new JSONObject();
        success.put("action", action);
        success.put("message", message);
        success.put("userEmail", userEmail);
        success.put("doctorEmail", doctorEmail);
        try {
            session.getBasicRemote().sendText(success.toString());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void broadcastToHRs(JSONObject json) {
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
    
    

    public static Map<String, UserInfo> getOnlineUsers() {
        return onlineUsers;
    }

    public static Map<Session, UserInfo> getOnlineDoctors() {
        return onlineDoctors;
    }
}