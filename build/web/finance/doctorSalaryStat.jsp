<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thống kê lương bác sĩ</title>
    <style>
        /* Reset và style chung cho body */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f4f4;
        }
        /* Container cho nội dung bên phải */
        .right-side {
            margin-left: 220px; /* Giả sử sidebar chiếm khoảng 200px + khoảng cách */
            padding: 20px;
            background-color: #fff;
            min-height: 100vh;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1 {
            font-size: 24px;
            color: #333;
            margin-bottom: 20px;
            text-align: center;
        }
        /* Style cho form lọc dữ liệu */
        form.filter-form {
            margin-bottom: 20px;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 15px;
            justify-content: center;
        }
        form.filter-form label {
            font-size: 14px;
            color: #555;
        }
        form.filter-form input[type="date"],
        form.filter-form input[type="text"] {
            padding: 6px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }
        form.filter-form button {
            padding: 8px 16px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        form.filter-form button:hover {
            background-color: #0056b3;
        }
        /* Nút Export CSV */
        .export-btn {
            display: inline-block;
            padding: 8px 16px;
            background-color: #28a745;
            color: #fff;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            margin-bottom: 15px;
        }
        .export-btn:hover {
            background-color: #218838;
        }
        /* Table styling */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 16px;
        }
        table thead {
            background-color: #007bff;
            color: #fff;
        }
        table th, table td {
            padding: 12px 15px;
            border: 1px solid #ddd;
            text-align: center;
        }
        table tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        table th.sortable:hover {
            cursor: pointer;
            background-color: #0056b3;
        }
        /* Phân trang */
        .pagination {
            margin-top: 20px;
            text-align: center;
        }
        .pagination a, .pagination span {
            display: inline-block;
            padding: 8px 12px;
            margin: 0 4px;
            text-decoration: none;
            color: #007bff;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .pagination a:hover {
            background-color: #007bff;
            color: #fff;
        }
        .pagination .current {
            background-color: #007bff;
            color: #fff;
            border-color: #007bff;
        }
        .no-data {
            text-align: center;
            font-style: italic;
            color: #888;
        }
    </style>
</head>
<body>
    <jsp:include page="../admin/AdminHeader.jsp" />
    <jsp:include page="../admin/AdminLeftSideBar.jsp" />
    <div class="right-side">
        <h1>Thống kê lương bác sĩ</h1>
        
        <!-- Form lọc: theo khoảng thời gian và tìm kiếm theo tên bác sĩ -->
        <form class="filter-form" action="doctorsalary" method="get">
            <label>Ngày bắt đầu:
                <input type="date" name="startDate" value="${startDate}" />
            </label>
            <label>Ngày kết thúc:
                <input type="date" name="endDate" value="${endDate}" />
            </label>
            <label>Tìm kiếm:
                <input type="text" name="search" placeholder="Tên bác sĩ" value="${search}" />
            </label>
            <button type="submit">Lọc</button>
        </form>
        
        <!-- Nút Export CSV: Giữ lại các tham số lọc -->
        <div style="text-align: center;">
            <a href="doctorsalary?export=csv&startDate=${startDate}&endDate=${endDate}&search=${search}&sortField=${sortField}&sortDir=${sortDir}&pageSize=${pageSize}" class="export-btn">Export CSV</a>
        </div>
        
        <!-- Bảng thống kê -->
        <table>
            <thead>
                <tr>
                    <th class="sortable">
                        <a href="doctorsalary?startDate=${startDate}&endDate=${endDate}&search=${search}&sortField=DoctorName&sortDir=${sortField == 'DoctorName' && sortDir == 'asc' ? 'desc' : 'asc'}">
                            Tên bác sĩ
                        </a>
                    </th>
                    <th class="sortable">
                        <a href="doctorsalary?startDate=${startDate}&endDate=${endDate}&search=${search}&sortField=ShiftCount&sortDir=${sortField == 'ShiftCount' && sortDir == 'asc' ? 'desc' : 'asc'}">
                            Số ca làm việc
                        </a>
                    </th>
                    <th>Lương theo ca</th>
                    <th class="sortable">
                        <a href="doctorsalary?startDate=${startDate}&endDate=${endDate}&search=${search}&sortField=TotalSalary&sortDir=${sortField == 'TotalSalary' && sortDir == 'asc' ? 'desc' : 'asc'}">
                            Tổng lương
                        </a>
                    </th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty stats}">
                        <c:forEach var="stat" items="${stats}">
                            <tr>
                                <td><c:out value="${stat.doctorName}" /></td>
                                <td><c:out value="${stat.shiftCount}" /></td>
                                <td>
                                    <fmt:formatNumber value="${stat.salaryRate}" type="currency" currencySymbol="VND" />
                                </td>
                                <td>
                                    <fmt:formatNumber value="${stat.totalSalary}" type="currency" currencySymbol="VND" />
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td class="no-data" colspan="4">Không có dữ liệu</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
        
        <!-- Phân trang động -->
        <div class="pagination">
            <c:if test="${page > 1}">
                <a href="doctorsalary?startDate=${startDate}&endDate=${endDate}&search=${search}&sortField=${sortField}&sortDir=${sortDir}&page=${page - 1}&pageSize=${pageSize}">&laquo; Prev</a>
            </c:if>
            <c:forEach var="i" begin="1" end="${totalPages}">
                <c:choose>
                    <c:when test="${i == page}">
                        <span class="current">${i}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="doctorsalary?startDate=${startDate}&endDate=${endDate}&search=${search}&sortField=${sortField}&sortDir=${sortDir}&page=${i}&pageSize=${pageSize}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <c:if test="${page < totalPages}">
                <a href="doctorsalary?startDate=${startDate}&endDate=${endDate}&search=${search}&sortField=${sortField}&sortDir=${sortDir}&page=${page + 1}&pageSize=${pageSize}">Next &raquo;</a>
            </c:if>
        </div>
    </div>
</body>
</html>
