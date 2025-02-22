<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Create User Account</title>
        <%-- No CSS or JS includes here; they are in AdminHeader.jsp --%>
        <style>
            /* Style cho form */
            .form-container{
                width: 50%;
                margin: 0 auto;
            }

            label {
                display: block; /* Each label takes full width */
                margin-bottom: 5px;
            }

            /* Adjust input field widths */
            input[type="text"],
            input[type="password"],
            input[type="email"],
            input[type="tel"],
            select {
                width: 100%;
                padding: 8px;
                margin-bottom: 10px; /* Add margin below each input*/
                box-sizing: border-box;
            }

            /* Style nút submit và cancel */
            button[type="submit"],
            .btn-secondary {
                background-color: var(--primary-color);
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                text-decoration: none; /* Remove underline from link */
                margin-right: 10px; /* Space between the buttons*/
            }

            button[type="submit"]:hover,
            .btn-secondary:hover {
                background-color: #2962ff; /*Slightly darker color*/
            }
            /* Responsive form */
            @media (max-width: 768px) {
                .form-container {
                    width: 90%; /* Adjust width for smaller screens */
                }
            }
        </style>
        <script>
            // JavaScript validation (unchanged)
            // ... (your validation script)
        </script>

    </head>
    <body>
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />

        <div class="right-side"> <%-- Use right-side class for layout --%>
            <div class="main-content"> <%-- Main content container --%>
                <h2 class="text-center">Create New Account</h2> <%-- Center the heading --%>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success text-center">${successMessage}</div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger text-center">${errorMessage}</div>
                </c:if>

                <div class="form-container"> <%-- Added a container for the form --%>
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
                </div> <%-- Close the .form-container --%>
            </div>
        </div>


        <%-- No JavaScript or CSS includes here; they are in AdminHeader.jsp --%>
    </body>
</html>