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
            <h2 class="mb-3 text-center title">Edit Application</h2>
            <form action="EditStaffApplication" class="edit-form" method="post">
                <input type="hidden" readonly="" name="id" value="${application.id}">
                <input type="hidden" readonly="" name="staffSendId" value="${application.staffSendId}">
                <input type="hidden" readonly="" name="staffHanleId" value="${sessionScope.staff.id}">
                <label for="typeName">Type name:</label>
                <input type="text" readonly="" id="typeName" name="typeName" value="${application.typeName}" required>
                <label for="staffName">Staff name:</label>
                <input type="text" readonly="" id="staffName" name="staffName" value="${application.staffName}" required>
                <div class="date-container">
                    <div class="date-item">
                        <label for="dateSend">Date send:</label>
                        <input type="text" id="dateSend" class="dateTime" name="dateSend" value="${application.dateSend}" readonly="">
                    </div>
                    <div class="date-item">
                        <label for="status">Status:</label>
                        <input type="text" readonly="" id="status" name="status" value="${status}" required>
                    </div>

                </div>

                <label for="reason">Reason:</label><br>
                <textarea id="reason" readonly="" name="reason" style="width:100%">${application.reason}</textarea><br>

                <label for="reply">Reply:</label><br>
                <textarea id="reply" name="reply"required style="width:100%">${application.reply}</textarea>

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
