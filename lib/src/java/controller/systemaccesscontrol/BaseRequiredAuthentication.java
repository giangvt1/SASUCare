package controller.systemaccesscontrol;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this lgicense
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.system.Staff;

/**
 *
 * @author acer
 */
public abstract class BaseRequiredAuthentication extends HttpServlet {

    private boolean isAuthenticated(HttpServletRequest req) {
        return req.getSession().getAttribute("account") != null;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (isAuthenticated(req)) {
            doAuthenGet(req, resp, (Staff) req.getSession().getAttribute("account"));
        } else {
            resp.sendRedirect("../error403.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (isAuthenticated(req)) {
            doAuthenPost(req, resp, (Staff) req.getSession().getAttribute("account"));
        } else {
            resp.sendRedirect("../error403.jsp");
        }
    }

    protected abstract void doAuthenGet(HttpServletRequest req, HttpServletResponse resp, Staff logged) throws ServletException, IOException;

    protected abstract void doAuthenPost(HttpServletRequest req, HttpServletResponse resp, Staff logged) throws ServletException, IOException;

}
