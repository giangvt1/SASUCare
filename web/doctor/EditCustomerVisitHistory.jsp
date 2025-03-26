<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Customer Visit History</title>
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
            <a class="back-btn" href="../doctor/ShowCustomerMedicalDetail?customerId=${param.customerId}&appointmentId=${param.appointmentId}">
                Back
            </a>
            <h2 class="title">${empty param.id ? "Create new" : "Update"} customer's visit history</h2>
            <form action="EditCustomerVisitHistory" class="edit-form" method="post">
                <input type="hidden" name="id" value="${param.id}">
                <input type="hidden" name="staffId" value="${sessionScope.staff.id}">
                <input type="hidden" name="customerId" value="${param.customerId}">
                <input type="hidden" name="appointmentId" value="${param.appointmentId}">

                <label for="reasonForVisit">Reason For Visit:</label>
                <input type="text" id="reasonForVisit" name="reasonForVisit" value="${param.reasonForVisit}" required>

                <label for="diagnoses">Diagnoses:</label>
                <input type="text" id="diagnoses" name="diagnoses" value="${param.diagnoses}" required>

                <label for="treatmentPlan">Treatment Plan:</label>
                <input type="text" id="treatmentPlan" name="treatmentPlan" value="${param.treatmentPlan}" required>
                `
                <label for="note">note:</label>
                <input type="text" id="note" name="note" value="${param.note}" required>

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