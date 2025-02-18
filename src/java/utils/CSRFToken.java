///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
//package utils;
//
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpSession;
//import java.util.UUID;
//
///**
// *
// * @author acer
// */
//public class CSRFToken {
//    public static String generateToken() {
//        return UUID.randomUUID().toString();
//    }
//    
//    public static void setToken(HttpSession session) {
//        session.setAttribute("csrfToken", generateToken());
//    }
//    
//    public static boolean validateToken(HttpServletRequest request) {
//        String token = request.getParameter("csrfToken");
//        String sessionToken = (String) request.getSession().getAttribute("csrfToken");
//        return token != null && token.equals(sessionToken);
//    }
//}
