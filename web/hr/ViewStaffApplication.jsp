<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>List staff applications</title>
    </head>
    <body class="skin-black">
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
        <div class="right-side">
            <style>
                .filter-item {
                    width: 30%;
                }
            </style>
            <h2 class="mb-3 text-center title">List Applications</h2>
            <form action="ViewStaffApplication" method="get" class="searchForm">
                <input type="hidden" name="staffId" value="${sessionScope.staff.id}" />
                <div  class="row d-flex justify-content-center">
                    <div class="filter-container">
                        <div class="filter-item" style="width: 94%">
                            <span>Full name</span>
                            <div class="search-input">
                                <input type="text" name="staffName" placeholder="Search staff name..." value="${param.staffName}" onchange="this.form.submit()"/>
                            </div>
                        </div>
                        <div class="filter-item">
                            <span for="typeName">Application name</span>
                            <select name="typeName" id="typeName" onchange="this.form.submit()">
                                <option value="" ${empty param.typeName ? 'selected' : ''}>All</option>
                                <c:forEach var="type" items="${typeList}">
                                    <option value="${type.name}" ${param.typeName == type.name ? 'selected' : ''}>${type.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="filter-item">
                            <span for="dateSendFrom">Date send from</span>
                            <input type="date" class="form-control" name="dateSendFrom" id="dateSendFrom" value="${param.dateSendFrom}" onblur="this.form.submit()"/>
                        </div>  
                        <div class="filter-item">
                            <span for="dateSendTo">To</span>
                            <input type="date" class="form-control" name="dateSendTo" id="dateSendTo" value="${param.dateSendTo}" onblur="this.form.submit()"/>
                        </div>

                        <!-- Status -->
                        <div class="filter-item">
                            <span for="status">Status</span>
                            <select name="status" id="status" onchange="this.form.submit()">
                                <option value="" ${empty param.status ? 'selected' : ''}>All</option>
                                <option value="Pending" ${param.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                <option value="Approved" ${param.status == 'Approved' ? 'selected' : ''}>Approved</option>
                                <option value="Rejected" ${param.status == 'Rejected' ? 'selected' : ''}>Rejected</option>
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
                    <button type="submit" class="back-btn">Search</button>
                </div>
            </form>
            <table class="table">
                <thead>
                    <tr style="background-color: #007bff; color: white">
                        <th>#</th>
                        <th>Staff ID</th>
                        <th>Staff name</th>
                        <th>Type name</th>
                        <th>Date send</th>
                        <th>Reason</th>
                        <th>Status</th>
                        <th>Date reply</th>
                        <th style="text-align-last: center">Reply</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="app" items="${applications}" varStatus="status">
                        <tr>
                            <td>${status.index + 1}</td>
                            <td>${app.staffSendId}</td>
                            <td>${app.staffName}</td>
                            <td>${app.typeName}</td>                   
                            <td><fmt:formatDate value="${app.dateSend}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                            <td>${app.reason}</td>
                            <td>${app.status}</td>
                            <td><fmt:formatDate value="${app.dateReply}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                            <td>${app.reply}</td>
                            <td> <c:if test="${fn:toLowerCase(app.status) == 'pending'}">
                                    <a style="display: block;width: 110px;margin: 0" class="add-btn" href="EditStaffApplication?applicationId=${app.id}&status=Approved">Approved</a>
                                    <a style="display: block;width: 110px" class="delete-btn" href="EditStaffApplication?applicationId=${app.id}&status=Rejected">Rejected</a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div class="pre-next-Btn">
                <!-- Nút Previous -->
                <c:if test="${currentPage > 1}">
                    <a class="page-link" href="ViewStaffApplication?staffId=${sessionScope.staff.id}&page=${currentPage - 1}&staffName=${param.staffName}&dateSendFrom=${param.dateSendFrom}&dateSendTo=${param.dateSendTo}&typeName=${param.typeName}&status=${param.status}&sort=${param.sort}&size=${param.size}">Previous</a>
                </c:if>
                <!-- Phần phân trang -->
                <div class="page-link-container">
                    <c:choose>
                        <c:when test="${totalPages <= 5}">
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a class="page-link ${i == currentPage ? 'active' : ''}" href="ViewStaffApplication?staffId=${sessionScope.staff.id}&page=${i}&staffName=${param.staffName}&dateSendFrom=${param.dateSendFrom}&dateSendTo=${param.dateSendTo}&typeName=${param.typeName}&status=${param.status}&sort=${param.sort}&size=${param.size}">${i}</a>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <a class="page-link ${currentPage == 1 ? 'active' : ''}" href="ViewStaffApplication?staffId=${sessionScope.staff.id}&page=1&staffName=${param.staffName}&dateSendFrom=${param.dateSendFrom}&dateSendTo=${param.dateSendTo}&typeName=${param.typeName}&status=${param.status}&sort=${param.sort}&size=${param.size}">1</a>
                            <c:if test="${currentPage > 2}">
                                <span class="page-link">...</span>
                            </c:if>

                            <c:forEach begin="${currentPage - 1}" end="${currentPage + 1}" var="i">
                                <c:if test="${i > 1 && i < totalPages}">
                                    <a class="page-link ${i == currentPage ? 'active' : ''}" href="ViewStaffApplication?staffId=${sessionScope.staff.id}&page=${i}&staffName=${param.staffName}&dateSendFrom=${param.dateSendFrom}&dateSendTo=${param.dateSendTo}&typeName=${param.typeName}&status=${param.status}&sort=${param.sort}&size=${param.size}">${i}</a>
                                </c:if>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages - 2}">
                                <span class="page-link">...</span>
                            </c:if>
                            <a class="page-link ${currentPage == totalPages ? 'active' : ''}" href="ViewStaffApplication?staffId=${sessionScope.staff.id}&page=${totalPages}&staffName=${param.staffName}&dateSendFrom=${param.dateSendFrom}&dateSendTo=${param.dateSendTo}&typeName=${param.typeName}&status=${param.status}&sort=${param.sort}&size=${param.size}">${totalPages}</a>
                        </c:otherwise>
                    </c:choose>
                </div>
                <!-- Nút Next -->
                <c:if test="${currentPage < totalPages}">
                    <a class="page-link" href="ViewStaffApplication?staffId=${sessionScope.staff.id}&page=${currentPage + 1}&staffName=${param.staffName}&dateSendFrom=${param.dateSendFrom}&dateSendTo=${param.dateSendTo}&typeName=${param.typeName}&status=${param.status}&sort=${param.sort}&size=${param.size}">Next</a>
                </c:if>
            </div>

    </body>
</html>
