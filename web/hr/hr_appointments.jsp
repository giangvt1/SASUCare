<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
                                            <h6 class="mb-1"><fmt:formatDate value="${appointment.doctorSchedule.scheduleDate}" pattern="dd/MM/yyyy" /></h6>
                                            <small class="text-muted">${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}</small>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <span class="status-badge status-${appointment.status}">
                                                    ${appointment.status}
                                                </span>
                                                <div class="action-buttons">
                                                    <button class="btn btn-sm btn-outline-primary" onclick="viewDetails('${appointment.doctorSchedule.scheduleDate}', '${appointment.doctor.id}')">
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

        <div class="modal fade" id="appointmentModal" tabindex="-1" aria-labelledby="appointmentModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="appointmentModalLabel">Appointment Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <table class="table">
                            <tbody>
                                <tr>
                                    <th>Patient Name</th>
                                    <td id="patientName"></td>
                                </tr>
                                <tr>
                                    <th>Doctor Name</th>
                                    <td id="doctorName"></td>
                                </tr>
                                <tr>
                                    <th>Department</th>
                                    <td id="department"></td>
                                </tr>
                                <tr>
                                    <th>Appointment Date</th>
                                    <td id="appointmentDate"></td>
                                </tr>
                                <tr>
                                    <th>Time</th>
                                    <td id="appointmentTime"></td>
                                </tr>
                                <tr>
                                    <th>Status</th>
                                    <td id="appointmentStatus"></td>
                                </tr>
                                <tr>
                                    <th>Notes</th>
                                    <td id="appointmentNotes"></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
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
                                                                            "Are you sure that you want to cancel this appointment?" :
                                                                            "Are you sure that you want to confirm this appointment?";

                                                                    if (confirm(confirmationMessage)) {
                                                                        // Redirect to appropriate servlet with query parameters
                                                                        window.location.href = "../doctor/appointment/action?appointmentId=" + appointmentId + "&action=" + action;
                                                                    }
                                                                }

                                                                function viewDetails(date, doctorId) {
                                                                    fetch(`/SWP391_GR6/doctor/api/appointments?date=` + date + `&doctorId=` + doctorId)
                                                                            .then(response => response.json())
                                                                            .then(data => {
                                                                                if (data.length === 0) {
                                                                                    alert("No appointments found for this date and doctor.");
                                                                                    return;
                                                                                }

                                                                                let appointment = data[0]; // Get first appointment from the response

                                                                                // 🟢 Fix: Check if elements exist before setting values
                                                                                let patientNameElem = document.getElementById("patientName");
                                                                                let doctorNameElem = document.getElementById("doctorName");
                                                                                let departmentElem = document.getElementById("department");
                                                                                let appointmentDateElem = document.getElementById("appointmentDate");
                                                                                let appointmentTimeElem = document.getElementById("appointmentTime");
                                                                                let appointmentStatusElem = document.getElementById("appointmentStatus");
                                                                                let appointmentNotesElem = document.getElementById("appointmentNotes");
                                                                                if (!patientNameElem || !doctorNameElem || !departmentElem || !appointmentDateElem || !appointmentTimeElem || !appointmentStatusElem || !appointmentNotesElem) {
                                                                                    console.error("Modal elements not found in DOM.");
                                                                                    return;
                                                                                }

                                                                                //  Update modal content with appointment details
                                                                                patientNameElem.innerText = appointment.customer.fullname || "N/A"; // Use customer ID instead of fullname since it's missing
                                                                                doctorNameElem.innerText = appointment.doctor.name || "N/A";
                                                                                departmentElem.innerText = "Department Data Not Available"; // Fix: No department in response
                                                                                appointmentDateElem.innerText = appointment.doctorSchedule.scheduleDate || "N/A";
                                                                                appointmentTimeElem.innerText = appointment.doctorSchedule.shift.timeStart + " - " + appointment.doctorSchedule.shift.timeEnd;
                                                                                appointmentStatusElem.innerText = appointment.status;
                                                                                appointmentNotesElem.innerText = "No notes available."; // Fix: Notes missing in response

                                                                                // Show modal
                                                                                let modal = new bootstrap.Modal(document.getElementById('appointmentModal'));
                                                                                modal.show();
                                                                            })
                                                                            .catch(error => {
                                                                                console.error("Error fetching appointment details:", error);
                                                                                alert("Failed to load appointment details.");
                                                                            });
                                                                }
        </script>
    </body>
</html>
