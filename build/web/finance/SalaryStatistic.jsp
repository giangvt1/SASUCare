<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Biểu đồ thống kê lương bác sĩ</title>
    <style>
        /* Reset cơ bản và thiết lập nền */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #ece9e6, #ffffff);
        }
        /* Container chính: giả sử sidebar chiếm 200px */
        .right-side {
            margin-left: 220px;
            padding: 30px 20px;
            min-height: 100vh;
            background-color: #f9f9f9;
        }
        /* Chart container với kiểu card hiện đại */
        .chart-container {
            width: 90%;
            max-width: 1000px;
            margin: 20px auto;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            padding: 30px;
        }
        .chart-container h1 {
            margin-top: 0;
            text-align: center;
            color: #333;
            font-size: 24px;
            margin-bottom: 20px;
        }
        /* Form filter: canh giữa, khoảng cách hợp lý */
        .filter-form {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }
        .filter-form label {
            font-size: 16px;
            color: #555;
        }
        .filter-form input[type="month"] {
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 15px;
        }
        .filter-form button {
            padding: 8px 18px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            font-size: 15px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .filter-form button:hover {
            background-color: #0056b3;
        }
        /* Responsive cho biểu đồ */
        .chart-box {
            position: relative;
            height: 500px;
        }
    </style>
</head>
<body>
    <!-- Include Header & Sidebar (tùy chỉnh theo hệ thống của bạn) -->
    <jsp:include page="../admin/AdminHeader.jsp" />
    <jsp:include page="../admin/AdminLeftSideBar.jsp" />
    
    <div class="right-side">
        <div class="chart-container">
            <h1>Biểu đồ tổng lương theo bác sĩ</h1>
            
            <!-- Form chọn tháng để lọc dữ liệu -->
            <form class="filter-form" action="DoctorSalaryChart" method="get">
                <label for="selectedMonth">Chọn tháng:</label>
                <input type="month" id="selectedMonth" name="month" value="${monthSelected}" />
                <button type="submit">Lọc</button>
            </form>
            
            <!-- Vùng hiển thị biểu đồ -->
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

        // Tạo mảng nhãn và dữ liệu từ attribute stats
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
                        text: 'Thống kê tổng lương theo bác sĩ'
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
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
                            }
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>
