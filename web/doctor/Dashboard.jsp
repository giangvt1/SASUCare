<%-- 
    Document   : Dashboard
    Created on : 20 thg 1, 2025, 19:50:06
    Author     : TRUNG
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Doctor Dashboard</title>
        <link href="../css/admin/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <!-- font Awesome -->
        <link href="../css/admin/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/admin/styleAdmin.css" rel="stylesheet" type="text/css" />
    </head>
    <body class="skin-black">
        <jsp:include page="../admin/AdminHeader.jsp"></jsp:include>
        <jsp:include page="../doctor/DoctorLeftSideBar.jsp"></jsp:include>


        <!-- jQuery 2.0.2 -->
        <script src="../js/jquery.min.js" type="text/javascript"></script>
        <!-- Bootstrap -->
        <script src="../js/bootstrap.min.js" type="text/javascript"></script>
        <!-- Director App -->
        <script src="../js/Director/app.js" type="text/javascript"></script>

        <!-- Director dashboard demo (This is only for demo purposes) -->
        <script src="../js/Director/dashboard.js" type="text/javascript"></script>
        <script>
            document.querySelectorAll(".sidebar-menu > li").forEach((li) => {
                li.classList.remove("active");
            });
            let dashBoard = document.querySelector(".dash-board");
//            let manageMedical = document.querySelector(".manage-medical");
//            let manageApplication = document.querySelector(".manage-application");
//            let manageCalendar = document.querySelector(".manage-calendar");
            dashBoard.classList.add("active");
        </script>
    </body>
</html>
