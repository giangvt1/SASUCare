<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>List Application</title>
        <link href="../css/admin/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/admin/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/admin/styleAdmin.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="../css/doctor/manage_medical_style.css"/>
    </head>
    <body class="skin-black">
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <div class="right-side">
            <h2 class="mb-3">List Aplication</h2>
            <a href="../doctor/SendApplication.jsp">Send Application</a>
            <form action="ViewApplication" method="get" class="sidebar-form" id="searchApplicationForm">
                <input type="text" name="did" hidden value="16" />
                <div class="filter-medical">
                    <select name="name">
                        <option value="" ${empty param.name ? 'selected' : ''}>All name application</option>
                        <option value="tang luong" ${param.name == 'tang luong' ? 'selected' : ''}>Đơn xin tăng lương</option>
                        <option value="doi lich" ${param.name == 'doi lich' ? 'selected' : ''}>Đơn xin đổi lịch làm</option>
                        <option value="xin nghi" ${param.name == 'xin nghi' ? 'selected' : ''}>Đơn xin nghỉ</option>
                        <option value="chuyen cong tac" ${param.name == 'chuyen cong tac' ? 'selected' : ''}>Đơn xin chuyển đơn vị công tác</option>
                        <option value="khac" ${param.name == 'khac' ? 'selected' : ''}>Các loại đơn khác</option>
                    </select>
                    <input type="date" name="date" value="${param.date}" />
                    <select name="status">
                        <option value="" ${empty param.status ? 'selected' : ''}>All status</option>
                        <option value="pending" ${param.status == 'peding' ? 'selected' : ''}>Pending</option>
                        <option value="done" ${param.status == 'done' ? 'selected' : ''}>Done</option>
                        <option value="reject" ${param.status == 'reject' ? 'selected' : ''}>Reject</option>
                    </select>
                </div>
                <select name="sort" id="sort">
                    <option value="default" ${empty param.sort == 'default' ? 'selected' : ''}>Sort Default</option>
                    <option value="dateLTH" ${param.sort == 'dateLTH' ? 'selected' : ''}>Date low to high</option>
                    <option value="dateHTL" ${param.sort == 'dateHTL' ? 'selected' : ''}>Date high to low</option>
                </select>
                <select name="size" id="size">
                    <option value="10" ${param.size == '10' ? 'selected' : ''}>Data per page 10</option>
                    <option value="1" ${param.size == '1' ? 'selected' : ''}>Data per page 1</option>
                    <option value="2" ${param.size == '2' ? 'selected' : ''}>Data per page 2</option>
                    <option value="20" ${param.size == '20' ? 'selected' : ''}>Data per page 20</option>
                </select>
                <input style="margin-left: 38%" class="submit-search" type="submit" value="Search" />
            </form>
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
                <a class="page-link" id="previousBtn" href="ViewApplication?did=${param.did}&page=${currentPage - 1}&name=${param.name}&date=${param.date}&status=${param.status}&sort=${param.sort}&size=${param.size}">Previous</a>
                <span class="page-link page-num">Page ${currentPage}</span>
                <a class="page-link" id="nextBtn" href="ViewApplication?did=${param.did}&page=${currentPage + 1}&name=${param.name}&date=${param.date}&status=${param.status}&sort=${param.sort}&size=${param.size}">Next</a>
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
        <script>
            document.getElementById("sort").addEventListener("change", function () {
                document.getElementById("searchApplicationForm").submit();
            });

            document.getElementById("size").addEventListener("change", function () {
                document.getElementById("searchApplicationForm").submit();
            });
        </script>
    </body>
</html>
