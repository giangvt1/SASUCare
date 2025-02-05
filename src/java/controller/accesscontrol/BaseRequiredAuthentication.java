///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this lgicense
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
//package controller.accesscontrol;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import java.io.IOException;
//import model.Customer;
//
///**
// *
// * @author acer
// */
//public abstract class BaseRequiredAuthentication extends HttpServlet {
//
//    private boolean isAuthenticated(HttpServletRequest req) {
//        return req.getSession(false) != null && req.getSession().getAttribute("account") != null;
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        if (isAuthenticated(req)) {
//            Customer logged = (Customer) req.getSession().getAttribute("currentCustomer");
//            doGet(req, resp, logged);
//        } else {
//            resp.sendError(403, "You cannot access this page!");
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        if (isAuthenticated(req)) {
//            Customer logged = (Customer) req.getSession().getAttribute("currentCustomer");
//            doPost(req, resp, logged);
//        } else {
//            resp.sendError(403, "You cannot access this page!");
//        }
//    }
//
//    protected abstract void doGet(HttpServletRequest req, HttpServletResponse resp, Customer logged) throws ServletException, IOException;
//
//    protected abstract void doPost(HttpServletRequest req, HttpServletResponse resp, Customer logged) throws ServletException, IOException;
//
//}
