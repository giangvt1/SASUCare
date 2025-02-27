<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">  
        <title>Admin Sidebar</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            /* Sidebar styles */
            .sidebar {
                background: #222d32;
                color: #b8c7ce;
                min-height: 100vh;
                padding: 15px;
                font-family: 'Arial', sans-serif;
            }
            .user-panel {
                margin-bottom: 15px;
                padding-bottom: 15px;
                border-bottom: 1px solid #4b646f;
                display: flex;
                align-items: center;
            }
            .user-panel .image img {
                width: 45px;
                height: 45px;
                border-radius: 50%;
            }
            .user-panel .info {
                margin-left: 10px;
            }
            .user-panel .info p {
                margin: 0;
                font-weight: bold;
                color: #fff;
            }
            .user-panel .info a {
                color: #00a65a;
                font-size: 12px;
                text-decoration: none;
            }
            .sidebar-menu {
                list-style: none;
                padding: 0;
                margin: 0;
            }
            .sidebar-menu li {
                margin-bottom: 8px;
            }
            .sidebar-menu li a {
                color: #b8c7ce;
                display: block;
                padding: 10px 15px;
                border-radius: 3px;
                text-decoration: none;
                transition: background 0.3s;
            }
            .sidebar-menu li a:hover,
            .sidebar-menu li.active a {
                background: #1e282c;
                color: #fff;
            }
            .sidebar-menu li a i {
                margin-right: 10px;
            }
        </style>
    </head>
    <body>
        <aside class="left-side sidebar-offcanvas">
            <!-- Sidebar -->
            <section class="sidebar">
                <!-- User panel -->
                <div class="user-panel">
                    <div class="image">
                        <c:choose>
                            <c:when test="${not empty sessionScope.staff and not empty sessionScope.staff.img}">
                                <img src="${pageContext.request.contextPath}/${sessionScope.staff.img}" class="img-circle" alt="User Image" />
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/img/default-profile.jpg" class="img-circle" alt="User Image" />
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="info">
                        <p>
                            Hello, 
                            <c:choose>
                                <c:when test="${not empty sessionScope.account}">
                                    ${sessionScope.account.displayname}
                                </c:when>
                                <c:otherwise>
                                    Guest
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
                    </div>
                </div>

<<<<<<< Updated upstream
                <!-- Lấy danh sách URL được phép từ session -->
                <c:set var="allowedUrls" value="${sessionScope.allowedUrls}" />

<<<<<<< Updated upstream
                <!-- Sidebar menu -->
                <ul class="sidebar-menu">
                    <!-- Dashboard luôn hiển thị -->
                    <li class="active">
                        <a href="${pageContext.request.contextPath}/admin/Dashboard.jsp">
                            <i class="fa fa-dashboard"></i> <span>Dashboard</span>
                        </a>
                    </li>

                    <!-- Nếu user có vai trò HR -->
                    <c:if test="${allowedUrls != null and allowedUrls.contains('/hr/create')}">
                        <li>
                            <a href="../hr/create">
                                <i class="fa fa-user-plus"></i> <span>Create Account</span>
                            </a>
                        </li>
                        <li>
                            <a href="../hr/accountlist">
                                <i class="fa fa-globe"></i> <span>Account List</span>
                            </a>
                        </li>
                        <li>
                            <a href="../hr/calendarmanage">
                                <i class="fa fa-table"></i> <span>Doctor Calendar</span>
                            </a>
                        </li>
                        <li>
                            <a href="../ManageService">
                                <i class="fa fa-table"></i> <span>Add ServicePackage</span>
                            </a>
                        </li>
                    </c:if>
=======
=======
<aside class="left-side sidebar-offcanvas">
    <section class="sidebar">
        <!-- User panel -->
        <div class="user-panel">
            <div class="image">
                <c:choose>
                    <c:when test="${not empty sessionScope.staff and not empty sessionScope.staff.img}">
                        <img src="${pageContext.request.contextPath}/${sessionScope.staff.img}" class="img-circle" alt="User Image" />
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/img/default-profile.jpg" class="img-circle" alt="User Image" />
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="info">
                <p>
                    Hello,
                    <c:choose>
                        <c:when test="${not empty sessionScope.account}">
                            ${sessionScope.account.displayname}
                        </c:when>
                        <c:otherwise>
                            Guest
                        </c:otherwise>
                    </c:choose>
                </p>
                <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
            </div>
        </div>
>>>>>>> Stashed changes
        <!-- Sidebar menu -->
        <ul class="sidebar-menu">
            <li class="active">
                <a href="${pageContext.request.contextPath}/admin/Dashboard.jsp">
                    <i class="fa fa-dashboard"></i> <span>Dashboard</span>
                </a>
            </li>
            <c:if test="${sessionScope.allowedUrls != null && sessionScope.allowedUrls.contains('/hr/create')}">
                <li>
                    <a href="${pageContext.request.contextPath}/hr/create">
                        <i class="fa fa-user-plus"></i> <span>Create Account</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/hr/accountlist">
                        <i class="fa fa-globe"></i> <span>Account List</span>
                    </a>
                </li>

                <li>
                    <a href="${pageContext.request.contextPath}/hr/calendarmanage">
                        <i class="fa fa-table"></i> <span>Doctor Calendar</span>
                    </a>
                </li>
                <li>
                    <a href="../ManageService">
                        <i class="fa fa-table"></i> <span>Add ServicePackage</span>
                    </a>
                </li>
            </c:if>
>>>>>>> Stashed changes

                    <!-- Nếu user có vai trò Doctor -->
                    <c:if test="${allowedUrls != null and (allowedUrls.contains('/doctor/SendApplication.jsp') or allowedUrls.contains('/doctor/ManageMedical.jsp'))}">
                        <li>
                            <a href="../doctor/ViewApplication?did=16">
                                <i class="fa fa-envelope"></i> <span>Manage Application</span>
                            </a>
                        </li>
                        <li>
                            <a href="../doctor/SearchCustomer?page=1&sort=default&size=10">
                                <i class="fa fa-medkit"></i> <span>Manage Medical</span>
                            </a>
                        </li>
                        <li>
                            <a href="../doctor/waiting-appointment">
                                <i class="fa fa-medkit"></i> <span>Appoinment</span>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </section>
            <!-- /.sidebar -->
        </aside>
    </body>
</html>
