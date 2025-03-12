<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage type application</title>
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
    </head>
    <body class="skin-black">
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <div class="right-side">
            <style>
                .filter-item {
                    width: 45%;
                }
            </style>
            <h2 class="mb-3 text-center title">List type applications</h2>
            <div class="table-data mt-4">
                <div style="margin-bottom: 30px"></div>
                <a class="add-btn" href="../admin/EditTypeApplication">Add type application</a>
                <table class="table" style="width:95%">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Type name</th>
                            <th>Staff manage name</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>

                        <c:forEach var="typeApp" items="${typeList}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td>${typeApp.name}</td>
                                <td>${typeApp.staffManageName}</td>
                                <td><a class="edit-btn" href="../admin/EditTypeApplication?id=${typeApp.id}&name=${typeApp.name}&staffManage=${typeApp.staffManageId}">Edit</a></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>  
        <script src="../js/doctor/doctor.js"></script>
    </body>
</html>
