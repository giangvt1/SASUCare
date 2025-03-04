<%-- 
    Document   : ResetPassword
    Created on : Feb 19, 2025, 11:08:11 PM
    Author     : acer
--%>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Reset Password</title>
        <%-- No CSS or JS includes here, they should be in AdminHeader.jsp --%>
        <script>
            // Hàm validate mật khẩu theo pattern:
            // - Ít nhất 6 ký tự
            // - Có ít nhất 1 chữ hoa, 1 chữ thường, 1 số và 1 ký tự đặc biệt
            function validateResetPassword() {
                var newPasswordField = document.getElementById("newPassword");
                var confirmPasswordField = document.getElementById("confirmPassword");
                var newPassword = newPasswordField.value.trim();
                var confirmPassword = confirmPasswordField.value.trim();
                // Pattern mật khẩu: lưu ý sử dụng literal RegExp để tránh escape phức tạp
                var passwordRegex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{6,}$/;
                if (newPassword === "") {
                    alert("New Password is required.");
                    newPasswordField.focus();
                    return false;
                }
                if (!passwordRegex.test(newPassword)) {
                    alert("Password must be at least 6 characters long and include at least one uppercase letter, one lowercase letter, one digit, and one special character.");
                    newPasswordField.focus();
                    return false;
                }
                if (confirmPassword === "") {
                    alert("Please confirm your new password.");
                    confirmPasswordField.focus();
                    return false;
                }
                if (newPassword !== confirmPassword) {
                    alert("Passwords do not match. Please try again.");
                    confirmPasswordField.focus();
                    return false;
                }
                return true;
            }
        </script>
    </head>
    <body>
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />

        <div class="right-side"> <%-- Use right-side container --%>
            <div class="main-content"> <%-- Main content container --%>
                <h2 class="text-center">Reset Password</h2>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">${successMessage}</div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">${errorMessage}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/system/resetpass" method="POST" onsubmit="return validateResetPassword();">
                    <div class="mb-3"> <%-- Use Bootstrap spacing --%>
                        <label for="newPassword" class="form-label">New Password</label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Confirm New Password</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                    </div>

                    <div class="text-center">  <%-- Center the button --%>
                        <button type="submit" class="btn btn-primary">Reset Password</button>
                    </div>
                </form>
            </div> <%-- Close main-content --%>
        </div> <%-- Close right-side --%>

        <%-- No script includes here, they are in AdminHeader.jsp --%>
    </body>
</html>