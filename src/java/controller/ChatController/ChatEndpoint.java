package controller.ChatController;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import org.json.JSONArray;
import org.json.JSONObject;
import model.UserInfo;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap; // Use ConcurrentHashMap for better thread safety

@ServerEndpoint(value = "/chat")
public class ChatEndpoint {
    // Collections to manage sessions and user information
    private static final Set<Session> clients = Collections.synchronizedSet(new HashSet<>());
    // Map user email to their active sessions
    private static final Map<String, Set<Session>> userSessions = Collections.synchronizedMap(new HashMap<>());
    // Map user email to their info (only if currently handled by HR / not assigned)
    private static final Map<String, UserInfo> onlineUsers = Collections.synchronizedMap(new HashMap<>());
    // Map HR session to their info
    private static final Map<Session, UserInfo> onlineHRs = Collections.synchronizedMap(new HashMap<>());
    // Map Doctor session to their info
    private static final Map<Session, UserInfo> onlineDoctors = Collections.synchronizedMap(new HashMap<>());
    // Map a specific USER session TO the specific HR session handling it (needs cleanup on HR disconnect)
    private static final Map<Session, Session> userToHR = Collections.synchronizedMap(new HashMap<>());
    // Map user email to the email of the doctor they are assigned to
    private static final Map<String, String> assignedToDoctor = Collections.synchronizedMap(new HashMap<>()); // userEmail -> doctorEmail
    // Map user email to their info (only if assigned to a doctor)
    private static final Map<String, UserInfo> assignedUsers = Collections.synchronizedMap(new HashMap<>()); // userEmail -> UserInfo

    // In-memory message store (Key: User's Email)
    private static final Map<String, List<JSONObject>> messageStore = new ConcurrentHashMap<>();

    // Timer for delayed user removal (when talking to HR and disconnecting)
    private static final Map<String, TimerTask> removalTimers = Collections.synchronizedMap(new HashMap<>());
    private static final Timer timer = new Timer(true); // Use daemon thread for timer
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    @OnOpen
    public void onOpen(Session session, EndpointConfig config) {
        clients.add(session);
        System.out.println("New session opened: " + session.getId() + ", Current clients: " + clients.size());
    }

    @OnClose
    public void onClose(Session session) {
        clients.remove(session);
        UserInfo hrInfo = onlineHRs.remove(session); // Attempt to remove as HR, get info if successful
        UserInfo docInfo = onlineDoctors.remove(session); // Attempt to remove as Doctor

        String userEmailToRemove = null;
        UserInfo userInfo = null; // User info of the disconnected entity (if it's a user)

        // Check if it was an HR
        if (hrInfo != null) {
            System.out.println("HR disconnected: " + hrInfo.getEmail() + " (Session: " + session.getId() + ")");

            // *** START: CRITICAL FIX FOR USER-TO-HR MAPPING ***
            // When an HR disconnects, remove all mappings pointing TO this HR session.
            synchronized (userToHR) { // Synchronize access to the map
                Iterator<Map.Entry<Session, Session>> iterator = userToHR.entrySet().iterator();
                int removedMappings = 0;
                while (iterator.hasNext()) {
                    Map.Entry<Session, Session> entry = iterator.next();
                    if (entry.getValue().equals(session)) { // Check if the VALUE (HR session) is the one that disconnected
                        Session userSession = entry.getKey();
                        iterator.remove(); // Remove the mapping
                        System.out.println("Removed stale user-to-HR mapping for user session " + userSession.getId() + " (was mapped to disconnected HR " + hrInfo.getEmail() + ")");
                        removedMappings++;
                        // Don't re-assign here, let the user's next message trigger it.
                    }
                }
                if (removedMappings > 0) {
                     System.out.println("Cleaned up " + removedMappings + " user-to-HR mappings for disconnected HR " + hrInfo.getEmail());
                }
            }
            // *** END: CRITICAL FIX ***

            // Notify remaining HRs about the current state of doctors and users
            broadcastToHRs(createOnlineDoctorsUpdate());
            broadcastToHRs(createOnlineUsersUpdate());

        } else if (docInfo != null) {
            // Doctor disconnected logic
            System.out.println("Doctor disconnected: " + docInfo.getEmail() + " (Session: " + session.getId() + ")");
            List<String> usersToUnassign = new ArrayList<>();
            // Clean up assignments pointing to this doctor
            synchronized (assignedToDoctor) {
                 // Find users assigned to this doctor
                 assignedToDoctor.forEach((userMail, docMail) -> {
                     if (docMail.equals(docInfo.getEmail())) {
                         usersToUnassign.add(userMail);
                     }
                 });

                 // Process unassignments
                 for (String userMail : usersToUnassign) {
                     assignedToDoctor.remove(userMail);
                     UserInfo uInfo = assignedUsers.remove(userMail); // Remove from doctor's assigned list
                     if (uInfo != null) {
                         // Check if the unassigned user is still online (has sessions)
                         boolean userStillOnline = false;
                         synchronized(userSessions){
                             userStillOnline = userSessions.containsKey(userMail) && !userSessions.get(userMail).isEmpty();
                         }

                         if (userStillOnline) {
                             onlineUsers.put(userMail, uInfo); // Put user back into the HR pool
                             System.out.println("User " + userMail + " unassigned from disconnected doctor " + docInfo.getEmail() + " and returned to HR pool.");
                             // Notify user they are back with HR? (Optional enhancement)
                             // notifyUserBackToHR(userMail, uInfo.getFullName());
                         } else {
                             System.out.println("User " + userMail + " was assigned to disconnected doctor " + docInfo.getEmail() + ", but user is also offline. Cleaned up assignment.");
                             // No need to put in onlineUsers if offline
                             // Consider if history needs removal or specific handling here
                         }
                     } else {
                          System.out.println("Warning: User " + userMail + " was in assignedToDoctor map for disconnected Dr " + docInfo.getEmail() + " but not found in assignedUsers map.");
                     }
                 }
                 if (!usersToUnassign.isEmpty()) {
                     System.out.println("Unassigned " + usersToUnassign.size() + " users from disconnected doctor " + docInfo.getEmail());
                 }
            } // End synchronized assignedToDoctor

            // Update HRs about doctor list change and potentially user list change
            broadcastToHRs(createOnlineDoctorsUpdate());
            broadcastToHRs(createOnlineUsersUpdate());

        } else {
            // It wasn't an HR or a Doctor, assume it's a regular user session closing
            Session userSessionToRemove = session; // The session that triggered onClose
            // Find which user this session belonged to
            synchronized(userSessions) { // Lock userSessions during iteration/modification
                Iterator<Map.Entry<String, Set<Session>>> userIter = userSessions.entrySet().iterator();
                while(userIter.hasNext()) {
                    Map.Entry<String, Set<Session>> entry = userIter.next();
                    if (entry.getValue().contains(userSessionToRemove)) {
                        userEmailToRemove = entry.getKey();
                        Set<Session> sessions = entry.getValue();
                        sessions.remove(userSessionToRemove); // Remove the specific session
                        System.out.println("User session removed: " + userSessionToRemove.getId() + " for user " + userEmailToRemove + ". Remaining sessions: " + sessions.size());

                        // Clean up the userToHR map for THIS specific closing user session
                        synchronized (userToHR) {
                             Session removedHrSession = userToHR.remove(userSessionToRemove); // Remove mapping *from* this user session
                             if (removedHrSession != null) {
                                System.out.println("Removed user-to-HR mapping for disconnecting user session " + userSessionToRemove.getId());
                             }
                        }

                        if (sessions.isEmpty()) {
                            // No more active sessions for this user - FULL disconnect
                            userIter.remove(); // Remove user entry completely from userSessions map
                            userInfo = onlineUsers.get(userEmailToRemove); // Get user info *before* removing from lists
                            if (userInfo == null) {
                                userInfo = assignedUsers.get(userEmailToRemove); // Maybe they were assigned?
                            }
                            System.out.println("All sessions closed for user: " + userEmailToRemove);

                            // Check if user was assigned to a doctor
                            String doctorEmail = assignedToDoctor.get(userEmailToRemove);
                            if (doctorEmail != null) {
                                // User was assigned, notify doctor and clean up assignment data immediately
                                System.out.println("Assigned user " + userEmailToRemove + " disconnected fully.");
                                assignedToDoctor.remove(userEmailToRemove);
                                assignedUsers.remove(userEmailToRemove); // Remove from doctor's list data
                                if(userInfo != null) {
                                    notifyDoctorOfRemoval(doctorEmail, userEmailToRemove, userInfo.getFullName());
                                } else {
                                    System.out.println("Could not find UserInfo for disconnected assigned user " + userEmailToRemove + " to notify doctor.");
                                    notifyDoctorOfRemoval(doctorEmail, userEmailToRemove, userEmailToRemove); // Fallback to email as name
                                }
                                // No broadcast needed here, notifyDoctorOfRemoval updates the specific doctor
                            } else {
                                // User was talking to HR (or waiting), schedule removal from HR list if they don't reconnect
                                System.out.println("Unassigned user " + userEmailToRemove + " disconnected fully. Scheduling removal from HR list.");
                                UserInfo infoForRemoval = userInfo != null ? userInfo : onlineUsers.get(userEmailToRemove); // Try one last time to get info
                                if (infoForRemoval != null) {
                                    scheduleUserRemoval(userEmailToRemove, infoForRemoval.getFullName());
                                } else {
                                    System.out.println("Could not find UserInfo for " + userEmailToRemove + " for scheduled removal notification.");
                                    scheduleUserRemoval(userEmailToRemove, userEmailToRemove); // Use email as fallback name
                                }
                                // scheduleUserRemoval will handle broadcasting the list update to HRs via clearChat action
                            }
                        }
                        break; // Found the user, exit loop
                    }
                } // End while loop userSessions
            } // End synchronized userSessions
        } // End else (user disconnect)

        System.out.println("Session closed: " + session.getId() + ". Total clients: " + clients.size());
    }

