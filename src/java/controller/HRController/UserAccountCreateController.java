package controller.HRController;

import controller.systemaccesscontrol.BaseRBACController;
import dao.GoogleDBContext;
import dao.UserDBContext;
import dao.RoleDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.system.Role;
import model.system.User;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Random;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class UserAccountCreateController extends BaseRBACController {

    private static final String PASSWORD_PATTERN = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>])[A-Za-z\\d!@#$%^&*(),.?\":{}|<>]{6,}$";
    private static final String PHONE_PATTERN = "^0\\d{9}$";
    private static final String EMAIL_PATTERN = "^[\\w.-]+@[\\w.-]+\\.[A-Za-z]{2,6}$";
    private static final Random randompass = new Random();

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        RoleDBContext db = new RoleDBContext();
        request.setAttribute("role", db.list());
        request.getRequestDispatcher("../hr/HRCreate.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        GoogleDBContext gg = new GoogleDBContext();
        UserDBContext userDB = new UserDBContext();
        
        // Lấy dữ liệu từ form và trim các giá trị đầu vào
        String username = request.getParameter("username") != null ? request.getParameter("username").trim() : "";
        // Bỏ qua mật khẩu nhập từ form, vì chúng ta sẽ tạo mật khẩu ngẫu nhiên
        // String password = request.getParameter("password") != null ? request.getParameter("password").trim() : "";
        String displayname = request.getParameter("displayname") != null ? request.getParameter("displayname").trim() : "";
        String gmail = request.getParameter("gmail") != null ? request.getParameter("gmail").trim() : "";
        String phone = request.getParameter("phone") != null ? request.getParameter("phone").trim() : "";
        String[] roleIds = request.getParameterValues("roles");

        // Validate username: không được null và không rỗng
        if (username.isEmpty()) {
            request.setAttribute("errorMessage", "Username is required and must not be blank.");
            request.getRequestDispatcher("../hr/HRCreate.jsp").forward(request, response);
            return;
        }
        // Validate displayname: không được rỗng
        if (displayname.isEmpty()) {
            request.setAttribute("errorMessage", "Display Name is required and must not be blank.");
            request.getRequestDispatcher("../hr/HRCreate.jsp").forward(request, response);
            return;
        }
        // Validate email
        Pattern emailPattern = Pattern.compile(EMAIL_PATTERN);
        Matcher emailMatcher = emailPattern.matcher(gmail);
        if (gmail.isEmpty() || !emailMatcher.matches()) {
            request.setAttribute("errorMessage", "Please provide a valid email address.");
            request.getRequestDispatcher("../hr/HRCreate.jsp").forward(request, response);
            return;
        }
        // Validate phone number: phải có đúng 10 chữ số và bắt đầu bằng 0
        Pattern phonePattern = Pattern.compile(PHONE_PATTERN);
        Matcher phoneMatcher = phonePattern.matcher(phone);
        if (phone.isEmpty() || !phoneMatcher.matches()) {
            request.setAttribute("errorMessage", "Phone number must be exactly 10 digits and start with 0.");
            request.getRequestDispatcher("../hr/HRCreate.jsp").forward(request, response);
            return;
        }
        // Validate roles: phải chọn ít nhất một role
        if (roleIds == null || roleIds.length == 0) {
            request.setAttribute("errorMessage", "At least one role must be selected.");
            request.getRequestDispatcher("../hr/HRCreate.jsp").forward(request, response);
            return;
        }
        
        // Kiểm tra email đã tồn tại trước
        if (userDB.isEmailExists(gmail)) {
            request.setAttribute("errorMessage", "Email already exists. Please use a different email.");
            request.getRequestDispatcher("../hr/HRCreate.jsp").forward(request, response);
            return;
        }
        
        // Tạo mật khẩu ngẫu nhiên (ví dụ: 6 ký tự, bạn có thể điều chỉnh số ký tự)
        String generatedPassword = gg.generateRandomPassword(6);
        System.out.println("Generated password: " + generatedPassword);
        
        // Gửi mật khẩu đến email của user (hàm sendPasswordByEmail cần tích hợp JavaMail)
        boolean emailSent = gg.sendPasswordByEmail(gmail, generatedPassword);
        if (!emailSent) {
            request.setAttribute("errorMessage", "Failed to send password email. Please try again.");
            request.getRequestDispatcher("../hr/HRCreate.jsp").forward(request, response);
            return;
        }
        
        // Tạo đối tượng User mới, sử dụng mật khẩu generated (sẽ được mã hóa bên DAO)
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(generatedPassword);
        newUser.setDisplayname(displayname);
        newUser.setGmail(gmail);
        newUser.setPhone(phone);

        // Gán roles
        ArrayList<Role> roles = new ArrayList<>();
        for (String roleId : roleIds) {
            try {
                Role role = new Role();
                role.setId(Integer.parseInt(roleId));
                roles.add(role);
            } catch (NumberFormatException ex) {
                continue;
            }
        }
        newUser.setRoles(roles);

        // Nếu role là Doctor, lấy thông tin phòng ban từ form
        // Giả sử chỉ cho chọn 1 phòng ban
        String departmentParam = request.getParameter("departments");
        if (departmentParam != null && !departmentParam.isEmpty()) {
            try {
                int depId = Integer.parseInt(departmentParam);
                Department dep = new Department();
                dep.setId(depId);
                ArrayList<Department> depList = new ArrayList<>();
                depList.add(dep);
                newUser.setDep(depList);
            } catch (NumberFormatException ex) {
                // Nếu parse thất bại, không set phòng ban
            }
        }

        // Gọi hàm insert trong UserDBContext (mật khẩu sẽ được mã hóa bên DAO)
        try {
            userDB.insert(newUser, logged);
            request.setAttribute("successMessage", "Register a new account successful. The password has been sent to the provided email.");
        } catch (Exception ex) {
            request.setAttribute("errorMessage", "Error, try again: " + ex.getMessage());
        }
        request.getRequestDispatcher("../hr/HRCreate.jsp").forward(request, response);
    }
}
