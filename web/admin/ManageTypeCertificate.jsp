<%-- 
    Document   : ManageTypeCertificate
    Created on : Mar 13, 2025, 10:15:55 AM
    Author     : acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage type certificate</title>
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
            <h2 class="mb-3 text-center title">List type certificates</h2>
            <div class="table-data mt-4">
                <div style="margin-bottom: 30px"></div>
                <a class="add-btn" href="../admin/EditTypeCertificate">Add type certificate</a>
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

                        <c:forEach var="typeCer" items="${typeList}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td>${typeCer.name}</td>
                                <td>${typeCer.staffManageName}</td>
                                <td><a class="edit-btn" href="../admin/EditTypeCertificate?id=${typeCer.id}&name=${typeCer.name}&staffManage=${typeCer.staffManageId}">Edit</a></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>  
        <script src="../js/doctor/doctor.js"></script>
    </body>
</html>
