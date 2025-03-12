<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Application</title>
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    </head>
    <body class="skin-black">
        <style>
            .date-container {
                display: flex;
                justify-content: space-between;
                margin-bottom: 15px;
            }

            .date-item {
                width: 48%;
            }
        </style>
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <div class="right-side">
            <a class="back-btn" href="../hr/ViewStaffApplication?staffId=${sessionScope.staff.id}">
                Back
            </a>
            <h2 class="mb-3 text-center title">Edit certificate</h2>
            <form action="EditDoctorCertificate" class="edit-form" method="post">
                <input type="hidden" readonly="" name="certificateId" value="${certificate.certificateId}">
                <input type="hidden" readonly="" name="doctorId" value="${certificate.doctorId}">
                <input type="hidden" readonly="" name="staffId" value="${sessionScope.staff.id}">
                <label for="certificateName">Certificate name:</label>
                <input type="text" readonly="" id="certificateName" name="certificateName" value="${certificate.certificateName}" required>
                <label for="doctorName">Doctor name:</label>
                <input type="text" readonly="" id="doctorName" name="doctorName" value="${certificate.doctorName}" required>
                <label for="typeName">Type name:</label>
                <input type="text" readonly="" id="typeName" name="typeName" value="${certificate.typeName}" required>
                <div class="date-container">
                    <div class="date-item">
                        <label for="issueDate">issue date:</label>
                        <input type="text" id="issueDate" class="date" name="issueDate" value="${certificate.issueDate}" readonly="">
                    </div>
                    <div class="date-item">
                        <label for="status">Status:</label>
                        <input type="text" readonly="" id="status" name="status" value="${status}" required>
                    </div>
                </div>
                <label for="documentPath">Document path:</label>
                <input type="text" readonly="" id="documentPath" name="documentPath" value="${certificate.documentPath}" required>
                <label for="checkNote">Check note:</label><br>
                <textarea id="checkNote" name="checkNote" style="width:100%"></textarea><br>
                <div class="submit-container">
                    <button type="submit" class="back-btn">Submit</button>
                </div>
            </form>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <script src="https://npmcdn.com/flatpickr/dist/l10n/vn.js"></script>
        <script src="../js/doctor/doctor.js"></script>
    </body>
</html>
