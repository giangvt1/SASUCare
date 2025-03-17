<%-- 
    Document   : Blog
    Created on : Mar 12, 2025, 1:25:50 AM
    Author     : admin
--%>

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
        <h1>Blog</h1>
        <div class="contentList">
                <h2>Danh Sách Bài Viết</h2>

                <table>
                    <c:if test="${empty contents}">
    <p>Không có bài viết nào để hiển thị.</p>
</c:if>
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
    </body>
</html>


