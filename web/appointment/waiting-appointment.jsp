<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Pending Appointments</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
        <link href="../css/admin/styleAdmin.css" rel="stylesheet" type="text/css"/>

        <style>
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

            .appointments-container {
                margin-top: 50px;
                margin-left: 260px;
                padding: 20px;
            }

            .appointment-card {
                background-color: #f8f9fa;
                padding: 20px;
                margin-bottom: 15px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                cursor: pointer;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .appointment-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            }

            .appointment-card::after {
                /*content: '👆 Click for details';*/
                position: absolute;
                right: 10px;
                bottom: 10px;
                font-size: 0.8em;
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .appointment-card:hover::after {
                opacity: 0.7;
            }

            .appointment-actions {
                display: flex;
                gap: 10px;
                margin-top: 10px;
            }

            .btn-approve {
                background-color: #28a745;
                color: white;
            }
            .btn-reject {
                background-color: #dc3545;
                color: white;
            }

            .modal {
                backdrop-filter: blur(5px);
            }

            .modal-content {
                border-radius: 15px;
                box-shadow: 0 0 25px rgba(0, 0, 0, 0.2);
            }

            .modal-body dl {
                display: grid;
                grid-template-columns: auto 1fr;
                gap: 15px 30px;
                margin: 0;
            }

            .modal-body dt {
                font-weight: bold;
                color: #007bff;
                display: flex;
                align-items: center;
            }

            .modal-body dd {
                margin: 0;
                padding: 8px;
                background: #f8f9fa;
                border-radius: 5px;
            }

            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                margin-top: 20px;
            }

            .pagination a {
                margin: 0 5px;
                padding: 8px 16px;
                text-decoration: none;
                color: #007bff;
                border: 1px solid #ddd;
                border-radius: 5px;
                transition: background-color 0.3s;
            }

            .pagination a:hover {
                background-color: #f1f1f1;
            }

            .pagination span {
                margin: 0 10px;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />

        <div class="appointments-container right-side">
            <h2>Pending Appointments</h2>

            Filter Section 
            <form action="${pageContext.request.contextPath}/doctor/waiting-appointment" method="get" class="search-form">
                <input type="text" name="customerName" placeholder="Search by Customer Name" 
                       value="${param.customerName}" class="filter-input">

                <select name="sortOrder" class="filter-input">
                    <option value="asc" ${param.sortOrder == 'asc' ? 'selected' : ''}>Sort by Date (Ascending)</option>
                    <option value="desc" ${param.sortOrder == 'desc' ? 'selected' : ''}>Sort by Date (Descending)</option>
                </select>

                <button type="submit" class="btn btn-primary">Filter</button>
            </form>


            <div class="appointment-list">
                <c:choose>
                    <c:when test="${not empty appointments}">
                        <c:set var="hasPending" value="false" />

                        <c:forEach var="appointment" items="${appointments}">
                            <c:if test="${appointment.status eq 'Pending'}">
                                <c:set var="hasPending" value="true" />
                                <div class="appointment-card" onclick="showAppointmentDetails(this, '${appointment.id}')">
                                    <h3>Patient Appointment</h3>
                                    <p><i class="fa fa-calendar"></i> <strong>Date:</strong> 
                                        <fmt:formatDate value="${appointment.doctorSchedule.scheduleDate}" pattern="yyyy-MM-dd" />
                                    </p>
                                    <p><i class="fa fa-clock-o"></i> <strong>Time:</strong> 
                                        ${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}
                                    </p>
                                    <p><i class="fa fa-user"></i> <strong>Patient Name:</strong> ${appointment.customer.fullname}</p>

                                    <div class="appointment-actions" onclick="event.stopPropagation();">
                                        <button type="button" class="btn btn-approve"
                                                onclick="cancelOrAcceptAppointment('${appointment.id}', 'approve')">
                                            <i class="fa fa-check"></i> Approve
                                        </button>
                                        <button type="button" class="btn btn-reject"
                                                onclick="cancelOrAcceptAppointment('${appointment.id}', 'cancel')">
                                            <i class="fa fa-times"></i> Reject
                                        </button>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>

                        <c:if test="${not hasPending}">
                            <div class="alert alert-info">
                                <i class="fa fa-info-circle"></i> No pending appointments found.
                            </div>
                        </c:if>

                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info">
                            <i class="fa fa-info-circle"></i> No pending appointments found.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>


        <div class="modal fade" id="appointmentDetailsModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fa fa-calendar-check-o"></i> Appointment Details
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <dl>
                            <dt><i class="fa fa-user"></i> Patient ID</dt>
                            <dd id="modalCustomerId"></dd>

                            <dt><i class="fa fa-calendar"></i> Date</dt>
                            <dd id="modalDate"></dd>

                            <dt><i class="fa fa-clock-o"></i> Time Slot</dt>
                            <dd id="modalTimeSlot"></dd>

                            <dt><i class="fa fa-stethoscope"></i> Specialization</dt>
                            <dd id="modalSpecialization"></dd>

                            <dt><i class="fa fa-info-circle"></i> Status</dt>
                            <dd id="modalStatus" class="badge bg-warning">Pending</dd>
                        </dl>

                        <div class="appointment-actions mt-4">
                            <button type="button" class="btn btn-approve" id="modalApproveBtn">
                                <i class="fa fa-check"></i> Approve
                            </button>
                            <button type="button" class="btn btn-reject" id="modalRejectBtn">
                                <i class="fa fa-times"></i> Reject
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <% int currentPage = (int) request.getAttribute("currentPage");
   int totalPages = (int) request.getAttribute("totalPages");
   int pageSize = (int) request.getAttribute("pageSize");
        %>

        <div class="pagination">
            <% if (currentPage > 1) { %>
            <a href="?page=1&pageSize=<%=pageSize%>">First</a>
            <a href="?page=<%=currentPage - 1%>&pageSize=<%=pageSize%>">Previous</a>
            <% } %>

            <span>Page <%= currentPage %> of <%= totalPages %></span>

            <% if (currentPage < totalPages) { %>
            <a href="?page=<%=currentPage + 1%>&pageSize=<%=pageSize%>">Next</a>
            <a href="?page=<%=totalPages%>&pageSize=<%=pageSize%>">Last</a>
            <% } %>
        </div>



        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
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