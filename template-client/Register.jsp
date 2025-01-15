<%-- 
    Document   : Register
    Created on : 13 thg 1, 2025, 22:15:58
    Author     : TRUNG
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="./css/login_style.css"/>
        <link href="css/bootstrap.min.css" rel="stylesheet" />
    </head>
    <body>
        <div class="register-container d-none">
            <div class="d-flex justify-content-center bg-white register-form login">
                <form action="registerHandler.jsp" method="POST">
                    <!-- Close button -->
                    <div
                        class="close-register position-absolute"
                        >
                        ×
                    </div>
                    <h3 class="text-center mt-4">Register</h3>
                    <span class="d-flex justify-content-center">
                        Already have an account?
                        <a href="#!" class="change-login">
                            &nbsp;Sign In
                        </a>
                    </span>
                    <table class="mt-4 mb-4">
                        <tbody>
                            <tr>
                                <td><b>Username</b></td>
                            </tr>
                            <tr>
                                <td>
                                    <input
                                        class="input"
                                        type="text"
                                        name="username"
                                        placeholder="Enter username"
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
                                        class="input"
                                        type="password"
                                        name="password"
                                        placeholder="Enter password"
                                        required
                                        />
                                </td>
                            </tr>
                            <tr>
                                <td class="pt-4"><b>Confirm password</b></td>
                            </tr>
                            <tr>
                                <td>
                                    <input
                                        class="input"
                                        type="password"
                                        name="confirm-password"
                                        placeholder="Confirm password"
                                        required
                                        />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <button class="button mt-4" type="submit">Register</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </form>
            </div>
        </div>
    </body>
</html>
