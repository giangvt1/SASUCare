package controller.AdminController;
 
 import controller.systemaccesscontrol.BaseRBACController;
 import dao.DoctorDBContext;
 import java.io.IOException;
 import jakarta.servlet.ServletException;
 import jakarta.servlet.http.HttpServletRequest;
 import jakarta.servlet.http.HttpServletResponse;
 import java.util.ArrayList;
 import model.Doctor;
 import model.VisitHistory;
 import model.system.User;
 
 public class DoctorMedicalConsultation extends BaseRBACController {
 
     @Override
     protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
         String doctorId = request.getParameter("doctorId");
         String pageStr = request.getParameter("page");
         int sizeOfEachTable = 10;
         String sizeStr = request.getParameter("size");
         if (sizeStr != null && !sizeStr.isEmpty()) {
             sizeOfEachTable = Integer.parseInt(sizeStr);
         }
         int page = 1;
         if (pageStr != null && !pageStr.isEmpty()) {
             try {
                 page = Integer.parseInt(pageStr);
             } catch (NumberFormatException e) {
                 page = 1;
             }
         }
 
         DoctorDBContext doctorDB = new DoctorDBContext();
         if (doctorId != null) {
             try {
                 Doctor doctor = doctorDB.getDoctorInforById(Integer.parseInt(doctorId));
 
                 ArrayList<VisitHistory> visitHistoryList = doctorDB.getVisitHistoriesByDoctorIdPaginated(Integer.parseInt(doctorId), page, sizeOfEachTable);
                 int total = doctorDB.getVisitHistoryCountByDoctorId(Integer.parseInt(doctorId));
                 int totalPages = (int) Math.ceil((double) total / sizeOfEachTable);
 
                 request.setAttribute("doctor", doctor);
                 request.setAttribute("totalPages", totalPages);
                 request.setAttribute("visitHistoryList", visitHistoryList);
                 request.setAttribute("page", page);
 
                 request.getRequestDispatcher("DoctorMedicalConsultation.jsp").forward(request, response);
             } catch (Exception e) {
                 e.printStackTrace();
                 response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing data.");
             }
         } else {
             response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Doctor ID is required.");
         }
     }
 
     @Override
     protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
         throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
     }
 
 }