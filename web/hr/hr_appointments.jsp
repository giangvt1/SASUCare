<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>HR - Appointment Management</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">

        <style>
            .appointment-card {
                transition: transform 0.2s;
                margin-bottom: 1rem;
            }

            .appointment-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }

            .status-badge {
                padding: 0.5em 1em;
                border-radius: 20px;
                font-weight: 500;
            }

            .status-Pending {
                background-color: #ffd700;
                color: #000;
            }

            .status-Confirmed {
                background-color: #28a745;
                color: #fff;
            }

            .status-Cancelled {
                background-color: #dc3545;
                color: #fff;
            }

            .filters {
                background: #f8f9fa;
                padding: 1rem;
                border-radius: 8px;
                margin-bottom: 2rem;
            }

            .action-buttons {
                display: flex;
                gap: 0.5rem;
            }

            .statistics {
                background: #fff;
                padding: 1.5rem;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-bottom: 2rem;
            }
        </style>
    </head>
    <body>

        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <div class="container-fluid py-4">
            <div class="row">


                <!-- Main content -->
                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 right-side">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1>Appointment Management</h1>
                    </div>

                    <!-- Statistics -->
                    <div class="statistics row">
                        <div class="col-md-3">
                            <h5>Total Appointments</h5>
                            <h2>${appointmentsTotal.size()}</h2>
                        </div>
                        <div class="col-md-3">
                            <h5>Pending</h5>
                            <h2>${appointmentsTotal.stream().filter(a -> a.getStatus().equals("Pending")).count()}</h2>
                        </div>
                        <div class="col-md-3">
                            <h5>Confirmed</h5>
                            <h2>${appointmentsTotal.stream().filter(a -> a.getStatus().equals("Confirmed")).count()}</h2>
                        </div>
                        <div class="col-md-3">
                            <h5>Canceled</h5>
                            <h2>${appointmentsTotal.stream().filter(a -> a.getStatus().equals("Canceled")).count()}</h2>
                        </div>
                    </div>

                    <!-- Filters -->
                    <div class="filters">
                        <form method="get" action="appointments">
                            <div class="row g-3">
                                <div class="col-md-3">
                                    <input type="text" class="form-control" name="name" placeholder="Search by name...">
                                </div>
                                <div class="col-md-3">
                                    <input type="date" class="form-control" name="date" >
                                </div>
                                <div class="col-md-3">
                                    <select class="form-select" name="status">
                                        <option value="">All Status</option>
                                        <option>Pending</option>
                                        <option>Confirmed</option>
                                        <option>Canceled</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <button type="submit" class="btn btn-primary w-100">
                                        <i class="fas fa-filter"></i> Apply Filters
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <!-- Pagination Controls -->
                    <div class="pagination">
                        <!-- Previous Button -->
                        <c:if test="${pageIndex > 1}">
                            <a href="${pageContext.request.contextPath}/hr/appointments?name=${param.name}&date=${param.date}&status=${param.status}&pageIndex=${pageIndex - 1}&pageSize=${pageSize}" class="btn btn-primary">Previous</a>          
                        </c:if>

                        <!-- Current Page and Total Pages -->
                        <span>Page ${pageIndex} of ${totalPages}</span>

                        <!-- Next Button -->
                        <c:if test="${pageIndex < totalPages}">
                            <a href="${pageContext.request.contextPath}/hr/appointments?name=${param.name}&date=${param.date}&status=${param.status}&pageIndex=${pageIndex + 1}&pageSize=${pageSize}" class="btn btn-primary">Next</a>
                        </c:if>
                    </div>


                    <!-- Appointments List -->
                    <div class="appointments-list">
                        <c:forEach var="appointment" items="${appointments}">
                            <div class="card appointment-card">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-md-3">
                                            <h5 class="card-title mb-1">${appointment.customer.fullname}</h5>
                                            <small class="text-muted">Patient ID: ${appointment.customer.id}</small>
                                        </div>
                                        <div class="col-md-3">
                                            <h6 class="mb-1">${appointment.doctor.name}</h6>
                                            <small class="text-muted">${appointment.doctor.staff.department.name}</small>
                                        </div>
                                        <div class="col-md-3">
                                            <h6 class="mb-1">${appointment.doctorSchedule.scheduleDate}</h6>
                                            <small class="text-muted">${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}</small>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <span class="status-badge status-${appointment.status}">
                                                    ${appointment.status}
                                                </span>
                                                <div class="action-buttons">
                                                    <button class="btn btn-sm btn-outline-primary" onclick="viewDetails('${appointment.id}')">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    <c:if test="${appointment.status == 'Pending' }">
                                                        <div class="approve"> <button class="btn btn-sm btn-outline-success" onclick="cancelOrAcceptAppointment('${appointment.id}', 'Confirmed')">
                                                                <i class="fas fa-check"></i>
                                                            </button>
                                                            <button class="btn btn-sm btn-outline-danger" onclick="cancelOrAcceptAppointment('${appointment.id}', 'Canceled')">
                                                                <i class="fas fa-times"></i>
                                                            </button>
                                                        </div></c:if>

                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                        </c:forEach>


                    </div>
                </main>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                                function updateStatus(appointmentId, status) {
                                                                    fetch(`/hr/api/appointments/${appointmentId}/status`, {
                                                                        method: 'POST',
                                                                        headers: {'Content-Type': 'application/json'},
                                                                        body: JSON.stringify({status: status})
                                                                    })
                                                                            .then(response => response.json())
                                                                            .then(data => {
                                                                                if (data.success)
                                                                                    window.location.reload();
                                                                                else
                                                                                    alert('Failed to update status');
                                                                            })
                                                                            .catch(error => console.error('Error:', error));
                                                                }

                                                                function cancelOrAcceptAppointment(appointmentId, action) {
                                                                    let confirmationMessage = action === "cancel" ?
                                                                            "Are you sure that you want to confirm this appointment?" :
                                                                            "Are you sure that you want to cancel this appointment?";

                                                                    if (confirm(confirmationMessage)) {
                                                                        // Redirect to appropriate servlet with query parameters
                                                                        window.location.href = "../doctor/appointment/action?appointmentId=" + appointmentId + "&action=" + action;
                                                                    }
                                                                }

                                                                function viewDetails(appointmentId) {
                                                                    alert('Viewing details for appointment: ' + appointmentId);
                                                                }
        </script>
    </body>
</html>
