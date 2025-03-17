<%-- 
    Document   : CreateContent
    Created on : Mar 11, 2025, 10:07:03 PM
    Author     : admin
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Tạo Nội Dung</title>
    </head>
    <style>
        .formCreate {
            margin-left: 30%;
            padding-left: 50px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 8px;
            text-align: left;
            border: 1px solid #ddd;
        }

        th {
            background-color: #f4f4f4;
        }

        img {
            width: 100px; /* Giới hạn kích thước ảnh */
            height: auto;
        }

        .message {
            color: green;
        }
    </style>
    <body>
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />

        <div class="formCreate">
            <h2>Thêm Bài Viết Mới</h2>

            <% String message = (String) request.getAttribute("message"); %>
            <% if (message != null) { %>
            <p class="message"><%= message %></p>
            <% } %>

            <form action="${pageContext.request.contextPath}/createcontent" method="post" enctype="multipart/form-data">
                <label for="title">Tiêu đề:</label><br>
                <input type="text" id="title" name="title" required><br><br>

                <label for="content">Nội dung:</label><br>
                <textarea id="content" name="content" rows="5" cols="50" required></textarea><br><br>

                <label for="image">Hình ảnh:</label><br>
                <input type="file" id="image" name="image" accept="image/*" required><br><br>

                <button type="submit" name="submit">Đăng bài</button>
            </form>


            <!-- Phần hiển thị danh sách bài viết -->
            <div class="contentList">
                <h2>Danh Sách Bài Viết</h2>

                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tiêu Đề</th>
                            <th>Nội Dung</th>
                            <th>Hình Ảnh</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Lặp qua danh sách bài viết để hiển thị -->
                    <c:forEach var="content" items="${contents}">
                        <tr>
                            <td>${content.id}</td>
                            <td>${content.title}</td>
                            <td>${content.content}</td>
                            <td><img src="${content.image}" alt="image"></td>
                        </tr>
                    </c:forEach>
                      
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>

