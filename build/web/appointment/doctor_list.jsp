<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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

        .checkbox-container {
            text-align: left;
            display: inline-block;
            max-height: 300px;
            overflow-y: auto;
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

        table tr:hover {
            background-color: #f5f5f5;
        }

        table tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        table tr:nth-child(odd) {
            background-color: #fff;
        }

        table th, table td {
            text-align: center;
        }

        table th {
            background-color:rgb(86, 175, 226);
            color: white;
        }

        table td {
            color: #333;
        }
        ul {
            list-style-type: none;
            padding: 0;
            margin: 0;
        }

    </style>
    <body>
        <jsp:include page="../Header.jsp"></jsp:include>

            <h2>Book Your Appointment</h2>


            <!-- Search Bar and Filter Section -->
            <form id="searchForm" action="../appointment/doctor" method="get">
                <!-- Hidden input for the selected date -->
                <input type="hidden" id="selectedDate" name="date" value="${selectedDate}" required>

            <!-- Search by doctor name -->
            <input type="text" id="doctorName" name="name" placeholder="Search by name or specialty" value="${param.name}">

            <!-- Button to open the multi-select department modal -->
            <button type="button" onclick="openDepartmentModal()">Select Departments</button>

            <!-- Container for dynamically generated hidden inputs -->
            <div id="selectedSpecialtiesContainer"></div>

            <button type="submit">Search</button>
            <button type="button" onclick="resetFilters()">Reset</button>
        </form>

        <!-- Multi-Select Modal for Departments -->
        <div id="departmentModal" class="modal" style="display: none;">
            <div class="modal-content">
                <span class="close" onclick="closeDepartmentModal()">&times;</span>
                <h3>Select Specialties</h3>

                <!-- Department List with Checkboxes -->
                <div class="checkbox-container">
                    <c:forEach var="specialty" items="${departments}">
                        <label>
                            <input type="checkbox" class="specialty-checkbox" value="${specialty.id}" 
                                   <c:if test="${fn:contains(param.specialties, specialty.id)}">checked</c:if>> 
                            ${specialty.name}
                        </label><br>
                    </c:forEach>
                </div>

                <button onclick="applySelectedSpecialties()">Apply</button>
            </div>
        </div>

        <!-- Doctor List Table -->
        <table border="1">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Specialties</th>
                    <th>Time Slot</th>
                    <th>Book</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="entry" items="${doctorMap}">
                    <c:set var="doctor" value="${entry.key}" />
                    <c:set var="schedules" value="${entry.value}" />
                    <tr>
                        <td>${doctor.name}</td> <!-- Ensure 'doctor' object is correctly referenced -->
                        <td>
                            <ul>
                                <c:forEach var="specialty" items="${doctor.specialties}">
                                    <li>${specialty}</li>
                                    </c:forEach>
                            </ul>
                        </td>
                        <td>
                            <c:forEach var="schedule" items="${schedules}">
                                <label>
                                    <input type="radio" name="selectedSchedule_${doctor.id}" value="${schedule.id}"
                                           data-doctor-name="${doctor.name}" 
                                           data-specialties="<c:forEach var='sp' items='${doctor.specialties}' varStatus='status'>${sp}${!status.last ? ', ' : ''}</c:forEach>" 
                                           data-shift-time="${schedule.shift.timeStart} - ${schedule.shift.timeEnd}"
                                           <c:if test="${!schedule.available}">disabled</c:if>
                                           onchange="updateBookButton(${doctor.id})">
                                    ${schedule.shift.timeStart} - ${schedule.shift.timeEnd}
                                </label><br>
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
                <p><strong>Specialties:</strong> <span id="modalSpecialties"></span></p>
                <p><strong>Time Slot:</strong> <span id="modalShiftTime"></span></p>
                <button onclick="closeModal()">Close</button>
                <button id="confirmBooking">Confirm Booking</button>
            </div>
        </div>

        <script>

            function openDepartmentModal() {
                document.getElementById("departmentModal").style.display = "block";
            }

            function closeDepartmentModal() {
                document.getElementById("departmentModal").style.display = "none";
            }

            function applySelectedSpecialties() {
                let selectedValues = [];
                let checkboxes = document.querySelectorAll(".specialty-checkbox:checked");
                let container = document.getElementById("selectedSpecialtiesContainer");

                // Clear previous hidden inputs
                container.innerHTML = "";

                checkboxes.forEach((checkbox) => {
                    selectedValues.push(checkbox.value);

                    // Create a hidden input for each selected department
                    let input = document.createElement("input");
                    input.type = "hidden";
                    input.name = "specialties";
                    input.value = checkbox.value;
                    container.appendChild(input);
                });

                closeDepartmentModal();
            }

            function resetFilters() {
                let dateValue = document.getElementById("selectedDate").value; // Get current selected date

                document.getElementById("doctorName").value = ""; // Clear doctor name input
                document.getElementById("selectedSpecialtiesContainer").innerHTML = ""; // Clear selected specialties

                // Uncheck all department checkboxes
                document.querySelectorAll(".specialty-checkbox").forEach((checkbox) => {
                    checkbox.checked = false;
                });

                // Reload the page but keep the date in the URL
                window.location.href = "../appointment/doctor?date=" + encodeURIComponent(dateValue);
            }

            function updateBookButton(doctorId) {
                let selectedSchedule = document.querySelector("input[name='selectedSchedule_" + doctorId + "']:checked");
                let bookButton = document.getElementById("bookBtn_" + doctorId);
                bookButton.disabled = !selectedSchedule;
            }

            function openBookingModal(doctorId) {
                let selectedSchedule = document.querySelector("input[name='selectedSchedule_" + doctorId + "']:checked");

                if (!selectedSchedule) {
                    alert("Please select a time slot before booking.");
                    return;
                }

                document.getElementById("modalDoctorName").innerText = selectedSchedule.getAttribute("data-doctor-name");
                document.getElementById("modalSpecialties").innerText = selectedSchedule.getAttribute("data-specialties");
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
