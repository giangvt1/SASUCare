package controller.guest;

import dao.DoctorRatingDBContext;
import dao.RatingDBContext;
import model.Doctor;
import model.Rating;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import model.Customer;

@WebServlet(name = "DoctorDetailsServlet", urlPatterns = {"/DoctorDetailsServlet"})
public class DoctorDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy doctorId từ request
        String doctorIdStr = request.getParameter("id");
        if (doctorIdStr == null || doctorIdStr.isEmpty()) {
            response.sendRedirect("doctorList.jsp"); // Chuyển hướng nếu không có ID
            return;
        }

        try {
            int doctorId = Integer.parseInt(doctorIdStr);
            DoctorRatingDBContext doctorDAO = new DoctorRatingDBContext();
            Doctor doctor = doctorDAO.getDoctorById(doctorId);

            if (doctor != null) {
                // Lấy tham số filter từ request
                String ratingFilterStr = request.getParameter("ratingFilter");
                int ratingFilter = 0;
                List<Rating> ratings = doctor.getRatings();
                List<Rating> filteredRatings = new ArrayList<>();
                if (ratingFilterStr != null && !ratingFilterStr.equals("all")) {
                    ratingFilter = Integer.parseInt(ratingFilterStr);
                    // Lọc đánh giá dựa trên tham số filter
                    for (Rating rating : ratings) {
                        if (rating.getRating() == ratingFilter) {
                            filteredRatings.add(rating);
                        }
                    }
                } else {
                    filteredRatings = doctor.getRatings(); // Không lọc nếu là "all"
                }

                // Gán danh sách đánh giá đã lọc vào request
                request.setAttribute("doctor", doctor);
                request.setAttribute("filteredRatings", filteredRatings);

                request.getRequestDispatcher("/guest/doctorDetails.jsp").forward(request, response);
            } else {
                response.sendRedirect("/guest/doctorList.jsp"); // Chuyển hướng nếu không tìm thấy bác sĩ
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("/guest/doctorList.jsp"); // Xử lý lỗi nếu ID không hợp lệ
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("currentCustomer");
        if (customer == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int doctorId = Integer.parseInt(request.getParameter("doctorId"));
        DoctorRatingDBContext doctorDAO = new DoctorRatingDBContext();
        Doctor doctor = doctorDAO.getDoctorById(doctorId);
        String action = request.getParameter("action");
        String customerUsername = customer.getUsername();
        RatingDBContext ratingDB = new RatingDBContext();

        int rate = Integer.parseInt(request.getParameter("rate"));
        int reverseStar = 6 - rate;
        String comment = request.getParameter("comment");
        
        Rating rating = new Rating(doctorId, customerUsername, reverseStar, comment);
        ratingDB.saveOrUpdateRating(rating);

        response.sendRedirect(request.getContextPath() + "/DoctorDetailsServlet?id="+doctorId);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
