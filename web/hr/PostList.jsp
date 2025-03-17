<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Post List</title>
        <%-- No CSS or JS includes here, they are in AdminHeader.jsp --%>
    </head>
    <body>
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />

        <div class="right-side">
            <div class="main-content">
                <c:set var="searchValue" value="${param.search == null ? '' : param.search}"/> <%--Set searchValue--%>

                <h2>Post List</h2>

                <form method="get" action="${pageContext.request.contextPath}/hr/posts" class="mb-3">
                    <div class="input-group">
                        <input type="text" name="search" class="form-control" placeholder="Search..." value="${searchValue}">
                        <button type="submit" class="btn btn-primary">Search</button>
                        <a href="../hr/create-post" class="btn btn-secondary" style="margin-left: 6px">Create Post</a>
                    </div>
                </form>

                <div class="table-responsive"> 
                    <table class="table table-bordered table-striped">
                        <thead>
                            <tr>
                                <th>Id</th>
                                <th>Title</th>
                                <th>Image</th>
                                <th>Content</th>
                                <th>Author</th>
                                <th>Create At</th>
                                <th>Update At</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${posts}">
                                <tr>
                                    <td>${p.id}</td>
                                    <td>${p.title}</td>
                                    <td>
                                        <img src="${pageContext.request.contextPath}/${p.image}" width="100" height="100" alt="alt"/>
                                    </td>
                                    <td>${p.content}</td>
                                    <td>${p.staffName}</td>
                                    <td>${p.createdAt}</td>
                                    <td>${p.updatedAt}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.status == true}">
                                                Active
                                            </c:when>
                                            <c:otherwise>
                                                InActive
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/hr/edit-post?id=${p.id}" class="btn btn-warning btn-sm">Edit</a> <%-- Corrected Edit link --%>
                                        <a href="${pageContext.request.contextPath}/hr/delete-post?id=${p.id}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this post?')">Delete</a><%-- Corrected Delete link --%>
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
                                <a class="page-link" href="?page=${requestScope.currentPage - 1}&search=${searchValue}" aria-label="Previous">
                                    <span aria-hidden="true">«</span>
                                </a>
                            </li>
                        </c:if>
                        <c:forEach var="i" begin="1" end="${requestScope.totalPages}">

                            <li class="page-item ${i == requestScope.currentPage ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}&search=${searchValue}">${i}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${requestScope.currentPage < requestScope.totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${requestScope.currentPage + 1}&search=${searchValue}" aria-label="Next">
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