<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Customer Medical History</title>
    </head>
    <body>
        <h2>${empty param.id ? "Create New" : "Update"} Customer Medical History</h2>
        <form action="EditCustomerMedicalHistory" method="post">
            <input type="hidden" id="cid" name="cid" value="${param.cid}" required>
            <input type="hidden" id="id" name="id" value="${param.id}">

            <label for="name">Name:</label>
            <input type="text" id="name" name="name" value="${param.name}" required><br><br>

            <label for="detail">Detail:</label><br>
            <textarea id="detail" name="detail" rows="4" cols="50" required>${param.detail}</textarea><br><br>

            <input type="submit" value="${empty param.id ? "Create" : "Update"}">
        </form>
    </body>
    <script>
        document.querySelectorAll(".sidebar-menu > li").forEach((li) => {
            li.classList.remove("active");
        });
        let manageMedical = document.querySelector(".manage-medical");
        manageMedical.classList.add("active");
    </script>
    <script>
        document.querySelector("form").addEventListener("submit", function (event) {
            let name = document.getElementById("name").value.trim();
            let detail = document.getElementById("detail").value.trim();
            let mess = "";
            if (name === "") {
                mess += "Name not null\n";

            }
            if (detail === "") {
                mess += "detail not null\n";
            }
            if (mess !== "") {
                alert(mess);
                event.preventDefault();
            }
        });
    </script>
</html>
