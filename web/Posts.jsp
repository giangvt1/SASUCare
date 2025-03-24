<%-- 
    Document   : service.jsp
    Created on : Jan 31, 2025, 9:34:20 AM
    Author     : admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Posts Page</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f4f4f4;
            }
            .container {
                max-width: 1200px;
                margin: auto;
                padding: 20px;
            }
            .heading {
                text-align: center;
                margin-bottom: 40px;
            }
            .card {
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                margin: 20px;
                overflow: hidden;
                transition: transform 0.3s;
                flex: 1 1 calc(33% - 40px);
                max-width: calc(33% - 40px);
            }
            .card:hover {
                transform: scale(1.05);
            }
            .card img {
                width: 100%;
                height: auto;
            }
            .card-content {
                padding: 20px;
                text-align: center;
            }
            .card-content h3 {
                margin: 0 0 10px;
            }
            .more {
                color: #007bff;
                text-decoration: none;
            }
            .grid {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
            }
        </style>

    </head>
    <body>
        <jsp:include page="Header.jsp"></jsp:include>

            <div class="grid">

                <div class="container-fluid py-5">
                    <div class="container">
                        <div class="text-center mx-auto mb-5" style="max-width: 500px">
                            <h5
                                class="d-inline-block text-primary text-uppercase border-bottom border-5"
                                >
                                Blog Post
                            </h5>
                            <h1 class="display-4">Our Medical Blog Posts</h1>
                        </div>
                        <form method="get" action="${pageContext.request.contextPath}/posts" class="mb-3" style="width: 30%; margin: 0 auto">
                    <div class="input-group">
                        <input type="text" name="search" class="form-control" placeholder="Search..." value="${searchValue}">
                        <button type="submit" class="btn btn-primary">Search</button>
                    </div>
                </form>
                        <div class="row g-5">
                        <c:forEach items="${posts}" var="p">
                            <div class="col-xl-4 col-lg-6">
                                <div class="bg-light rounded overflow-hidden">
                                    <img class="img-fluid w-100" src="${p.image}" alt="Post image" />
                                    <div class="p-4">
                                        <a class="h3 d-block mb-3" href="#"
                                           >${p.title}</a
                                        >
                                        <p class="m-0">
                                            ${p.content}
                                        </p>
                                    </div>
                                    <div class="d-flex justify-content-between border-top p-4">
                                        <div class="d-flex align-items-center">
                                            <img
                                                class="rounded-circle me-2"
                                                src="img/user.jpg"
                                                width="25"
                                                height="25"
                                                alt=""
                                                />
                                            <small>${p.staffName}</small>
                                        </div>
                                        <div class="d-flex align-items-center">
                                            <small class="ms-3"
                                                   ><i class="far fa-eye text-primary me-1"></i>12345</small
                                            >
                                            <small class="ms-3"
                                                   ><i class="far fa-comment text-primary me-1"></i>123</small
                                            >
                                        </div>
                                        <a href="${pageContext.request.contextPath}/post-detail?id=${p.id}" class="btn btn-info btn-sm">View Detail</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
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

        </div>
        <jsp:include page="Footer.jsp"></jsp:include>
        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/waypoints/waypoints.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>
        <script src="lib/tempusdominus/js/moment.min.js"></script>
        <script src="lib/tempusdominus/js/moment-timezone.min.js"></script>
        <script src="lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>
    </body>
</html>
