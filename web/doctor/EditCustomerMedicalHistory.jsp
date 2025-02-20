<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Customer Medical History</title>
        <link href="../css/admin/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <!-- font Awesome -->
        <link href="../css/admin/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/admin/styleAdmin.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
    </head>
    <body class="skin-black">
        <style>
            .right-side {
                padding: 20px;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }
            textarea.form-control {
                resize: vertical;
            }
            label {
                display: block;
                margin: 15px 0 5px;
                font-weight: bold;
            }

            input[type="text"], textarea {
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
            }

            input[type="submit"]:hover {
                background-color: #4cae4c;
            }</style>
            <jsp:include page="../admin/AdminHeader.jsp"></jsp:include>
            <jsp:include page="../admin/AdminLeftSideBar.jsp"></jsp:include>

            <div class="right-side">
                <a class="back-btn" href="../doctor/ShowCustomerMedicalDetail?cId=${param.cId}">
                Back
            </a>
            <h2 class="text-center title">${empty param.id ? "Create New" : "Update"} Customer Medical History</h2>
            <form action="EditCustomerMedicalHistory" method="post">
                <input type="hidden" id="cId" name="cId" value="${param.cId}" required>
                <input type="hidden" id="id" name="id" value="${param.id}">

                <label for="name">Name:</label>
                <input style="width: 30%" type="text" id="name" name="name" value="${param.name}" required><br><br>

                <label for="detail">Detail:</label><br>
                <textarea class="form-control" id="detail" name="detail" rows="4" cols="50" required>${param.detail}</textarea><br><br>

                <input type="submit" value="${empty param.id ? "Create" : "Update"}">
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