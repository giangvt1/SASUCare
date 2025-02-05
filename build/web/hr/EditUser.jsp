<%-- 
    Document   : EditUser
    Created on : Feb 5, 2025, 6:09:48 PM
    Author     : acer
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Edit User</title>
        <link href="../css/admin/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <link href="../css/admin/styleAdmin.css" rel="stylesheet" type="text/css"/>
        <link href="../css/admin/font-awesome.min.css" rel="stylesheet" type="text/css"/>
        <style>
            .main-content {
                margin-top: 50px;
                margin-left: 260px;
                padding: 20px;
            }
            .alert {
                margin-top: 20px;
            }
        </style>
    </head>

    <body>
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <div class="container main-content">
            <div class="container mt-4">
                <h2>Edit User</h2>

                <!-- Hiển thị thông báo lỗi hoặc thành công -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success">${success}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <!-- Form chỉnh sửa thông tin user -->
                <form method="post" action="${pageContext.request.contextPath}/hr/edit">
                    <input type="hidden" name="username" value="${user.username}" />
                    <div class="form-group">
                        <label for="displayname">Display Name</label>
                        <input type="text" class="form-control" id="displayname" name="displayname" value="${user.displayname}" required>
                    </div>
                    <div class="form-group">
                        <label for="gmail">Email</label>
                        <input type="email" class="form-control" id="gmail" name="gmail" value="${user.gmail}" required>
                    </div>
                    <div class="form-group">
                        <label for="phone">Phone</label>
                        <input type="text" class="form-control" id="phone" name="phone" value="${user.phone}">
                    </div>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                    <a href="${pageContext.request.contextPath}/hr/accountlist" class="btn btn-secondary">Cancel</a>
                </form>
            </div>
        </div>
        <script src="../js/jquery.min.js"></script>
        <script src="../js/bootstrap.min.js"></script>
    </body>
</html>

