<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Appointments</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="../static/css/appointment/appointments.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!--<link href="https://pay.vnpay.vn/lib/vnpay/vnpay.css" rel="stylesheet" />-->
        <script src="https://pay.vnpay.vn/lib/vnpay/vnpay.min.js"></script>
    </head>

    <body>
        <%@ page import="java.util.Date" %>
        <%
            long currentTime = new Date().getTime(); // Get current timestamp (milliseconds)
            request.setAttribute("currentTime", currentTime); // Set it as a request attribute
        %>

        <jsp:include page="../Header.jsp"/>

        <div class="appointments-container">
            <h1 class="page-title">My Appointments</h1>

            <!-- Search Form -->
            <form class="search-form" action="../appointment/list" method="get">
                <div class="search-wrapper">
                    <input type="text" 
                           class="search-input" 
                           name="doctorName" 
                           placeholder="Search by Doctor Name"
                           value="${param.doctorName}">
                    <button type="submit" class="search-button">
                        <i class="fas fa-search"></i> Search
                    </button>
                </div>
            </form>


            <!-- Confirmed Section -->
            <div class="status-section confirmed">
                <div class="status-title">Coming Up</div>
                <div class="event-list">
                    <c:set var="hasConfirmedAppointments" value="false" />
                    <c:forEach var="appointment" items="${appointments}">
                        <c:if test="${appointment.status == 'Confirmed'}">
                            <c:set var="hasConfirmedAppointments" value="true" />
                            <div class="event-card">
                                <div class="event-details">
                                    <div class="doctor-name">${appointment.doctor.name}</div>
                                    <div class="event-time">${appointment.doctorSchedule.scheduleDate} | ${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}</div>
                                    <div class="event-status">Confirmed</div>
                                </div>

                                <div class="invoice-details">
                                    <c:if test="${appointment.invoice != null}">
                                   --------------- Has invoice--------------
                                    </c:if>
                                </div>

                                <div class="action-buttons">
                                    <button class="btn btn-view" onclick="openAppointmentModal('${appointment.doctor.name}', '${appointment.doctorSchedule.scheduleDate}', '${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}', '${appointment.status}', ${appointment.invoice != null ? appointment.invoice.id : 'null'})">View Details</button>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>


                </div><c:if test="${!hasConfirmedAppointments}">
                    <div class="empty-state">
                        <i class="fas fa-calendar-check empty-state-icon"></i>
                        <p class="empty-state-text">No upcoming appointments scheduled yet.<br>
                            Book an appointment to get started!</p>
                    </div>
                </c:if>
            </div>

            <!-- Pending Section -->
            <div class="status-section pending">
                <div class="status-title">Pending</div>
                <div class="event-list">
                    <c:set var="hasPendingAppointments" value="false" />
                    <c:forEach var="appointment" items="${appointments}">
                        <c:if test="${appointment.status == 'Pending' and appointment.doctorSchedule.scheduleDate.time >= currentTime}">
                            <c:set var="hasPendingAppointments" value="true" />
                            <div class="event-card">
                                <div class="event-details">
                                    <div class="doctor-name">${appointment.doctor.name}</div>
                                    <div class="event-time">${appointment.doctorSchedule.scheduleDate} | ${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}</div>
                                    <div class="event-status">Pending</div>
                                </div>
                                <div class="action-buttons">
                                    <button class="btn btn-cancel" onclick="cancelAppointment(${appointment.id})">Cancel</button>
                                    <!--<button class="btn btn-reschedule" onclick="openRescheduleModal('${appointment.id}')">Reschedule</button>-->
                                    <button class="btn btn-view" onclick="openAppointmentModal('${appointment.doctor.name}', '${appointment.doctorSchedule.scheduleDate}', '${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}', '${appointment.status}')">View Details</button>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>

                </div> <c:if test="${!hasPendingAppointments}">
                    <div class="empty-state">
                        <i class="fas fa-hourglass-half empty-state-icon"></i>
                        <p class="empty-state-text">No pending appointments at the moment.<br>
                            Your appointment requests will appear here.</p>
                    </div>
                </c:if>
            </div>

            <!-- Canceled Section -->
            <div class="status-section canceled">
                <div class="status-title">Canceled</div>
                <div class="event-list">
                    <c:set var="hasCanceledAppointments" value="false" />
                    <c:forEach var="appointment" items="${appointments}">
                        <c:if test="${appointment.status == 'Canceled' }">
                            <c:set var="hasCanceledAppointments" value="true" />
                            <div class="event-card">
                                <div class="event-details">
                                    <div class="doctor-name">${appointment.doctor.name}</div>
                                    <div class="event-time">${appointment.doctorSchedule.scheduleDate} | ${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}</div>
                                    <div class="event-status">Canceled</div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>

                </div>
                <c:if test="${!hasCanceledAppointments}">
                    <div class="empty-state">
                        <i class="fas fa-ban empty-state-icon"></i>
                        <p class="empty-state-text">No canceled appointments.<br>
                            You can cancel appointments from the pending section.</p>
                    </div>
                </c:if>
            </div>

            <!-- Done Section -->
            <div class="status-section done">
                <div class="status-title">Done</div>
                <div class="event-list">
                    <c:set var="hasDoneAppointments" value="false" />
                    <c:forEach var="appointment" items="${appointments}">
                        <c:if test="${appointment.status == 'Done'}">
                            <c:set var="hasDoneAppointments" value="true" />
                            <div class="event-card">
                                <div class="event-details">
                                    <div class="doctor-name">${appointment.doctor.name}</div>
                                    <div class="event-time">${appointment.doctorSchedule.scheduleDate} | ${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}</div>
                                    <div class="event-status">Completed</div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>

                </div>
                <c:if test="${!hasDoneAppointments}">
                    <div class="empty-state">
                        <i class="fas fa-check-circle empty-state-icon"></i>
                        <p class="empty-state-text">No completed appointments yet.<br>
                            Your completed appointments will be listed here.</p>
                    </div>
                </c:if>
            </div>

        </div>

        <!-- Modal Templates -->
        <div id="appointmentModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Appointment Details</h3>
                    <button class="close-btn" onclick="closeModal()">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="detail-item">
                        <i class="fas fa-user-md"></i>
                        <strong>Doctor:</strong>
                        <span id="modalDoctorName"></span>
                    </div>
                    <div class="detail-item">
                        <i class="far fa-calendar"></i>
                        <strong>Date:</strong>
                        <span id="modalDate"></span>
                    </div>
                    <div class="detail-item">
                        <i class="far fa-clock"></i>
                        <strong>Time Slot:</strong>
                        <span id="modalTimeSlot"></span>
                    </div>
                    <div class="detail-item">
                        <i class="fas fa-info-circle"></i>
                        <strong>Status:</strong>
                        <span id="modalStatus"></span>
                    </div>

                    <!-- Invoice Details Section -->
                    <div id="invoiceDetails" class="detail-item">
                        <strong>Invoice Amount: </strong><span id="invoiceAmount"></span><br>
                        <strong>Invoice Status: </strong><span id="invoiceStatus"></span><br>
                        <strong>Invoice Date: </strong><span id="invoiceDate"></span><br>
                        <button id="payInvoiceButton" style="display:none;">Pay Invoice</button>
                    </div>
                </div>
            </div>
        </div>



        <jsp:include page="../Footer.jsp"/>
        <script>

            function payInvoice(invoiceId, amount, txnRef) {
                if (!txnRef) {
                    alert("Transaction reference is missing!");
                    return;
                }

                let data = new URLSearchParams();
                data.append('amount', amount);
                data.append('vnp_TxnRef', txnRef);
                data.append('bankCode', 'VNBANK');
                data.append('language', 'vn');

                fetch('/SWP391_GR6/vnpayajax', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: data
                })
                        .then(response => response.json())
                        .then(x => {
                            if (x.code === '00') {
                                window.location.href = x.data;
                            } else {
                                alert(x.message);
                            }
                        })
                        .catch(error => {
                            console.error("Error processing payment:", error);
                            alert("An error occurred while processing the payment.");
                        });
            }




            function openRescheduleModal(id) {
                document.getElementById("rescheduleAppointmentId").value = id;
                document.getElementById("rescheduleModal").style.display = "block";
            }
            function viewDetails(appointmentId) {
                // Fetch appointment data and populate modal (dummy logic for now)
                document.getElementById("modalDoctorName").innerText = "Doctor Name";
                document.getElementById("modalDate").innerText = "Date";
                document.getElementById("modalTimeSlot").innerText = "Time Slot";
                document.getElementById("modalStatus").innerText = "Status";
                document.getElementById("appointmentModal").style.display = "block";
            }
            function openAppointmentModal(doctorName, date, timeSlot, status, invoiceId) {
                document.getElementById("modalDoctorName").innerText = doctorName;
                document.getElementById("modalDate").innerText = date;
                document.getElementById("modalTimeSlot").innerText = timeSlot;
                document.getElementById("modalStatus").innerText = status;

                const payInvoiceButton = document.getElementById("payInvoiceButton");

                // Fetch invoice details by ID if the invoice exists
                if (invoiceId !== 'null') {
                    fetch(`../invoice/` + invoiceId)  // Change this to the correct endpoint for fetching the invoice
                            .then(response => response.json())
                            .then(invoice => {
                                // Display invoice details
                                document.getElementById("invoiceAmount").innerText = formatCurrency(invoice.amount);
                                document.getElementById("invoiceStatus").innerText = invoice.status;
                                document.getElementById("invoiceDate").innerText = invoice.expireDate;

                                // Conditionally display the Pay Invoice button based on invoice status
                                const payInvoiceButton = document.getElementById("payInvoiceButton");
                                if (invoice.status === 'Pending') {  // Check if the status is 'Pending' or any other condition
                                    payInvoiceButton.style.display = 'inline';
                                    payInvoiceButton.onclick = function () {
                                        payInvoice(invoice.id, invoice.amount, invoice.txnRef);
                                    };
                                } else {
                                    payInvoiceButton.style.display = 'none';  // Hide button if status is not 'Pending'
                                }
                            })
                            .catch(error => {
                                console.error('Error fetching invoice:', error);
                                document.getElementById("invoiceDetails").style.display = 'none'; // Hide invoice details if error occurs
                            });
                } else {
                    document.getElementById("invoiceDetails").style.display = 'none';  // Hide if no invoice
                    document.getElementById("payInvoiceButton").style.display = 'none'; // Hide Pay Invoice button
                }

                // Show the modal
                document.getElementById("appointmentModal").style.display = "block";
            }




            // Function to close the modal
            function closeModal() {
                document.querySelectorAll(".modal").forEach(modal => modal.style.display = "none");
            }

            function cancelAppointment(appointmentId) {
                if (confirm("Are you sure you want to cancel this appointment?")) {
                    // Redirect to cancel servlet
                    window.location.href = "../appointment/cancel?appointmentId=" + appointmentId;
                }
            }

            function formatCurrency(amount) {
                return new Intl.NumberFormat('en-US', {
                    style: 'currency',
                    currency: 'VND'
                }).format(amount);
            }


        </script>
    </body>
</html>