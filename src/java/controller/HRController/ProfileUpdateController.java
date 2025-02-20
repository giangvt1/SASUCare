package controller.HRController;

import controller.systemaccesscontrol.BaseRBACController;
import dao.StaffDBContext;
import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.system.Staff;
import model.system.User;
import java.nio.file.Paths;

@MultipartConfig // Cho phép xử lý multipart/form-data
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

        HttpSession session = request.getSession();
        StaffDBContext staffDB = new StaffDBContext();
        Staff staff = staffDB.getByUsername(logged.getUsername());
        if (staff == null) {
            staff = new Staff();
            staff.setStaffusername(logged);
            staff.setCreateby(logged);
            staff.setCreateat(new Timestamp(System.currentTimeMillis()));
        }

        Part filePart = request.getPart("img");
        if (filePart != null && filePart.getSize() > 0) {
            if (filePart.getSize() > 3145728) {
                request.setAttribute("errorMessage", "File size too large. Maximum allowed size is 3 MB.");
                request.getRequestDispatcher("/admin/AdminProfile.jsp").forward(request, response);
                return;
            }
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String fileNameLower = fileName.toLowerCase();
            if (!(fileNameLower.endsWith(".jpg") || fileNameLower.endsWith(".png"))) {
                request.setAttribute("errorMessage", "Invalid file type. Only JPG and PNG files are allowed.");
                request.getRequestDispatcher("/admin/AdminProfile.jsp").forward(request, response);
                return;
            }
            String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            // Tạo tên file mới với timestamp để tránh trùng lặp
            String newFileName = System.currentTimeMillis() + "_" + fileName;
            String filePath = uploadPath + File.separator + newFileName;
            filePart.write(filePath);
            // Lưu đường dẫn tương đối (sẽ được sử dụng trong JSP)
            staff.setImg("uploads" + File.separator + newFileName);
        }
        
        // Lấy và trim các giá trị đầu vào khác
            String newFileName = System.currentTimeMillis() + "_" + fileName;
            String filePath = uploadPath + File.separator + newFileName;
            filePart.write(filePath);
            staff.setImg("uploads" + File.separator + newFileName);
        }
        String fullname = request.getParameter("fullname") != null ? request.getParameter("fullname").trim() : "";
        String genderStr = request.getParameter("gender");
        String address = request.getParameter("address") != null ? request.getParameter("address").trim() : "";
        String dobStr = request.getParameter("dob") != null ? request.getParameter("dob").trim() : "";

        if (fullname.isEmpty()) {
            request.setAttribute("errorMessage", "Fullname is required.");
            request.getRequestDispatcher("/admin/AdminProfile.jsp").forward(request, response);
            return;
        }
        if (!fullname.matches("^[A-Za-zÀ-ÖØ-öø-ÿ\\s]+$")) {
            request.setAttribute("errorMessage", "Fullname must contain only letters and spaces.");
            request.getRequestDispatcher("/admin/AdminProfile.jsp").forward(request, response);
            return;
        }
        String normalizedFullname = fullname.replaceAll("\\s+", " ");
        if (!fullname.equals(normalizedFullname)) {
            request.setAttribute("errorMessage", "Fullname must not contain multiple consecutive spaces.");
            request.getRequestDispatcher("/admin/AdminProfile.jsp").forward(request, response);
            return;
        }
        if (!address.isEmpty()) {
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
        boolean gender = "true".equalsIgnoreCase(genderStr);

        try {
            if (staff.getId() == 0) {
                staff.setFullname(normalizedFullname);
                staff.setGender(gender);
                staff.setAddress(address.isEmpty() ? null : address);
                staff.setDob(dob);

                staffDB.insert(staff);
                session.setAttribute("successMessage", "Profile created successfully.");
            } else {
                if (staff.getFullname() != null && normalizedFullname.isEmpty()) {
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
                staff.setFullname(normalizedFullname);
                staff.setGender(gender);
                staff.setAddress(address.isEmpty() ? staff.getAddress() : address);
                staff.setDob(dob == null ? staff.getDob() : dob);
                staff.setUpdateby(logged);
                staff.setUpdateat(new Timestamp(System.currentTimeMillis()));

                staffDB.update(staff);
                session.setAttribute("successMessage", "Profile updated successfully.");
            }
            Staff updatedStaff = staffDB.getByUsername(logged.getUsername());
            session.setAttribute("staff", updatedStaff);

            response.sendRedirect(request.getContextPath() + "/system/profile");
        } catch (RuntimeException ex) {
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
