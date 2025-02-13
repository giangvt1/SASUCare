<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Customer Visit History</title>
    </head>
    <body>
        <h2>${empty param.id ? "Create New" : "Update"} Customer Visit History</h2>
        <form action="EditCustomerVisitHistory" method="post">
            <input type="hidden" name="id" value="${param.id}">
            <input type="hidden" name="did" value="16">
            <input type="hidden" name="cid" value="${param.cid}">

            <label for="reasonForVisit">Reason for Visit:</label>
            <input type="text" id="reasonForVisit" name="reasonForVisit" value="${param.reasonForVisit}" required><br><br>

            <label for="visitDate">Visit Date:</label>
            <input type="date" id="visitDate" name="visitDate" value="${param.visitDate}"><br><br>

            <label for="diagnoses">Diagnoses:</label>
            <input type="text" id="diagnoses" name="diagnoses" value="${param.diagnoses}"><br><br>

            <label for="treatmentPlan">Treatment Plan:</label>
            <input type="text" id="treatmentPlan" name="treatmentPlan" value="${param.treatmentPlan}"><br><br>

            <label for="nextAppointment">Next Appointment:</label>
            <input type="date" id="nextAppointment" name="nextAppointment" value="${param.nextAppointment}"><br><br>

            <input type="submit" value="${empty param.id ? "Create" : "Update"}">
        </form>

        <script>
            document.querySelectorAll(".sidebar-menu > li").forEach((li) => {
                li.classList.remove("active");
            });
            let manageMedical = document.querySelector(".manage-medical");
            manageMedical.classList.add("active");
        </script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                let visitDateInput = document.getElementById("visitDate");
                if (!visitDateInput.value) {
                    let now = new Date();
                    let vietnamTime = new Date(now.getTime() + (7 * 60 * 60 * 1000));
                    let today = vietnamTime.toISOString().split("T")[0];
                    visitDateInput.value = today;
                }
            });
        </script>
        <script>
            document.querySelector("form").addEventListener("submit", function (event) {
                let reasonForVisit = document.getElementById("reasonForVisit").value.trim();
                let visitDate = document.getElementById("visitDate").value.trim();
                let diagnoses = document.getElementById("diagnoses").value.trim();
                let treatmentPlan = document.getElementById("treatmentPlan").value.trim();
                let mess = "";
                if (reasonForVisit === "") {
                    mess += "Reason For Visit not null\n";

                }
                if (visitDate === "") {
                    mess += "Visit Date not null\n";
                }
                if (diagnoses === "") {
                    mess += "Diagnoses not null\n";
                }
                if (treatmentPlan === "") {
                    mess += "Treatment Plan not null\n";
                }
                if (mess !== "") {
                    alert(mess);
                    event.preventDefault();
                }
            });
        </script>
    </body>
</html>
