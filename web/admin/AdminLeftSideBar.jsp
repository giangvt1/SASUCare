<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Sidebar</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <aside class="left-side sidebar-offcanvas">
        <!-- Sidebar -->
        <section class="sidebar">
            <!-- User panel -->
            <div class="user-panel">
                <div class="pull-left image">
                    <img src="../img/meoomdau.jpg" class="img-circle" alt="User Image" />
                </div>
                <div class="pull-left info">
                    <p>Hello, 
                        <c:choose>
                            <c:when test="${not empty sessionScope.account}">
                                ${sessionScope.account.displayname}
                            </c:when>
                            <c:otherwise>Guest</c:otherwise>
                        </c:choose>
                    </p>
                    <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
                </div>
            </div>
            
            <!-- Lấy danh sách URL được phép từ session -->
            <c:set var="allowedUrls" value="${sessionScope.allowedUrls}" />
            
            
            <!-- Sidebar menu -->
            <ul class="sidebar-menu">
                <!-- Dashboard (hiển thị luôn) -->
                <li class="active">
                    <a href="../admin/Dashboard.jsp">
                        <i class="fa fa-dashboard"></i> <span>Dashboard</span>
                    </a>
                </li>
                <!-- Hiển thị Create Account nếu URL '/hr/create' nằm trong allowedUrls -->
                <c:if test="${allowedUrls != null and allowedUrls.contains('/hr/create')}">
                    <li>
                        <a href="../hr/create">
                            <i class="fa fa-user-plus"></i> <span>Create Account</span>
                        </a>
                    </li>
                </c:if>
                <!-- Hiển thị Account List nếu URL '/hr/accountlist' nằm trong allowedUrls -->
                <c:if test="${allowedUrls != null and allowedUrls.contains('/hr/accountlist')}">
                    <li>
                        <a href="../hr/accountlist">
                            <i class="fa fa-globe"></i> <span>Account List</span>
                        </a>
                    </li>
                </c:if>
                <!-- Hiển thị Doctor Calendar nếu URL '/hr/calendarmanage' nằm trong allowedUrls -->
                <c:if test="${allowedUrls != null and allowedUrls.contains('/hr/calendarmanage')}">
                    <li>
                        <a href="../hr/calendarmanage">
                            <i class="fa fa-table"></i> <span>Doctor Calendar</span>
                        </a>
                    </li>
                </c:if>
                <!-- Các mục menu khác có thể được thêm theo cùng cách -->
            </ul>
        </section>
        <!-- /.sidebar -->
    </aside>
</body>
</html>
