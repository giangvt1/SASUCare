<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Book Your Appointment</title>
        <link rel="stylesheet" href="styles.css">
    </head>

    <style>
        /* Modal background */
        .modal {
            display: none; /* Hidden by default */
            position: fixed; /* Stay in place */
            z-index: 1; /* Sit on top */
            left: 0;
            top: 0;
            width: 100%; /* Full width */
            height: 100%; /* Full height */
            overflow: auto; /* Enable scroll if needed */
            background-color: rgb(0,0,0); /* Fallback color */
            background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
            padding-top: 60px;
        }

        /* Modal content */
        .modal-content {
            background-color: #fefefe;
            margin: 5% auto; /* 5% from the top and centered */
            padding: 20px;
            border: 1px solid #888;
            width: 40%; /* Smaller width */
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            position: relative; /* Position relative to contain the close button */
        }

        /* Close button */
        .close {
            color: #aaa;
            position: absolute; /* Position absolute within the modal content */
            top: 10px;
            right: 20px;
            font-size: 28px;
            font-weight: bold;
        }

        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }

        /* Table styling */
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            font-size: 18px;
            text-align: left;
        }

        table th, table td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }

        table th {
            background-color: #f2f2f2;
        }

        table tr:hover {
            background-color: #f5f5f5;
        }

        table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
    </style>
    <body>
        <jsp:include page="../Header.jsp"></jsp:include>

            <h2>Book Your Appointment</h2>

            <!-- Search Bar -->
            <form action="appointment/doctor" method="get">
                <input type="hidden" name="date" value="${selectedDate}" required>
            <input type="text" name="search" placeholder="Search by name or specialist">
            <button type="submit">Search</button>
        </form>

        <!-- Doctor List Table -->
        <table border="1">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Specialist</th>
                    <th>Time Slot</th>
                    <th>Book</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="entry" items="${doctorMap}">
                    <c:set var="doctor" value="${entry.key}" />
                    <c:set var="schedules" value="${entry.value}" />
                    <tr>
                        <td>${doctor.name}</td>
                        <td>${doctor.specialty}</td>
                        <td>
                            <c:forEach var="schedule" items="${schedules}">
                                <input type="radio" name="selectedSchedule_${doctor.id}" value="${schedule.id}"
                                       data-doctor-name="${doctor.name}" 
                                       data-specialty="${doctor.specialty}" 
                                       data-shift-time="${schedule.shift.timeStart} - ${schedule.shift.timeEnd}"
                                       <c:choose>
                                           <c:when test="${schedule.available}">
                                               onchange="enableBookButton(${doctor.id})"
                                           </c:when>
                                           <c:otherwise>
                                               onchange="disableBookButton(${doctor.id})"
                                           </c:otherwise>
                                       </c:choose>>
                                ${schedule.shift.timeStart} - ${schedule.shift.timeEnd}
                                <input type="hidden" id="scheduleId_${doctor.id}" value="${schedule.id}">
                                <input type="hidden" id="available" value="${schedule.available}">
                            </c:forEach>
                        </td>
                        <td>
                            <button id="bookBtn_${doctor.id}" disabled class="disabled-btn" onclick="openBookingModal(${doctor.id})">Book</button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- Booking Modal -->
        <div id="bookingModal" class="modal" style="display: none;">
            <div class="modal-content">
                <span class="close" onclick="closeModal()">&times;</span>
                <h3>Your Booking Details</h3>
                <p><strong>Doctor Name:</strong> <span id="modalDoctorName"></span></p>
                <p><strong>Specialist:</strong> <span id="modalSpecialty"></span></p>
                <p><strong>Time Slot:</strong> <span id="modalShiftTime"></span></p>
                <button onclick="closeModal()">Close</button>
                <button id="confirmBooking">Confirm Booking</button>
            </div>
        </div>

        <script>
            function disableBookButton(doctorId) {
                let bookButton = document.getElementById("bookBtn_" + doctorId);
                bookButton.disabled = true;
                bookButton.classList.remove("active-btn");
                bookButton.classList.add("disabled-btn");
            }
            
            function enableBookButton(doctorId) {
                let bookButton = document.getElementById("bookBtn_" + doctorId);
                bookButton.disabled = false;
                bookButton.classList.remove("disabled-btn");
                bookButton.classList.add("active-btn");
            }

            function openBookingModal(doctorId) {
                let selectedSchedule = document.querySelector("input[name='selectedSchedule_" + doctorId + "']:checked");

                if (!selectedSchedule) {
                    alert("Please select a time slot before booking.");
                    return;
                }

                document.getElementById("modalDoctorName").innerText = selectedSchedule.getAttribute("data-doctor-name");
                document.getElementById("modalSpecialty").innerText = selectedSchedule.getAttribute("data-specialty");
                document.getElementById("modalShiftTime").innerText = selectedSchedule.getAttribute("data-shift-time");

                let scheduleId = selectedSchedule.value;
                document.getElementById("confirmBooking").onclick = function () {
                    window.location.href = "../appointment/confirm?doctor=" + doctorId + "&schedule=" + scheduleId;
                };

                document.getElementById("bookingModal").style.display = "block";
            }

            function closeModal() {
                document.getElementById("bookingModal").style.display = "none";
            }
        </script>
    </body>
</html>
