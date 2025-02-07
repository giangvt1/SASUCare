package controller.HRController;

import controller.systemaccesscontrol.BaseRBACController;
import dao.StaffDBContext;
import java.io.IOException;
import java.sql.SQLException; // Import SQLException
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat; // Import SimpleDateFormat
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Import HttpSession
import model.system.Staff;
import model.system.User;

public class ProfileUpdateController extends BaseRBACController {

    private static final Logger LOGGER = Logger.getLogger(ProfileUpdateController.class.getName());

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {
        StaffDBContext staffDB = new StaffDBContext();
        Staff staff = staffDB.getByUsername(logged.getUsername());

        request.setAttribute("staff", staff);
        request.getRequestDispatcher("/admin/AdminProfile.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged) throws ServletException, IOException {

        String fullname = request.getParameter("fullname");
        String genderStr = request.getParameter("gender");
        String address = request.getParameter("address");
        String dobStr = request.getParameter("dob");

        // Validation (RẤT QUAN TRỌNG - Phải validate dữ liệu cẩn thận)
        if (fullname == null || fullname.isEmpty()) {
            request.setAttribute("errorMessage", "Fullname is required.");
            request.getRequestDispatcher("/admin/AdminProfile.jsp").forward(request, response);
            return;
        }
        // Validate address (example)
        if (address == null || address.length() > 50) { // Check length, etc.
            request.setAttribute("errorMessage", "Invalid address.");
            request.getRequestDispatcher("/admin/AdminProfile.jsp").forward(request, response);
            return;
        }

        boolean gender = "true".equalsIgnoreCase(genderStr);
        java.sql.Date dob = null;

        if (dobStr != null && !dobStr.isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); // Use SimpleDateFormat
                dob = new java.sql.Date(sdf.parse(dobStr).getTime());
            } catch (ParseException ex) {
                LOGGER.log(Level.WARNING, "Invalid date format: {0}", dobStr);
                request.setAttribute("errorMessage", "Invalid date format. Please use YYYY-MM-DD.");
                request.getRequestDispatcher("/admin/AdminProfile.jsp").forward(request, response);
                return; // Stop further processing
            }
        }

        HttpSession session = request.getSession();
        StaffDBContext staffDB = new StaffDBContext();
        Staff staff = staffDB.getByUsername(logged.getUsername());

        try {
            if (staff == null) {
                // INSERT
                staff = new Staff();
                staff.setStaffusername(logged);
                staff.setCreateby(logged);
                staff.setCreateat(new Timestamp(System.currentTimeMillis()));
                staff.setFullname(fullname);
                staff.setGender(gender);
                staff.setAddress(address);
                staff.setDob(dob);

                staffDB.insert(staff);
                session.setAttribute("successMessage", "Profile created successfully.");
            } else {
                // UPDATE
                staff.setFullname(fullname);
                staff.setGender(gender);
                staff.setAddress(address);
                staff.setDob(dob);
                staff.setUpdateby(logged);
                staff.setUpdateat(new Timestamp(System.currentTimeMillis()));

                staffDB.update(staff);
                session.setAttribute("successMessage", "Profile updated successfully.");
            }
            response.sendRedirect(request.getContextPath() + "/system/profile");

        } catch (RuntimeException ex) { // Catch RuntimeException from DAO
            LOGGER.log(Level.SEVERE, "Error processing profile update", ex);
            session.setAttribute("errorMessage", "A database error occurred. Please try again later.");
            response.sendRedirect(request.getContextPath() + "/system/profile"); // Redirect even if error

        } catch (IOException ex) { // Catch other exceptions (if needed)
            LOGGER.log(Level.SEVERE, "An unexpected error occurred", ex);
            session.setAttribute("errorMessage", "An unexpected error occurred. Please try again later.");
            response.sendRedirect(request.getContextPath() + "/system/profile"); // Redirect even if error
        }
    }
}
