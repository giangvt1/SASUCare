<%-- 
    Document   : SendApplicaion
    Created on : 27 thg 1, 2025, 23:10:36
    Author     : TRUNG
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Send Application</title>
        <link href="../css/admin/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <!-- font Awesome -->
        <link href="../css/admin/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/admin/styleAdmin.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="../css/doctor/manage_medical_style.css"/>
    </head>
    <body class="skin-black"">
        <jsp:include page="../admin/AdminHeader.jsp"></jsp:include>
        <jsp:include page="DoctorLeftSideBar.jsp"></jsp:include>
            <div class="right-side">
                <h3 class="text-center">Send Application</h3>
                <form action="SendApplication" method="POST" class="mt-4">
                    <div class="form-group">
                        <label for="did">Doctor ID</label>
                        <input type="number" class="form-control" id="did" name="did" placeholder="Enter Department ID" required>
                    </div>
                    <div class="form-group">
                        <label for="name">Name</label>
                        <input type="text" class="form-control" id="name" name="name" placeholder="Enter your name" required>
                    </div>
                    <div class="form-group">
                        <label for="reason">Reason</label>
                        <textarea class="form-control" id="reason" name="reason" placeholder="Enter your reason" rows="4" required></textarea>
                    </div>
                    <div>${message}</div>
                <button type="submit" class="btn btn-primary">Submit</button>
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
            document.querySelectorAll(".sidebar-menu > li").forEach((li) => {
                li.classList.remove("active");
            });
            let manageApplication = document.querySelector(".manage-application");
            manageApplication.classList.add("active");
        </script>
    </body>
</html>
