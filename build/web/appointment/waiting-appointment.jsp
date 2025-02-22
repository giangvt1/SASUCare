<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Pending Appointments</title>
        <link rel="stylesheet" href="styles.css">
        <link href="../css/admin/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/admin/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/admin/styleAdmin.css" rel="stylesheet" type="text/css"/>

        <style>
            /* Filter Section Styling */
            .search-form {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                margin-bottom: 20px;
                justify-content: flex-start;
            }

            .filter-input {
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
                width: 200px;
            }

            .filter-input:focus {
                border-color: #007bff;
                outline: none;
            }

            .btn {
                background-color: #007bff;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            .btn:hover {
                background-color: #0056b3;
            }

            .appointments-container {
                margin-top: 50px;
                margin-left: 260px;
                padding: 20px;
            }

            .alert {
                margin-top: 20px;
            }

            /* Appointment Card Styling */
            .appointment-card {
                background-color: #f8f9fa;
                padding: 20px;
                margin-bottom: 15px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .appointment-card h3 {
                margin-bottom: 10px;
                color: #007bff;
            }

            .appointment-card p {
                margin-bottom: 8px;
                font-size: 16px;
            }

            .btn-approve {
                background-color: #28a745;
            }

            .btn-reject {
                background-color: #dc3545;
            }

            .btn-view {
                background-color: #007bff;
            }

            .no-appointments {
                text-align: center;
                font-size: 18px;
                color: #888;
                margin-top: 20px;
            }
        </style>
    </head>
    <body>
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />

        <div class="appointments-container">
            <h2>Pending Appointments</h2>

            <!-- ✅ Filter Section -->
            <form action="${pageContext.request.contextPath}/doctor/waiting-appointment" method="get" class="search-form">
                <!-- Search by Customer Name -->
                <input type="text" name="customerName" placeholder="Search by Customer Name" value="${param.customerName}" class="filter-input">

                <!-- Sort by Date -->
                <select name="sortOrder" class="filter-input">
                    <option value="asc" ${param.sortOrder == 'asc' ? 'selected' : ''}>Sort by Date (Ascending)</option>
                    <option value="desc" ${param.sortOrder == 'desc' ? 'selected' : ''}>Sort by Date (Descending)</option>
                </select>

                <!-- Submit Filter -->
                <button type="submit" class="btn">Filter</button>
            </form>

            <!-- ✅ Success Message -->
            <c:if test="${param.success == 'true'}">
                <div class="alert alert-success">Appointment updated successfully!</div>
            </c:if>

            <!-- ✅ Pending Appointments List -->
            <div class="appointment-list">
                <c:choose>
                    <c:when test="${not empty appointments}">
                        <c:forEach var="appointment" items="${appointments}">
                            <div class="appointment-card">
                                <h3>${appointment.customer.id}</h3>
                                <p><strong>Date:</strong> <fmt:formatDate value="${appointment.doctorSchedule.scheduleDate}" pattern="yyyy-MM-dd" /></p>
                                <p><strong>Time Slot:</strong> ${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}</p>
                                <p><strong>Department:</strong> ${appointment.doctor.staff.department.name}</p>
                                <p><strong>Status:</strong> Pending</p>

                                <!-- ✅ Approve/Reject Actions -->
                                <form action="${pageContext.request.contextPath}/doctor/waiting-appointment" method="post">
                                    <input type="hidden" name="appointmentId" value="${appointment.id}">
                                    <button type="button" class="btn btn-approve"
                                            onclick="cancelOrAcceptAppointment('${appointment.id}', 'approve')">
                                        Approve
                                    </button>
                                    <button type="button" class="btn btn-approve"
                                            onclick="cancelOrAcceptAppointment('${appointment.id}', 'cancel')">
                                        Reject
                                    </button>
                                </form>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p class="no-appointments">No pending appointments found.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <script>
            function cancelOrAcceptAppointment(appointmentId, action) {
                let confirmationMessage = action === "cancel" ?
                        "Are you sure you want to cancel this appointment?" :
                        "Are you sure you want to approve this appointment?";

                if (confirm(confirmationMessage)) {
                    // Redirect to appropriate servlet with query parameters
                    window.location.href = "../doctor/appointment/action?appointmentId=" + appointmentId + "&action=" + action;
                }
            }


        </script>

    </body>
</html>
