<%-- 
    Document   : SearchPackageForm
    Created on : Feb 9, 2025, 1:12:40 AM
    Author     : admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Package" %>

<!DOCTYPE html>
<html>
<head>
    <title>Tìm kiếm gói khám</title>
    <style>
    body { 
        font-family: Arial, sans-serif; 
        background-color: #ffffff; /* White background */
    }
    .container { 
        width: 60%; 
        margin: 0 auto; 
    }
    table { 
        width: 100%; 
        border-collapse: collapse; 
        margin-top: 20px; 
    }
    th, td { 
        border: 1px solid #1a75ff; /* Blue border */
        padding: 8px; 
        text-align: left; 
    }
    th { 
        background-color: #1a75ff; /* Blue header */
        color: #ffffff; /* White text */
    }
    td a {
        color: #1a75ff; /* Blue links */
        text-decoration: none;
    }
    td a:hover {
        text-decoration: underline;
    }
    .error { 
        color: red; 
    }
    .filter-container { 
        margin-top: 10px; 
    }
    input[type="text"], select, button {
        border: 1px solid #1a75ff; /* Blue border */
        padding: 5px;
        border-radius: 4px;
    }
    button {
        background-color: #1a75ff; /* Blue button */
        color: #ffffff; /* White text */
        cursor: pointer;
        border: none;
        padding: 8px 12px;
        border-radius: 4px;
    }
    button:hover {
        background-color: #004de6; /* Darker blue on hover */
    }
    .pagination a {
        color: #1a75ff; /* Blue pagination links */
        text-decoration: none;
        padding: 8px 12px;
        border: 1px solid #1a75ff;
        border-radius: 4px;
        margin: 0 2px;
    }
    .pagination a.active {
        background-color: #1a75ff;
        color: #ffffff;
    }
    .pagination a:hover {
        background-color: #004de6;
        color: #ffffff;
    }
</style>
</head>
<body>
    <jsp:include page="../Header.jsp"/>
    <div class="container">
        <h2>Tìm kiếm gói khám</h2>
        
        <form action="SearchPackage" method="get">
    <input type="text" name="keyword" placeholder="Nhập từ khóa..." value="${param.keyword}">

    <!-- Bộ lọc danh mục -->
    <select name="category">
        <option value="all">Tất cả danh mục</option>
        <c:forEach var="cat" items="${categories}">
            <option value="${cat}" ${param.category == cat ? 'selected' : ''}>${cat}</option>
        </c:forEach>
    </select>

    <button type="submit">Tìm kiếm</button>
</form>

<!-- Hiển thị lỗi nếu có -->
<c:if test="${not empty error}">
    <p class="error">${error}</p>
</c:if>

<!-- Danh sách gói khám -->
<c:choose>
    <c:when test="${not empty packages}">
        <table>
            <tr>
<!--                <th>ID</th>-->
                <th>Tên gói</th>
                <th>Mô tả</th>
                <th>Giá (VNĐ)</th>
                <th>Thời gian (phút)</th>
                <th>Danh mục</th>
                <th>Action</th>
            </tr>
            <c:forEach var="pkg" items="${packages}">
                <tr>
<!--                    <td>${pkg.id}</td>-->
                    <td><a href="packageDetail.jsp?id=${pkg.id}">${pkg.name}</a></td>
                    <td>${pkg.description}</td>
                    <td>${pkg.price}</td>
                    <td>${pkg.durationMinutes}</td>
                    <td>${pkg.category}</td>
                    <td>
                        <a href="./appointment">Đặt lịch</a>
                    </td>
                </tr>
            </c:forEach>
        </table>
        
        <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage - 1}&keyword=${param.keyword}&category=${param.category}" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                            </c:if>
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&keyword=${param.keyword}&view=${view}">${i}</a>
                                </li>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage + 1}&keyword=${param.keyword}&category=${param.category}" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
        
    </c:when>
    <c:otherwise>
        <c:if test="${not empty param.keyword}">
            <p>Không tìm thấy kết quả nào.</p>
        </c:if>
    </c:otherwise>
</c:choose>
    </div>
    <jsp:include page="../Footer.jsp"></jsp:include>
    </body>
</html>
