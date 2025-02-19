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
                        <a href="#!" class="change-login">Sign In</a>
                    </span>
                    <table class="mt-4 mb-4">
                        <tbody>
                            <tr>
                                <td><b>Username</b></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="input-container">
                                        <input class="input" type="text" name="username" id="username" placeholder="Enter username" required />
                                        <div id="username-error" class="error-message"></div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="pt-4"><b>Password</b></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="input-container">
                                        <input class="input" type="password" name="password" id="password" placeholder="Enter password" required />
                                        <div id="password-error" class="error-message"></div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="pt-4"><b>Confirm password</b></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="input-container">
                                        <input class="input" type="password" name="confirm-password" id="confirm-password" placeholder="Confirm password" required />
                                        <div id="confirm-password-error" class="error-message"></div>
                                    </div>
                                </td>
                            </tr>

                            <!-- New field for Gmail -->
                            <tr>
                                <td class="pt-4"><b>Gmail</b></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="input-container">
                                        <input class="input" type="email" name="email" id="email" placeholder="Enter your Gmail" required />
                                        <div id="email-error" class="error-message"></div>
                                    </div>
                                </td>
                            </tr>

                            <!-- New field for Full Name -->
                            <tr>
                                <td class="pt-4"><b>Full Name</b></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="input-container">
                                        <input class="input" type="text" name="full-name" id="full-name" placeholder="Enter full name" required />
                                        <div id="full-name-error" class="error-message"></div>
                                    </div>
                                </td>
                            </tr>

                            <!-- New field for Phone Number -->
                            <tr>
                                <td class="pt-4"><b>Phone Number</b></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="input-container">
                                        <input class="input" type="text" name="phone-number" id="phone-number" placeholder="Enter phone number" required />
                                        <div id="phone-number-error" class="error-message"></div>
                                    </div>
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

        <script>
            // Hàm xử lý gửi form và thông báo kết quả
            function validateForm() {
                var errorMessages = document.querySelectorAll(".error-message");
                for (var i = 0; i < errorMessages.length; i++) {
                    if (errorMessages[i].innerText.trim() !== "") {
                        alert("Please fix the errors before submitting!");
                        return false; // Ngăn gửi form nếu có lỗi
                    }
                }
                return true; // Gửi form nếu không có lỗi
            }


            // Hàm đóng form đăng ký
            function closeRegisterForm() {
                document.getElementById("register-container").classList.add("d-none");
            }
            
            document.addEventListener("DOMContentLoaded", function () {
                var username = document.getElementById("username");
                var password = document.getElementById("password");
                var confirmPassword = document.getElementById("confirm-password");
                var email = document.getElementById("email");
                var fullName = document.getElementById("full-name");
                var phoneNumber = document.getElementById("phone-number");

                username.oninput = function () { validateInput(username, /^(?![_\.])(?!.*[_\.]{2})[a-zA-Z0-9._]{6,20}(?<![_\.])$/, "Username must be at least 6 characters"); };
                password.oninput = function () { 
                    validateInput(password, /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{6,}$/, 
                    "Invalid Password!"); 
                };
                confirmPassword.oninput = function () { validateConfirmPassword(); };
                email.oninput = function () { validateInput(email, /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/, "Invalid email format"); };
                fullName.oninput = function () { 
                    validateInput(fullName, /^(?!.* {2,})[a-zA-Z]+(?: [a-zA-Z]+)*$/, "Invalid Name"); 
                };


                phoneNumber.oninput = function () { validateInput(phoneNumber, /^\d{10}$/, "Phone number must be 10 digits"); };

                function validateInput(input, regex, errorMessage) {
                    var errorElement = getErrorElement(input);
                    var trimmedValue = input.value.trim();

                    if (trimmedValue === "") {
                        errorElement.innerText = "This field cannot be empty or contain only spaces";
                        errorElement.style.color = "red";
                    } else if (!regex.test(trimmedValue)) {
                        errorElement.innerText = errorMessage;
                        errorElement.style.color = "red";
                    } else {
                        errorElement.innerText = "";
                    }
                    toggleSubmitButton();
                }

                function validateConfirmPassword() {
                    var errorElement = getErrorElement(confirmPassword);
                    if (confirmPassword.value.trim() === "") {
                        errorElement.innerText = "";
                    } else if (confirmPassword.value !== password.value) {
                        errorElement.innerText = "Passwords do not match";
                        errorElement.style.color = "red";
                    } else {
                        errorElement.innerText = "";
                    }
                    toggleSubmitButton();
                }

                // Kiểm tra nếu có error-message thì disable nút submit
                function toggleSubmitButton() {
                    var errorMessages = document.querySelectorAll(".error-message");
                    var hasError = Array.from(errorMessages).some(error => error.innerText.trim() !== "");
                    document.querySelector("button[type='submit']").disabled = hasError;
                }


                function getErrorElement(input) {
                    return document.getElementById(input.id + "-error");
                }
            });

        </script>
    </body>
</html>
