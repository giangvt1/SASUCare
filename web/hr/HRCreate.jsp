<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create User Account</title>
    <!-- External CSS Files -->
    <link href="${pageContext.request.contextPath}/css/admin/bootstrap.min.css" rel="stylesheet" type="text/css"/>
    <link href="${pageContext.request.contextPath}/css/admin/font-awesome.min.css" rel="stylesheet" type="text/css"/>
    <link href="${pageContext.request.contextPath}/css/admin/styleAdmin.css" rel="stylesheet" type="text/css"/>
    <style>
        /* Các style bổ sung chỉ áp dụng cho trang này */
        table {
            width: 50%;
            margin: 20px auto;
            border-collapse: collapse;
        }
        td, th {
            padding: 10px;
            text-align: left;
        }
        input[type="text"],
        input[type="password"],
        input[type="email"],
        input[type="tel"],
        select {
            width: 100%;
            padding: 8px;
            margin: 5px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        button {
            padding: 10px 15px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
        .alert {
            padding: 10px;
            margin: 15px auto;
            border-radius: 5px;
            text-align: center;
            width: 50%;
        }
        .alert-success {
            background-color: #4CAF50;
            color: white;
        }
        .alert-danger {
            background-color: #f44336;
            color: white;
        }
    </style>
    <script>
        const passwordPattern = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{6,}$/;
        const phonePattern = /^0\d{9}$/;
        const emailPattern = /^[\w\.-]+@[\w\.-]+\.[A-Za-z]{2,6}$/;

        function trimInput(id) {
            let field = document.getElementById(id);
            field.value = field.value.trim();
        }

        function validateForm() {
            let username = document.getElementById("username").value.trim();
            let password = document.getElementById("password").value.trim();
            let displayname = document.getElementById("displayname").value.trim();
            let email = document.getElementById("gmail").value.trim();
            let phone = document.getElementById("phone").value.trim();

            if (!username) {
                alert("Username is required.");
                return false;
            }
            if (!password || !passwordPattern.test(password)) {
                alert("Password must be at least 6 characters long and include uppercase, lowercase, a digit, and a special character.");
                return false;
            }
            if (!displayname) {
                alert("Display Name is required.");
                return false;
            }
            if (!email || !emailPattern.test(email)) {
                alert("Please provide a valid email address.");
                return false;
            }
            if (!phone || !phonePattern.test(phone)) {
                alert("Phone number must be exactly 10 digits and start with 0.");
                return false;
            }
            let rolesSelect = document.getElementById("roles");
            if (!rolesSelect.value) {
                alert("Please select at least one role.");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <jsp:include page="../admin/AdminHeader.jsp" />
    <jsp:include page="../admin/AdminLeftSideBar.jsp" />

    <h2 style="text-align: center;">Create New Account</h2>
    
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">${successMessage}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">${errorMessage}</div>
    </c:if>
    
    <form action="${pageContext.request.contextPath}/hr/create" method="POST" onsubmit="return validateForm()">
        <table>
            <tr>
                <th><label for="username">Username</label></th>
                <td><input type="text" name="username" id="username" required onblur="trimInput('username')" /></td>
            </tr>
            <tr>
                <th><label for="password">Password</label></th>
                <td><input type="password" name="password" id="password" required onblur="trimInput('password')" /></td>
            </tr>
            <tr>
                <th><label for="displayname">Display Name</label></th>
                <td><input type="text" name="displayname" id="displayname" required onblur="trimInput('displayname')" /></td>
            </tr>
            <tr>
                <th><label for="gmail">Email</label></th>
                <td><input type="email" name="gmail" id="gmail" required onblur="trimInput('gmail')" /></td>
            </tr>
            <tr>
                <th><label for="phone">Phone Number</label></th>
                <td><input type="tel" name="phone" id="phone" required onblur="trimInput('phone')" /></td>
            </tr>
            <tr>
                <th><label for="roles">Role</label></th>
                <td>
                    <select name="roles" id="roles" required>
                        <c:forEach var="r" items="${role}">
                            <option value="${r.id}">${r.name}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
        </table>
        
        <div style="text-align: center;">
            <button type="submit">Create Account</button>
        </div>
    </form>
    
    <script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
