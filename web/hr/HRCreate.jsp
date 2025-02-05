<%-- 
    Document   : HRCreate
    Created on : Jan 21, 2025, 4:13:58 AM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create User Account</title>
                <link href="../css/admin/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <!-- font Awesome -->
        <link href="../css/admin/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/admin/styleAdmin.css" rel="stylesheet" type="text/css" />
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
        </style>

    </head>
    <body class="skin-black">
        <a href="../admin/AdminHeader.jsp"></a>
        <jsp:include page="../admin/AdminHeader.jsp"></jsp:include>
        <jsp:include page="../admin/AdminLeftSideBar.jsp"></jsp:include>
        <h2 style="text-align: center;">Create New Account</h2>
        <form action="/hr/create" method="POST">
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
                    <th><label for="fullname">Full Name</label></th>
                    <td><input type="text" name="fullname" id="fullname" required /></td>
                </tr>
                <tr>
                    <th><label for="gender">Gender</label></th>
                    <td>
                        <input type="radio" name="gender" value="true" id="gender-male" /> Male
                        <input type="radio" name="gender" value="false" id="gender-female" /> Female
                    </td>
                </tr>
                <tr>
                    <th><label for="email">Email</label></th>
                    <td><input type="email" name="email" id="email" required /></td>
                </tr>
                <tr>
                    <th><label for="phone">Phone Number</label></th>
                    <td><input type="tel" name="phone" id="phone" required /></td>
                </tr>
                <tr>
                    <th><label for="dob">Date of Birth</label></th>
                    <td><input type="date" name="dob" id="dob" required /></td>
                </tr>
                <tr>
                    <th><label for="address">Address</label></th>
                    <td><input type="text" name="address" id="address" required /></td>
                </tr>
                <tr>
                    <th><label for="role">Role</label></th>
                    <td>
                        <select name="role" id="role" required>
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
                <!-- Director App -->
        <script src="../js/Director/app.js" type="text/javascript"></script>

        <!-- Director dashboard demo (This is only for demo purposes) -->
        <script src="../js/Director/dashboard.js" type="text/javascript"></script>
    </body>
    
</html>

