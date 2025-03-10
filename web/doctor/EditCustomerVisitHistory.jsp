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
            <a class="back-btn" href="../doctor/ShowCustomerMedicalDetail?cId=${param.cId}">
                Back
            </a>
            <h2 class="title">${empty param.id ? "Create new" : "Update"} customer's visit history</h2>
            <form action="EditCustomerVisitHistory" class="edit-form" method="post">
                <input type="hidden" name="id" value="${param.id}">
                <input type="hidden" name="sId" value="${sessionScope.staff.id}">
                <input type="hidden" name="cId" value="${param.cId}">

                <label for="reasonForVisit">Reason For Visit:</label>
                <input type="text" id="reasonForVisit" name="reasonForVisit" value="${param.reasonForVisit}" required>

                <div class="date-container">
                    <div class="date-item">
                        <label for="visitDate">Visit Date:</label>
                        <input type="text" id="visitDate" class="dateTime" name="visitDate" value="${param.visitDate}">
                    </div>
                    <div class="date-item">
                        <label for="nextAppointment">Next Appointment:</label>
                        <input type="text" id="nextAppointment" class="dateTime" name="nextAppointment" value="${param.nextAppointment}">
                    </div>
                </div>

                <label for="diagnoses">Diagnoses:</label>
                <input type="text" id="diagnoses" name="diagnoses" value="${param.diagnoses}" required>

                <label for="treatmentPlan">Treatment Plan:</label>
                <input type="text" id="treatmentPlan" name="treatmentPlan" value="${param.treatmentPlan}" required>

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