    // Helper method to create the JSON update message for online users (for HRs)
    private JSONObject createOnlineUsersUpdate() {
        JSONObject json = new JSONObject();
        json.put("action", "updateOnlineUsers");
        JSONArray usersArray = new JSONArray();
        synchronized(onlineUsers) { // Synchronize iteration over onlineUsers map
            // Create a temporary list from values to avoid holding lock too long if toJson is slow
             List<UserInfo> currentUsers = new ArrayList<>(onlineUsers.values());
             for (UserInfo user : currentUsers) {
                 // Double check if user really has sessions before broadcasting
                 boolean hasSession = false;
                 synchronized (userSessions) { // Need to lock userSessions to check safely
                     hasSession = userSessions.containsKey(user.getEmail()) && !userSessions.get(user.getEmail()).isEmpty();
                 }
                 if (hasSession) {
                      usersArray.put(user.toJson());
                 } else {
                      // Cleanup inconsistency found during broadcast prep
                      // Check again before removing, maybe session was added back?
                     synchronized (userSessions) {
                         hasSession = userSessions.containsKey(user.getEmail()) && !userSessions.get(user.getEmail()).isEmpty();
                     }
                     if (!hasSession) {
                         onlineUsers.remove(user.getEmail()); // Remove inconsistent entry
                         System.out.println("Cleaned up inconsistent state during broadcast prep: Removed " + user.getEmail() + " from onlineUsers (no sessions).");
                     } else {
                          usersArray.put(user.toJson()); // Reconnected just in time
                     }
                 }
            }
        }
        json.put("onlineUsers", usersArray);
        // System.out.println("Prepared online users update for HRs. Count: " + usersArray.length()); // Reduce log noise
        return json;
    }

     // Helper method to create the JSON update message for online doctors (for HRs)
    private JSONObject createOnlineDoctorsUpdate() {
        JSONObject json = new JSONObject();
        json.put("action", "updateOnlineDoctors");
        JSONArray doctorsArray = new JSONArray();
         synchronized (onlineDoctors){ // Synchronize iteration over onlineDoctors map
             // Create a temporary list from values
             List<UserInfo> currentDoctors = new ArrayList<>(onlineDoctors.values());
            for (UserInfo doctor : currentDoctors) {
                doctorsArray.put(doctor.toJson());
            }
         }
        json.put("onlineDoctors", doctorsArray);
        // System.out.println("Prepared online doctors update for HRs. Count: " + doctorsArray.length()); // Reduce log noise
        return json;
    }

    // Modified scheduleUserRemoval to pass user info
    private void scheduleUserRemoval(String userEmail, String userFullName) {
        // Cancel any existing timer for this user
        TimerTask existingTask = removalTimers.remove(userEmail);
        if (existingTask != null) {
            existingTask.cancel();
            System.out.println("Cancelled previous removal timer for user: " + userEmail);
        }

        System.out.println("Scheduling removal notification for user: " + userEmail + " in 10 seconds.");
        TimerTask removalTask = new TimerTask() {
            @Override
            public void run() {
                boolean actuallyRemoved = false;
                synchronized (userSessions) { // Synchronize on userSessions for the check
                    // Double-check: Only remove from HR list if user hasn't reconnected
                    if (!userSessions.containsKey(userEmail) || userSessions.get(userEmail).isEmpty()) {
                        System.out.println("Executing delayed removal notification for user: " + userEmail);
                        // Remove from HR's online list map
                        synchronized(onlineUsers){ // Synchronize the removal
                            if (onlineUsers.containsKey(userEmail)) {
                                onlineUsers.remove(userEmail);
                                actuallyRemoved = true;
                            }
                        }

                        if (actuallyRemoved) {
                             // Notify HRs to remove the user from their UI and clear chat history reference
                            JSONObject clearChatMsg = new JSONObject();
                            clearChatMsg.put("action", "clearChat");
                            clearChatMsg.put("userEmail", userEmail);
                            clearChatMsg.put("fullName", userFullName); // Include name for context
                            broadcastToHRs(clearChatMsg); // This implicitly updates HR user lists
                            System.out.println("Broadcasted clearChat (removal notification) for " + userEmail + " to HRs.");
                        } else {
                            System.out.println("User " + userEmail + " was not in onlineUsers map during scheduled removal.");
                        }
                        // Decide if you want to remove history on disconnect delay
                        // messageStore.remove(userEmail);
                        // System.out.println("Removed message history for disconnected user: " + userEmail);

                    } else {
                        System.out.println("Removal notification cancelled for user " + userEmail + " as they reconnected.");
                    }
                } // End synchronized userSessions
                removalTimers.remove(userEmail); // Clean up timer entry itself
            }
        };
        removalTimers.put(userEmail, removalTask);
        timer.schedule(removalTask, 10000); // 10-second delay
    }


