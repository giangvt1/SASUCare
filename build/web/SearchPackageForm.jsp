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
    
 <title>Quản lý Gói Khám</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .container { width: 70%; margin: 0 auto; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f4f4f4; }
        .form-container { margin-top: 20px; padding: 10px; border: 1px solid #ddd; }
    </style>
</head>
<body>
    <jsp:include page="Header.jsp"></jsp:include>
    <div class="container">
        <h2>Quản lý Gói Khám</h2>

        <!-- Form tìm kiếm -->
        <form action="ManageService" method="get">
            <input type="text" name="keyword" placeholder="Nhập từ khóa..." value="${param.keyword}">
            <select name="category">
                <option value="all">Tất cả danh mục</option>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat}" ${param.category == cat ? 'selected' : ''}>${cat}</option>
                </c:forEach>
            </select>
            <button type="submit">Tìm kiếm</button>
        </form>
            <!-- Form thêm/sửa gói khám -->
        <div class="form-container">
            <h3><c:if test="${empty editPackage}">Thêm Gói Khám</c:if><c:if test="${not empty editPackage}">Chỉnh Sửa Gói Khám</c:if></h3>
            <form action="ManageService" method="post">
                <input type="hidden" name="id" value="${editPackage.id}">
                <input type="text" name="name" placeholder="Tên gói khám" value="${editPackage.name}" required>
                <textarea name="description" placeholder="Mô tả" required>${editPackage.description}</textarea>
                <input type="number" name="price" placeholder="Giá" value="${editPackage.price}" required>
                <input type="number" name="duration" placeholder="Thời gian (phút)" value="${editPackage.durationMinutes}" required>
                <select name="category" required>
            <option value="">-- Chọn danh mục --</option>
            <c:forEach var="cat" items="${categories}">
                <option value="${cat}" ${editPackage.category == cat ? 'selected' : ''}>${cat}</option>
            </c:forEach>
        </select>
                <button type="submit">${editPackage.id == null ? 'Add' : 'Update'}</button>

        <!-- Hiển thị lỗi nếu có -->
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>

        <!-- Hiển thị danh sách gói khám -->
        <table>
            <tr>
                <th>ID</th>
                <th>Tên</th>
                <th>Mô tả</th>
                <th>Giá</th>
                <th>Thời gian (phút)</th>
                <th>Danh mục</th>
                <th>Hành động</th>
            </tr>
            <c:forEach var="pkg" items="${packages}">
                <tr>
                    <td>${pkg.id}</td>
                    <td>${pkg.name}</td>
                    <td>${pkg.description}</td>
                    <td>${pkg.price}</td>
                    <td>${pkg.durationMinutes}</td>
                    <td>${pkg.category}</td>
                    <td>
                        <a href="ManageService?action=edit&id=${pkg.id}">Sửa</a> |
                        <a href="ManageService?action=delete&id=${pkg.id}" onclick="return confirm('Bạn có chắc muốn xóa?');">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
        </table>

        

                
                
            </form>
                
                
        </div>
                <nav aria-label="Page navigation">
            <ul class="pagination">
                <c:if test="${currentPage > 1}">
                    <li class="page-item">
                        <a class="page-link" href="?page=${currentPage - 1}&search=${search}&view=${view}" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                </c:if>
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link" href="?page=${i}&search=${search}&view=${view}">${i}</a>
                    </li>
                </c:forEach>
                <c:if test="${currentPage < totalPages}">
                    <li class="page-item">
                        <a class="page-link" href="?page=${currentPage + 1}&search=${search}&view=${view}" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </c:if>
            </ul>
        </nav>
    </div>
    <jsp:include page="Footer.jsp"></jsp:include>
    </body>
</html>
