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
            :root {
                --primary-blue: #3498db;
                --dark-bg: #2c3e50;
                --success-green: #27ae60;
                --danger-red: #e74c3c;
                --warning-yellow: #f1c40f;
                --text-dark: #2c3e50;
                --text-light: #ecf0f1;
                --border-color: #bdc3c7;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f5f6fa;
                margin: 0;
                padding: 0;
            }

            /* Main Content Area */
            .main-content {
                margin-left: 260px;
                padding: 20px;
                transition: margin-left 0.3s;
            }

            /* Header Styling */
            h2 {
                color: var(--text-dark);
                font-size: 24px;
                margin-bottom: 25px;
                padding-bottom: 10px;
                border-bottom: 2px solid var(--primary-blue);
            }

            /* Search Form */
            .search-form {
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-bottom: 20px;
                display: flex;
                gap: 10px;
                align-items: center;
                flex-wrap: wrap;
            }

            input[type="text"],
            input[type="number"],
            select {
                padding: 10px 15px;
                border: 1px solid var(--border-color);
                border-radius: 4px;
                margin-right: 10px;
                font-size: 14px;
                min-width: 200px;
                transition: border-color 0.3s;
            }

            input[type="text"]:focus,
            input[type="number"]:focus,
            select:focus {
                border-color: var(--primary-blue);
                outline: none;
                box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
            }

            button {
                background-color: var(--primary-blue);
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            button:hover {
                background-color: #2980b9;
            }

            /* Stats Cards */
            .stats-container {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .stat-card {
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .stat-card h3 {
                margin: 0;
                color: var(--text-dark);
                font-size: 16px;
            }

            .stat-card .value {
                font-size: 24px;
                font-weight: bold;
                color: var(--primary-blue);
                margin-top: 10px;
            }

            /* Table Styling */
            table {
                width: 100%;
                background: white;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-top: 20px;
            }

            th {
                background-color: var(--primary-blue);
                color: white;
                padding: 15px;
                text-align: left;
                font-weight: 500;
            }

            td {
                padding: 12px 15px;
                border-bottom: 1px solid var(--border-color);
            }

            tr:hover {
                background-color: #f8f9fa;
            }

            /* Action Buttons */
            .edit-btn, .delete-btn {
                padding: 6px 12px;
                border-radius: 4px;
                text-decoration: none;
                font-size: 14px;
                transition: all 0.3s;
                display: inline-block;
                margin: 0 4px;
            }

            .edit-btn {
                background-color: var(--warning-yellow);
                color: var(--text-dark);
            }

            .delete-btn {
                background-color: var(--danger-red);
                color: white;
            }

            .edit-btn:hover {
                background-color: #d4ac0d;
            }

            .delete-btn:hover {
                background-color: #c0392b;
            }

            /* Package Form */
            .package-form {
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-top: 20px;
            }

            .form-group {
                margin-bottom: 15px;
            }

            label {
                display: block;
                margin-bottom: 5px;
                color: var(--text-dark);
                font-weight: 500;
            }

            /* Pagination */
            .pagination {
                display: flex;
                justify-content: center;
                gap: 5px;
                margin-top: 20px;
            }

            .pagination .page-item .page-link {
                padding: 8px 16px;
                border: 1px solid var(--border-color);
                color: var(--text-dark);
                background: white;
                text-decoration: none;
                border-radius: 4px;
                transition: all 0.3s;
            }

            .pagination .page-item.active .page-link {
                background-color: var(--primary-blue);
                color: white;
                border-color: var(--primary-blue);
            }

            .pagination .page-item .page-link:hover {
                background-color: #f8f9fa;
            }

            /* Error Messages */
            .error {
                color: var(--danger-red);
                background-color: #fde8e8;
                padding: 10px;
                border-radius: 4px;
                margin: 10px 0;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .main-content {
                    margin-left: 0;
                }

                .search-form {
                    flex-direction: column;
                }

                input[type="text"],
                input[type="number"],
                select {
                    width: 100%;
                    margin-right: 0;
                }

                table {
                    display: block;
                    overflow-x: auto;
                }
            }
        </style>
    </head>
    <body>

        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        

        <div class="container-fluid main-content right-side">

            <h2>Tìm kiếm gói khám</h2>

            <!-- Form tìm kiếm gói khám -->
            <form action="${pageContext.request.contextPath}/ManageService" method="get">
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
            <form action="${pageContext.request.contextPath}/ManageService" method="post">
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
