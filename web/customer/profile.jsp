<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>User Profile</title>
        <link href="../../css/bootstrap.min.css" rel="stylesheet" />
        <link href="../../css/style.css" rel="stylesheet" type="text/css"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
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
            body{margin-top:20px;
                background-color:#f2f6fc;
                color:#69707a;
                }
                .img-account-profile {
                    height: 10rem;
                }
                .rounded-circle {
                    border-radius: 50% !important;
                }
                .card {
                    box-shadow: 0 0.15rem 1.75rem 0 rgb(33 40 50 / 15%);
                }
                .card .card-header {
                    font-weight: 500;
                }
                .card-header:first-child {
                    border-radius: 0.35rem 0.35rem 0 0;
                }
                .card-header {
                    padding: 1rem 1.35rem;
                    margin-bottom: 0;
                    background-color: rgba(33, 40, 50, 0.03);
                    border-bottom: 1px solid rgba(33, 40, 50, 0.125);
                }
                .form-control, .dataTable-input {
                    display: block;
                    width: 100%;
                    padding: 0.875rem 1.125rem;
                    font-size: 0.875rem;
                    font-weight: 400;
                    line-height: 1;
                    color: #69707a;
                    background-color: #fff;
                    background-clip: padding-box;
                    border: 1px solid #c5ccd6;
                    -webkit-appearance: none;
                    -moz-appearance: none;
                    appearance: none;
                    border-radius: 0.35rem;
                    transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
                }

                .nav-borders .btn.active {
                    color: #0061f2;
                    border-bottom-color: #0061f2;
                }
                .nav-borders .btn {
                    color: #69707a;
                    border-bottom-width: 0.125rem;
                    border-bottom-style: solid;
                    border-bottom-color: transparent;
                    padding-top: 0.5rem;
                    padding-bottom: 0.5rem;
                    padding-left: 0;
                    padding-right: 0;
                    margin-left: 1rem;
                    margin-right: 1rem;
                    background: none;
                    outline: none;
                    border: none;
                }
                .nav-borders .btn {
                    margin: 5px;
                }
                #profile-section, #security-section {
                    display: none;
                }
                #profile-section.active, #security-section.active {
                    display: block;
                }
        </style> 
    </head>
    <body>
        <jsp:include page="/Header.jsp"/>

        <div class="container-xl px-4 mt-4">
            <!-- Account page navigation -->
            <div class="nav-borders d-flex">
                <button class="btn btn-primary" id="btnProfile">Profile</button>
                <button class="btn btn-secondary" id="btnSecurity">Security</button>
                
            </div>
            <hr class="mt-0 mb-4">
            
            <div id="profile-section" class="active">
                <!-- Profile Content -->
                <div class="row">
                    <div class="col-xl-4">
                        <div class="card mb-4 mb-xl-0">
                            <div class="card-header">Profile Picture</div>
                            <div class="card-body text-center">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.currentGoogle}">
                                        <img class="img-account-profile rounded-circle mb-2" src="${sessionScope.currentGoogle.picture}" alt="">
                                    </c:when>
                                    <c:otherwise>
                                        <img class="img-account-profile rounded-circle mb-2" src="https://i.pinimg.com/originals/c6/e5/65/c6e56503cfdd87da299f72dc416023d4.jpg" alt="">
                                    </c:otherwise>
                                </c:choose>

                                <div class="small font-italic text-muted mb-4">JPG or PNG no larger than 5 MB</div>
                                <button class="btn btn-primary" type="button">Upload new image</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-8">
                        <div class="card mb-4">
                            <div class="card-header">Account Details</div>
                            <div class="card-body">
                                <c:if test="${not empty customer}">
                                    <form action="${pageContext.request.contextPath}/profile" method="post" id="profileForm">
                                        <div class="mb-3">
                                            <label class="small mb-1" for="name">Full Name</label>
                                            <input class="form-control" id="name" name="name" type="text" value="${customer.fullname}" placeholder="Enter your username">
                                            <div id="name-error" class="text-danger"></div>
                                        </div>
                                        <div class="mb-3">
                                            <label class="small mb-1" for="address">Address</label>
                                            <input class="form-control" id="address" name="address" type="text" value="${customer.address}" placeholder="Enter your address">
                                            <div id="address-error" class="text-danger"></div>
                                        </div>   
                                        <div class="mb-3">
                                            <label for="phone" class="form-label">Phone Number</label>
                                            <input type="tel" class="form-control" id="phone" name="phone" value="${customer.phone_number}" placeholder="Enter your phone number">
                                            <div id="phone-error" class="text-danger"></div>
                                        </div>
                                        <div class="mb-3">
                                            <label class="small mb-1" for="email">Email address</label>
                                            <input class="form-control" id="email" type="email" name="email" value="${customer.gmail}" readonly>
                                        </div>
                                        <button class="btn btn-primary" type="submit">Save changes</button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div id="security-section">
                
                    <!-- Security Content -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not hasPassword}">
                                    <!-- Form Set Password -->
                                    <div class="card mb-4">
                                        <div class="card-body">
                                            <form action="${pageContext.request.contextPath}/changepass?action=set-pass" method="POST">
                                                <div class="mb-3">
                                                    <label class="small mb-1" for="newPassword">Set Password</label>
                                                    <input class="form-control" id="newPassword" name="newPassword" type="password" placeholder="Enter new password">
                                                    <div id="password-error" class="text-danger"></div>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="small mb-1" for="confirmPassword">Confirm Password</label>
                                                    <input class="form-control" id="confirmPassword" name="confirmPassword" type="password" placeholder="Confirm new password">
                                                    <div id="confirm-password-error" class="text-danger"></div>
                                                </div>
                                                <button class="btn btn-primary" type="submit">Set Password</button>
                                            </form>
                                        </div>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <!-- Form Update Password -->
                                    <div class="card mb-4">
                                        <div class="card-header">Change Password</div>
                                        <div class="card-body">
                                            <form action="${pageContext.request.contextPath}/changepass?action=update-pass" method="POST">
                                                <div class="mb-3">
                                                    <label class="small mb-1" for="oldPassword">Current Password</label>
                                                    <input class="form-control" id="oldPassword" name="oldPassword" type="password" placeholder="Enter current password">
                                                </div>
                                                <div class="mb-3">
                                                    <label class="small mb-1" for="newPassword">New Password</label>
                                                    <input class="form-control" id="newPassword" name="newPassword" type="password" placeholder="Enter new password">
                                                    <div id="password-error" class="text-danger"></div>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="small mb-1" for="confirmPassword">Confirm Password</label>
                                                    <input class="form-control" id="confirmPassword" name="confirmPassword" type="password" placeholder="Confirm new password">
                                                    <div id="confirm-password-error" class="text-danger"></div>
                                                </div>
                                                <button class="btn btn-primary" type="submit">Save</button>
                                            </form>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </div>
                
            </div>
        </div>

        <jsp:include page="/Footer.jsp"/>
        <script src="../../js/bootstrap.bundle.min.js"></script>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
            const profileForm = document.getElementById("profileForm");
            const passwordForm = document.getElementById("passwordForm");

            const btnProfile = document.getElementById("btnProfile");
            const btnSecurity = document.getElementById("btnSecurity");
            const profileSection = document.getElementById("profile-section");
            const securitySection = document.getElementById("security-section");

            document.getElementById("name").oninput = validateProfileForm;
            document.getElementById("phone").oninput = validateProfileForm;
            document.getElementById("address").oninput = validateProfileForm;

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

        const phone = document.getElementById("phone");
        const phoneError = document.getElementById("phone-error");
        const phoneValue = phone.value.trim();

        if (phoneValue !== "" && (!/^0\d{9,10}$/.test(phoneValue) || /\s/.test(phone.value))) {
            phoneError.innerText = "Phone number must be 10-11 digits and contain no spaces!";
            isValid = false;
        } else {
            phoneError.innerText = "";
        }

        const address = document.getElementById("address");
        const addressError = document.getElementById("address-error");
        const addressValue = address.value.trim();

        if (addressValue !== "" && (addressValue.length < 5 || addressValue.length > 50 || /^\s|\s$/.test(address.value))) {
            addressError.innerText = "Address must be between 5 - 50 characters and not have spaces at the beginning or end.";
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

        const passwordRegex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*]).{6,}$/;
        if (!passwordRegex.test(newPassword.value)) {
            passwordError.innerText = "Invalid Password!";
            isValid = false;
        } else {
            passwordError.innerText = "";
        }

        if (newPassword.value !== confirmPassword.value) {
            confirmPasswordError.innerText = "Password doesn't match!";
            isValid = false;
        } else {
            confirmPasswordError.innerText = "";
        }

        document.querySelector(".btn.btn-primary[type='submit']").disabled = !isValid;
        return isValid;
    }

    function showProfile() {
        profileSection.classList.add("active");
        securitySection.classList.remove("active");
        btnProfile.classList.add("btn-primary");
        btnProfile.classList.remove("btn-secondary");
        btnSecurity.classList.add("btn-secondary");
        btnSecurity.classList.remove("btn-primary");
    }

    function showSecurity() {
        securitySection.classList.add("active");
        profileSection.classList.remove("active");
        btnSecurity.classList.add("btn-primary");
        btnSecurity.classList.remove("btn-secondary");
        btnProfile.classList.add("btn-secondary");
        btnProfile.classList.remove("btn-primary");
    }

    btnProfile.addEventListener("click", showProfile);
    btnSecurity.addEventListener("click", showSecurity);

    showProfile();
});



</script>

    
        </body>
</html>
