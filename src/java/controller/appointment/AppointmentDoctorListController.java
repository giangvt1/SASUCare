package controller.appointment;

import dao.DoctorDBContext;
import model.Doctor;
import model.DoctorSchedule;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class AppointmentDoctorListController extends HttpServlet {

    private DoctorDBContext doctorDB = new DoctorDBContext();   
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String dateParam = request.getParameter("date");
    Date selectedDate = Date.valueOf(dateParam); // Convert string to SQL Date
    
//    DoctorDBContext doctorDB = new DoctorDBContext();
    ArrayList<Doctor> doctors = doctorDB.list();

    // Map doctors with their schedules
    Map<Doctor, ArrayList<DoctorSchedule>> doctorMap = new HashMap<>();
    for (Doctor doctor : doctors) {
        ArrayList<DoctorSchedule> schedules = doctorDB.getDoctorSchedules(doctor.getId(), selectedDate);
        doctorMap.put(doctor, schedules);
    }

    request.setAttribute("doctorMap", doctorMap);
    request.setAttribute("selectedDate", selectedDate);
    request.getRequestDispatcher("/appointment/doctor_list.jsp").forward(request, response);
}

}
