<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Account List</title>
    </head>
    <body>
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />

        <div class="right-side">
            <div class="main-content">
                <h2>User Account List</h2>
                <form method="get" action="${pageContext.request.contextPath}/admin/accountlist" class="mb-3">
                    <div class="input-group">
                        <input type="text" name="search" class="form-control" placeholder="Search..." value="${search}">
                        <button type="submit" class="btn btn-primary">Search</button>

                        <!-- View mode switch -->
                        <div class="btn-group">
                            <a href="?page=1&pageSize=${pageSize}&view=basic&search=${search}" 
                               class="btn ${view == 'basic' ? 'btn-primary' : 'btn-secondary'}">Basic View</a>
                            <a href="?page=1&pageSize=${pageSize}&view=extended&search=${search}" 
                               class="btn ${view == 'extended' ? 'btn-primary' : 'btn-secondary'}">Extended View</a>
                        </div>
                    </div>
                    <select name="pageSize" onchange="this.form.submit()">
                        <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                        <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                        <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                        <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                    </select>
                    <input type="hidden" name="page" value="1">
                </form>

                <div class="table-responsive">
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
                                            <c:when test="${user.gender}">Male</c:when>
                                            <c:otherwise>Female</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <c:if test="${view eq 'extended'}">
                                        <td><fmt:formatDate value="${user.dob}" pattern="yyyy-MM-dd" /></td>
                                        <td><fmt:formatDate value="${user.createat}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                        <td>${user.createby}</td>
                                        <td><fmt:formatDate value="${user.updateat}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                        <td>${user.updateby}</td>
                                        <td>${user.roleName}</td>
                                    </c:if>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/edit?username=${user.staffUsername}&page=${requestScope.currentPage}&view=${param.view}&search=${searchValue}" class="btn btn-warning btn-sm">Edit</a>
                                        <a href="?action=delete&page=${currentPage}&pageSize=${pageSize}&view=${view}&search=${search}&username=${user.staffUsername}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this user?')">Delete</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center">
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage - 1}&pageSize=${pageSize}&search=${search}&view=${view}" aria-label="Previous">
                                    <span aria-hidden="true">«</span>
                                </a>
                            </li>
                        </c:if>

                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}&pageSize=${pageSize}&search=${search}&view=${view}">${i}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage + 1}&pageSize=${pageSize}&search=${search}&view=${view}" aria-label="Next">
                                    <span aria-hidden="true">»</span>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>

            </div>
        </div>
    </body>
</html>
