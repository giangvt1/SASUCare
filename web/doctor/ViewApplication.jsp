<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Application</title>
        <link href="../css/admin/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/admin/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/admin/styleAdmin.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
    </head>
    <body class="skin-black">
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../doctor/DoctorLeftSideBar.jsp" />
        <div class="right-side">
            <h2 class="mb-3">List Aplication</h2>
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Date</th>
                        <th>Reason</th>
                        <th>Status</th>
                        <th>Reply</th>
                    </tr>
                </thead>
                <tbody>
                <div class="hasNextPage" hidden>${hasNextPage}</div>
                <c:forEach var="app" items="${applications}" varStatus="status">
                    <tr>
                        <td>${status.index + 1}</td>
                        <td>${app.name}</td>
                        <td>${app.date}</td>
                        <td>${app.reason}</td>
                        <td>${app.status}</td>
                        <td>${app.reply}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <div class="pre-next-Btn">
                <a class="page-link" id="previousBtn" href="ViewApplication?did=${param.did}&page=${currentPage - 1}">Previous</a>
                <span class="page-link page-num">Page ${currentPage}</span>
                <a class="page-link" id="nextBtn" href="ViewApplication?did=${param.did}&page=${currentPage + 1}">Next</a>
            </div>
        </div>

        <script>
            let hasNextPage = document.querySelector(".hasNextPage").textContent.trim();
            let pre = document.querySelector("#previousBtn");
            let next = document.querySelector("#nextBtn");
            let p = document.querySelector(".page-num").textContent.trim();

            if (p === "Page 1")
                pre.classList.add("disabled");
            if (hasNextPage === "false")
                next.classList.add("disabled");
        </script>
        <script>
            document.querySelectorAll(".sidebar-menu > li").forEach((li) => {
                li.classList.remove("active");
            });
            let manageApplication = document.querySelector(".manage-application");
            manageApplication.classList.add("active");
        </script>
    </body>
</html>