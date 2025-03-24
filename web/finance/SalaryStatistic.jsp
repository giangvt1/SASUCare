<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Biểu đồ thống kê lương bác sĩ</title>
    <style>
        /* Reset cơ bản và nền trang với gradient nhẹ */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #ece9e6, #ffffff);
        }
        /* Container bên phải (nội dung chính) với khoảng cách từ sidebar */
        .right-side {
            margin-left: 220px;
            padding: 40px 30px;
            min-height: 100vh;
            background-color: #f9f9f9;
        }
        /* Card chứa biểu đồ với hiệu ứng bóng đổ, bo tròn và hover nhẹ */
        .chart-container {
            width: 90%;
            max-width: 1000px;
            margin: 20px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            padding: 40px;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .chart-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
        }
        .chart-container h1 {
            margin-top: 0;
            text-align: center;
            color: #333;
            font-size: 28px;
            margin-bottom: 30px;
        }
        /* Form lọc: căn giữa, khoảng cách hợp lý và input đẹp */
        .filter-form {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            align-items: center;
            gap: 20px;
            margin-bottom: 30px;
        }
        .filter-form label {
            font-size: 16px;
            color: #555;
        }
        .filter-form input[type="month"] {
            padding: 10px 14px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        .filter-form input[type="month"]:focus {
            outline: none;
            border-color: #007bff;
        }
        .filter-form button {
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .filter-form button:hover {
            background-color: #0056b3;
        }
        /* Khu vực hiển thị biểu đồ */
        .chart-box {
            position: relative;
            height: 500px;
        }
        /* Responsive */
        @media (max-width: 768px) {
            .right-side {
                margin-left: 0;
                padding: 20px;
            }
            .chart-container {
                width: 100%;
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Include Header & Sidebar -->
    <jsp:include page="../admin/AdminHeader.jsp" />
    <jsp:include page="../admin/AdminLeftSideBar.jsp" />
    
    <div class="right-side">
        <div class="chart-container">
            <h1>Biểu đồ tổng lương theo bác sĩ</h1>
            
            <!-- Form lọc: chọn tháng -->
            <form class="filter-form" action="DoctorSalaryChart" method="get">
                <label for="selectedMonth">Chọn tháng:</label>
                <input type="month" id="selectedMonth" name="month" value="${monthSelected}" />
                <button type="submit">Lọc</button>
            </form>
            
            <!-- Khu vực hiển thị biểu đồ -->
            <div class="chart-box">
                <canvas id="salaryChart"></canvas>
            </div>
        </div>
    </div>
    
    <!-- Nhúng Chart.js từ CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // Lấy context của canvas
        const ctx = document.getElementById('salaryChart').getContext('2d');

        // Tạo mảng nhãn (tên bác sĩ) và dữ liệu (tổng lương) từ attribute stats
        const labels = [
            <c:forEach var="stat" items="${stats}" varStatus="loop">
                "<c:out value='${stat.doctorName}'/>"<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];
        const totalSalaries = [
            <c:forEach var="stat" items="${stats}" varStatus="loop">
                ${stat.totalSalary}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        // Khởi tạo biểu đồ cột với Chart.js
        const salaryChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Tổng lương',
                    data: totalSalaries,
                    backgroundColor: 'rgba(54, 162, 235, 0.7)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: true,
                        text: 'Thống kê tổng lương theo bác sĩ',
                        font: {
                            size: 20
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(context.parsed.y);
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            font: { size: 14 },
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
                            }
                        }
                    },
                    x: {
                        ticks: {
                            font: { size: 14 },
                            autoSkip: false,
                            maxRotation: 30,
                            minRotation: 30
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>
