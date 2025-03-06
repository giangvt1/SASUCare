<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Send Application</title>
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
    </head>
    <body class="skin-black">
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <style>
            .right-side {
                padding: 20px;
                background-color: #fff;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }

            textarea.form-control {
                resize: vertical;
            }
        </style>
        <div class="right-side">
            <h3 class="text-center title">Send Application</h3>
            <a class="back-btn" href="ViewApplication?staffId=${sessionScope.staff.id}">View Application</a>
            <form action="SendApplication" method="POST" class="mt-4">
                <input type="text" hidden id="staffId" name="staffId" value="${sessionScope.staff.id}" required><br>
                <input type="text" hidden name="staffName" value="${sessionScope.staff.fullname}" required><br>
                <div class="form-group">
                    <label for="typeId">Loại đơn</label>
                    <select style="width: 15%" class="form-control" name="typeId" id="typeId" required="">
                        <option value="" ${empty param.typeId ? 'selected' : ''}>Type</option>
                        <c:forEach var="type" items="${typeList}">
                            <option value="${type.id}" ${param.id == type.id ? 'selected' : ''}>${type.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="reason">Reason</label>
                    <textarea class="form-control" id="reason" name="reason" placeholder="Enter your reason" rows="10" required></textarea>
                </div>
                <div>${message}</div>
                <button type="submit" class="btn btn-primary">Send</button>
            </form>
        </div>
        <script src="../js/doctor/doctor.js"></script>
    </body>
</html>