<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">


        <title>Create User Account</title>
        <link href="../css/admin/styleAdmin.css" rel="stylesheet" type="text/css"/>
        <link href="../css/admin/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <link href="../css/admin/font-awesome.min.css" rel="stylesheet" type="text/css"/>
        <style>
            table {
                width: 50%;
                margin: 20px auto;
                border-collapse: collapse;
            }
            td {
                padding: 10px;
                text-align: left;
            }
            th {
                text-align: left;
            }
            input[type="text"], input[type="password"], input[type="email"], input[type="tel"], select {
                width: 100%;
                padding: 8px;
                margin: 5px 0;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
            button {
                padding: 10px 15px;
                background-color: #4CAF50;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
            button:hover {
                background-color: #45a049;
            }
            .alert {
                padding: 10px;
                margin: 15px;
                border-radius: 5px;
                text-align: center;
            }
            .alert-success {
                background-color: #4CAF50;
                color: white;
            }
            .alert-danger {
                background-color: #f44336;
                color: white;
            }
        </style>
    </head>
    <body>
        <jsp:include page="../admin/AdminHeader.jsp"></jsp:include>
        <jsp:include page="../admin/AdminLeftSideBar.jsp"></jsp:include>


            <h2 style="text-align: center;">Create New Account</h2>

            <!-- Hiển thị thông báo thành công hoặc lỗi -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>

        <form action="../hr/create" method="POST">
            <table>
                <tr>
                    <th><label for="username">Username</label></th>
                    <td><input type="text" name="username" id="username" required /></td>
                </tr>
                <tr>
                    <th><label for="password">Password</label></th>
                    <td><input type="password" name="password" id="password" required /></td>
                </tr>
                <tr>
                    <th><label for="displayname">Full Name</label></th>
                    <td><input type="text" name="displayname" id="displayname" required /></td>
                </tr>
                <tr>
                    <th><label for="gmail">Email</label></th>
                    <td><input type="email" name="gmail" id="gmail" required /></td>
                </tr>
                <tr>
                    <th><label for="phone">Phone Number</label></th>
                    <td><input type="tel" name="phone" id="phone" required /></td>
                </tr>
                <tr>
                    <th><label for="roles">Role</label></th>
                    <td>
                        <select name="roles" id="roles" multiple required>
                            <c:forEach var="r" items="${role}">
                                <option value="${r.id}">${r.name}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
            </table>

            <div style="text-align: center;">
                <button type="submit">Create Account</button>
            </div>
        </form>

        <!-- jQuery 2.0.2 -->
        <script src="../js/jquery.min.js" type="text/javascript"></script>
        <!-- Bootstrap -->
        <script src="../js/bootstrap.min.js" type="text/javascript"></script>
        <script src="../js/main.js" type="text/javascript"></script>
    </body>
</html>
