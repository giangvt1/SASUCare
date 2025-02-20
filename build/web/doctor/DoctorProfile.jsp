<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Medical</title>
        <link href="../css/admin/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <!-- font Awesome -->
        <link href="../css/admin/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/admin/styleAdmin.css" rel="stylesheet" type="text/css" />
    </head>
    <body class="skin-black">
        <jsp:include page="../admin/AdminHeader.jsp"></jsp:include>
        <jsp:include page="../admin/AdminLeftSideBar.jsp"></jsp:include>
            <div class="right-side">
                <h1 style="margin-top: 50px">Doctor Profile</h1>
                <form action="UpdateDoctorProfile" method="post">
                    <input type="hidden" name="id" value="${staff.id}" />

                <label>Full Name:</label>
                <input type="text" name="fullname" value="${staff.fullname}" /><br/>

                <label>Email:</label>
                <input type="email" name="email" value="${staff.email}" /><br/>

                <label>Phone Number:</label>
                <input type="text" name="phonenumber" value="${staff.phonenumber}" /><br/>

                <label>Date of Birth:</label>
                <input type="date" name="dob" value="${staff.dob}" /><br/>

                <label>Gender:</label>
                <select name="gender">
                    <option value="true" ${staff.gender ? "selected" : ""}>Male</option>
                    <option value="false" ${!staff.gender ? "selected" : ""}>Female</option>
                </select><br/>

                <label>Address:</label>
                <input type="text" name="address" value="${staff.address}" /><br/>

                <button type="submit">Submit</button>
            </form>
        </div>
        <!-- jQuery 2.0.2 -->
        <script src="../js/jquery.min.js" type="text/javascript"></script>
        <!-- Bootstrap -->
        <script src="../js/bootstrap.min.js" type="text/javascript"></script>
        <!-- Director App -->
        <script src="../js/Director/app.js" type="text/javascript"></script>
        <script>
            document.querySelectorAll(".sidebar-menu > li").forEach((li) => {
                li.classList.remove("active");
            });
        </script>
    </body>
</html>
