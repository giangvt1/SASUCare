///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
//package controller.accesscontrol;
//
//import dao.CustomerDBContext;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import java.io.IOException;
//import model.Feature;
//import model.Role;
//import model.Customer;
//
///**
// * Base class for controllers that require role-based access control (RBAC).
// */
//public abstract class BaseRBACController extends BaseRequiredAuthentication {
//
//    /**
//     * Checks if the logged-in user is authorized to access the requested
//     * resource.
//     *
//     * @param req The HTTP request.
//     * @param logged The logged-in user.
//     * @return true if authorized, false otherwise.
//     */
//    private boolean isAuthorized(HttpServletRequest req, Customer logged) {
//        CustomerDBContext db = new CustomerDBContext();
//        Role role = db.getRole(logged.getUsername());
//        if (role == null || role.getFeatures() == null) {
//            return false; // Role or features are null, deny access
//        }
//        logged.setRole(role);
//        String currentUrl = req.getServletPath();
//
//        // Check if the user's role has access to the requested feature
//        for (Feature feature : role.getFeatures()) {
//            if (feature.getUrl().equals(currentUrl)) {
//                return true;
//            }
//        }
//        return false;
//    }
//
//    /**
//     * Abstract method for handling authorized GET requests.
//     */
//    protected abstract void doAuthorizedGet(HttpServletRequest req, HttpServletResponse resp, Customer logged) throws ServletException, IOException;
//
//    /**
//     * Abstract method for handling authorized POST requests.
//     *
//     * @param req
//     */
//    protected abstract void doAuthorizedPost(HttpServletRequest req, HttpServletResponse resp, Customer logged) throws ServletException, IOException;
//
//    @Override
//    protected void doGet(HttpServletRequest req, HttpServletResponse resp, Customer logged)
//            throws ServletException, IOException {
//        if (isAuthorized(req, logged)) {
//            doAuthorizedGet(req, resp, logged);
//        } else {
//            req.setAttribute("errorMessage", "Access denied! You do not have permission to access this page.");
//            req.getRequestDispatcher("error403.jsp").forward(req, resp);
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest req, HttpServletResponse resp, Customer logged)
//            throws ServletException, IOException {
//        if (isAuthorized(req, logged)) {
//            doAuthorizedPost(req, resp, logged);
//        } else {
//            req.setAttribute("errorMessage", "Access denied! You do not have permission to access this page.");
//            req.getRequestDispatcher("error403.jsp").forward(req, resp);
//        }
//    }
//}
