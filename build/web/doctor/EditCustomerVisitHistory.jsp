<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Customer Visit History</title>
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
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
                        <input type="datetime-local" id="visitDate" readonly="" name="visitDate" value="${param.visitDate}" required>
                    </div>
                    <div class="date-item">
                        <label for="nextAppointment">Next Appointment:</label>
                        <input type="datetime-local" id="nextAppointment" name="nextAppointment" value="${param.nextAppointment}">
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

        <!-- jQuery 2.0.2 -->
        <script src="../js/jquery.min.js" type="text/javascript"></script>
        <!-- Bootstrap -->
        <script src="../js/bootstrap.min.js" type="text/javascript"></script>
        <!-- Director App -->
        <script src="../js/Director/app.js" type="text/javascript"></script>

        <!-- Director dashboard demo (This is only for demo purposes) -->
        <script src="../js/Director/dashboard.js" type="text/javascript"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                let now = new Date();
                let vietnamTime = new Date(now.getTime() + (7 * 60 * 60 * 1000));

                function formatDateTime(date) {
                    let offset = date.getTimezoneOffset();
                    let localISOTime = new Date(date.getTime() - offset).toISOString().slice(0, 16);
                    return localISOTime;
                }

                let visitDateInput = document.getElementById("visitDate");
                visitDateInput.value = formatDateTime(vietnamTime); // Luôn đặt giá trị mặc định là ngày giờ hiện tại

                let nextAppointmentInput = document.getElementById("nextAppointment");
                if (!nextAppointmentInput.value) {
                    nextAppointmentInput.value = "";
                }
            });

            document.querySelector("form").addEventListener("submit", function (event) {
                let reasonForVisit = document.getElementById("reasonForVisit").value.trim();
                let visitDate = document.getElementById("visitDate").value.trim();
                let diagnoses = document.getElementById("diagnoses").value.trim();
                let treatmentPlan = document.getElementById("treatmentPlan").value.trim();
                let mess = "";

                if (!reasonForVisit)
                    mess += "Reason For Visit cannot be empty\\n";
                if (!visitDate)
                    mess += "Visit Date cannot be empty\\n";
                if (!diagnoses)
                    mess += "Diagnoses cannot be empty\\n";
                if (!treatmentPlan)
                    mess += "Treatment Plan cannot be empty\\n";

                if (mess) {
                    alert(mess);
                    event.preventDefault();
                }
            });

        </script>
    </body>
</html>