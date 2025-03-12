<%-- 
    Document   : TestPackages
    Created on : Feb 10, 2025, 3:37:14 AM
    Author     : admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
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
        <h2>Test Packages</h2>
        <div class="container">

    
    <!-- FORM TÌM KIẾM -->
        <form action="TestPackage" method="get" class="form-container">
            <input type="text" name="keyword" placeholder="Nhập từ khóa..." value="${keyword}" />
            <select name="category">
                <option value="all">Tất cả danh mục</option>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat}" ${selectedCategory == cat ? 'selected' : ''}>${cat}</option>
                </c:forEach>
            </select>
            <button type="submit">Tìm kiếm</button>
        </form>

        <!-- FORM THÊM GÓI XÉT NGHIỆM -->
        <h3> </h3>
        <form action="TestPackage" method="post" class="form-container">
            <input type="hidden" name="action" value="add">
            <input type="text" name="name" placeholder="Tên gói" required>
            <input type="text" name="description" placeholder="Mô tả">
            <input type="number" step="0.01" name="price" placeholder="Giá" required>
            <input type="number" name="duration" placeholder="Thời gian (phút)" required>
            <select name="category">
                <option value="">Chọn danh mục</option>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat}">${cat}</option>
                </c:forEach>
            </select>
            <button type="submit">Thêm</button>
        </form>

        <!-- DANH SÁCH GÓI XÉT NGHIỆM -->
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên Gói</th>
                    <th>Mô Tả</th>
                    <th>Giá</th>
                    <th>Thời Gian</th>
                    <th>Danh Mục</th>
                    <th>Hành Động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="test" items="${tests}">
                    <tr>
                        <td>${test.id}</td>
                        <td>${test.name}</td>
                        <td>${test.description}</td>
                        <td>${test.price}</td>
                        <td>${test.duration_minutes}</td>
                        <td>${test.category}</td>
                        <td>
                            <a href="TestPackage?action=edit&id=${test.id}" class="edit-btn">Sửa</a> |
                            <a href="TestPackage?action=delete&id=${test.id}" class="delete-btn" onclick="return confirm('Bạn có chắc muốn xóa?')">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <c:if test="${empty tests}">
            <p>Không tìm thấy gói xét nghiệm nào.</p>
        </c:if>
    </div>
    <jsp:include page="Footer.jsp"></jsp:include>
    </body>
</html>
