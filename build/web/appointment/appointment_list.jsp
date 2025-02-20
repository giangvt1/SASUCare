<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>My Appointments</title>
        <link rel="stylesheet" href="styles.css">
        <style>
            :root {
                --primary-color: #87CEEB;
                --primary-light: #B0E2FF;
                --primary-dark: #4682B4;
                --border-color: #ADD8E6;
                --text-color: #333;

                /* Status-specific colors with reduced opacity for better aesthetics */
                --status-pending: rgba(255, 243, 205, 0.7);
                --status-confirmed: rgba(212, 237, 218, 0.7);
                --status-canceled: rgba(248, 215, 218, 0.7);
                --status-done: rgba(204, 229, 255, 0.7);
            }

            .appointments-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
                display: flex;
                flex-direction: column;
                gap: 25px;
            }

            h2 {
                color: var(--primary-dark);
                margin-bottom: 30px;
                font-size: 28px;
            }

            /* Search Form */
            .search-form {
                margin-bottom: 30px;
                display: flex;
                gap: 10px;
                align-items: center;
            }

            .search-form input {
                padding: 10px 15px;
                border: 1px solid var(--border-color);
                border-radius: 4px;
                flex: 1;
                max-width: 300px;
            }

            .search-form button {
                padding: 10px 20px;
                background-color: var(--primary-color);
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                transition: background-color 0.2s ease;
            }

            .search-form button:hover {
                background-color: var(--primary-dark);
            }

            /* Status Sections */
            .status-section {
                background: white;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            }

            .status-title {
                font-size: 20px;
                font-weight: bold;
                margin-bottom: 15px;
                color: var(--primary-dark);
            }

            /* Event List */
            .event-list {
                display: flex;
                gap: 20px;
                overflow-x: auto;
                padding: 10px 0;
                scrollbar-width: thin;
            }

            .event-list::-webkit-scrollbar {
                height: 6px;
            }

            .event-list::-webkit-scrollbar-thumb {
                background: var(--primary-light);
                border-radius: 10px;
            }

            /* Event Cards */
            .event-card {
                background: white;
                padding: 20px;
                border-radius: 10px;
                min-width: 280px;
                border: 1px solid var(--border-color);
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }

            .event-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            }

            /* Status-specific styling */
            .status-section.pending {
                background-color: var(--status-pending);
            }
            .status-section.confirmed {
                background-color: var(--status-confirmed);
            }
            .status-section.canceled {
                background-color: var(--status-canceled);
            }
            .status-section.done {
                background-color: var(--status-done);
            }

            .doctor-name {
                font-size: 18px;
                font-weight: bold;
                color: var(--primary-dark);
                margin-bottom: 8px;
            }

            .event-time {
                font-size: 14px;
                color: #666;
                margin-bottom: 12px;
            }

            .event-status {
                font-weight: 500;
                text-transform: uppercase;
                font-size: 12px;
                padding: 4px 8px;
                border-radius: 4px;
                display: inline-block;
                margin-bottom: 15px;
            }

            /* Action Buttons */
            .action-buttons {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
            }

            .btn {
                padding: 8px 12px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 13px;
                font-weight: 500;
                transition: opacity 0.2s ease;
            }

            .btn:hover {
                opacity: 0.9;
            }

            .btn-cancel {
                background: var(--status-canceled);
                color: #721c24;
            }

            .btn-reschedule {
                background: var(--status-pending);
                color: #856404;
            }

            .btn-view {
                background: var(--primary-light);
                color: var(--primary-dark);
            }

            /* Modal Styling */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                backdrop-filter: blur(4px);
            }

            .modal-content {
                background-color: white;
                margin: 50px auto;
                padding: 25px;
                border-radius: 12px;
                width: 90%;
                max-width: 500px;
                position: relative;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
            }

            .close {
                position: absolute;
                right: 20px;
                top: 15px;
                font-size: 24px;
                font-weight: bold;
                color: #aaa;
                cursor: pointer;
                transition: color 0.2s ease;
            }

            .close:hover {
                color: var(--primary-dark);
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .appointments-container {
                    padding: 15px;
                }

                .event-card {
                    min-width: 250px;
                }

                .search-form {
                    flex-direction: column;
                    align-items: stretch;
                }

                .search-form input {
                    max-width: none;
                }
            }
        </style>
    </head>
</head>
<body>
    <jsp:include page="../Header.jsp"/>
    <h2>My Appointments</h2>

    <!-- Filter Section -->
    <form action="../appointment/list" method="get">
        <input type="text" name="doctorName" placeholder="Search by Doctor Name" value="${param.doctorName}">
        <button type="submit">Search</button>
    </form>

    <!-- Appointments Display -->
    <div class="appointments-container">



        <!-- Confirmed Section -->
        <div class="status-section confirmed">
            <div class="status-title">Coming Up</div>
            <div class="event-list">
                <c:forEach var="appointment" items="${appointments}">
                    <c:if test="${appointment.status == 'Confirmed'}">
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
            </div>
        </div>

        <!-- Pending Section -->
        <div class="status-section pending">
            <div class="status-title">Pending</div>
            <div class="event-list">
                <c:forEach var="appointment" items="${appointments}">
                    <c:if test="${appointment.status == 'Pending'}">
                        <div class="event-card">
                            <div class="event-details">
                                <div class="doctor-name">${appointment.doctor.name}</div>
                                <div class="event-time">${appointment.doctorSchedule.scheduleDate} | ${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}</div>
                                <div class="event-status">Pending</div>
                            </div>
                            <div class="action-buttons">
                                <button class="btn btn-cancel" onclick="cancelAppointment(${appointment.id})">Cancel</button>
                                <button class="btn btn-reschedule" onclick="openRescheduleModal('${appointment.id}')">Reschedule</button>
                                <button class="btn btn-view" onclick="openAppointmentModal('${appointment.doctor.name}', '${appointment.doctorSchedule.scheduleDate}', '${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}', '${appointment.status}')">View Details</button>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>

        <!-- Canceled Section -->
        <div class="status-section canceled">
            <div class="status-title">Canceled</div>
            <div class="event-list">
                <c:forEach var="appointment" items="${appointments}">
                    <c:if test="${appointment.status == 'Canceled'}">
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
        </div>

        <!-- Done Section -->
        <div class="status-section done">
            <div class="status-title">Done</div>
            <div class="event-list">
                <c:forEach var="appointment" items="${appointments}">
                    <c:if test="${appointment.status == 'Done'}">
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
        </div>

    </div>

    <jsp:include page="../Footer.jsp"/>


    <!-- Appointment Detail Modal -->
    <div id="appointmentModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h3>Appointment Details</h3>
            <p><strong>Doctor:</strong> <span id="modalDoctorName"></span></p>
            <p><strong>Date:</strong> <span id="modalDate"></span></p>
            <p><strong>Time Slot:</strong> <span id="modalTimeSlot"></span></p>
            <p><strong>Status:</strong> <span id="modalStatus"></span></p>
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