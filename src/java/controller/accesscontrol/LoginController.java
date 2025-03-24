package controller.accesscontrol;

import dao.CustomerDBContext;
import dao.GoogleDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Customer;
import model.GoogleAccount;

/**
 *
 * @author acer
 */
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        GoogleDBContext googleDAO = new GoogleDBContext();
        CustomerDBContext customerDAO = new CustomerDBContext();
        String code = request.getParameter("code");
        GoogleLogin gg = new GoogleLogin();
        String accessToken = gg.getToken(code);
        GoogleAccount account = gg.getUserInfo(accessToken);

        HttpSession session = request.getSession();

        if (!googleDAO.isGoogleExist(account.getEmail())) {
            googleDAO.insert(account); // Nếu chưa có tài khoản Google thì thêm vào bảng google
        }

        // Kiểm tra xem customer có tồn tại hay chưa
        Customer customer = customerDAO.getByGmail(account.getEmail());

        if (customer == null) {
            // Nếu không tồn tại customer -> tạo mới
            customer = new Customer();
            customer.setGmail(account.getEmail());
            customer.setGoogle_id(account);
            customer.setFullname(account.getName());

            customerDAO.insert(customer); // Thêm mới customer
        } else {
            // Nếu đã có customer nhưng chưa liên kết với Google, thì cập nhật liên kết
            if (customer.getGoogle_id() == null) {
                customer.setGoogle_id(account);
                customerDAO.update(customer);
            }
        }
        
        System.out.println("asdasdadas: " + customer.getId());

        // Lưu thông tin vào session để sử dụng sau này
        session.setAttribute("currentCustomer", customer);
        session.setAttribute("currentGoogle", account);

        // Check if there is a URL to redirect after login
        String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
        if (redirectUrl != null) {
            session.removeAttribute("redirectAfterLogin"); // Remove it after using
            response.sendRedirect(redirectUrl);
        } else {
            response.sendRedirect("Home.jsp"); // Default redirect
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        CustomerDBContext db = new CustomerDBContext();
        Customer account = db.login(username, password);

        HttpSession session = request.getSession();

        if (account != null) {
            session.setAttribute("currentCustomer", account);

            // Redirect user back to the previous page if they were redirected for login
            String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
            if (redirectUrl != null) {
                session.removeAttribute("redirectAfterLogin"); // Clear session attribute
                response.sendRedirect(redirectUrl);
            } else {
                response.sendRedirect("Home.jsp"); // Default redirect
            }
        } else {
            // Show an alert for invalid login and reload login page
            response.setContentType("text/html");
            response.getWriter().println("<script type='text/javascript'>"
                    + "alert('Invalid username or password. Please try again.');"
                    + "window.history.back();"
                    + "</script>");
        }
    }
}
