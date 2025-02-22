<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard</title>
        <link href="../css/admin/admin_styles.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
        <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
         <script src="../js/admin_scripts.js" type="text/javascript"></script>
    </head>
    <body>
        <header class="header">
            <a href="${pageContext.request.contextPath}/admin/Dashboard.jsp" class="logo">Director</a> <%-- Corrected path --%>
            <nav class="navbar navbar-static-top" role="navigation">
                <a href="#" class="navbar-btn sidebar-toggle" data-bs-toggle="offcanvas" role="button">
                    <i class="fas fa-bars"></i>
                </a>

                <div class="navbar-right">
                    <span class="user-role">Roles:
                        <c:choose>
                            <c:when test="${not empty sessionScope.userRoles}">
                                <c:forEach var="role" items="${sessionScope.userRoles}">
                                    <span class="badge badge-info">${role}</span>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>No Roles</c:otherwise>
                        </c:choose>
                    </span>

                    <ul class="nav navbar-nav">
                        <%-- User Account Dropdown --%>
                        <li class="dropdown user user-menu">
                            <a href="#" class="dropdown-toggle" data-bs-toggle="dropdown"> <%-- Corrected data attribute --%>
                                <i class="fa fa-user"></i>
                                <span>
                                    <%
                                        model.system.User account = (model.system.User) session.getAttribute("account");
                                        if (account != null) {
                                            out.print(account.getDisplayname());
                                        } else {
                                            out.print("Guest");
                                        }
                                    %>
                                    <i class="caret"></i> <%-- This caret might need font-awesome class --%>
                                </span>
                            </a>
                            <ul class="dropdown-menu dropdown-custom dropdown-menu-right">
                                <li class="dropdown-header text-center">Account</li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/hr/edit">
                                        <i class="fa fa-clock-o fa-fw pull-right"></i> Updates
                                    </a>
                                </li>
                                <li class="divider"></li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/system/profile">
                                        <i class="fa fa-user fa-fw pull-right"></i>
                                        Profile
                                    </a>
                                </li>
                                <li class="divider"></li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/system/logout">
                                        <i class="fa fa-ban fa-fw pull-right"></i> Logout
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </nav>
        </header>

       
    </body>
</html>