<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Customer Visit History</title>
        <link href="../css/admin/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <!-- font Awesome -->
        <link href="../css/admin/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/admin/styleAdmin.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
    </head>
    <body class="skin-black">
        <style>.right-side {
                padding: 20px;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            label {
                display: block;
                margin: 15px 0 5px;
                font-weight: bold;
            }

            input[type="text"], input[type="datetime-local"] {
                width: 100%;
                padding: 10px;
                margin: 5px 0 20px;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
                font-size: 16px;
            }

            input[type="submit"] {
                background-color: #5cb85c;
                color: white;
                padding: 10px 15px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
                transition: background-color 0.3s;
            }

            input[type="submit"]:hover {
                background-color: #4cae4c;
            }

            .error {
                color: red;
                margin: 10px 0;
            }
        </style>
        <jsp:include page="../admin/AdminHeader.jsp"></jsp:include>
        <jsp:include page="../admin/AdminLeftSideBar.jsp"></jsp:include>
            <div class="right-side">
                <a class="back-btn" href="../doctor/ShowCustomerMedicalDetail?cId=${param.cId}">
                Back
            </a>
            <h2 class="title">${empty param.id ? "Create new" : "Update"} customer's visit history</h2>
            <form action="EditCustomerVisitHistory" method="post">
                <input type="hidden" name="id" value="${param.id}">
                <input type="hidden" name="did" value="16">
                <input type="hidden" name="cId" value="${param.cId}">

                <label for="reasonForVisit">Reason For Visit:</label>
                <input type="text" id="reasonForVisit" name="reasonForVisit" value="${param.reasonForVisit}" required><br><br>

                <label for="visitDate">Visit Date:</label>
                <input type="datetime-local" id="visitDate" name="visitDate" value="${param.visitDate}" required><br><br>

                <label for="diagnoses">Diagnoses:</label>
                <input type="text" id="diagnoses" name="diagnoses" value="${param.diagnoses}" required><br><br>

                <label for="treatmentPlan">Treatment Plan:</label>
                <input type="text" id="treatmentPlan" name="treatmentPlan" value="${param.treatmentPlan}" required><br><br>

                <label for="nextAppointment">Next Appointment:</label>
                <input type="datetime-local" id="nextAppointment" name="nextAppointment" value="${param.nextAppointment}"><br><br>

                <input type="submit" value="${empty param.id ? "Create" : "Update"}">
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