<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Account List</title>
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
            <input type="text" name="search" class="form-control mr-2" placeholder="Search username, displayname or fullname" value="">
            <button type="submit" class="btn btn-primary">Search</button>
            <!-- View switcher -->
            <a href="?view=basic&search=${search}" class="btn btn-secondary ml-2">Basic View</a>
            <a href="?view=extended&search=${search}" class="btn btn-secondary ml-2">Extended View</a>
        </form>
        
        <!-- User Table -->
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>Staff Username</th>
                    <th>Full Name</th>
                    <th>Display Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Gender</th>
                    <c:if test="${view eq 'extended'}">
                        <th>Date of Birth</th>
                        <th>Create At</th>
                        <th>Create By</th>
                        <th>Update At</th>
                        <th>Update By</th>
                        <th>Role</th>
                    </c:if>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="user" items="${listUser}">
                    <tr>
                        <td>${user.staffUsername}</td>
                        <td>${user.fullname}</td>
                        <td>${user.displayname}</td>
                        <td>${user.gmail}</td>
                        <td>${user.phone}</td>
                        <td>
                            <c:choose>
                                <c:when test="${user.gender}">
                                    Male
                                </c:when>
                                <c:otherwise>
                                    Female
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <c:if test="${view eq 'extended'}">
                            <td>
                                <c:if test="${not empty user.dob}">
                                    <fmt:formatDate value="${user.dob}" pattern="yyyy-MM-dd" />
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${not empty user.createat}">
                                    <fmt:formatDate value="${user.createat}" pattern="yyyy-MM-dd HH:mm:ss" />
                                </c:if>
                            </td>
                            <td>${user.createby}</td>
                            <td>
                                <c:if test="${not empty user.updateat}">
                                    <fmt:formatDate value="${user.updateat}" pattern="yyyy-MM-dd HH:mm:ss" />
                                </c:if>
                            </td>
                            <td>${user.updateby}</td>
                            <td>${user.roleName}</td>
                        </c:if>
                        <td>
                            <a href="${pageContext.request.contextPath}/hr/edit?username=${user.staffUsername}" class="btn btn-warning btn-sm">Edit</a>
                            <a href="${pageContext.request.contextPath}/hr/accountlist?action=delete&username=${user.staffUsername}" 
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
                        <a class="page-link" href="?page=${currentPage - 1}&search=${search}&view=${view}" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                </c:if>
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link" href="?page=${i}&search=${search}&view=${view}">${i}</a>
                    </li>
                </c:forEach>
                <c:if test="${currentPage < totalPages}">
                    <li class="page-item">
                        <a class="page-link" href="?page=${currentPage + 1}&search=${search}&view=${view}" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </c:if>
            </ul>
        </nav>
    </div>
    
    <script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
</body>
</html>
