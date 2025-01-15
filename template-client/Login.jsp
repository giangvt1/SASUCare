<%-- 
    Document   : Loginjsp
    Created on : 13 thg 1, 2025, 22:12:10
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
        <div class="login-container d-none" >
            <div class="d-flex justify-content-center bg-white login">
                <form>
                    <!-- Close button -->
                    <div
                        class="close-login position-absolute"
                        >
                        ×
                    </div>
                    <h3 class="text-center mt-4">Log in</h3>
                    <span class="d-flex justify-content-center">
                        Don't have an account?
                        <a href="#!" class="change-register">
                            &nbsp;Sign up
                        </a  >
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
    </body>
</html>
