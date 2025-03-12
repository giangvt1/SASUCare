<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Create User Account</title>
        <!-- Styles -->
        <style>
            .form-container {
                width: 50%;
                margin: 0 auto;
            }
            label {
                display: block;
                margin-bottom: 5px;
            }
            input[type="text"],
            input[type="password"],
            input[type="email"],
            input[type="tel"],
            select {
                width: 100%;
                padding: 8px;
                margin-bottom: 10px;
                box-sizing: border-box;
            }
            button[type="submit"],
            .btn-secondary {
                background-color: var(--primary-color);
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                text-decoration: none;
                margin-right: 10px;
            }
            button[type="submit"]:hover,
            .btn-secondary:hover {
                background-color: #2962ff;
            }
            @media (max-width: 768px) {
                .form-container {
                    width: 90%;
                }
            }
        </style>
        
        <!-- Scripts -->
        <script>
            // Regex pattern cho số điện thoại: 10 chữ số, bắt đầu bằng 0
            const phonePattern = /^0\d{9}$/;

            // Hàm trim input khi mất focus
            function trimInput(id) {
                let field = document.getElementById(id);
                if (field) {
                    field.value = field.value.trim();
                }
            }

            // Hiển thị trường Department nếu Role = Doctor
            function toggleDepartmentField() {
                const roleSelect = document.getElementById("roles");
                // Lấy text hiển thị của option được chọn
                const selectedRoleText = roleSelect.options[roleSelect.selectedIndex].text;
                const deptDiv = document.getElementById("departmentDiv");
                
                // Kiểm tra chuỗi "Doctor" (có thể dùng toLowerCase() nếu cần)
                if (selectedRoleText === "Doctor") {
                    deptDiv.style.display = "table-row";
                } else {
                    deptDiv.style.display = "none";
                }
            }

            // Validate form trước khi submit
            function validateForm() {
                const username = document.getElementById("username").value.trim();
                const displayname = document.getElementById("displayname").value.trim();
                const email = document.getElementById("gmail").value.trim();
                const phone = document.getElementById("phone").value.trim();
                
                if (!username) {
                    alert("Username is required.");
                    return false;
                }
                if (!displayname) {
                    alert("Display Name is required.");
                    return false;
                }
                if (!email) {
                    alert("Email is required.");
                    return false;
                }
                if (!phone || !phonePattern.test(phone)) {
                    alert("Phone number must be exactly 10 digits and start with 0.");
                    return false;
                }
                
                const rolesSelect = document.getElementById("roles");
                if (!rolesSelect.value) {
                    alert("Please select at least one role.");
                    return false;
                }
                
                return true; // Hợp lệ
            }
        </script>
    </head>
    <body>
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />

        <div class="right-side">
            <div class="main-content">
                <h2 class="text-center">Create New Account</h2>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success text-center">${successMessage}</div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger text-center">${errorMessage}</div>
                </c:if>

                <div class="form-container">
                    <form action="${pageContext.request.contextPath}/hr/create" 
                          method="POST" 
                          onsubmit="return validateForm()">
                        <table>
                            <tr>
                                <th><label for="username">Username</label></th>
                                <td>
                                    <input type="text" name="username" id="username" 
                                           required 
                                           onblur="trimInput('username')" />
                                </td>
                            </tr>
                            <tr>
                                <th><label for="displayname">Display Name</label></th>
                                <td>
                                    <input type="text" name="displayname" id="displayname" 
                                           required 
                                           onblur="trimInput('displayname')" />
                                </td>
                            </tr>
                            <tr>
                                <th><label for="gmail">Email</label></th>
                                <td>
                                    <input type="email" name="gmail" id="gmail" 
                                           required 
                                           onblur="trimInput('gmail')" />
                                </td>
                            </tr>
                            <tr>
                                <th><label for="phone">Phone Number</label></th>
                                <td>
                                    <input type="tel" name="phone" id="phone" 
                                           required 
                                           onblur="trimInput('phone')" />
                                </td>
                            </tr>
                            <tr>
                                <th><label for="roles">Role</label></th>
                                <td>
                                    <select name="roles" id="roles" 
                                            onchange="toggleDepartmentField()" 
                                            required>
                                        <option value="">--Select Role--</option>
                                        <c:forEach var="r" items="${role}">
                                            <option value="${r.id}">${r.name}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                            </tr>
                            <tr id="departmentDiv" style="display:none;">
                                <th><label for="departments">Department</label></th>
                                <td>
                                    <select name="departments" id="departments" multiple="">
                                        <option value="">--Select Department--</option>
                                        <c:forEach var="de" items="${department}">
                                            <option value="${de.id}">${de.name}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                            </tr>
                        </table>

                        <div style="text-align: center;">
                            <button type="submit">Create Account</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>
