<%-- 
    Document   : AdminLogin
    Created on : 20 thg 1, 2025, 22:06:28
    Author     : TRUNG
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
        <link rel="stylesheet" href="../css/admin/loginAdminStyle.css" />
        <link rel="stylesheet" href="../css/bootstrap.min.css" />
    </head>
    <body class="bg-primary">
        <div class="admin-login">
            <div class="admin-login-container d-flex">
                <div class="left-side"><img src="../img/adminLogin1.png" alt="login" /></div>
                <div class="right-side">
                    <%
                        String errorMessage = (String) request.getAttribute("errorMessage");
                        if (errorMessage != null) {
                    %>
                    <div class="alert alert-danger" role="alert">
                        <%= errorMessage %>
                    </div>
                    <%
                        }
                    %>
                    <form action="<%= request.getContextPath() %>/system/login" method="POST" class="form-admin-login"> 
                        <h1>Login to Dashboard</h1>
                        <table class="mt-4 mb-4">
                            <tbody>
                                <tr>
                                    <td><b>Username</b></td>
                                </tr>
                                <tr>
                                    <td>
                                        <input class="input" type="text" name="username" placeholder="Enter username" required />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="pt-4"><b>Password</b></td>
                                </tr>
                                <tr>
                                    <td>
                                        <input class="input" type="password" name="password" placeholder="Enter password" required />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="text-end pt-2">
                                        <a href="#!">Forgot Password</a>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <button class="button mt-4" type="submit">Login</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>