<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${empty typeApp.id ? "Add" : "Update"} Type Application</title>
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
    </head>
    <body class="skin-black">
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />

        <div class="right-side">
            <a class="back-btn" href="../admin/ManageTypeApplication">
                Back
            </a>
            <h2 class="text-center title m-b-20">${empty id ? "Create new" : "Edit"} type application</h2>
            <form action="EditTypeApplication" class="edit-form" method="post">
                <input type="hidden" id="id" name="id" value="${id}">
                <label for="name">Name:</label>
                <br>
                <input style="width: 30%" type="text" id="name" name="name" value="${name != null ? name : ''}" required><br>

                <label for="staffManage">Staff manage</label>
                <br>
                <select style="width: 30%;
                        height: 40px;
                        padding: 8px;
                        border: 1px solid #ccc;
                        border-radius: 5px;" name="staffManage" id="staffManage">
                    <option value="" ${empty staffManage ? 'selected' : ''}></option>
                    <c:forEach var="s" items="${staff}">
                        <option value="${s.id}" ${staffManage == s.id ? 'selected' : ''}>${s.fullname}</option>
                    </c:forEach>
                </select>

                <div class="submit-container">
                    <button type="submit" class="back-btn">${empty id ? "Add" : "Edit"}</button>
                </div>
            </form>
        </div>
    </body>
</html>