    @OnMessage
    public void onMessage(String message, Session session) {
        try {
            JSONObject json = new JSONObject(message);
            String action = json.optString("action");
            // System.out.println("Received action: " + action + " from session " + session.getId()); // Reduce log noise

            switch (action) {
                case "userInfo":
                    handleUserInfo(json, session);
                    break;
                case "sendMessage":
                    handleSendMessage(json, session);
                    break;
                case "deleteMessage": // This seems to be used for closing user session by HR
                    handleDeleteUserSession(json, session); // Renamed for clarity
                    break;
                case "exportChat":
                    handleExportChat(json, session);
                    break;
                case "assignDoctor":
                    handleAssignDoctor(json, session);
                    break;
                case "getChatHistory":
                    handleGetChatHistory(json, session);
                    break;
                default:
                    System.out.println("Unrecognized action: " + action);
            }
        } catch (Exception e) {
            System.err.println("Error processing message: " + message + " from session " + session.getId());
            e.printStackTrace();
            sendError(session, "processingError", "Error processing message: " + e.getMessage());
        }
    }

    private void handleUserInfo(JSONObject json, Session session) {
        String email = json.getString("email");
        String fullName = json.getString("fullName");
        String role = json.getString("role");
        UserInfo user = new UserInfo(email, fullName, role);

        // Cancel removal timer if user reconnects
        TimerTask pendingTask = removalTimers.remove(email);
        if (pendingTask != null) {
            pendingTask.cancel();
            System.out.println("User reconnected, cancelled removal timer: " + email);
        }

        if ("HR".equals(role)) {
            onlineHRs.put(session, user);
            System.out.println("HR connected: " + email + " (Session: " + session.getId() + ")");
            // Send current lists to the newly connected HR
            sendMessageInternal(session, createOnlineUsersUpdate());
            sendMessageInternal(session, createOnlineDoctorsUpdate());
             // Notify OTHER HRs? Not strictly necessary unless count matters.
             // broadcastOnlineDoctors(); // Maybe needed if HR count display exists
        } else if ("Doctor".equals(role)) {
            onlineDoctors.put(session, user);
            System.out.println("Doctor connected: " + email + " (Session: " + session.getId() + ")");
            sendAssignedUsersToDoctor(email, session); // Send assigned users list to this doctor upon connection
            broadcastToHRs(createOnlineDoctorsUpdate()); // Update HRs about doctor status
        } else {
            // Regular User
            synchronized(userSessions){ // Ensure atomic add to set
                userSessions.computeIfAbsent(email, k -> Collections.synchronizedSet(new HashSet<>())).add(session);
            }
            System.out.println("User session added: " + session.getId() + " for user " + email);

            boolean isAssigned;
            synchronized(assignedToDoctor){
                isAssigned = assignedToDoctor.containsKey(email);
            }

            if (!isAssigned) {
                // Add or update user info in the HR pool list
                onlineUsers.put(email, user);
                System.out.println("User added/updated in onlineUsers (HR pool): " + email);
                broadcastOnlineUsers(); // Notify HRs of new/reconnected user
            } else {
                 System.out.println("User " + email + " reconnected but is already assigned to a doctor. Not adding to HR pool.");
                 String doctorEmail;
                 synchronized(assignedToDoctor){
                     doctorEmail = assignedToDoctor.get(email);
                 }
                 if (doctorEmail != null) {
                    notifyDoctorUserReconnected(doctorEmail, email);
                    // Also update the user's online status in the doctor's list
                    sendAssignedUsersToDoctor(doctorEmail, getDoctorSessions(doctorEmail)); // Update full list for doctor
                 }
             }
        }
    }


     private void notifyDoctorUserReconnected(String doctorEmail, String userEmail) {
        List<Session> doctorSessions = getDoctorSessions(doctorEmail);
        if (!doctorSessions.isEmpty()) {
            JSONObject notification = new JSONObject();
            notification.put("action", "userReconnected");
            notification.put("userEmail", userEmail);
            System.out.println("Notifying doctor " + doctorEmail + " about user " + userEmail + " reconnection.");
            for (Session docSession : doctorSessions) {
                sendMessageInternal(docSession, notification);
            }
        } else {
             System.out.println("Could not notify doctor " + doctorEmail + " of user " + userEmail + " reconnect: Doctor offline?");
        }
    }


