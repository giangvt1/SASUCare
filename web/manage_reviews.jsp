<%-- 
    Document   : manage_reviews
    Created on : Mar 10, 2025, 11:59:00 AM
    Author     : admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý Đánh giá Bác sĩ</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css">
    </head>
    <body>
        <h1>Quản lý Đánh giá Bác sĩ</h1>
        <div class="container mt-4">
            <h2 class="text-center">Quản lý Đánh giá Bác sĩ</h2>

            <table class="table table-bordered">
                <thead class="thead-dark">
                    <tr>
                        <th>#</th>
                        <th>Người đánh giá</th>
                        <th>Đánh giá</th>
                        <th>Bình luận</th>
                        <th>Ngày</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="rating" items="${ratings}">
                    <tr>
                        <td>${rating.doctorId}</td>
                        <td>${rating.customerUsername}</td>
                        <td>${rating.rating}</td>
                        <td>${rating.comment}</td>
                        <td>${rating.createdAt}</td>
                        <td>${rating.createdAt}</td>
                        <td>
                            ${rating.visible == 1 ? 'Hiển thị' : 'Ẩn'}
                        </td>
                        <td>
                            <!-- Xóa đánh giá -->
                            <form action="${pageContext.request.contextPath}/managereviews" method="post" style="display:inline;">
                                <input type="hidden" name="id" value="${rating.doctorId}">
                                <input type="hidden" name="username" value="${rating.customerUsername}">
                                <input type="hidden" name="action" value="delete">
                                <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                            </form>
                            <!-- Thay đổi trạng thái hiển thị -->
                            <form action="${pageContext.request.contextPath}/managereviews" method="post" style="display:inline;">
                                <input type="hidden" name="id" value="${rating.doctorId}">
                                <input type="hidden" name="username" value="${rating.customerUsername}">
                                <input type="hidden" name="visible" value="${rating.visible == 1 ? '0' : '1'}">
                                <input type="hidden" name="action" value="toggleVisibility">
                                <button type="submit" class="btn btn-warning btn-sm">
                                    ${rating.visible == 1 ? 'Ẩn' : 'Hiển thị'}
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js"></script>
    </body>
</html>
