<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Danh sách Bác sĩ</title>
        <style>
                    /* Thiết lập chung */
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
            color: #333;
        }

        .container {
            max-width: 1200px;
            margin: auto;
            padding: 40px 20px;
            text-align: center;
        }

        h2 {
            color: #007bff;
            font-size: 32px;
            margin-bottom: 20px;
            text-transform: uppercase;
        }

        /* Thiết lập lưới bác sĩ */
        .doctor-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            justify-content: center;
        }

        /* Thẻ bác sĩ */
        .doctor-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: 0.3s;
            text-align: center;
        }

        .doctor-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        }

        .doctor-card img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 50%;
            border: 4px solid #007bff;
            margin-bottom: 15px;
        }

        .doctor-card h3 {
            font-size: 20px;
            margin-bottom: 10px;
            color: #333;
        }

        .doctor-card p {
            font-size: 14px;
            color: #666;
            margin-bottom: 15px;
        }

        /* Nút bấm */
        .action-btn {
            display: inline-block;
            padding: 10px 16px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: 0.3s;
        }

        .action-btn:hover {
            background: #0056b3;
        }

        </style>
    </head>
    <body>
        <jsp:include page="../Header.jsp"></jsp:include>
            <div class="container">

                <h2 style="text-align: center;">Danh sách Bác sĩ</h2>
                <div class="doctor-container">
                <c:forEach var="doctor" items="${doctors}">
                    <div class="doctor-card">
                        <img src='img/doctors/${doctor.img}' alt="Bác sĩ ${doctor.name}">
                        <h3>${doctor.name}</h3>
                        <p>Chuyên khoa: ${doctor.specialties}</p>
                        <a href="DoctorDetailsServlet?id=${doctor.id}" class="action-btn">Xem chi tiết</a>
                    </div>
                </c:forEach>
            </div>

        </div>

        <jsp:include page="../Footer.jsp"></jsp:include>
        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/waypoints/waypoints.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>
        <script src="lib/tempusdominus/js/moment.min.js"></script>
        <script src="lib/tempusdominus/js/moment-timezone.min.js"></script>
        <script src="lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>
    </body>
</html>
