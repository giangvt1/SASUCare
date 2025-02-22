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
        <%-- ALL CSS and JS includes are now in AdminHeader.jsp --%>
    </head>
    <body>
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />

        <div class="right-side"> <%-- Essential for layout --%>
            <div class="main-content"> <%-- Main content container --%>
                <h2>User Account List</h2>

                <form method="get" action="${pageContext.request.contextPath}/hr/accountlist" class="mb-3">
                    <div class="input-group">
                        <input type="text" name="search" class="form-control" placeholder="Search..." value="${param.search}">
                        <button type="submit" class="btn btn-primary">Search</button>
                        <a href="?page=${currentPage}&view=basic&search=${param.search}" class="btn btn-secondary">Basic View</a>
                        <a href="?page=${currentPage}&view=extended&search=${param.search}" class="btn btn-secondary">Extended View</a>
                    </div>
                </form>

                <div class="table-responsive"> <%-- For responsive table --%>
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
                </div>


                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage - 1}&search=${param.search}&view=${param.view}" aria-label="Previous">
                                    <span aria-hidden="true">«</span>
                                </a>
                            </li>
                        </c:if>

                        <%-- Pagination numbers --%>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}&search=${param.search}&view=${param.view}">${i}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage + 1}&search=${param.search}&view=${param.view}" aria-label="Next">
                                    <span aria-hidden="true">»</span>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav> <%-- Close pagination nav --%>
            </div> <%-- Close .main-content --%>
        </div> <%-- Close .right-side --%>
    </body>
</html>
