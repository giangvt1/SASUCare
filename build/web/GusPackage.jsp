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
        body { font-family: Arial, sans-serif; }
        .container { width: 60%; margin: 0 auto; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f4f4f4; }
        .error { color: red; }
        .filter-container { margin-top: 10px; }
    </style>
</head>
<body>
    <jsp:include page="Header.jsp"></jsp:include>
    <div class="container">
        <h2>Tìm kiếm gói khám</h2>
        
        <form action="SearchPackageServlet" method="get">
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
                <th>ID</th>
                <th>Tên gói</th>
                <th>Mô tả</th>
                <th>Giá (VNĐ)</th>
                <th>Thời gian (phút)</th>
                <th>Danh mục</th>
                <th>Action</th>
            </tr>
            <c:forEach var="pkg" items="${packages}">
                <tr>
                    <td>${pkg.id}</td>
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
    </c:when>
    <c:otherwise>
        <c:if test="${not empty param.keyword}">
            <p>Không tìm thấy kết quả nào.</p>
        </c:if>
    </c:otherwise>
</c:choose>
    </div>
    <jsp:include page="Footer.jsp"></jsp:include>
    </body>
</html>
