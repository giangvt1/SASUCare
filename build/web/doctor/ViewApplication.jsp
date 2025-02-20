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
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
    </head>
    <body class="skin-black">
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <div class="right-side">
            <h2 class="mb-3 text-center title">List Applications</h2>
            <form style="margin-left: 15%; margin-top: 30px " action="ViewApplication" method="get" class="sidebar-form" id="searchApplicationForm">
                <input type="hidden" name="did" value="16" />

                <div  class="row d-flex justify-content-center">
                    <!-- Name Application -->
                    <div class="col-md-2 form-group">
                        <label for="name">name application</label>
                        <select class="form-control" name="name" id="name" onchange="this.form.submit()">
                            <option value="" ${empty param.name ? 'selected' : ''}>All</option>
                            <option value="tang luong" ${param.name == 'tang luong' ? 'selected' : ''}>Đơn xin tăng lương</option>
                            <option value="doi lich" ${param.name == 'doi lich' ? 'selected' : ''}>Đơn xin đổi lịch làm</option>
                            <option value="xin nghi" ${param.name == 'xin nghi' ? 'selected' : ''}>Đơn xin nghỉ</option>
                            <option value="chuyen cong tac" ${param.name == 'chuyen cong tac' ? 'selected' : ''}>Đơn xin chuyển đơn vị</option>
                            <option value="khac" ${param.name == 'khac' ? 'selected' : ''}>Loại khác</option>
                        </select>
                    </div>

                    <!-- Date -->
                    <div class="col-md-2 form-group">
                        <label for="date">Date</label>
                        <input type="date" class="form-control" name="date" id="date" value="${param.date}" onblur="this.form.submit()"/>
                    </div>

                    <!-- Status -->
                    <div class="col-md-2 form-group">
                        <label for="status">Status</label>
                        <select class="form-control" name="status" id="status" onchange="this.form.submit()">
                            <option value="" ${empty param.status ? 'selected' : ''}>All</option>
                            <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Pending</option>
                            <option value="done" ${param.status == 'done' ? 'selected' : ''}>Done</option>
                            <option value="reject" ${param.status == 'reject' ? 'selected' : ''}>Reject</option>
                        </select>
                    </div>

                    <!-- Sort -->
                    <div class="col-md-2 form-group">
                        <label for="sort">Sort</label>
                        <select class="form-control" name="sort" id="sort" onchange="this.form.submit()">
                            <option value="default" ${param.sort == 'default' ? 'selected' : ''}>Default</option>
                            <option value="dateLTH" ${param.sort == 'dateLTH' ? 'selected' : ''}>Date Increment</option>
                            <option value="dateHTL" ${param.sort == 'dateHTL' ? 'selected' : ''}>Date Decrement</option>
                        </select>
                    </div>
                    <!-- Size -->
                    <div class="col-md-2 form-group">
                        <label for="size">Sise each table</label>
                        <select class="form-control" name="size" id="size" onchange="this.form.submit()">
                            <option value="10" ${param.size == '10' ? 'selected' : ''}>10</option>
                            <option value="5" ${param.size == '1' ? 'selected' : ''}>5</option>
                            <option value="20" ${param.size == '2' ? 'selected' : ''}>20</option>
                            <option value="100" ${param.size == '20' ? 'selected' : ''}>100</option>
                        </select>
                    </div>
                </div>
            </form>
            <div class="table-data mt-4">
                <div style="margin-bottom: 30px"></div>
                <a class="add-btn" href="../doctor/SendApplication.jsp">Send Application</a>
                <table class="table" style="width:95%">
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
                    <!-- Nút Previous -->
                    <c:if test="${currentPage > 1}">
                        <a class="page-link" href="ViewApplication?did=${param.did}&page=${currentPage - 1}&name=${param.name}&date=${param.date}&status=${param.status}&sort=${param.sort}&size=${param.size}">Previous</a>
                    </c:if>
                    <!-- Phần phân trang -->
                    <div class="page-link-container">
                        <c:choose>
                            <c:when test="${totalPages <= 5}">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <a class="page-link ${i == currentPage ? 'active' : ''}" href="ViewApplication?did=${param.did}&page=${i}&name=${param.name}&date=${param.date}&status=${param.status}&sort=${param.sort}&size=${param.size}">${i}</a>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <a class="page-link ${currentPage == 1 ? 'active' : ''}" href="ViewApplication?did=${param.did}&page=1&name=${param.name}&date=${param.date}&status=${param.status}&sort=${param.sort}&size=${param.size}">1</a>
                                <c:if test="${currentPage > 2}">
                                    <span class="page-link">...</span>
                                </c:if>

                                <c:forEach begin="${currentPage - 1}" end="${currentPage + 1}" var="i">
                                    <c:if test="${i > 1 && i < totalPages}">
                                        <a class="page-link ${i == currentPage ? 'active' : ''}" href="ViewApplication?did=${param.did}&page=${i}&name=${param.name}&date=${param.date}&status=${param.status}&sort=${param.sort}&size=${param.size}">${i}</a>
                                    </c:if>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages - 2}">
                                    <span class="page-link">...</span>
                                </c:if>
                                <a class="page-link ${currentPage == totalPages ? 'active' : ''}" href="ViewApplication?did=${param.did}&page=${totalPages}&name=${param.name}&date=${param.date}&status=${param.status}&sort=${param.sort}&size=${param.size}">${totalPages}</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <!-- Nút Next -->
                    <c:if test="${currentPage < totalPages}">
                        <a class="page-link" href="ViewApplication?did=${param.did}&page=${currentPage + 1}&name=${param.name}&date=${param.date}&status=${param.status}&sort=${param.sort}&size=${param.size}">Next</a>
                    </c:if>
                </div>
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