    private void handleSendMessage(JSONObject json, Session session) {
        String msgContent = json.getString("message");
        String senderEmail = json.getString("email");
        String senderFullName = json.getString("fullName"); // Get sender full name
        String receiverEmail = json.optString("receiverEmail", null); // Client might specify receiver (e.g., specific user from HR/Doc)
        String timestamp = DATE_FORMAT.format(new Date());

        UserInfo senderInfo = onlineHRs.get(session); // Is sender HR?
        if (senderInfo == null) {
            senderInfo = onlineDoctors.get(session); // Is sender Doctor?
        }

        String conversationKeyEmail; // The user's email will be the key for storing history
        boolean isAdminSender = (senderInfo != null); // HR or Doctor

        JSONObject messageObject = new JSONObject();
        messageObject.put("action", "sendMessage"); // Ensure action is present for client handling
        messageObject.put("message", msgContent);
        messageObject.put("senderEmail", senderEmail);
        messageObject.put("senderFullName", senderFullName); // Include sender name
        messageObject.put("timestamp", timestamp); // Include timestamp

        if (isAdminSender) {
            // Admin (HR or Doctor) sending to a User
            if (receiverEmail == null || receiverEmail.isEmpty()) {
                System.err.println("Admin " + senderEmail + " sending message without receiverEmail!");
                sendError(session, "sendError", "Receiver email missing.");
                return;
            }
            conversationKeyEmail = receiverEmail; // History stored under user's email
            messageObject.put("receiverEmail", receiverEmail);
            // Relay message to the target user's sessions
            sendMessageToUser(receiverEmail, senderEmail, senderFullName, msgContent, timestamp, messageObject); // Pass full object
            System.out.println("Admin " + senderEmail + " sent message to user " + receiverEmail);

        } else {
            // User sending message
            conversationKeyEmail = senderEmail; // User's email is the key for history
            messageObject.put("receiverEmail", "Support"); // Placeholder, will be replaced

            // Determine receiver (Assigned Doctor or HR)
            String assignedDoctorEmail;
            synchronized(assignedToDoctor){
                 assignedDoctorEmail = assignedToDoctor.get(senderEmail);
            }

            if (assignedDoctorEmail != null) {
                // Send to assigned doctor
                messageObject.put("receiverEmail", assignedDoctorEmail);
                sendMessageToDoctor(assignedDoctorEmail, senderEmail, senderFullName, msgContent, timestamp, messageObject);
                 System.out.println("User " + senderEmail + " sent message to assigned Dr. " + assignedDoctorEmail);
            } else {
                // Send to an available HR
                Session hrSession = null;
                UserInfo hrInfo = null;
                boolean hrFound = false;

                 // 1. Check if already mapped to an active HR session
                synchronized (userToHR) { // Lock map during check and potential assignment
                    Session mappedHrSession = userToHR.get(session);
                    if (mappedHrSession != null && mappedHrSession.isOpen()) {
                         // Verify the mapped HR is still in the onlineHRs list
                        synchronized(onlineHRs){
                            hrInfo = onlineHRs.get(mappedHrSession);
                        }
                        if (hrInfo != null) {
                            hrSession = mappedHrSession;
                            hrFound = true;
                            System.out.println("User " + senderEmail + " (session " + session.getId() + ") sending to previously mapped HR " + hrInfo.getEmail());
                        } else {
                            // Mapped HR session exists but HR is not in onlineHRs map anymore (should have been cleaned by onClose)
                            System.out.println("User " + senderEmail + " had stale mapping to session " + mappedHrSession.getId() + ". Removing mapping.");
                            userToHR.remove(session); // Clean up stale mapping
                        }
                    }

                    // 2. If no valid mapping, find a new HR (simple round-robin/first available)
                    if (!hrFound) {
                        synchronized(onlineHRs){ // Lock HR map while iterating/selecting
                             if (!onlineHRs.isEmpty()) {
                                 // Simple first-available strategy
                                 Map.Entry<Session, UserInfo> entry = onlineHRs.entrySet().iterator().next();
                                 hrSession = entry.getKey();
                                 hrInfo = entry.getValue();
                                 userToHR.put(session, hrSession); // Assign this HR to the user's session
                                 hrFound = true;
                                 System.out.println("Assigning user " + senderEmail + " (session " + session.getId() + ") to HR " + hrInfo.getEmail() + " (Session: " + hrSession.getId() + ")");
                             }
                        }
                    }
                } // End synchronized userToHR

                // 3. Send message or handle no HR available
                if (hrFound && hrSession != null && hrInfo != null) {
                    messageObject.put("receiverEmail", hrInfo.getEmail()); // Set actual HR email
                    sendMessageToAdmin(hrSession, senderEmail, senderFullName, msgContent, timestamp, messageObject);
                    System.out.println("User " + senderEmail + " sent message to HR " + hrInfo.getEmail());
                } else {
                    // No HR online
                    sendError(session, "noSupportAvailable", "No support staff is currently available. Please try again later.");
                    System.out.println("No HR online to receive message from " + senderEmail + " (session " + session.getId() + ")");
                    // Store message even if no HR is online? Yes, store it.
                    conversationKeyEmail = senderEmail; // Ensure key is set for storage
                    // Don't set receiverEmail in stored object if no HR found? Or set to "Pending"?
                    messageObject.remove("receiverEmail"); // Remove placeholder
                    messageObject.put("status", "pending_hr"); // Indicate it needs routing
                }
            }
        }

        // --- Store the message ---
        if (conversationKeyEmail != null && !conversationKeyEmail.isEmpty()) {
            // Add the fully constructed message object (including receiver if known)
             messageStore.computeIfAbsent(conversationKeyEmail, k -> Collections.synchronizedList(new ArrayList<>())).add(messageObject);
            // System.out.println("Message stored for conversation key: " + conversationKeyEmail); // Reduce log noise
        } else {
             System.err.println("Could not determine conversation key to store message: " + messageObject.toString());
        }
    }


    // Renamed from handleDeleteMessage for clarity - Used by HR to close a user's chat forcefully
    private void handleDeleteUserSession(JSONObject json, Session session) {
        UserInfo requestingHrInfo = onlineHRs.get(session);
        if (requestingHrInfo == null) {
             sendError(session, "unauthorized", "Only HR can perform this action.");
             return;
        }

        String userEmailToClose = json.getString("email");
        System.out.println("HR " + requestingHrInfo.getEmail() + " requested to close session(s) for user: " + userEmailToClose);

        Set<Session> userSessSet = null;
        synchronized(userSessions){
             // Get a copy of the set to avoid issues if it changes during iteration
             if(userSessions.containsKey(userEmailToClose)){
                 userSessSet = new HashSet<>(userSessions.get(userEmailToClose));
             }
        }

        if (userSessSet != null && !userSessSet.isEmpty()) {
             System.out.println("Found " + userSessSet.size() + " active session(s) for user " + userEmailToClose + ". Closing them.");
             for (Session userSession : userSessSet) {
                 try {
                     // Notify user before closing
                     JSONObject closeNotification = new JSONObject();
                     closeNotification.put("action", "forceClose");
                     closeNotification.put("reason", "Your chat session was ended by an administrator.");
                     // Use sendMessageInternal for robust sending
                     sendMessageInternal(userSession, closeNotification);

                     // Close the session (this will trigger onClose for the user session)
                     userSession.close(new CloseReason(CloseReason.CloseCodes.NORMAL_CLOSURE, "Chat session ended by admin"));
                     System.out.println("Requested close for session " + userSession.getId() + " for user " + userEmailToClose);
                 } catch (IOException e) {
                     System.err.println("Error closing session " + userSession.getId() + " for user " + userEmailToClose + ": " + e.getMessage());
                     // onClose should still handle cleanup even if close fails here
                 } catch (Exception e) {
                     System.err.println("Unexpected error during force close of session " + userSession.getId() + ": " + e.getMessage());
                 }
             }
             // onClose method handles the actual removal from maps and broadcasting updates.
             // Optionally notify the HR requester that the action was initiated.
             sendSuccess(session, "sessionCloseInitiated", "Close request sent to session(s) for " + userEmailToClose + ".");

        } else {
             System.out.println("No active sessions found for user: " + userEmailToClose + ". Checking if listed as online.");
              // If user has no sessions but is still in onlineUsers (e.g., disconnected before timer)
              UserInfo removedUserInfo = null;
              synchronized(onlineUsers){
                   removedUserInfo = onlineUsers.remove(userEmailToClose);
              }
             if(removedUserInfo != null){
                  broadcastOnlineUsers(); // Update HR list
                  System.out.println("Removed offline user " + userEmailToClose + " from online list by HR request.");
                  sendSuccess(session, "userRemoved", "User " + userEmailToClose + " was offline but removed from the waiting list.");
                   // Consider removing message history here too?
                   // messageStore.remove(userEmailToClose);
             } else {
                  // Also check if user was assigned but offline
                  boolean wasAssigned = false;
                  synchronized(assignedToDoctor){ wasAssigned = assignedToDoctor.containsKey(userEmailToClose); }
                  if (wasAssigned) {
                       sendError(session, "sessionCloseError", "User " + userEmailToClose + " is assigned to a doctor. Unassign first or contact the doctor.");
                  } else {
                       sendError(session, "sessionCloseError", "User " + userEmailToClose + " not found or already offline.");
                  }
             }
        }
    }

