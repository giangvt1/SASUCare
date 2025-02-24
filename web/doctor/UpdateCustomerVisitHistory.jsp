
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Create Visit History</h1>
        <form action="UpdateCustomerVisitHistory" method="post">
            <input type="text" hidden id="id" name="id" value="${id}" required><br><br>
            <input type="text" hidden id="did" name="did" value="16" required><br><br>
            <input type="text" hidden id="cid" name="cid" value="${cid}" required><br><br>

            <label for="reasonForVisit">Reason for Visit:</label>
            <input type="text" id="reasonForVisit" name="reasonForVisit" value="${reasonForVisit}" required><br><br>

            <label for="visitDate">Visit Date:</label>
            <input type="date" id="visitDate" name="visitDate" value="${visitDate}"><br><br>

            <label for="diagnoses">Diagnoses:</label>
            <input type="text" id="diagnoses" name="diagnoses" value="${diagnoses}"><br><br>

            <label for="treatmentPlan">Treatment Plan:</label>
            <input type="text" id="treatmentPlan" name="treatmentPlan" value="${treatmentPlan}"><br><br>

            <label for="nextAppointment">Next Appointment:</label>
            <input type="date" id="nextAppointment" name="nextAppointment" value="${nextAppointment}"><br><br>


            <button type="submit">Update</button>
        </form>
        <script>
            document.querySelectorAll(".sidebar-menu > li").forEach((li) => {
                li.classList.remove("active");
            });
            let manageMedical = document.querySelector(".manage-medical");
            manageMedical.classList.add("active");
        </script>
    </body>
</html>
