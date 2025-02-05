<%-- 
    Document   : CreateMedicalHistory
    Created on : 28 thg 1, 2025, 00:19:42
    Author     : TRUNG
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h2>Create New Medical History</h2>
        <form action="CreateCustomerMedicalHistory" method="post">
            <input type="text" hidden id="cid" name="cid" value="${cid}" required><br><br>
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required><br><br>

            <label for="detail">Detail:</label><br>
            <textarea id="detail" name="detail" rows="4" cols="50" required></textarea><br><br>

            <input type="submit" value="Create">
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
