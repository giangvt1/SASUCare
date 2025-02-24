<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>   
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>List Application</title>
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
    </head>
    <body class="skin-black">
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <div class="right-side">
            <style>
                .filter-item {
                    width: 30%;
                }
            </style>
            <h2 class="mb-3 text-center title">List Applications</h2>
            <form action="ViewApplication" method="get" class="searchForm">
                <input type="hidden" name="staffId" value="${sessionScope.staff.id}" />

                <div  class="row d-flex justify-content-center">
                    <div class="filter-container">
                        <div class="filter-item">
                            <span for="typeName">Name application</span>
                            <select name="name" id="name" onchange="this.form.submit()">
                                <option value="" ${empty param.name ? 'selected' : ''}>All</option>
                                <c:forEach var="type" items="${typeList}">
                                    <option value="${type.name}" ${param.name == type.name ? 'selected' : ''}>${type.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="filter-item">
                            <span for="dateSend">Date Send</span>
                            <input type="date" class="form-control" name="dateSend" id="dateSend" value="${param.dateSend}" onblur="this.form.submit()"/>
                        </div>

                        <!-- Status -->
                        <div class="filter-item">
                            <span for="status">Status</span>
                            <select name="status" id="status" onchange="this.form.submit()">
                                <option value="" ${empty param.status ? 'selected' : ''}>All</option>
                                <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Pending</option>
                                <option value="approved" ${param.status == 'approved' ? 'selected' : ''}>Approved</option>
                                <option value="rejected" ${param.status == 'rejected' ? 'selected' : ''}>Rejected</option>
                            </select>
                        </div>

                        <!-- Sort -->
                        <div class="filter-item">
                            <span for="sort">Sort</span>
                            <select name="sort" id="sort" onchange="this.form.submit()">
                                <option value="default" ${param.sort == 'default' ? 'selected' : ''}>Default</option>
                                <option value="dateLTH" ${param.sort == 'dateLTH' ? 'selected' : ''}>Date Increment</option>
                                <option value="dateHTL" ${param.sort == 'dateHTL' ? 'selected' : ''}>Date Decrement</option>
                            </select>
                        </div>
                        <!-- Size -->
                        <div class="filter-item">
                            <span for="size">Sise each table</span>
                            <select name="size" id="size" onchange="this.form.submit()">
                                <option value="10" ${param.size == '10' ? 'selected' : ''}>10</option>
                                <option value="5" ${param.size == '5' ? 'selected' : ''}>5</option>
                                <option value="20" ${param.size == '20' ? 'selected' : ''}>20</option>
                                <option value="100" ${param.size == '100' ? 'selected' : ''}>100</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="submit-container">
                    <button type="submit" class="back-btn">Submit</button>
                </div>
            </form>
            <div class="table-data mt-4">
                <div style="margin-bottom: 30px"></div>
                <a class="add-btn" href="../doctor/SendApplication">Send Application</a>
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
                        <c:forEach var="app" items="${applications}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td>${app.typeName}</td>
                                <td><fmt:formatDate value="${app.dateSend}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
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
                        <a class="page-link" href="ViewApplication?staffId=${sessionScope.staff.id}&page=${currentPage - 1}&name=${param.name}&date=${param.date}&status=${param.status}&sort=${param.sort}&size=${param.size}">Previous</a>
                    </c:if>
                    <!-- Phần phân trang -->
                    <div class="page-link-container">
                        <c:choose>
                            <c:when test="${totalPages <= 5}">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <a class="page-link ${i == currentPage ? 'active' : ''}" href="ViewApplication?staffId=${sessionScope.staff.id}&page=${i}&name=${param.name}&date=${param.date}&status=${param.status}&sort=${param.sort}&size=${param.size}">${i}</a>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <a class="page-link ${currentPage == 1 ? 'active' : ''}" href="ViewApplication?staffId=${sessionScope.staff.id}&page=1&name=${param.name}&date=${param.date}&status=${param.status}&sort=${param.sort}&size=${param.size}">1</a>
                                <c:if test="${currentPage > 2}">
                                    <span class="page-link">...</span>
                                </c:if>

                                <c:forEach begin="${currentPage - 1}" end="${currentPage + 1}" var="i">
                                    <c:if test="${i > 1 && i < totalPages}">
                                        <a class="page-link ${i == currentPage ? 'active' : ''}" href="ViewApplication?staffId=${sessionScope.staff.id}&page=${i}&name=${param.name}&date=${param.date}&status=${param.status}&sort=${param.sort}&size=${param.size}">${i}</a>
                                    </c:if>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages - 2}">
                                    <span class="page-link">...</span>
                                </c:if>
                                <a class="page-link ${currentPage == totalPages ? 'active' : ''}" href="ViewApplication?staffId=${sessionScope.staff.id}&page=${totalPages}&name=${param.name}&date=${param.date}&status=${param.status}&sort=${param.sort}&size=${param.size}">${totalPages}</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <!-- Nút Next -->
                    <c:if test="${currentPage < totalPages}">
                        <a class="page-link" href="ViewApplication?staffId=${sessionScope.staff.id}&page=${currentPage + 1}&name=${param.name}&date=${param.date}&status=${param.status}&sort=${param.sort}&size=${param.size}">Next</a>
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
    </body>
</html>
