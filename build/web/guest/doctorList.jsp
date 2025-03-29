<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Danh sách Bác sĩ</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Nên link font Poppins nếu chưa có trong Header/Footer -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        /* --- CSS giữ nguyên như phiên bản trước --- */
        /* --- Thiết lập Chung --- */
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f7f6; /* Màu nền nhẹ nhàng hơn */
            color: #333;
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto; /* Căn giữa container */
            padding: 0 20px; /* Tăng padding */
        }

        h2.page-title { /* Thêm class để dễ quản lý */
            color: #0056b3; /* Màu xanh đậm hơn một chút */
            font-size: 28px; /* Có thể điều chỉnh */
            font-weight: 600;
            margin-top: 50px;
            margin-bottom: 30px; /* Tăng khoảng cách dưới */
            text-transform: uppercase;
            text-align: center;
            letter-spacing: 1px; /* Thêm khoảng cách chữ */
        }

        /* --- Lưới Bác sĩ --- */
        .doctor-container {
            display: grid;
            /* Tự động điều chỉnh số cột dựa trên không gian có sẵn,
               mỗi cột có chiều rộng tối thiểu 280px */
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px; /* Khoảng cách giữa các thẻ */
            justify-content: center; /* Căn giữa các thẻ nếu còn dư không gian */
            padding-bottom: 40px; /* Thêm khoảng đệm dưới cùng */
        }

        /* --- Thẻ Bác sĩ --- */
        .doctor-card {
            background: #ffffff;
            border-radius: 8px; /* Bo góc nhẹ nhàng */
            padding: 25px;
            /* Bóng đổ tinh tế hơn */
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out; /* Hiệu ứng mượt mà */
            text-align: center;
            display: flex; /* Sử dụng flexbox để căn chỉnh nội dung bên trong */
            flex-direction: column; /* Sắp xếp nội dung theo chiều dọc */
            align-items: center; /* Căn giữa theo chiều ngang */
            overflow: hidden; /* Đảm bảo nội dung không tràn */
        }

        .doctor-card:hover {
            transform: translateY(-5px); /* Nâng thẻ lên khi hover */
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12); /* Bóng đổ rõ hơn khi hover */
        }

        /* --- Ảnh Bác sĩ --- */
        .doctor-card img {
            width: 120px;
            height: 120px;
            object-fit: cover; /* Giữ tỉ lệ ảnh, cắt phần thừa */
            border-radius: 50%; /* Bo tròn ảnh */
            margin-bottom: 20px; /* Khoảng cách dưới ảnh */
            display: block; /* Đảm bảo không có khoảng trắng thừa dưới ảnh */
            background-color: #eee; /* Màu nền nhẹ cho vùng ảnh nếu ảnh lỗi */
        }

        /* --- Thông tin Bác sĩ --- */
        .doctor-card h3 {
            font-size: 20px;
            font-weight: 600; /* Tên rõ ràng hơn */
            margin-top: 0; /* Reset margin top */
            margin-bottom: 8px; /* Khoảng cách dưới tên */
            color: #2d3748; /* Màu chữ đậm hơn */
        }

        .doctor-card p {
            font-size: 14px;
            color: #5a6778; /* Màu chữ xám nhẹ */
            margin-bottom: 20px; /* Khoảng cách dưới chuyên khoa */
            flex-grow: 1; /* Đẩy nút xuống dưới nếu thẻ có chiều cao khác nhau */
        }

        /* --- Nút Xem Chi Tiết --- */
        .action-btn {
            display: inline-block;
            padding: 10px 20px; /* Tăng padding ngang */
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 14px;
            font-weight: 500; /* Chữ trên nút rõ hơn */
            transition: background-color 0.3s ease;
            border: none; /* Bỏ viền nếu có */
            cursor: pointer; /* Đổi con trỏ chuột */
        }

        .action-btn:hover {
            background: #0056b3; /* Màu đậm hơn khi hover */
            color: white; /* Đảm bảo màu chữ không đổi */
        }

        /* --- Responsive điều chỉnh nhỏ (ví dụ) --- */
        @media (max-width: 600px) {
            h2.page-title {
                font-size: 24px;
            }
            .doctor-card {
                padding: 20px;
            }
            .doctor-container {
                gap: 20px; /* Giảm khoảng cách trên màn hình nhỏ */
            }
        }

    </style>
</head>
<body>
    <jsp:include page="../Header.jsp"></jsp:include>

    <div class="container">

        <h2 class="page-title">Danh sách Bác sĩ</h2>

        <div class="doctor-container">
            <%-- Đặt URL ảnh mặc định vào biến để dễ quản lý --%>
            <c:set var="defaultAvatar" value="https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png" />

            <c:forEach var="doctor" items="${doctors}">
                <div class="doctor-card">
                    <%-- Kiểm tra nếu doctor.img không rỗng thì dùng nó, ngược lại dùng ảnh mặc định --%>
                    <c:choose>
                        <c:when test="${not empty doctor.img}">
                            <%-- Sử dụng c:url để đảm bảo URL hợp lệ --%>
                            <c:url var="imageUrl" value="${doctor.img}" />
                            <img src="${imageUrl}" alt="Bác sĩ ${doctor.name}">
                        </c:when>
                        <c:otherwise>
                            <%-- Sử dụng ảnh mặc định đã đặt ở trên --%>
                            <img src="https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png" alt="Bác sĩ ${doctor.name} (Ảnh mặc định)">
                        </c:otherwise>
                    </c:choose>

                    <h3>${doctor.name}</h3>
                    <p>Chuyên khoa: ${doctor.specialties}</p>

                    <c:url var="detailsUrl" value="DoctorDetailsServlet">
                        <c:param name="id" value="${doctor.id}" />
                    </c:url>
                    <a href="${detailsUrl}" class="action-btn">Xem chi tiết</a>
                </div>
            </c:forEach>
        </div>

    </div>

    <jsp:include page="../Footer.jsp"></jsp:include>

    <!-- JavaScript Libraries (Giữ nguyên nếu Header/Footer cần) -->
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
    <%-- Các thư viện JS khác nếu cần thiết --%>
</body>
</html>