    private void handleExportChat(JSONObject json, Session session) {
        // Allow HR or the assigned Doctor to export
        UserInfo adminInfo = onlineHRs.get(session);
        boolean isDoctor = false;
        String adminEmail = null;

        if (adminInfo != null) {
            adminEmail = adminInfo.getEmail();
        } else {
            adminInfo = onlineDoctors.get(session);
            if (adminInfo != null) {
                isDoctor = true;
                adminEmail = adminInfo.getEmail();
            }
        }

        if (adminInfo == null) {
            sendError(session, "exportError", "Only HR or assigned Doctors can export chat history.");
            return;
        }

        String userEmail = json.getString("email");
        String userFullName = json.optString("fullName", userEmail); // Use email if name not provided

        // Security check: If Doctor, ensure they are assigned to this user
        if (isDoctor) {
            String assignedDocEmail;
            synchronized(assignedToDoctor){
                assignedDocEmail = assignedToDoctor.get(userEmail);
            }
             if (!adminEmail.equals(assignedDocEmail)) {
                sendError(session, "exportError", "You are not assigned to this user to export their chat.");
                System.out.println("Doctor " + adminEmail + " attempted to export chat for unassigned/different user " + userEmail);
                return;
            }
        }

        // Retrieve history safely from ConcurrentHashMap
        List<JSONObject> history = messageStore.getOrDefault(userEmail, Collections.emptyList());

        if (history.isEmpty()) {
            sendError(session, "exportError", "No chat history found for " + userEmail);
            return;
        }

        // --- Format chat content ---
        StringBuilder chatContent = new StringBuilder();
        chatContent.append("Chat history with: ").append(userFullName).append(" (").append(userEmail).append(")\n");
        chatContent.append("Exported by: ").append(adminInfo.getFullName()).append(" (").append(adminEmail).append(") on ").append(DATE_FORMAT.format(new Date())).append("\n");
        chatContent.append("============================================\n\n");

        // Iterate over a copy of the list for safety, although the list itself is synchronized externally
        List<JSONObject> historyCopy;
        synchronized (history) { // Lock the specific list while copying
            historyCopy = new ArrayList<>(history);
        }

        for (JSONObject msg : historyCopy) {
            chatContent.append("[")
                       .append(msg.optString("timestamp", "No Timestamp"))
                       .append("] ")
                       .append(msg.optString("senderFullName", msg.optString("senderEmail"))) // Use FullName if available
                       .append(": ")
                       .append(msg.optString("message"))
                       .append("\n");
        }

        exportToFile(userEmail, userFullName, chatContent.toString(), session);
    }

    private void exportToFile(String email, String fullName, String chatContent, Session session) {
        try {
             // Consider making the path configurable via system property or config file
             String logDirPath = System.getProperty("chat.log.dir", "chat_logs"); // Default to relative "chat_logs"
             File logDir = new File(logDirPath);

             if (!logDir.exists()) {
                 System.out.println("Chat log directory not found, attempting to create: " + logDir.getAbsolutePath());
                 if (!logDir.mkdirs()) {
                     System.err.println("Failed to create chat log directory: " + logDir.getAbsolutePath());
                     sendError(session, "exportError", "Server configuration error: Failed to create log directory.");
                     return;
                 }
                 System.out.println("Created chat log directory: " + logDir.getAbsolutePath());
             } else if (!logDir.isDirectory()) {
                  System.err.println("Chat log path exists but is not a directory: " + logDir.getAbsolutePath());
                  sendError(session, "exportError", "Server configuration error: Log path is not a directory.");
                  return;
             } else if (!logDir.canWrite()) {
                  System.err.println("Cannot write to chat log directory: " + logDir.getAbsolutePath());
                  sendError(session, "exportError", "Server configuration error: Cannot write to log directory.");
                  return;
             }

            // Sanitize file name components
            String safeEmail = email.replaceAll("[^a-zA-Z0-9.\\-@_]", "_");
            String safeFullName = fullName.replaceAll("[^a-zA-Z0-9_]", "_");
            String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
            // Ensure filename isn't excessively long
            safeEmail = safeEmail.length() > 50 ? safeEmail.substring(0, 50) : safeEmail;
            safeFullName = safeFullName.length() > 50 ? safeFullName.substring(0, 50) : safeFullName;

            String fileName = "chat_" + safeFullName + "_" + safeEmail + "_" + timestamp + ".txt";
            File file = new File(logDir, fileName);

            try (FileWriter writer = new FileWriter(file)) {
                writer.write(chatContent);
            }
            System.out.println("Chat exported successfully to: " + file.getAbsolutePath());
            // Send only filename back to client for security
            sendSuccess(session, "exportSuccess", "Chat exported successfully to file: " + file.getName());

        } catch (IOException e) {
            System.err.println("Failed to export chat for " + email + ": " + e.getMessage());
            e.printStackTrace();
            sendError(session, "exportError", "Failed to write chat export file: " + e.getMessage());
        } catch (SecurityException se) {
             System.err.println("Security exception accessing chat log directory: " + se.getMessage());
             se.printStackTrace();
             sendError(session, "exportError", "Permission denied writing chat log file.");
        } catch (Exception e) {
             System.err.println("Unexpected error during chat export for " + email + ": " + e.getMessage());
             e.printStackTrace();
             sendError(session, "exportError", "An unexpected error occurred during export.");
        }
    }


