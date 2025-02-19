package controller.HRController;

import controller.systemaccesscontrol.BaseRBACController;
import dao.UserDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.system.User;
import java.io.IOException;

public class EditUserController extends BaseRBACController {

    @Override
    protected void doAuthorizedGet(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        if (username == null || username.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/hr/accountlist");
            return;
        }
        
        UserDBContext userDB = new UserDBContext();
        User user = userDB.getUserByUsername(username); // Lấy user theo username
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/hr/accountlist");
            return;
        }
        
        request.setAttribute("user", user);
        request.getRequestDispatcher("/hr/EditUser.jsp").forward(request, response);
    }

    @Override
    protected void doAuthorizedPost(HttpServletRequest request, HttpServletResponse response, User logged)
            throws ServletException, IOException {
        // Lấy và trim các giá trị đầu vào
        String username = request.getParameter("username");
        String newDisplayname = request.getParameter("displayname") != null ? request.getParameter("displayname").trim() : "";
        String newGmail = request.getParameter("gmail") != null ? request.getParameter("gmail").trim() : "";
        String newPhone = request.getParameter("phone") != null ? request.getParameter("phone").trim() : "";

        // Kiểm tra username
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("error", "Invalid user data.");
            request.getRequestDispatcher("/hr/EditUser.jsp").forward(request, response);
            return;
        }
        
        UserDBContext userDB = new UserDBContext();
        // Lấy user hiện tại từ DB
        User existingUser = userDB.getUserByUsername(username);
        if (existingUser == null) {
            request.setAttribute("error", "User not found.");
            request.getRequestDispatcher("/hr/EditUser.jsp").forward(request, response);
            return;
        }
        
        // Validate Display Name: nếu đã tồn tại (không null) thì không cho phép cập nhật thành chuỗi rỗng
        if (existingUser.getDisplayname() != null && newDisplayname.isEmpty()) {
            request.setAttribute("error", "Display Name cannot be set to empty since it already exists.");
            request.setAttribute("user", existingUser);
            request.getRequestDispatcher("/hr/EditUser.jsp").forward(request, response);
            return;
        }
        // Chuẩn hóa display name: thay thế nhiều khoảng trắng liên tiếp bằng một khoảng trắng
        String normalizedDisplayname = newDisplayname.replaceAll("\\s+", " ");
        if (!newDisplayname.equals(normalizedDisplayname)) {
            request.setAttribute("error", "Display Name must not contain multiple consecutive spaces.");
            request.setAttribute("user", existingUser);
            request.getRequestDispatcher("/hr/EditUser.jsp").forward(request, response);
            return;
        }
        
        // Validate Email: nếu đã có, không cho phép cập nhật thành rỗng.
        if (existingUser.getGmail() != null && newGmail.isEmpty()) {
            request.setAttribute("error", "Email cannot be set to empty since it already exists.");
            request.setAttribute("user", existingUser);
            request.getRequestDispatcher("/hr/EditUser.jsp").forward(request, response);
            return;
        }
        // (Bạn có thể thêm validate định dạng email bằng regex nếu cần)
        
        // Validate Phone Number: nếu đã có dữ liệu, không cho phép cập nhật thành rỗng;
        // và nếu có dữ liệu mới, chỉ cho phép 10 chữ số, bắt đầu bằng 0
        if (existingUser.getPhone() != null && newPhone.isEmpty()) {
            request.setAttribute("error", "Phone Number cannot be set to empty since it already exists.");
            request.setAttribute("user", existingUser);
            request.getRequestDispatcher("/hr/EditUser.jsp").forward(request, response);
            return;
        }
        if (!newPhone.isEmpty() && !newPhone.matches("^0\\d{9}$")) {
            request.setAttribute("error", "Phone Number must be exactly 10 digits, start with 0, and contain only digits.");
            request.setAttribute("user", existingUser);
            request.getRequestDispatcher("/hr/EditUser.jsp").forward(request, response);
            return;
        }
        
        // Tạo đối tượng User mới dùng cho update
        User userToUpdate = new User();
        userToUpdate.setUsername(username);
        userToUpdate.setDisplayname(newDisplayname);
        userToUpdate.setGmail(newGmail);
        userToUpdate.setPhone(newPhone);
        
        boolean success = userDB.updateUser(userToUpdate);
        if (success) {
            request.setAttribute("success", "User updated successfully!");
        } else {
            request.setAttribute("error", "Failed to update user.");
        }
        
        // Lấy lại thông tin user sau khi update và set vào request
        User updatedUser = userDB.getUserByUsername(username);
        request.setAttribute("user", updatedUser);
        request.getRequestDispatcher("/hr/EditUser.jsp").forward(request, response);
    }
}
