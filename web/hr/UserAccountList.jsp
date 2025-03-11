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
        <%-- No CSS or JS includes here, they are in AdminHeader.jsp --%>
    </head>
    <body>
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />

        <div class="right-side">
            <div class="main-content">
                <c:set var="searchValue" value="${param.search == null ? '' : param.search}"/> <%--Set searchValue--%>

                <h2>User Account List</h2>

                <form method="get" action="${pageContext.request.contextPath}/hr/accountlist" class="mb-3">
                    <div class="input-group">
                        <input type="text" name="search" class="form-control" placeholder="Search..." value="${searchValue}">
                        <button type="submit" class="btn btn-primary">Search</button>
                        <%-- Improved View Switcher Links --%>
                        <a href="?page=1&view=basic&search=${param.search}" class="btn btn-secondary">Basic View</a>
                        <a href="?page=1&view=extended&search=${param.search}" class="btn btn-secondary">Extended View</a>
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
                                                <fmt:formatDate value="${user.dob}" pattern="dd-MM-yyyy" />
                                            </c:if>
                                        </td>
                                        <td>
                                            <c:if test="${not empty user.createat}">
                                                <fmt:formatDate value="${user.createat}" pattern="dd-MM-yyyy HH:mm:ss" />
                                            </c:if>
                                        </td>
                                        <td>${user.createby}</td>
                                        <td>
                                            <c:if test="${not empty user.updateat}">
                                                <fmt:formatDate value="${user.updateat}" pattern="dd-MM-yyyy HH:mm:ss" />
                                            </c:if>
                                        </td>
                                        <td>${user.updateby}</td>
                                        <td>${user.roleName}</td>
                                    </c:if>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/hr/edit?username=${user.staffUsername}&page=${requestScope.currentPage}&view=${param.view}&search=${searchValue}" class="btn btn-warning btn-sm">Edit</a> <%-- Corrected Edit link --%>
                                        <a href="${pageContext.request.contextPath}/hr/accountlist?action=delete&username=${user.staffUsername}&page=${requestScope.currentPage}&view=${param.view}&search=${searchValue}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this user?')">Delete</a><%-- Corrected Delete link --%>

                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>


                <%-- Pagination (corrected and improved) --%>
                <%-- Pagination --%>
                <nav aria-label="Page navigation example">
                    <ul class="pagination justify-content-center">

                        <c:if test="${requestScope.currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${requestScope.currentPage - 1}&search=${searchValue}&view=${param.view}" aria-label="Previous">
                                    <span aria-hidden="true">«</span>
                                </a>
                            </li>
                        </c:if>
                        <c:forEach var="i" begin="1" end="${requestScope.totalPages}">

                            <li class="page-item ${i == requestScope.currentPage ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}&search=${searchValue}&view=${param.view}">${i}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${requestScope.currentPage < requestScope.totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${requestScope.currentPage + 1}&search=${searchValue}&view=${param.view}" aria-label="Next">
                                    <span aria-hidden="true">»</span>
                                </a>
                            </li>
                        </c:if>

                    </ul>
                </nav>

            </div> <%-- Close .main-content --%>
        </div> <%-- Close .right-side --%>

    </body>
</html>