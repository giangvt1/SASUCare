<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Send Application</title>
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
    </head>
    <body class="skin-black">
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <style>
            .right-side {
                padding: 20px;
                background-color: #fff;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }

            textarea.form-control {
                resize: vertical;
            }
        </style>
        <div class="right-side">
            <h3 class="text-center title">Send Application</h3>
            <a class="back-btn" href="ViewApplication?staffId=${sessionScope.staff.id}">View Application</a>
            <form action="SendApplication" method="POST" class="mt-4">
                <input type="text" hidden id="staffId" name="staffId" value="${sessionScope.staff.id}" required><br>
                <div class="form-group">
                    <label for="typeId">Loại đơn</label>
                    <select style="width: 15%" class="form-control" name="typeId" id="typeId" required="">
                        <option value="" ${empty param.typeId ? 'selected' : ''}>Type</option>
                        <c:forEach var="type" items="${typeList}">
                            <option value="${type.id}" ${param.id == type.id ? 'selected' : ''}>${type.name}</option>
                        </c:forEach>
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
        <script>
            document.querySelector("form").addEventListener("submit", function (event) {
                let reason = document.getElementById("reason").value.trim();
                let mess = "";
                if (reason === "") {
                    mess += "Reason not null\n";

                }
                if (mess !== "") {
                    alert(mess);
                    event.preventDefault();
                }
            });
        </script>
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