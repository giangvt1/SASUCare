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
    </head>

    <body>
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
                                <div class="action-buttons">
                                    <button class="btn btn-view" onclick="openAppointmentModal('${appointment.doctor.name}', '${appointment.doctorSchedule.scheduleDate}', '${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}', '${appointment.status}')">View Details</button>
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
                        <c:if test="${appointment.status == 'Pending'}">
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
                        <c:if test="${appointment.status == 'Canceled'}">
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
                </div>
            </div>
        </div>

        <!-- Reschedule Modal -->
        <div id="rescheduleModal" class="modal" style="display: hidden;">
            <div class="modal-content">
                <span class="close" onclick="closeModal()">&times;</span>
                <h3>Reschedule Appointment</h3>
                <form action="/appointment/reschedule" method="post">
                    <input type="hidden" id="rescheduleAppointmentId" name="id" value="${appointment.id}">

                    <label for="newDate">Select Date:</label>
                    <input type="date" id="newDate" name="date" required onchange="getShiftsByDate()">

                    <label for="newShift">Select Time Slot:</label>
                    <select id="newShift" name="shift" required>
                        <option value="">Select Time</option>
                        <!-- Shifts will be dynamically populated here -->
                        <c:forEach var="shift" items="${availableShifts}">
                            <option value="${shift.id}">${shift.shift.timeStart} - ${shift.shift.timeEnd}</option>
                        </c:forEach>
                    </select>

                    <button type="submit">Confirm Reschedule</button>
                </form>
            </div>
        </div>

        <jsp:include page="../Footer.jsp"/>
        <script>

            // Function to call the backend to get shifts for the selected date
            function getShiftsByDate() {
                let selectedDate = document.getElementById("newDate").value;
                let doctorId = 16; // Get this value dynamically, for now hardcoded

                // Make an AJAX call to the backend to fetch available shifts for the selected date
                fetch(`/appointment/reschedule?doctorId=${doctorId}&date=${selectedDate}`)
                        .then(response => response.json())
                        .then(data => {
                            let shiftSelect = document.getElementById("newShift");
                            shiftSelect.innerHTML = '<option value="">Select Time</option>'; // Clear previous options

                            // Populate the new options dynamically
                            data.forEach(shift => {
                                let option = document.createElement("option");
                                option.value = shift.id;
                                option.text = `${shift.timeStart} - ${shift.timeEnd}`;
                                                        shiftSelect.appendChild(option);
                                                    });
                                                })
                                                .catch(error => console.error("Error fetching shifts:", error));
                                    }

                                    function closeModal() {
                                        document.querySelector("#rescheduleModal").style.display = "none";
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
                                    // Function to open the modal and set data
                                    function openAppointmentModal(doctorName, date, timeSlot, status) {
                                        document.getElementById("modalDoctorName").innerText = doctorName;
                                        document.getElementById("modalDate").innerText = date;
                                        document.getElementById("modalTimeSlot").innerText = timeSlot;
                                        document.getElementById("modalStatus").innerText = status;
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


        </script>
    </body>
</html>