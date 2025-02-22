<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>User Profile</title>
        <link href="../../css/bootstrap.min.css" rel="stylesheet" />
        <link href="../../css/style.css" rel="stylesheet" type="text/css"/>
        <style>
            .profile-container {
                max-width: 800px;
                margin: 30px auto;
                padding: 20px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
                border-radius: 8px;
                background-color: #f9f9f9;
            }
            .profile-header {
                margin-bottom: 30px;
                text-align: center;
            }
            .alert {
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/Header.jsp"/>

        <div class="profile-container">
            <div class="profile-header">
                <h2>User Profile</h2>
            </div>

            <c:if test="${not empty message}">
                <div class="alert alert-success">${message}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <c:if test="${not empty customer}">
                <form action="${pageContext.request.contextPath}/profile" method="post" id="profileForm">
                    <div class="mb-3">
                        <label for="name" class="form-label">Full Name</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            id="name" 
                            name="name" 
                            value="${customer.fullname}" 
                            placeholder="Enter your full name">
                        <div id="name-error" class="text-danger"></div>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input 
                            type="email" 
                            class="form-control" 
                            id="email" 
                            name="email" 
                            value="${customer.gmail}" 
                            readonly=""
                            placeholder="Enter your email">
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label">Phone Number</label>
                        <input 
                            type="tel" 
                            class="form-control" 
                            id="phone" 
                            name="phone" 
                            value="${customer.phone_number}" 
                            placeholder="Enter your phone number">
                        <div id="phone-error" class="text-danger"></div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="address" class="form-label">Address</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            id="address" 
                            name="address" 
                            value="${customer.address}" 
                            placeholder="Enter your address">
                    </div>

                    <div class="text-center">
                        <button type="submit" class="btn btn-primary">Update Profile</button>
                    </div>
                </form>
            </c:if>
        </div>

        <jsp:include page="/Footer.jsp"/>
        <script src="../../js/bootstrap.bundle.min.js"></script>

        <script>
    document.addEventListener("DOMContentLoaded", function () {
        const profileForm = document.getElementById("profileForm");
        const passwordForm = document.getElementById("passwordForm");

        if (profileForm) {
            profileForm.addEventListener("submit", function (e) {
                if (!validateProfileForm()) {
                    e.preventDefault();
                }
            });
        }

        if (passwordForm) {
            passwordForm.addEventListener("submit", function (e) {
                if (!validatePasswordForm()) {
                    e.preventDefault();
                }
            });
        }

        function validateProfileForm() {
            let isValid = true;

            // Validate Full Name (Hỗ trợ tiếng Việt)
            const name = document.getElementById("name");
            const nameError = document.getElementById("name-error");
            const nameValue = name.value.trim();

            if (!/^[\p{L}\s]{3,20}$/u.test(nameValue)) {
                nameError.innerText = "Name must be 3 - 20 characters";
                isValid = false;
            } else if (/^\s|\s$/.test(name.value) || /\s{2,}/.test(name.value)) {
                nameError.innerText = "Invalid name!";
                isValid = false;
            } else {
                nameError.innerText = "";
            }

            // Validate Phone Number (10-11 số)
            const phone = document.getElementById("phone");
            const phoneError = document.getElementById("phone-error");
            if (!/^0\d{9}$/.test(phone.value.trim())) {
                phoneError.innerText = "Phone number must be 10 digits!";
                isValid = false;
            } else {
                phoneError.innerText = "";
            }

            // Validate Address (5 - 50 characters)
            const address = document.getElementById("address");
            let addressError = document.getElementById("address-error");

            if (!addressError) {
                addressError = document.createElement("div");
                addressError.id = "address-error";
                addressError.classList.add("text-danger");
                address.parentNode.appendChild(addressError);
            }

            const addressValue = address.value.trim();
            if (addressValue.length < 5 || addressValue.length > 50) {
                addressError.innerText = "Address must be between 5 - 50 characters.";
                isValid = false;
            } else if (/\s{2,}/.test(addressValue)) {
                addressError.innerText = "Invalid input!";
                isValid = false;
            } else {
                addressError.innerText = "";
            }

            return isValid;
        }

        function validatePasswordForm() {
            let isValid = true;

            const newPassword = document.getElementById("newPassword");
            const confirmPassword = document.getElementById("confirmPassword");
            const passwordError = document.getElementById("password-error");
            const confirmPasswordError = document.getElementById("confirm-password-error");

            // Validate new password strength
            const passwordRegex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*]).{6,}$/;
            if (!passwordRegex.test(newPassword.value)) {
                passwordError.innerText = "Invalid Password!";
                isValid = false;
            } else {
                passwordError.innerText = "";
            }

            // Confirm new password match
            if (newPassword.value !== confirmPassword.value) {
                confirmPasswordError.innerText = "Password doesn't match!";
                isValid = false;
            } else {
                confirmPasswordError.innerText = "";
            }

            return isValid;
        }
    });
</script>

    </body>
</html>
