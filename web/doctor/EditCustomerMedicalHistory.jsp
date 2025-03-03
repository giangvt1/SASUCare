<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Customer Medical History</title>
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
    </head>
    <body class="skin-black">
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />

            <div class="right-side">
                <a class="back-btn" href="../doctor/ShowCustomerMedicalDetail?cId=${param.cId}">
                Back
            </a>
            <h2 class="text-center title m-b-20">${empty param.id ? "Create New" : "Update"} Customer Medical History</h2>
            <form action="EditCustomerMedicalHistory" class="edit-form" method="post">
                <input type="hidden" id="cId" name="cId" value="${param.cId}" required>
                <input type="hidden" id="id" name="id" value="${param.id}">

                <label for="name">Name:</label>
                <input style="width: 30%" type="text" id="name" name="name" value="${param.name}" required><br><br>

                <label for="detail">Detail:</label><br>
                <textarea class="form-control" id="detail" name="detail" rows="4" cols="50" required>${param.detail}</textarea><br><br>

                <div class="submit-container">
                    <button type="submit" class="back-btn" value="${empty param.id ? "Create" : "Update"}">Submit</button>
                </div>
            </form>
        </div>
    </body>
    <!-- jQuery 2.0.2 -->
    <script src="../js/jquery.min.js" type="text/javascript"></script>
    <!-- Bootstrap -->
    <script src="../js/bootstrap.min.js" type="text/javascript"></script>
    <!-- Director App -->
    <script src="../js/Director/app.js" type="text/javascript"></script>

    <!-- Director dashboard demo (This is only for demo purposes) -->
    <script src="../js/Director/dashboard.js" type="text/javascript"></script>
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