   private void handleAssignDoctor(JSONObject json, Session session) {
        // Ensure requester is HR
        UserInfo hrInfo = onlineHRs.get(session);
        if (hrInfo == null) {
            sendError(session, "assignError", "Only HR can assign users to doctors.");
            System.out.println("Non-HR (Session " + session.getId() + ") tried to assign doctor.");
            return;
        }

        String doctorEmail = json.getString("doctor"); // Doctor's email
        String userEmail = json.getString("userEmail"); // User's email

        System.out.println("HR " + hrInfo.getEmail() + " attempting to assign user " + userEmail + " to doctor " + doctorEmail);

        // Validate doctor is online
        List<Session> doctorSessions = getDoctorSessions(doctorEmail);
        if (doctorSessions.isEmpty()) {
            sendError(session, "assignError", "Doctor " + doctorEmail + " not found or is offline.");
            System.out.println("Assign failed: Doctor " + doctorEmail + " not found/offline.");
            return;
        }
        // Get Doctor's Info (assuming first session is representative)
        UserInfo doctorInfo = onlineDoctors.get(doctorSessions.get(0));
        if (doctorInfo == null) {
              sendError(session, "assignError", "Could not retrieve doctor's information.");
              System.out.println("Assign failed: Could not find doctor info for " + doctorEmail);
              return;
        }

        // Validate user exists in onlineUsers (meaning they are currently with HR and not already assigned)
        UserInfo userInfo = null;
        synchronized(onlineUsers){ // Lock onlineUsers during check and potential removal
            userInfo = onlineUsers.get(userEmail);
            if (userInfo != null) {
                 // --- Perform assignment ---
                onlineUsers.remove(userEmail); // Remove from HR's general pool *inside lock*
                assignedUsers.put(userEmail, userInfo); // Add to doctor's potential pool
                assignedToDoctor.put(userEmail, doctorEmail); // Track the assignment
                 System.out.println("Assignment successful: User " + userEmail + " assigned to Doctor " + doctorEmail);
            }
        } // End synchronized onlineUsers

        if (userInfo == null) {
            // User wasn't in the HR pool. Check if already assigned or offline.
            String currentAssignment;
            synchronized(assignedToDoctor){ currentAssignment = assignedToDoctor.get(userEmail); }

            if (currentAssignment != null) {
                 sendError(session, "assignError", "User " + userEmail + " is already assigned to Dr. " + getDoctorFullName(currentAssignment) + ".");
            } else {
                 // Check if user is online at all (maybe connected but race condition?)
                 boolean isUserOnline = false;
                 synchronized(userSessions) { isUserOnline = userSessions.containsKey(userEmail); }
                 if (!isUserOnline) {
                     sendError(session, "assignError", "User " + userEmail + " is currently offline.");
                 } else {
                     // Should not happen if logic is correct, user is online but not in onlineUsers and not assigned
                     sendError(session, "assignError", "User " + userEmail + " state is inconsistent. Cannot assign.");
                     System.err.println("Inconsistent state: User " + userEmail + " online but not in onlineUsers and not assigned.");
                 }
            }
            System.out.println("Assign failed: User " + userEmail + " not found in HR pool or is offline/already assigned.");
            return; // Stop assignment process
        }

        // --- Notifications (only if assignment was successful) ---

        // Notify HR (original requester)
        sendAssignSuccess(session, userEmail, userInfo.getFullName(), doctorEmail, doctorInfo.getFullName());

        // Notify the specific Doctor they have a new user & update their list
        notifyDoctorOfNewAssignment(doctorSessions, userInfo);
        sendAssignedUsersToDoctor(doctorEmail, doctorSessions); // Send updated list to all doctor sessions

        // Notify the User they have been assigned
        Set<Session> userSess = null;
        synchronized(userSessions){
             if (userSessions.containsKey(userEmail)) {
                 userSess = new HashSet<>(userSessions.get(userEmail)); // Copy set
             }
        }
        if (userSess != null && !userSess.isEmpty()) {
            sendUserAssignmentNotification(userSess, doctorEmail, doctorInfo.getFullName());
        } else {
             System.out.println("User " + userEmail + " session(s) not found immediately after assignment - cannot notify user directly.");
             // User might receive notification upon next action or reconnect.
        }

        // Update the general online user list for all OTHER HRs (remove the assigned user)
        broadcastOnlineUsers();
    }

    // Get chat history (can be requested by HR or assigned Doctor)
    private void handleGetChatHistory(JSONObject json, Session session) {
        UserInfo adminInfo = onlineHRs.get(session);
        boolean isDoctor = false;
        String adminEmail = null;

        if (adminInfo != null) {
             adminEmail = adminInfo.getEmail();
        } else {
            adminInfo = onlineDoctors.get(session);
            if (adminInfo != null) {
                isDoctor = true;
                adminEmail = adminInfo.getEmail();
            }
        }

        if (adminInfo == null) {
            sendError(session, "authError", "You must be logged in as HR or Doctor to get chat history.");
            return;
        }

        String userEmail = json.getString("userEmail");

        // Authorization Check:
        // HR can access any history.
        // Doctor can only access history of users currently assigned to them.
        if (isDoctor) {
             String assignedDocEmail;
             synchronized(assignedToDoctor){
                 assignedDocEmail = assignedToDoctor.get(userEmail);
             }
            if (!adminEmail.equals(assignedDocEmail)) {
                sendError(session, "authError", "You are not authorized to view this user's chat history.");
                System.out.println("Unauthorized history request: Doctor " + adminEmail + " for user " + userEmail + " (assigned to " + assignedDocEmail + ")");
                return;
            }
        }

        // Retrieve history safely
        List<JSONObject> history = messageStore.getOrDefault(userEmail, Collections.emptyList());
        List<JSONObject> historyCopy;
        // Lock the specific list while copying to ensure atomicity if needed, though getOrDefault is safe.
        // Copying avoids potential issues if the original list reference is modified later.
        synchronized (history) {
             historyCopy = new ArrayList<>(history);
        }


        // Send response back to the requesting admin
        JSONObject response = new JSONObject();
        response.put("action", "chatHistoryResponse");
        response.put("userEmail", userEmail);
        response.put("history", new JSONArray(historyCopy)); // Send the copy

        sendMessageInternal(session, response);
        System.out.println("Sent chat history (" + historyCopy.size() + " messages) for " + userEmail + " to " + adminEmail);
    }


    // --- Broadcast and Notification Methods ---

    // Broadcasts the current list of users waiting for HR
    private void broadcastOnlineUsers() {
         broadcastToHRs(createOnlineUsersUpdate());
    }

    // Broadcasts the current list of online doctors to HRs
    private void broadcastOnlineDoctors() {
         broadcastToHRs(createOnlineDoctorsUpdate());
    }

    // Send a JSON message to all connected HR sessions
    private void broadcastToHRs(JSONObject json) {
        Set<Session> currentHRSessions;
        synchronized(onlineHRs){ // Lock while getting keyset copy
            currentHRSessions = new HashSet<>(onlineHRs.keySet());
        }
        // System.out.println("Broadcasting to " + currentHRSessions.size() + " HR sessions: " + json.optString("action")); // Reduce log noise
        for (Session hrSession : currentHRSessions) {
            sendMessageInternal(hrSession, json);
        }
    }

