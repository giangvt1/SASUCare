<%-- 
    Document   : UserAccountList
    Created on : Feb 5, 2025, 5:55:54 PM
    Author     : acer
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>User Account List</title>
        <link href="../css/admin/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <link href="../css/admin/styleAdmin.css" rel="stylesheet" type="text/css"/>
        <style>
            .main-content {
                margin-left: 260px; /* Điều chỉnh theo sidebar */
                padding: 20px;
            }
            .pagination {
                margin: 20px 0;
            }
        </style>
    </head>
    <body>
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />

        <div class="container-fluid main-content">
            <h2>User Account List</h2>

            <!-- Search Form -->
            <form method="get" action="${pageContext.request.contextPath}/hr/accountlist" class="form-inline mb-3">
                <input type="text" name="search" class="form-control mr-2" value="${search}" placeholder="Search username or email">
                <button type="submit" class="btn btn-primary">Search</button>
            </form>

            <!-- User Table -->
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Username</th>
                        <th>Display Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${listUser}">
                        <tr>
                            <td>${user.username}</td>
                            <td>${user.displayname}</td>
                            <td>${user.gmail}</td>
                            <td>${user.phone}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/hr/edit?username=${user.username}" class="btn btn-warning btn-sm">Edit</a>
                                <a href="${pageContext.request.contextPath}/hr/accountlist?action=delete&username=${user.username}" 
                                   class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this user?')">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Pagination -->
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage - 1}&search=${search}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="?page=${i}&search=${search}">${i}</a>
                        </li>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage + 1}&search=${search}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </div>

        <script src="../js/jquery.min.js"></script>
        <script src="../js/bootstrap.min.js"></script>
    </body>
</html>
