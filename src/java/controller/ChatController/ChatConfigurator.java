package controller.ChatController;

import jakarta.servlet.http.HttpSession;
import jakarta.websocket.HandshakeResponse;
import jakarta.websocket.server.HandshakeRequest;
import jakarta.websocket.server.ServerEndpointConfig;

public class ChatConfigurator extends ServerEndpointConfig.Configurator {
    @Override
    public void modifyHandshake(ServerEndpointConfig config, HandshakeRequest request, HandshakeResponse response) {
        HttpSession httpSession = (HttpSession) request.getHttpSession();

        if (httpSession != null) {
            System.out.println("🔹 HttpSession found in Handshake: " + httpSession.getId());
            config.getUserProperties().put("httpSession", httpSession);
        } else {
            System.out.println("⚠️ No HttpSession found in HandshakeRequest!");
        }
    }

}
