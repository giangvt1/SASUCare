package controller.AdminController;

import dao.ApplicationDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.TypeApplication;

/**
 *
 * @author TRUNG
 */
public class ManageTypeApplication extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String typeNameStr = request.getParameter("typeName");
        String pageStr = request.getParameter("page");
        int sizeOfEachTable = 10;
        String typeName = null;
        if (typeNameStr != null) {
            typeNameStr = typeNameStr.trim().replaceAll("\\s+", " ");
            typeNameStr = typeNameStr.replace(" ", "%");
            typeName = typeNameStr;
        }
        String sizeStr = request.getParameter("size");
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);

            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        if (sizeStr != null && !sizeStr.isEmpty()) {
            sizeOfEachTable = Integer.parseInt(sizeStr);
        }
        ApplicationDBContext appDAO = new ApplicationDBContext();
        List<TypeApplication> typeList = appDAO.getAllTypes(typeName, page, sizeOfEachTable);
        int totalApplications = appDAO.getTotalTypes(typeName);
        int totalPages = (int) Math.ceil((double) totalApplications / sizeOfEachTable);
        request.setAttribute("typeList", typeList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("ManageTypeApplication.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

}
