/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Service;

import jakarta.websocket.EndpointConfig;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import org.json.JSONObject;

/**
 *
 * @author Golden Lightning
 */
@ServerEndpoint(value = "/notification")
public class Notification {

    @OnOpen
    public void onOpen(Session session, EndpointConfig config) {
//        clients.add(session);
        System.out.println("New session opened: " + session.getId());
    }

    @OnClose
    public void onClose(Session session) {
        System.out.println("Session close");
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        JSONObject json = new JSONObject(message);
        String action = json.optString("action");
        switch (action) {
            case "sendData":
              handleSendDataAction(json, session);
                break;
            default:
                throw new AssertionError();
        }
        System.out.println("Session message");

    }
    
    public void handleSendDataAction(JSONObject json, Session session){
        String doctor = json.optString("doctor");
        System.out.println(doctor);
    }
}