    // --- Helper methods for sending messages ---

    // Centralized method for sending JSON messages to a single session with error handling
    private void sendMessageInternal(Session session, JSONObject json) {
        if (session != null && session.isOpen()) {
            try {
                // System.out.println("Sending to " + session.getId() + ": " + json.toString()); // Verbose log
                session.getBasicRemote().sendText(json.toString());
            } catch (IOException e) {
                 System.err.println("Failed to send message to session " + session.getId() + ": " + e.getMessage() + " - Message: " + json.toString());
                 // Consider triggering onClose logic if send fails repeatedly? Difficult to manage state.
                 // For now, just log the error. onClose will handle eventual cleanup if session is broken.
            } catch (IllegalStateException e) {
                System.err.println("Session " + session.getId() + " likely closing or closed during send: " + e.getMessage());
            }
        } else {
            // System.out.println("Attempted to send message to closed or null session."); // Reduce log noise
        }
    }


    // Send message FROM Admin/Doctor TO a specific User's sessions
    // Pass the pre-constructed message object
    private void sendMessageToUser(String receiverEmail, String senderEmail, String senderFullName, String msgContent, String timestamp, JSONObject messageJson) {
        Set<Session> receiverSessionsSet = null;
        synchronized(userSessions){
            if(userSessions.containsKey(receiverEmail)){
                receiverSessionsSet = new HashSet<>(userSessions.get(receiverEmail)); // Copy set
            }
        }

        if (receiverSessionsSet != null && !receiverSessionsSet.isEmpty()) {
            // messageJson already contains all necessary fields
            for (Session userSession : receiverSessionsSet) {
                sendMessageInternal(userSession, messageJson);
            }
             // System.out.println("Relayed message from " + senderEmail + " to user " + receiverEmail + " ("+receiverSessionsSet.size()+" sessions)"); // Reduce noise
        } else {
             System.out.println("Cannot relay message: User " + receiverEmail + " has no active sessions.");
             // Optionally notify the sender admin that the user is offline?
             // findAdminSession(senderEmail).ifPresent(adminSession -> sendError(adminSession, "deliveryError", "User " + receiverEmail + " is currently offline."));
        }
    }

    // Send message FROM User TO assigned Doctor's sessions
    // Pass the pre-constructed message object
    private void sendMessageToDoctor(String doctorEmail, String senderEmail, String senderFullName, String msgContent, String timestamp, JSONObject messageJson) {
        List<Session> doctorSessions = getDoctorSessions(doctorEmail); // Gets currently open sessions
        if (!doctorSessions.isEmpty()) {
             // messageJson already contains all necessary fields
            for (Session docSession : doctorSessions) {
                sendMessageInternal(docSession, messageJson);
            }
            // System.out.println("Relayed message from user " + senderEmail + " to doctor " + doctorEmail + " ("+doctorSessions.size()+" sessions)"); // Reduce noise
        } else {
            System.out.println("Cannot relay message: Assigned doctor " + doctorEmail + " has no active sessions.");
            // Notify the user their message was stored but not delivered live
            Set<Session> userSess = null;
             synchronized(userSessions){
                 if(userSessions.containsKey(senderEmail)){
                    userSess = new HashSet<>(userSessions.get(senderEmail)); // Copy set
                 }
             }
            if (userSess != null && !userSess.isEmpty()){
                 JSONObject errorJson = new JSONObject();
                 errorJson.put("action", "deliveryWarning"); // Use a different action?
                 errorJson.put("message", "Your assigned doctor is currently offline. Your message has been saved and will be visible when they reconnect.");
                 for(Session s : userSess) sendMessageInternal(s, errorJson);
            }
        }
    }

    // Send message FROM User TO a specific HR session
    // Pass the pre-constructed message object
    private void sendMessageToAdmin(Session targetAdminSession, String senderEmail, String senderFullName, String msgContent, String timestamp, JSONObject messageJson) {
         // messageJson already contains sender, message, timestamp, receiver (HR/Doc email)
         sendMessageInternal(targetAdminSession, messageJson);
         // System.out.println("Relayed message from " + senderEmail + " to admin session " + targetAdminSession.getId()); // Reduce noise
    }

    // Send a generic error message back to the originating session
    private void sendError(Session session, String errorAction, String message) {
        JSONObject error = new JSONObject();
        error.put("action", errorAction);
        error.put("error", true);
        error.put("message", message);
        sendMessageInternal(session, error);
    }

    // Send a generic success message back to the originating session
     private void sendSuccess(Session session, String successAction, String message) {
        JSONObject success = new JSONObject();
        success.put("action", successAction);
        success.put("success", true);
        success.put("message", message);
        sendMessageInternal(session, success);
    }

    // Send a detailed success message after assigning a user to a doctor (to the requesting HR)
    private void sendAssignSuccess(Session hrSession, String userEmail, String userFullName, String doctorEmail, String doctorFullName) {
        JSONObject success = new JSONObject();
        success.put("action", "assignSuccess");
        success.put("success", true);
        success.put("message", "User " + userFullName + " assigned to Dr. " + doctorFullName + ".");
        success.put("userEmail", userEmail);
        success.put("userFullName", userFullName);
        success.put("doctorEmail", doctorEmail);
        success.put("doctorFullName", doctorFullName);
        sendMessageInternal(hrSession, success);
    }


    // --- Assignment specific notifications ---

    // Notify the relevant doctor sessions about a new user assignment
     private void notifyDoctorOfNewAssignment(List<Session> doctorSessions, UserInfo assignedUserInfo) {
        JSONObject notification = new JSONObject();
        notification.put("action", "newAssignment"); // Client uses this to show notification/toast
        notification.put("user", assignedUserInfo.toJson()); // Send full user info

        System.out.println("Notifying doctor " + getEmailFromDoctorSessions(doctorSessions) + " of new assignment: " + assignedUserInfo.getEmail());
        for (Session docSession : doctorSessions) {
            sendMessageInternal(docSession, notification);
        }
    }

    // Send the complete list of assigned users to a specific doctor (single session, e.g., on connect)
    private void sendAssignedUsersToDoctor(String doctorEmail, Session doctorSession) {
        sendAssignedUsersToDoctor(doctorEmail, Collections.singletonList(doctorSession));
    }

