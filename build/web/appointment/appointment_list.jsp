<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>My Appointments</title>
        <link rel="stylesheet" href="styles.css">

        <style>
            /* Table styling */
            table {
                width: 100%;
                border-collapse: collapse;
                margin: 20px 0;
                font-size: 18px;
                text-align: left;
                background-color: #fff;
                border: 1px solid #ddd;
            }

            table th, table td {
                padding: 12px;
                border-bottom: 1px solid #ddd;
            }

            table th {
                background-color: #f2f2f2;
                font-weight: bold;
            }




            table th, table td {
                text-align: center;
            }

            table th {
                background-color:rgb(52, 141, 182);
                color: white;
            }

            table td {
                color: #333;
            }

            /* Status-based row coloring */
            tr.status-confirmed {
                background-color: #d4edda; /* Light green */
            }

            tr.status-canceled {
                background-color: #f8d7da; /* Light red */
            }
            /* Modal Background */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                overflow: auto;
                background-color: rgba(0, 0, 0, 0.4);
                padding-top: 50px;
            }

            /* Modal Content */
            .modal-content {
                background-color: white;
                margin: auto;
                padding: 20px;
                border-radius: 10px;
                width: 50%;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
                position: relative;
            }

            /* Close Button */
            .close {
                position: absolute;
                top: 10px;
                right: 15px;
                font-size: 25px;
                font-weight: bold;
                color: #aaa;
                cursor: pointer;
            }

            .close:hover {
                color: black;
            }


        </style>
    </head>
    <body>
        <jsp:include page="../Header.jsp"/>
        <h2>My Appointments</h2>

        <!-- Filter Section -->
        <form action="../appointment/list" method="get">
            <input type="text" name="doctorName" placeholder="Search by Doctor Name" value="${param.doctorName}">

            <select name="status">
                <option value="">All Status</option>
                <option value="Confirmed" ${param.status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                <option value="Pending" ${param.status == 'Pending' ? 'selected' : ''}>Pending</option>
                <option value="Canceled" ${param.status == 'Canceled' ? 'selected' : ''}>Canceled</option>
            </select>

            <label>
                <input type="checkbox" name="sortOrder" value="asc" ${param.sortOrder == 'asc' ? 'checked' : ''}> Sort by Date Ascending
            </label>

            <button type="submit">Search</button>
        </form>

        <!-- Appointment Table -->
        <table border="1">
            <thead>
                <tr>
                    <th>Doctor Name</th>
                    <th>Appointment Date</th>
                    <th>Time Slot</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="appointment" items="${appointments}">
                    <tr class="status-${appointment.status.toLowerCase()}">
                        <td>${appointment.doctor.name}</td>
                        <td>${appointment.doctorSchedule.scheduleDate}</td>
                        <td>${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}</td>
                        <td>${appointment.status}</td>
                        <td>
                            <c:if test="${appointment.status == 'Pending'}">
                                <button class="cancel-btn" onclick="cancelAppointment(${appointment.id})">Cancel</button>
                                <button onclick="openRescheduleModal('${appointment.id}')">Reschedule</button>
                            </c:if>

                            <button onclick="openAppointmentModal(
                                            '${appointment.doctor.name}',
                                            '${appointment.doctorSchedule.scheduleDate}',
                                            '${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}',
                                                            '${appointment.status}'
                                                            )">
                                View Details
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

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
        <div id="rescheduleModal" class="modal" style="display: none;">
            <div class="modal-content">
                <span class="close" onclick="closeModal()">&times;</span>
                <h3>Reschedule Appointment</h3>
                <form action="/appointment/reschedule" method="post">
                    <input type="hidden" id="rescheduleAppointmentId" name="id">
                    <label for="newDate">Select Date:</label>
                    <input type="date" id="newDate" name="date" required>

                    <label for="newShift">Select Time Slot:</label>
                    <select id="newShift" name="shift" required>
                        <option value="">Select Time</option>
                        <c:forEach var="shift" items="${availableShifts}">
                            <option value="${shift.id}">${shift.timeStart} - ${shift.timeEnd}</option>
                        </c:forEach>
                    </select>

                    <button type="submit">Confirm Reschedule</button>
                </form>
            </div>
        </div>


        <script>

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
