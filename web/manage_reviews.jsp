<%-- 
    Document   : manage_reviews
    Created on : Mar 10, 2025, 11:59:00 AM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý Đánh giá Bác sĩ</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css">
</head>
<body>
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
                <%@ page import="java.util.List, model.Rating" %>
                <% List<Rating> ratings = (List<Rating>) request.getAttribute("ratings"); %>
                <% if (ratings != null) { %>
                    <% for (Rating rating : ratings) { %>
                        <tr>
                            <td><%= rating.getDoctorId() %></td>
                            <td><%= rating.getCustomerUsername() %></td>
                            <td><%= rating.getRating() %></td>
                            <td><%= rating.getComment() %></td>
                            <td><%= rating.getCreatedAt() %></td>
                            
                            <td>
                                
                                
                                <form action="<%= request.getContextPath() %>/managereviews" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= rating.getDoctorId() %>">
                                    <input type="hidden" name="action" value="delete">
                                    <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                <% } %>
            </tbody>
        </table>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js"></script>
</body>
</html>
