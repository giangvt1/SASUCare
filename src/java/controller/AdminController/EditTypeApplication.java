package controller.AdminController;

import dao.ApplicationDBContext;
import dao.StaffDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.List;
import model.TypeApplication;
import model.system.Staff;

public class EditTypeApplication extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String staffManage = request.getParameter("staffManage");
        StaffDBContext db = new StaffDBContext();
        List<Staff> staff = db.getStaffByRole(2);
        request.setAttribute("staff", staff);
        request.setAttribute("id", id);
        request.setAttribute("name", name);
        request.setAttribute("staffManage", staffManage);
        request.getRequestDispatcher("EditTypeApplication.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy giá trị từ form
        String name = request.getParameter("name");
        int staffManageId = Integer.parseInt(request.getParameter("staffManage"));
        String message = "";
        TypeApplication typeApp = new TypeApplication();
        typeApp.setName(name);
        typeApp.setStaffManageId(staffManageId);

        if (request.getParameter("id") != null && request.getParameter("id").length() != 0) {
            int id = Integer.parseInt(request.getParameter("id"));
            typeApp.setId(id);
            ApplicationDBContext dao = new ApplicationDBContext();
            boolean updated = dao.updateTypeApplication(typeApp);
            if (updated) {
                message = "Update success";
            } else {
                message = "Update fail";
            }
        } else {
            ApplicationDBContext dao = new ApplicationDBContext();
            boolean created = dao.createTypeApplication(typeApp);
            if (created) {
                message = "Create success";
            } else {
                message = "Create fail";
            }
        }
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script type='text/javascript'>");
        out.println("alert('" + message + "');");
        out.println("window.location.href='ManageTypeApplication';");
        out.println("</script>");

    }
}
