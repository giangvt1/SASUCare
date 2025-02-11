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
    <body class="skin-black">
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <div class="right-side">
            <h3 class="text-center">Send Application</h3>
            <form action="SendApplication" method="POST" class="mt-4">
                <input type="text" hidden id="did" name="did" value="16"required><br><br>
                <div class="form-group">
                    <label for="name">Loại đơn</label>
                    <select class="form-contsrol" id="name" name="name" required>
                        <option value="">-- Chọn loại đơn --</option>
                        <option value="tang luong">Đơn xin tăng lương</option>
                        <option value="doi lich">Đơn xin đổi lịch làm</option>
                        <option value="xin nghi">Đơn xin nghỉ</option>
                        <option value="chuyen cong tac">Đơn xin chuyển đơn vị công tác</option>
                        <option value="khac">Các loại đơn khác</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="reason">Reason</label>
                    <textarea class="form-control" id="reason" name="reason" placeholder="Enter your reason" rows="10" required></textarea>
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
