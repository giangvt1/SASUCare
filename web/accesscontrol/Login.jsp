<%-- 
    Document   : Loginjsp
    Created on : 13 thg 1, 2025, 22:12:10
    Author     : TRUNG
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="../css/login_style.css"/>
        <link href="../css/bootstrap.min.css" rel="stylesheet" />
    </head>
    <body>
        <div class="login-container d-none" >
            <div class="d-flex justify-content-center bg-white login">
                <form action="login" method="post">
    <!-- Close button -->
    <div class="close-login position-absolute">
        ×
    </div>
    <h3 class="text-center mt-4">Log in</h3>
    <span class="d-flex justify-content-center">
        Don't have an account?
        <a href="#!" class="change-register">
            &nbsp;Sign up
        </a>
    </span>
    <table class="mt-4 mb-4 w-100">
        <tbody>
            <tr>
                <td><b>Username</b></td>
            </tr>
            <tr>
                <td>
                    <input
                        class="form-control"
                        type="text"
                        name="username"
                        placeholder="Enter username or email"
                        required
                    />
                </td>
            </tr>
            <tr>
                <td class="pt-4"><b>Password</b></td>
            </tr>
            <tr>
                <td>
                    <input
                        class="form-control"
                        type="password"
                        name="password"
                        placeholder="Enter password"
                        required
                    />
                </td>
            </tr>
            <tr>
                <td class="text-end pt-2">
                    <a href="./forgotPassword">Forgot Password</a>
                </td>
            </tr>
            <tr>
                <td>
                    <button class="btn btn-primary w-100 mt-4" type="submit">Login</button>
                </td>
            </tr>
            <tr>
                <td class="text-center pt-3">
                    <a href="https://accounts.google.com/o/oauth2/auth?scope=email profile openid

&redirect_uri=http://localhost:9999/SWP391_GR6/login

&response_type=code

&client_id=370292122542-oqm0o2t9bsc5i2mmeovgnd85nch6fgb4.apps.googleusercontent.com

&approval_prompt=force" class="btn btn-light w-100 d-flex align-items-center justify-content-center border">
                        <img
                            src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/512px-Google_%22G%22_Logo.svg.png"
                            alt="Google Logo"
                            style="width: 20px; height: 20px; margin-right: 10px;"
                        />
                        Login with Google
                    </a>
                </td>
            </tr>
        </tbody>
    </table>
</form>

            </div>
        </div>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
    </body>
</html>
