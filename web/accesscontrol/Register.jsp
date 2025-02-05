<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register</title>
        <link rel="stylesheet" href="../css/login_style.css"/>
        <link href="../css/bootstrap.min.css" rel="stylesheet" />
    </head>
    <body>
        <div class="register-container d-none" id="register-container">
            <div class="d-flex justify-content-center bg-white register-form">
                <form action="register" method="POST" onsubmit="return validateForm()">
                    <!-- Close button -->
                    <div class="close-register position-absolute" onclick="closeRegisterForm()">×</div>
                    <h3 class="text-center mt-4">Register</h3>
                    <span class="d-flex justify-content-center">
                        Already have an account? 
                        <a href="login.jsp" class="change-login">Sign In</a>
                    </span>
                    <table class="mt-4 mb-4">
                        <tbody>
                            <tr>
                                <td><b>Username</b></td>
                            </tr>
                            <tr>
                                <td><input class="input" type="text" name="username" id="username" placeholder="Enter username" required /></td>
                            </tr>
                            <tr>
                                <td class="pt-3"><b>Password</b></td>
                            </tr>
                            <tr>
                                <td><input class="input" type="password" name="password" id="password" placeholder="Enter password" required /></td>
                            </tr>
                            <tr>
                                <td class="pt-3"><b>Confirm password</b></td>
                            </tr>
                            <tr>
                                <td><input class="input" type="password" name="confirm-password" id="confirm-password" placeholder="Confirm password" required /></td>
                            </tr>

                            <!-- New field for Gmail -->
                            <tr>
                                <td class="pt-3"><b>Gmail</b></td>
                            </tr>
                            <tr>
                                <td><input class="input" type="email" name="email" id="email" placeholder="Enter your Gmail" required /></td>
                            </tr>

                            <!-- New field for Full Name -->
                            <tr>
                                <td class="pt-3"><b>Full Name</b></td>
                            </tr>
                            <tr>
                                <td><input class="input" type="text" name="full-name" id="full-name" placeholder="Enter full name" required /></td>
                            </tr>

                            <!-- New field for Phone Number -->
                            <tr>
                                <td class="pt-3"><b>Phone Number</b></td>
                            </tr>
                            <tr>
                                <td><input class="input" type="text" name="phone-number" id="phone-number" placeholder="Enter phone number" required /></td>
                            </tr>

                            <tr>
                                <td><button class="button mt-3" type="submit">Register</button></td>
                            </tr>
                        </tbody>
                    </table>
                </form>
            </div>
        </div>

        <script>
            // Hàm xử lý gửi form và thông báo kết quả
            function validateForm() {
                var username = document.getElementById("username").value;
                var password = document.getElementById("password").value;
                var confirmPassword = document.getElementById("confirm-password").value;

                // Kiểm tra mật khẩu có khớp không
                if (password !== confirmPassword) {
                    alert("Passwords do not match!");
                    return false; // Ngừng gửi form
                }

                return true;
            }

            // Hàm đóng form đăng ký
            function closeRegisterForm() {
                document.getElementById("register-container").classList.add("d-none");
            }
        </script>
    </body>
</html>