    // Send the complete list of assigned users to all active sessions of a specific doctor
    private void sendAssignedUsersToDoctor(String doctorEmail, List<Session> doctorSessions) {
        if (doctorSessions == null || doctorSessions.isEmpty()) {
            return; // No sessions to send to
        }

        JSONArray usersArray = new JSONArray();
        // Iterate through assignments, find users for THIS doctor
        // Create copies/iterate safely due to potential concurrent modifications
        Map<String, String> currentAssignments;
        Map<String, UserInfo> currentAssignedUsersMap;

        synchronized(assignedToDoctor){ currentAssignments = new HashMap<>(assignedToDoctor); }
        synchronized(assignedUsers){ currentAssignedUsersMap = new HashMap<>(assignedUsers); }

        for (Map.Entry<String, String> entry : currentAssignments.entrySet()) {
            if (entry.getValue().equals(doctorEmail)) {
                String userEmail = entry.getKey();
                UserInfo userInfo = currentAssignedUsersMap.get(userEmail);
                if (userInfo != null) {
                    // Check if user has active sessions to determine online status
                    boolean userOnline = false;
                    synchronized(userSessions) {
                        userOnline = userSessions.containsKey(userEmail) && !userSessions.get(userEmail).isEmpty();
                    }
                    JSONObject userJson = userInfo.toJson();
                    userJson.put("isOnline", userOnline); // Add online status for doctor's UI
                    usersArray.put(userJson);
                } else {
                    System.out.println("Data inconsistency: User " + userEmail + " assigned to " + doctorEmail + " but not found in assignedUsers map.");
                    // Optionally clean up:
                    // synchronized(assignedToDoctor){ assignedToDoctor.remove(userEmail); }
                }
            }
        }

        JSONObject json = new JSONObject();
        json.put("action", "updateAssignedUsers");
        json.put("assignedUsers", usersArray);

        // System.out.println("Sending updated assigned users list to doctor " + doctorEmail + ". Count: " + usersArray.length()); // Reduce noise
        for (Session docSession : doctorSessions) {
            // Ensure session is still open before sending
            if (docSession.isOpen()) {
                 sendMessageInternal(docSession, json);
            }
        }
    }

    // Notify relevant doctor sessions when an assigned user is removed (disconnected or unassigned)
    private void notifyDoctorOfRemoval(String doctorEmail, String userEmail, String userFullName) {
        List<Session> doctorSessions = getDoctorSessions(doctorEmail); // Gets open sessions
        if(doctorSessions.isEmpty()){
            System.out.println("Cannot notify doctor " + doctorEmail + " of user " + userEmail + " removal: Doctor offline.");
            return;
        }

        JSONObject notification = new JSONObject();
        notification.put("action", "removeAssignedUser"); // Client uses this to update UI
        notification.put("userEmail", userEmail);
        notification.put("userFullName", userFullName); // Include name

         System.out.println("Notifying doctor " + doctorEmail + " of removal/disconnect of user: " + userEmail);
        for (Session docSession : doctorSessions) {
            sendMessageInternal(docSession, notification);
             // Immediately send updated list *after* notification to ensure UI sync
             sendAssignedUsersToDoctor(doctorEmail, docSession); // Send full list update to this specific session
        }
        // Note: Sending the full list update inside the loop ensures each doctor session gets the update.
        // If multiple sessions existed, this might send the list multiple times, but ensures consistency.
    }


    // Notify the user's sessions they've been assigned to a doctor
    private void sendUserAssignmentNotification(Set<Session> userSessionsSet, String doctorEmail, String doctorFullName) {
         if (userSessionsSet == null || userSessionsSet.isEmpty()) return;

        JSONObject notification = new JSONObject();
        notification.put("action", "assignedToDoctor");
        notification.put("doctorEmail", doctorEmail);
        notification.put("doctorFullName", doctorFullName);

        // System.out.println("Notifying user " + getEmailFromUserSessions(userSessionsSet) + " of assignment to doctor " + doctorEmail); // Reduce noise
        for (Session userSession : userSessionsSet) { // Iterate over the provided set (should be a safe copy)
            sendMessageInternal(userSession, notification);
        }
    }

    // --- Utility methods ---

    // Helper to get doctor's full name from email (searches online doctors)
    private String getDoctorFullName(String doctorEmail) {
         synchronized(onlineDoctors){ // Lock while iterating
             for(UserInfo info : onlineDoctors.values()) {
                 if(info.getEmail().equals(doctorEmail)) {
                     return info.getFullName();
                 }
             }
         }
         // Fallback if doctor disconnected right after assignment? Unlikely but possible.
          synchronized(assignedUsers) { // Check disconnected but assigned info? Less reliable.
               // This path is less likely to be useful if the primary goal is the *online* doctor's name
          }

         return doctorEmail; // Fallback to email if not found online
    }

    // Get all *currently open* sessions for a given doctor email
    private List<Session> getDoctorSessions(String doctorEmail) {
        List<Session> sessions = new ArrayList<>();
         synchronized (onlineDoctors){ // Lock map while iterating
             // Create copy of entries to avoid locking during potentially slow isOpen check? No, isOpen is fast.
            for (Map.Entry<Session, UserInfo> entry : onlineDoctors.entrySet()) {
                if (entry.getValue().getEmail().equals(doctorEmail) && entry.getKey().isOpen()) {
                    sessions.add(entry.getKey());
                }
            }
         }
        return sessions;
    }

     // Helper to get user email from a set of their sessions (assumes all sessions belong to the same user)
     // Use cautiously - better to pass email directly if known.
     private String getEmailFromUserSessions(Set<Session> sessions) {
          if (sessions == null || sessions.isEmpty()) return "unknown_user";
          Session sampleSession = sessions.iterator().next(); // Get any session from the set
          synchronized (userSessions) { // Lock map while searching
             for (Map.Entry<String, Set<Session>> entry : userSessions.entrySet()) {
                 if (entry.getValue().contains(sampleSession)) {
                      return entry.getKey();
                 }
             }
          }
          System.err.println("Warning: Could not find email for user session: " + sampleSession.getId());
          return "unknown_user_error"; // Should not happen if sessions are managed correctly
     }

     // Helper to get doctor email from a list of their sessions
     private String getEmailFromDoctorSessions(List<Session> sessions) {
          if (sessions == null || sessions.isEmpty()) return "unknown_doctor";
          Session sampleSession = sessions.get(0);
          synchronized(onlineDoctors) {
               UserInfo info = onlineDoctors.get(sampleSession);
               if (info != null) return info.getEmail();
          }
           System.err.println("Warning: Could not find email for doctor session: " + sampleSession.getId());
           return "unknown_doctor_error";
     }


    // --- Static getters (if needed by other parts of the application - use with caution) ---
    // Accessing these directly from outside might require external synchronization depending on usage.

    // Returns a synchronized map, but iteration still requires manual synchronization
    public static Map<String, UserInfo> getOnlineUsersMap() {
        return onlineUsers;
    }

    // Returns a synchronized map, but iteration still requires manual synchronization
    public static Map<Session, UserInfo> getOnlineDoctorsMap() {
        return onlineDoctors;
    }

    // Returns the ConcurrentHashMap - generally safe for point lookups/updates
     public static Map<String, List<JSONObject>> getMessageStore() {
        return messageStore;
    }
}