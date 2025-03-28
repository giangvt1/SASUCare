<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Hóa đơn</title>
    <style>
        /* Tổng thể */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #eef2f3;
            margin: 0;
            padding: 0;
        }
        /* Container chính bên phải sau sidebar */
        .right-side {
            margin-left: 220px;
            padding: 30px;
            background-color: #f9f9f9;
            min-height: 100vh;
        }
        h1 {
            text-align: center;
            color: #444;
            font-size: 26px;
            margin-bottom: 25px;
        }
        /* Form lọc, tìm kiếm và chọn số dòng hiển thị */
        .filter-form {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
        }
        .filter-form label {
            font-size: 15px;
            color: #555;
        }
        .filter-form input[type="text"],
        .filter-form input[type="date"] {
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }
        .filter-form select {
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
            background: #fff;
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
        /* Nút Export CSV */
        .export-btn {
            display: inline-block;
            padding: 8px 16px;
            background-color: #28a745;
            color: #fff;
            text-decoration: none;
            border-radius: 4px;
            font-size: 15px;
            margin-bottom: 15px;
        }
        .export-btn:hover {
            background-color: #218838;
        }
        /* Bảng hóa đơn */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background-color: #fff;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        th, td {
            padding: 12px 16px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }
        th {
            background-color: #007bff;
            color: #fff;
            font-weight: 600;
            font-size: 15px;
        }
        tbody tr:hover {
            background-color: #f1f1f1;
        }
        tbody tr:last-child td {
            border-bottom: none;
        }
        .no-data {
            text-align: center;
            font-style: italic;
            color: #888;
            padding: 20px;
        }
        /* Thông tin khách hàng và dịch vụ */
        .info-block {
            text-align: left;
        }
        .info-block strong {
            display: block;
            font-size: 15px;
            color: #333;
        }
        .info-block small {
            font-size: 13px;
            color: #666;
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
            transition: background-color 0.3s;
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
    </style>
</head>
<body>
    <jsp:include page="../admin/AdminHeader.jsp" />
    <jsp:include page="../admin/AdminLeftSideBar.jsp" />
    <div class="right-side">
        <h1>Quản lý Hóa đơn</h1>
        
        <!-- Form lọc, tìm kiếm và chọn số dòng hiển thị -->
        <form class="filter-form" action="InvoiceManagement" method="get">
            <label for="search">Tìm kiếm:</label>
            <input type="text" id="search" name="search" value="${param.search}" placeholder="Nhập từ khóa..." />
            <label for="startDate">Từ ngày:</label>
            <input type="date" id="startDate" name="startDate" value="${startDate}" />
            <label for="endDate">Đến ngày:</label>
            <input type="date" id="endDate" name="endDate" value="${endDate}" />
            <label for="pageSize">Số dòng:</label>
            <select id="pageSize" name="pageSize">
                <option value="5" <c:if test="${pageSize == 5}">selected</c:if>>5</option>
                <option value="10" <c:if test="${pageSize == 10}">selected</c:if>>10</option>
                <option value="20" <c:if test="${pageSize == 20}">selected</c:if>>20</option>
                <option value="50" <c:if test="${pageSize == 50}">selected</c:if>>50</option>
            </select>
            <button type="submit">Lọc</button>
        </form>
        
        <!-- Nút Export CSV: chuyển sang chế độ xuất file CSV -->
        <div style="text-align: center; margin-bottom: 15px;">
            <a href="InvoiceManagement?export=csv&search=${param.search}&startDate=${startDate}&endDate=${endDate}&sortField=${sortField}&sortDir=${sortDir}&pageSize=${pageSize}" class="export-btn">
                Export CSV
            </a>
        </div>
        
        <!-- Bảng hiển thị hóa đơn -->
        <table>
            <thead>
                <tr>
                    <th>
                        <a href="InvoiceManagement?sortField=orderInfo&sortDir=${sortField=='orderInfo' && sortDir=='asc' ? 'desc' : 'asc'}&search=${param.search}&startDate=${startDate}&endDate=${endDate}&pageSize=${pageSize}">
                            Order Info
                        </a>
                    </th>
                    <th>
                        <a href="InvoiceManagement?sortField=createdDate&sortDir=${sortField=='createdDate' && sortDir=='asc' ? 'desc' : 'asc'}&search=${param.search}&startDate=${startDate}&endDate=${endDate}&pageSize=${pageSize}">
                            Ngày Tạo
                        </a>
                    </th>
                    <th>
                        <a href="InvoiceManagement?sortField=expireDate&sortDir=${sortField=='expireDate' && sortDir=='asc' ? 'desc' : 'asc'}&search=${param.search}&startDate=${startDate}&endDate=${endDate}&pageSize=${pageSize}">
                            Ngày Hết Hạn
                        </a>
                    </th>
                    <th>Khách Hàng</th>
                    <th>Dịch Vụ</th>
                    <th>
                        <a href="InvoiceManagement?sortField=vnpTxnRef&sortDir=${sortField=='vnpTxnRef' && sortDir=='asc' ? 'desc' : 'asc'}&search=${param.search}&startDate=${startDate}&endDate=${endDate}&pageSize=${pageSize}">
                            VNPAY ID
                        </a>
                    </th>
                    <th>
                        <a href="InvoiceManagement?sortField=status&sortDir=${sortField=='status' && sortDir=='asc' ? 'desc' : 'asc'}&search=${param.search}&startDate=${startDate}&endDate=${endDate}&pageSize=${pageSize}">
                            Trạng Thái
                        </a>
                    </th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty invoiceList}">
                        <c:forEach var="inv" items="${invoiceList}">
                            <tr>
                                <td><c:out value="${inv.orderInfo}" /></td>
                                <td><fmt:formatDate value="${inv.createdDate}" pattern="yyyy-MM-dd" /></td>
                                <td><fmt:formatDate value="${inv.expireDate}" pattern="yyyy-MM-dd" /></td>
                                <td>
                                    <c:if test="${not empty inv.customer}">
                                        <div class="info-block">
                                            <strong><c:out value="${inv.customer.fullname}" /></strong>
                                            <small><c:out value="${inv.customer.gmail}" /></small>
                                        </div>
                                    </c:if>
                                </td>
                                <td>
                                    <c:if test="${not empty inv.service}">
                                        <div class="info-block">
                                            <strong><c:out value="${inv.service.name}" /></strong>
                                            <small>
                                                <fmt:formatNumber value="${inv.service.price}" type="currency" currencySymbol="VND" />
                                            </small>
                                        </div>
                                    </c:if>
                                </td>
                                <td><c:out value="${inv.txnRef}" /></td>
                                <td><c:out value="${inv.status}" /></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="8" class="no-data">Không có hóa đơn nào</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
        
        <!-- Phân trang -->
        <div class="pagination">
            <c:if test="${page > 1}">
                <a href="InvoiceManagement?page=${page - 1}&search=${param.search}&startDate=${startDate}&endDate=${endDate}&sortField=${sortField}&sortDir=${sortDir}&pageSize=${pageSize}">&laquo; Prev</a>
            </c:if>
            <c:forEach var="i" begin="1" end="${totalPages}">
                <c:choose>
                    <c:when test="${i == page}">
                        <span class="current">${i}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="InvoiceManagement?page=${i}&search=${param.search}&startDate=${startDate}&endDate=${endDate}&sortField=${sortField}&sortDir=${sortDir}&pageSize=${pageSize}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <c:if test="${page < totalPages}">
                <a href="InvoiceManagement?page=${page + 1}&search=${param.search}&startDate=${startDate}&endDate=${endDate}&sortField=${sortField}&sortDir=${sortDir}&pageSize=${pageSize}">Next &raquo;</a>
            </c:if>
        </div>
    </div>
</body>
</html>
