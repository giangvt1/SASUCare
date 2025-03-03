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
        <link href="${pageContext.request.contextPath}/css/admin/bootstrap.min.css" rel="stylesheet" type="text/css"/>
    <link href="${pageContext.request.contextPath}/css/admin/font-awesome.min.css" rel="stylesheet" type="text/css"/>
    <link href="${pageContext.request.contextPath}/css/admin/styleAdmin.css" rel="stylesheet" type="text/css"/>
    <style>
        .main-content {
            margin-left: 260px; /* Điều chỉnh theo sidebar */
            padding: 20px;
        }
        .pagination {
            margin: 20px 0;
        }
        table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}

th, td {
    border: 1px solid #ddd;
    padding: 8px;
    text-align: left;
}

th {
    background-color: #f4f4f4;
}

/* Pagination styles */
.pagination {
    margin-top: 20px;
    text-align: center;
}

.pagination a {
    margin: 5px;
    padding: 8px 12px;
    border: 1px solid #ddd;
    text-decoration: none;
    color: #333;
}

.pagination a.active {
    background-color: #007bff;
    color: white;
    border: 1px solid #007bff;
}

.pagination a:hover {
    background-color: #ddd;
}

.edit-btn, .delete-btn {
    padding: 5px 10px;
    text-decoration: none;
    color: white;
    border-radius: 4px;
}

.edit-btn {
    background-color: #ffc107;
}

.edit-btn:hover {
    background-color: #e0a800;
}

.delete-btn {
    background-color: #dc3545;
}

.delete-btn:hover {
    background-color: #c82333;
}

.container {
    width: 100%;
    margin-top: 20px;
}
        </style>
    </head>
    <body>
        
        
            <div class="container-fluid main-content">
                <h2>Tìm kiếm gói khám</h2>

                <form action="ManageService" method="get">
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

            <h3> </h3>
            
            <form action="ManageService" method="post">
                <input type="hidden" name="id" value="${editPackage.id}">
                <label>Name:</label>
                <input type="text" name="name" value="${editPackage.name}" required>
                <label>Description:</label>
                <input type="text" name="description" value="${editPackage.description}" required>
                <label>Price:</label>
                <input type="number" step="0.01" name="price" value="${editPackage.price}" required>
                <label>Duration:</label>
                <input type="number" name="duration" value="${editPackage.durationMinutes}" required>
                <label>Category:</label>
                <select name="category">
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat}" ${editPackage.category == cat ? 'selected' : ''}>${cat}</option>
                    </c:forEach>
                </select>
                <button type="submit">${editPackage.id == null ? 'Add' : 'Update'}</button>
            </form>

            <!-- Hiển thị lỗi nếu có -->
            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>

            <!-- Danh sách gói khám -->
            
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
                                    <a href="ManageService?page=${param.page}&action=edit&id=${pkg.id}" class="edit-btn">Edit</a> |
                                    <a href="ManageService?action=delete&id=${pkg.id}" class="delete-btn" onclick="return confirm('Bạn có chắc muốn xóa?')">Delete</a>
                                </td>                            
                            </tr>
                        </c:forEach>
                    </table>

                    <!-- Phân trang -->
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage - 1}&keyword=${param.keyword}&category=${param.category}&view=${view}" aria-label="Previous">
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
                                    <a class="page-link" href="?page=${currentPage + 1}&keyword=${param.keyword}&category=${param.category}&view=${view}" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                
                <c:otherwise>
                    <c:if test="${not empty param.keyword}">
                        <p>Không tìm thấy kết quả nào.</p>
                    </c:if>
                </c:otherwise>
            
        </div>
            <script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
          <script src="../js/main.js"></script>
        
    </body>
</html>
