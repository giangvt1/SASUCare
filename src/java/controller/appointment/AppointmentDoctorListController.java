package controller.appointment;

import dao.DepartmentDBContext;
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
import java.util.Arrays;
import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;
import model.Department;

public class AppointmentDoctorListController extends HttpServlet {

    private final DepartmentDBContext departmentDB = new DepartmentDBContext();
    private final DoctorDBContext doctorDB = new DoctorDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String dateParam = request.getParameter("date");
        Date selectedDate = null;

        try {
            if (dateParam != null && !dateParam.isEmpty()) {
                selectedDate = Date.valueOf(dateParam); // Convert string to SQL Date
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Invalid Date!");
            request.getRequestDispatcher("/appointment/doctor_list.jsp").forward(request, response);
            return;
        }

        // Retrieve department filter
        String[] departmentIds = request.getParameterValues("specialties");
        List<String> selectedSpecialties = (departmentIds != null) ? Arrays.asList(departmentIds) : new ArrayList<>();

        // Retrieve doctor name filter
        String name = request.getParameter("name");
        if (name != null) {
            name = name.trim().replaceAll("\\s+", " ").replace(" ", "%");
        }

        // Fetch doctors with detailed information
        List<Doctor> doctors = doctorDB.getDoctorsByFilters(name, selectedSpecialties, selectedDate);

        // Fetch available departments
        List<Department> departments = departmentDB.list();

        // Map doctors to their available schedules
        Map<Doctor, List<DoctorSchedule>> doctorMap = new LinkedHashMap<>();
        if (selectedDate != null) {
            for (Doctor doctor : doctors) {
                List<DoctorSchedule> schedules = doctorDB.getDoctorSchedules(doctor.getId(), selectedDate);
                doctorMap.put(doctor, schedules);
            }
        }

        // Set attributes for JSP
        request.setAttribute("departments", departments);
        request.setAttribute("doctorMap", doctorMap);
        request.setAttribute("selectedDate", selectedDate);

        // Forward to the JSP page
        request.getRequestDispatcher("/appointment/doctor_list.jsp").forward(request, response);
    }
}
