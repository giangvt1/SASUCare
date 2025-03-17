<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa Bài Đăng</title>
</head>
<body>
    <h1>Sửa Bài Đăng</h1>

    <form action="post" method="post">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" value="${editPost.id}"> <!-- Lưu ID của bài đăng -->

        <!-- Tiêu đề bài đăng -->
        <label for="title">Tiêu đề:</label>
        <input type="text" id="title" name="title" value="${editPost.title}" required><br><br>

        <!-- Nội dung bài đăng -->
        <label for="content">Nội dung:</label><br>
        <textarea id="content" name="content" rows="5" cols="40" required>${editPost.content}</textarea><br><br>

        <!-- Trạng thái bài đăng -->
        <label for="status">Trạng thái:</label>
        <select id="status" name="status">
            <option value="1" ${editPost.status ? 'selected' : ''}>Kích hoạt</option>
            <option value="0" ${!editPost.status ? 'selected' : ''}>Không kích hoạt</option>
        </select><br><br>

        <!-- Nhân viên quản lý bài đăng -->
        <label for="staffId">Nhân viên:</label>
        <select id="staffId" name="staffId" required>
            <c:forEach var="staff" items="${staffList}">
                <option value="${staff.id}" ${staff.id == editPost.staffId ? 'selected' : ''}>${staff.fullname}</option>
            </c:forEach>
        </select><br><br>

        <!-- Nút lưu thay đổi -->
        <button type="submit">Lưu thay đổi</button>
        <a href="post">Quay lại</a>
    </form>
</body>
</html>
