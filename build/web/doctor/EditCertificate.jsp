<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Certificate</title>
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    </head>
    <body class="skin-black">
        <style>.date-container {
                display: flex;
                justify-content: space-between;
                margin-bottom: 15px;
            }

            .date-item {
                width: 48%;
            }</style>
            <jsp:include page="../admin/AdminHeader.jsp" />
            <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <div class="right-side">
            <a class="back-btn" href="../doctor/ManageCertificates?staffId=${sessionScope.staff.id}">
                Back
            </a>
            <h2 class="title">${empty param.id ? "Create new" : "Update"} certificate</h2>
            <form action="EditCertificate" class="edit-form" enctype="multipart/form-data" method="post">
                <input type="hidden" name="id" value="${param.id}">
                <input type="hidden" name="staffId" value="${sessionScope.staff.id}">

                <label for="certificateName">Certificate name:</label>
                <input type="text" id="certificateName" name="certificateName" value="${param.certificateName}" required>
                <div class="form-group">
                    <label for="typeId">Type</label>
                    <select style="width: 48%; padding: 10px;" class="form-control" name="typeId" id="typeId" required="">
                        <option value="" ${empty param.typeId ? 'selected' : ''}></option>
                        <c:forEach var="type" items="${typeList}">
                            <option value="${type.id}" ${param.id == type.id ? 'selected' : ''}>${type.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="date-container">
                    <div class="date-item">
                        <label for="issueDate">Issue date:</label>
                        <input type="text" id="issueDate" class="date" name="issueDate" value="${param.issueDate}">
                    </div>
                </div>
                <div class="form-group">
                    <label for="file">File</label>
                    <br/>
                    <input type="file" class="form-control-file" id="file" name="file" accept=".pdf">
                </div>
                <label for="documentPath">Document path:</label>
                <input type="text" id="documentPath" name="documentPath" value="${param.documentPath}" required>

                <div class="submit-container">
                    <button type="submit" class="back-btn" value="${empty param.id ? "Create" : "Update"}">Submit</button>
                </div>
            </form>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <script src="https://npmcdn.com/flatpickr/dist/l10n/vn.js"></script>
        <script src="../js/doctor/doctor.js"></script>
    </body>
</html>
