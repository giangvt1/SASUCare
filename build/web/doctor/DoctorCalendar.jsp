<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor Weekly Schedule</title>
    <!-- Include CSS admin_styles.css của bạn -->
    <link href="${pageContext.request.contextPath}/css/admin_styles.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .schedule-table {
            margin-top: 20px;
        }
        .schedule-table th, .schedule-table td {
            text-align: center;
            vertical-align: middle;
        }
    </style>
</head>
<body>
    <!-- Include Header và Sidebar -->
    <jsp:include page="../admin/AdminHeader.jsp" />
    <jsp:include page="../admin/AdminLeftSideBar.jsp" />

    <div class="right-side stretch">
        <main class="main-content">
            <div class="container-fluid p-0">
                <h2>Weekly Schedule for Dr. ${doctor.name}</h2>
                <p>Week: <strong>${weekStart}</strong> to <strong>${weekEnd}</strong></p>
                <table class="table table-bordered schedule-table">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Shift Time</th>
                            <th>Shift Label</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${weeklySchedules}" var="schedule">
                            <tr>
                                <td>${schedule.scheduleDate}</td>
                                <td>
                                    ${schedule.shift.timeStart} - ${schedule.shift.timeEnd}
                                </td>
                                <td>
                                    <!-- Hiển thị label theo định dạng "K<shiftId>" -->
                                    K${schedule.shift.id}
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${schedule.available}">
                                            Available
                                        </c:when>
                                        <c:otherwise>
                                            Not Available
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
    