/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.ChatController;

/**
 *
 * @author ngoch
 */
import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

@ServerEndpoint("/chat")
public class ChatEndpoint {

    private static final Set<Session> clients = Collections.synchronizedSet(new HashSet<>());

    @OnOpen
    public void onOpen(Session session) {
        clients.add(session);
        System.out.println("New connection: " + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session senderSession) {
        System.out.println("📩 Received message from " + senderSession.getId() + ": " + message);
        broadcast(message, senderSession);
    }

    @OnClose
    public void onClose(Session session) {
        clients.remove(session);
        System.out.println("Session closed: " + session.getId());
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("WebSocket Error: " + throwable.getMessage());
    }

    private void broadcast(String message, Session senderSession) {
        synchronized (clients) {
            System.out.println("📢 Broadcasting message: " + message);
            for (Session client : clients) {
                if (!client.equals(senderSession)) {
                    try {
                        System.out.println("➡️ Sending to: " + client.getId());
                        client.getBasicRemote().sendText(message);
                    } catch (IOException e) {
                        System.err.println("❌ Error sending to " + client.getId() + ": " + e.getMessage());
                        e.printStackTrace();
                    }
                }
            }
        }
    }

}
