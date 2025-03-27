<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Biểu đồ doanh thu hóa đơn</title>
    <style>
        /* Reset & basic body styling */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #ece9e6, #ffffff);
        }

        /* Container for the right side (if you have a sidebar on the left) */
        .right-side {
            margin-left: 220px; /* Adjust if your sidebar width is different */
            padding: 40px 30px;
            min-height: 100vh;
            background-color: #f9f9f9;
        }

        /* Main chart card container */
        .chart-container {
            width: 90%;
            max-width: 1000px;
            margin: 20px auto;  /* centers horizontally */
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            padding: 40px;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .chart-container:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
        }
        .chart-container h1 {
            margin-bottom: 30px;
            text-align: center;
            color: #333;
            font-size: 28px;
        }

        /* Form for filtering revenue */
        .filter-form {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: center;
            gap: 20px; /* space between items */
            margin-bottom: 30px;
        }
        .filter-form label {
            font-size: 16px;
            color: #555;
        }
        .filter-form input[type="date"] {
            padding: 10px 14px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        .filter-form input[type="date"]:focus {
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

        /* Chart box to keep the canvas responsive */
        .chart-box {
            position: relative;
            height: 500px; /* Adjust as needed */
        }

        /* Responsive for smaller screens */
        @media (max-width: 768px) {
            .right-side {
                margin-left: 0;
                padding: 20px;
            }
            .chart-container {
                width: 100%;
                padding: 20px;
            }
            .chart-box {
                height: 400px; /* reduce height on mobile if needed */
            }
        }
    </style>
</head>
<body>
    <!-- Include Header & Sidebar (AdminHeader.jsp & AdminLeftSideBar.jsp) -->
    <jsp:include page="../admin/AdminHeader.jsp" />
    <jsp:include page="../admin/AdminLeftSideBar.jsp" />

    <div class="right-side">
        <div class="chart-container">
            <h1>Biểu đồ doanh thu hóa đơn</h1>

            <!-- Filter form -->
            <form class="filter-form" action="../finance/revenue" method="get">
                <label for="startDate">Từ ngày:</label>
                <input type="date" id="startDate" name="startDate" value="${startDate}" />
                
                <label for="endDate">Đến ngày:</label>
                <input type="date" id="endDate" name="endDate" value="${endDate}" />
                
                <button type="submit">Lọc</button>
            </form>

            <!-- Chart display -->
            <div class="chart-box">
                <canvas id="revenueChart"></canvas>
            </div>
        </div>
    </div>

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // Get revenue data
        const revenueData = [
            <c:forEach var="rev" items="${revenueList}" varStatus="loop">
                { month: "<c:out value='${rev.month}'/>", totalRevenue: ${rev.totalRevenue} }<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        // Prepare labels and values
        const labels = revenueData.map(item => item.month);
        const dataValues = revenueData.map(item => item.totalRevenue);

        // Init chart
        const ctx = document.getElementById('revenueChart').getContext('2d');
        const revenueChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu (VND)',
                    data: dataValues,
                    backgroundColor: 'rgba(40, 167, 69, 0.3)',
                    borderColor: 'rgba(40, 167, 69, 1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.3
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: true,
                        text: 'Doanh thu hóa đơn theo tháng',
                        font: { size: 20 }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return new Intl.NumberFormat('vi-VN', {
                                    style: 'currency',
                                    currency: 'VND'
                                }).format(context.parsed.y);
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
                                return new Intl.NumberFormat('vi-VN', {
                                    style: 'currency',
                                    currency: 'VND'
                                }).format(value);
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
