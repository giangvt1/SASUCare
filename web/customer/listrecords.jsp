<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chọn hồ sơ bệnh nhân</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <style>
        /* Container chứa các card bệnh nhân */
        .patient-container {
            display: grid;
            grid-template-columns: repeat(2, 1fr); /* Tạo 2 cột */
            gap: 15px; /* Khoảng cách giữa các thẻ */
            overflow-y: auto; /* Hiển thị thanh cuộn dọc khi nội dung vượt quá */
            max-height: 600px; /* Chiều cao tối đa để chứa 2 thẻ, điều chỉnh nếu cần */
            padding: 15px;
            margin: 0 auto;
        }

        /* Card của từng bệnh nhân */
        .patient-card {
            min-width: 350px;
            max-width: 400px;
            padding: 20px;
            border-radius: 10px;
            background-color: #fff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s;
        }

        .patient-card:hover {
            transform: translateY(-5px);
        }

        /* Tùy chỉnh tiêu đề */
        h3.text-primary {
            margin-bottom: 20px;
            font-size: 1.75rem;
        }

        /* Icon và text trong card */
        .patient-card p {
            margin: 8px 0;
            font-size: 0.95rem;
        }

        .patient-card i {
            margin-right: 8px;
            color: #007bff;
        }

        /* Nút thao tác */
        .btn {
            padding: 8px 15px;
            font-size: 0.9rem;
        }

        .btn-danger, .btn-secondary, .btn-primary {
            border-radius: 5px;
        }

        /* Container nút Quay lại và Thêm hồ sơ */
        .action-buttons {
            width: 50%;
            max-width: 500px;
            margin-top: 20px;
        }

        /* Thanh cuộn dọc đẹp hơn */
        .patient-container::-webkit-scrollbar {
            width: 8px;
        }

        .patient-container::-webkit-scrollbar-thumb {
            background-color: #007bff;
            border-radius: 10px;
        }

        .patient-container::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }
    </style>
</head>
<body class="bg-light">
    <jsp:include page="/Header.jsp"/>

    <div class="container d-flex flex-column align-items-center justify-content-center vh-100">
        <h3 class="text-primary text-center fw-bold">Chọn hồ sơ bệnh nhân</h3>
        <div class="patient-container">
            <!-- Lặp qua danh sách bệnh nhân nếu có nhiều hồ sơ -->
            <c:forEach var="record" items="${records}">
                <div class="patient-card">
                    <h5 class="fw-bold text-primary">
                        <i class="bi bi-person"></i> 
                        <c:out value="${record.fullName}" /> 
                        <span class="text-info">${record.idNumber}</span>
                    </h5>
                    <p><i class="bi bi-calendar"></i> Ngày sinh: <strong>${record.dob}</strong></p>
                    <p><i class="bi bi-telephone"></i> Số điện thoại: <strong>${record.phone}</strong></p>
                    <p><i class="bi bi-geo-alt"></i> Địa chỉ: <strong>${record.addressDetail}, ${record.ward}, ${record.district}, ${record.province}</strong></p>
                    <p><i class="bi bi-gender-ambiguous"></i> Giới tính: <strong>${record.gender}</strong></p>
                    <p><i class="bi bi-envelope"></i> Địa chỉ email: <strong>${record.email}</strong></p>
                    <p><i class="bi bi-globe"></i> Dân tộc: <strong>${record.nation}</strong></p>
                    <div class="d-flex justify-content-between mt-3">
                        <button class="btn btn-danger" onclick="confirmDelete(${record.record_id})">
                            <i class="bi bi-trash"></i> Xóa
                        </button>
                        <a href="record?action=update&recordId=${record.record_id}" class="btn btn-secondary">
                            <i class="bi bi-pencil-square"></i> Sửa
                        </a>
                        <a href="${pageContext.request.contextPath}/appointment" class="btn btn-primary">
                            Tiếp tục <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Nút Quay lại và Thêm hồ sơ -->
        <div class="d-flex justify-content-between action-buttons">
            <a href="previousPage.jsp" class="btn btn-outline-primary">
                <i class="bi bi-arrow-left"></i> Quay lại
            </a>
            <a href="${pageContext.request.contextPath}/customer/createrecord.jsp" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> Thêm hồ sơ
            </a>
        </div>
    </div>
    <jsp:include page="/Footer.jsp"/>

    <script>
        function confirmDelete(recordId) {
            if (confirm("Bạn có chắc chắn muốn xóa hồ sơ này?")) {
                window.location.href = "./record?action=delete&recordId=" + recordId;
            }
        }
    </script>
</body>
</html>