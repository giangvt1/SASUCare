<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Visit History</title>
    </head>
    <body>
        <h1>Create Visit History</h1>
        <form action="CreateCustomerVisitHistory" method="post">
            <label for="reasonForVisit">Reason for Visit:</label>
            <input type="text" id="reasonForVisit" name="reasonForVisit" required><br><br>

            <label for="diagnoses">Diagnoses:</label>
            <input type="text" id="diagnoses" name="diagnoses"><br><br>

            <label for="treatmentPlan">Treatment Plan:</label>
            <input type="text" id="treatmentPlan" name="treatmentPlan"><br><br>

            <label for="nextAppointment">Next Appointment:</label>
            <input type="date" id="nextAppointment" name="nextAppointment"><br><br>
            <input type="text" hidden id="did" name="did" value="16" required><br><br>
            <input type="text" hidden id="cid" name="cid" value="${cid}" required><br><br>
            <button type="submit">Create</button>
        </form>
    </body>
    <script>
        document.querySelectorAll(".sidebar-menu > li").forEach((li) => {
            li.classList.remove("active");
        });
        let manageMedical = document.querySelector(".manage-medical");
        manageMedical.classList.add("active");
    </script>
</html>
