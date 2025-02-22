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

    DepartmentDBContext departmentDB = new DepartmentDBContext();
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
// Retrieve the specialties parameter, which could have multiple values
        String[] departmentIds = request.getParameterValues("specialties");

// Initialize the list to hold selected specialties
        List<String> selectedSpecialties = null;

// Check if the departmentIds array has values
        if (departmentIds != null && departmentIds.length > 0) {
            selectedSpecialties = Arrays.asList(departmentIds); // Convert array to List
        } else {
            selectedSpecialties = new ArrayList<>();
        }

        String name = request.getParameter("name");

        // Lấy danh sách bác sĩ từ DB
        List<Doctor> doctors = doctorDB.getDoctorsByFilters(name, selectedSpecialties, selectedDate);
//        List<Doctor> doctors = doctorDB.list();
        List<Department> departments = departmentDB.list();
        Map<Doctor, List<DoctorSchedule>> doctorMap = new LinkedHashMap<>();

        if (selectedDate != null) {
            for (Doctor doctor : doctors) {
                List<DoctorSchedule> schedules = doctorDB.getDoctorSchedules(doctor.getId(), selectedDate);
                doctorMap.put(doctor, schedules);
            }
        }

        // Đưa dữ liệu lên request
        request.setAttribute("departments", departments);
        request.setAttribute("doctorMap", doctorMap);
        request.setAttribute("selectedDate", selectedDate);
        request.getRequestDispatcher("/appointment/doctor_list.jsp").forward(request, response);
    }
}
