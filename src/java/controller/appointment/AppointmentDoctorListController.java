package controller.appointment;

import dao.DoctorDBContext;
import model.Doctor;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import model.Shift;

public class AppointmentDoctorListController extends HttpServlet {

        @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String date = request.getParameter("date");
        if (date == null || date.isEmpty()) {
            date = "2025-02-10"; // Default date for testing
        }
        
        DoctorDBContext doctorDB = new DoctorDBContext();
        HashMap<Doctor, ArrayList<Shift>> doctorMap = doctorDB.getAvailableDoctors(date);
        
        request.setAttribute("doctorMap", doctorMap);
        request.setAttribute("selectedDate", date);
        request.getRequestDispatcher("doctor_list.jsp").forward(request, response);
    }
}
