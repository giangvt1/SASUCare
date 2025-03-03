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
        
    <jsp:include page="./admin/AdminHeader.jsp" />
    <jsp:include page="./admin/AdminLeftSideBar.jsp" />
    
        <div class="container-fluid main-content right-side">
            
        <h2>Tìm kiếm gói khám</h2>

        <!-- Form tìm kiếm gói khám -->
        <form action="ManageService" method="get">
            <input type="text" name="keyword" placeholder="Nhập từ khóa..." value="${param.keyword}">

            <!-- Bộ lọc danh mục -->
            <select name="category">
                <option value="all">Tất cả danh mục</option>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat}" ${category == cat ? 'selected' : ''}>${cat}</option>
                </c:forEach>
            </select>

            <button type="submit">Tìm kiếm</button>
        </form>

        <h3> </h3>

        <!-- Form thêm hoặc sửa gói khám -->
        <form action="ManageService" method="post">
            <input type="hidden" name="id" value="${editPackage.id}">
            
            <label for="name">Tên gói:</label>
            <input type="text" name="name" value="${editPackage.name}" required>
            
            <label for="description">Mô tả:</label>
            <input type="text" name="description" value="${editPackage.description}" required>
            
            <label for="price">Giá:</label>
            <input type="number" step="0.01" name="price" value="${editPackage.price}" required>
            
            <label for="duration">Thời gian (phút):</label>
            <input type="number" name="duration" value="${editPackage.durationMinutes}" required>

            <label for="category">Danh mục:</label>
<select name="category" required>
    <option value="">Chọn danh mục</option>
    <c:forEach var="cat" items="${categories}">
        <option value="${cat}" ${cat == editPackage.category ? 'selected' : ''}>${cat}</option>
    </c:forEach>
</select>
            <div style="display: none">
                <label for="service_id">Dịch vụ:</label>
            <select name="service_id">
                <option value="4" ${editPackage.serviceId == 4 ? 'selected' : ''}>Test</option>
                <option value="5" ${editPackage.serviceId == 5 ? 'selected' : ''}>Package</option>
                <option value="6" ${editPackage.serviceId == 6 ? 'selected' : ''}>Vaccine</option>
            </select>
            </div>
            

            <button type="submit">${editPackage.id == null ? 'Add' : 'Update'}</button>
        </form>

        <!-- Hiển thị lỗi nếu có -->
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>

        <!-- Danh sách gói khám -->
        <table>
            <thead>
                <tr>
<!--                    <th>ID</th>-->
                    <th>Tên gói</th>
                    <th>Mô tả</th>
                    <th>Giá (VNĐ)</th>
                    <th>Thời gian (phút)</th>
                    <th>Danh mục</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="pkg" items="${packages}">
                    <tr>
                        
                        <td><a href="packageDetail.jsp?id=${pkg.id}">${pkg.name}</a></td>
                        <td>${pkg.description}</td>
                        <td>${pkg.price}</td>
                        <td>${pkg.durationMinutes}</td>
                        <td>${pkg.category}</td>
                        <td>
                            <!-- Sửa gói khám -->
                            <a href="ManageService?page=${param.page}&action=edit&id=${pkg.id}" class="edit-btn">Sửa</a> |
                            <!-- Xóa gói khám -->
                            <a href="ManageService?action=delete&id=${pkg.id}" class="delete-btn" onclick="return confirm('Bạn có chắc muốn xóa?')">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- Phân trang -->
        <nav aria-label="Page navigation">
            <ul class="pagination">
                <c:if test="${currentPage > 1}">
                    <li class="page-item">
                        <a class="page-link" href="ManageService?page=${currentPage - 1}&keyword=${param.keyword}&category=${category}&view=${view}" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                </c:if>

                <c:forEach var="i" begin="1" end="${totalPages}">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link" href="ManageService?page=${i}&keyword=${param.keyword}&category=${category}&view=${view}">${i}</a>
                    </li>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <li class="page-item">
                        <a class="page-link" href="ManageService?page=${currentPage + 1}&keyword=${param.keyword}&category=${category}&view=${view}" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </c:if>
            </ul>
        </nav>

    </div>

        <script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
        <script src="../js/main.js"></script>

    </body>
</html>
