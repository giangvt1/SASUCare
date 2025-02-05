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

            <!-- Success/Error Messages -->
            <c:if test="${not empty message}">
                <div class="alert alert-success">${message}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <!-- Profile Form -->
            <c:if test="${not empty customer}">
                <form action="${pageContext.request.contextPath}/profile" method="post">
                    <!-- Full Name -->
                    <div class="mb-3">
                        <label for="name" class="form-label">Full Name</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            id="name" 
                            name="name" 
                            value="${customer.fullname}" 
                            required 
                            placeholder="Enter your full name">
                    </div>

                    <!-- Email -->
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input 
                            type="email" 
                            class="form-control" 
                            id="email" 
                            name="email" 
                            value="${customer.gmail}" 
                            required 
                            placeholder="Enter your email">
                    </div>

                    <!-- Phone -->
                    <div class="mb-3">
                        <label for="phone" class="form-label">Phone Number</label>
                        <input 
                            type="tel" 
                            class="form-control" 
                            id="phone" 
                            name="phone" 
                            value="" 
                            required 
                            placeholder="Enter your phone number">
                    </div>
                    <div class="mb-3">
                        <label for="address" class="form-label">Address</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            id="address" 
                            name="address" 
                            value="${''}" 
                            required 
                            placeholder="Enter your address">
                    </div>

                    <!-- Submit Button -->
                    <div class="text-center">
                        <button type="submit" class="btn btn-primary">Update Profile</button>
                    </div>
                </form>
                            
                <c:if test="${empty google}">
                    <form action="./changepass" method="post">
                    <!-- Old Password -->
                    <div class="mb-3">
                        <label for="oldPassword" class="form-label">Current Password</label>
                        <input 
                            type="password" 
                            class="form-control" 
                            id="oldPassword" 
                            name="oldPassword" 
                            required 
                            placeholder="Enter your current password">
                    </div>

                    <!-- New Password -->
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">New Password</label>
                        <input 
                            type="password" 
                            class="form-control" 
                            id="newPassword" 
                            name="newPassword" 
                            required 
                            placeholder="Enter your new password">
                    </div>

                    <!-- Confirm New Password -->
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Confirm New Password</label>
                        <input 
                            type="password" 
                            class="form-control" 
                            id="confirmPassword" 
                            name="confirmPassword" 
                            required 
                            placeholder="Confirm your new password">
                    </div>

                    <!-- Submit Button -->
                    <div class="text-center">
                        <button type="submit" class="btn btn-danger">Change Password</button>
                    </div>
                </form>
                </c:if>
            </c:if>
        </div>

        <jsp:include page="/Footer.jsp"/>
        <script src="../../js/bootstrap.bundle.min.js"></script>
    </body>
</html>
