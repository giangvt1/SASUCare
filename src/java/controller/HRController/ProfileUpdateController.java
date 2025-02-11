package controller.HRController;

import controller.systemaccesscontrol.BaseRBACController;
import dao.StaffDBContext;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.system.Staff;
import model.system.User;

public class ProfileUpdateController extends BaseRBACController {

    private static final Logger LOGGER = Logger.getLogger(ProfileUpdateController.class.getName());

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        StaffDBContext staffDB = new StaffDBContext();
        Staff staff = staffDB.getByUsername(logged.getUsername());
        request.setAttribute("staff", staff);
        request.getRequestDispatcher("/admin/AdminProfile.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {

        // Lấy và trim các giá trị đầu vào
        String fullname = request.getParameter("fullname") != null ? request.getParameter("fullname").trim() : "";
        String genderStr = request.getParameter("gender");
        String address = request.getParameter("address") != null ? request.getParameter("address").trim() : "";
        String dobStr = request.getParameter("dob") != null ? request.getParameter("dob").trim() : "";

        // Validate fullname: không được null, không rỗng và không chứa nhiều khoảng trắng liên tiếp
        if (fullname.isEmpty()) {
            request.setAttribute("errorMessage", "Fullname is required.");
            request.getRequestDispatcher("/admin/AdminProfile.jsp").forward(request, response);
            return;
        }
        // Chuẩn hóa fullname: thay thế nhiều khoảng trắng liên tiếp bằng một khoảng trắng
        String normalizedFullname = fullname.replaceAll("\\s+", " ");
        if (!fullname.equals(normalizedFullname)) {
            request.setAttribute("errorMessage", "Fullname must not contain multiple consecutive spaces.");
            request.getRequestDispatcher("/admin/AdminProfile.jsp").forward(request, response);
            return;
        }

        // Validate address: Nếu không rỗng, giới hạn độ dài không quá 50 ký tự và không chứa nhiều khoảng trắng liên tiếp
        if (address != null && !address.isEmpty()) {
            if (address.length() > 50) {
                request.setAttribute("errorMessage", "Address must not exceed 50 characters.");
                request.getRequestDispatcher("/admin/AdminProfile.jsp").forward(request, response);
                return;
            }
            String normalizedAddress = address.replaceAll("\\s+", " ");
            if (!address.equals(normalizedAddress)) {
                request.setAttribute("errorMessage", "Address must not contain multiple consecutive spaces.");
                request.getRequestDispatcher("/admin/AdminProfile.jsp").forward(request, response);
                return;
            }
        }

        // Validate date format nếu có giá trị
        java.sql.Date dob = null;
        if (!dobStr.isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                dob = new java.sql.Date(sdf.parse(dobStr).getTime());
            } catch (ParseException ex) {
                LOGGER.log(Level.WARNING, "Invalid date format: {0}", dobStr);
                request.setAttribute("errorMessage", "Invalid date format. Please use YYYY-MM-DD.");
                request.getRequestDispatcher("/admin/AdminProfile.jsp").forward(request, response);
                return;
            }
        }

        // Xử lý giá trị của gender (true/false)
        boolean gender = "true".equalsIgnoreCase(genderStr);

        HttpSession session = request.getSession();
        StaffDBContext staffDB = new StaffDBContext();
        Staff staff = staffDB.getByUsername(logged.getUsername());

        try {
            if (staff == null) {
                // INSERT: Nếu hồ sơ chưa tồn tại
                staff = new Staff();
                staff.setStaffusername(logged);
                staff.setCreateby(logged);
                staff.setCreateat(new Timestamp(System.currentTimeMillis()));
                staff.setFullname(fullname);
                staff.setGender(gender);
                // Nếu address là rỗng, lưu null
                staff.setAddress(address.isEmpty() ? null : address);
                staff.setDob(dob);

                staffDB.insert(staff);
                session.setAttribute("successMessage", "Profile created successfully.");
            } else {
                // UPDATE: Nếu hồ sơ đã tồn tại
                // Kiểm tra: nếu trường đã có dữ liệu (không null) mà input mới lại rỗng, không cho phép cập nhật.
                if (staff.getFullname() != null && fullname.isEmpty()) {
                    request.setAttribute("errorMessage", "Fullname cannot be set to empty since it already exists.");
                    request.getRequestDispatcher("/admin/AdminProfile.jsp").forward(request, response);
                    return;
                }
                if (staff.getAddress() != null && address.isEmpty()) {
                    request.setAttribute("errorMessage", "Address cannot be set to empty since it already exists.");
                    request.getRequestDispatcher("/admin/AdminProfile.jsp").forward(request, response);
                    return;
                }
                if (staff.getDob() != null && dob == null) {
                    request.setAttribute("errorMessage", "Date of Birth cannot be set to empty since it already exists.");
                    request.getRequestDispatcher("/admin/AdminProfile.jsp").forward(request, response);
                    return;
                }
                
                // Cập nhật các trường (nếu input không rỗng, cập nhật; nếu rỗng, giữ nguyên giá trị cũ)
                staff.setFullname(fullname);
                staff.setGender(gender);
                // Nếu input address rỗng, giữ nguyên, nếu không thì cập nhật
                staff.setAddress(address.isEmpty() ? staff.getAddress() : address);
                // Nếu input dob rỗng, giữ nguyên, nếu có giá trị thì cập nhật
                staff.setDob(dob == null ? staff.getDob() : dob);
                staff.setUpdateby(logged);
                staff.setUpdateat(new Timestamp(System.currentTimeMillis()));

                staffDB.update(staff);
                session.setAttribute("successMessage", "Profile updated successfully.");
            }
            response.sendRedirect(request.getContextPath() + "/system/profile");

        } catch (RuntimeException ex) { // Catch RuntimeException từ DAO
            LOGGER.log(Level.SEVERE, "Error processing profile update", ex);
            session.setAttribute("errorMessage", "A database error occurred. Please try again later.");
            response.sendRedirect(request.getContextPath() + "/system/profile");
        } catch (IOException ex) {
            LOGGER.log(Level.SEVERE, "An unexpected error occurred", ex);
            session.setAttribute("errorMessage", "An unexpected error occurred. Please try again later.");
            response.sendRedirect(request.getContextPath() + "/system/profile");
        }
    }
}
