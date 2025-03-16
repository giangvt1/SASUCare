package controller.HRController;

import controller.systemaccesscontrol.BaseRBACController;
import dao.ApplicationDBContext;
import dao.GoogleDBContext;
import dao.StaffDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.List;
import model.Application;
import model.TypeApplication;
import model.system.User;

/**
 *
 * @author TRUNG
 */
public class EditStaffApplication extends BaseRBACController {

   

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        String applicationId = request.getParameter("applicationId");
        String status = request.getParameter("status");
        ApplicationDBContext appDAO = new ApplicationDBContext();
        Application application = appDAO.getApplicationById(Integer.parseInt(applicationId));
        request.setAttribute("application", application);
        request.setAttribute("status", status);
        request.getRequestDispatcher("EditStaffApplication.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        int staffHandleId = Integer.parseInt(request.getParameter("staffHanleId"));
        int staffSendId = Integer.parseInt(request.getParameter("staffSendId"));
        int id = Integer.parseInt(request.getParameter("id"));
        String typeName = request.getParameter("typeName");
        String reply = request.getParameter("reply");
        String status = request.getParameter("status");
        String message = "";
        Application a = new Application();
        a.setId(id);
        a.setStaffProgressId(staffHandleId);
        a.setStatus(status);
        a.setReply(reply);
        ApplicationDBContext appDAO = new ApplicationDBContext();
        GoogleDBContext g = new GoogleDBContext();
        StaffDBContext s = new StaffDBContext();
        List<TypeApplication> typeList = appDAO.getAllTypes();
        String gmail = s.getUserGmailByStaffId(staffSendId);
        boolean isCreated = appDAO.updateApplicationForStaff(a);

        if (isCreated) {
            message = "Application sent successfully!";
            String title = "Đơn " + typeName + " của đã " + status;
            String mess = "Lý do:" + reply;
            g.send(gmail, title, mess);

        } else {
            message = "Failed to send application.";
        }

        request.setAttribute("typeList", typeList);
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script type='text/javascript'>");
        out.println("alert('" + message + "');");
        out.println("window.location.href='ViewStaffApplication?staffId=" + staffHandleId + "';");
        out.println("</script>");
    }
}
