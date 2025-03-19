<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Book Your Appointment</title>
        <link rel="stylesheet" href="../static/css/appointment/appointments.css">
        <link rel="stylesheet" href="../static/css/appointment/doctor-choose-style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    </head>

    <body>
        <jsp:include page="../Header.jsp"></jsp:include>

            <h2>Book Your Appointment</h2>


            <!-- Search Bar and Filter Section -->
            <form id="searchForm" action="../appointment/doctor" method="get">
                <!-- Hidden input for the selected date -->
                <input type="hidden" id="selectedDate" name="date" value="${selectedDate}" required>

            <!-- Search by doctor name -->
            <input type="text" id="doctorName" name="name" placeholder="Search by doctor'sname" value="${param.name}">

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
        <!-- Main container with sidebar and content -->
        <div class="container">
            <!-- Sidebar for Doctor Details -->
            <div class="sidebar doctor-sidebar" id="doctor-sidebar">
                <div id="doctor-sidebar-content">
                    <div class="no-doctor-selected">
                        <i class="fas fa-user-md fa-3x"></i>
                        <p>Select a doctor to view details</p>
                    </div>
                </div>
            </div>

            <!-- Main content area -->
            <div class="main-content">
                <!-- Doctor List Table -->
                <div>
                    <table border="1">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Specialties</th>
                                <th>Price ($)</th>
                                <th>Time Slot</th>
                                <th>Book</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="hasDoctor" value="false" />

                            <c:forEach var="entry" items="${doctorMap}">
                                <c:set var="doctor" value="${entry.key}" />
                                <c:set var="schedules" value="${entry.value}" />
                                <c:set var="hasDoctor" value="true" />

                                <tr class="clickable-row" 
                                    data-doctor-id="${doctor.id}"
                                    data-doctor-name="${doctor.name}"
                                    data-rating="${doctor.average_rating}"
                                    data-certificates="<c:forEach var="cert" items="${doctor.certificates}">
                                        ${cert.certificateName}
                                    </c:forEach>"
                                    data-image="${doctor.img}">

                                    <td>${doctor.name}</td>
                                    <td>
                                        <ul>
                                            <c:forEach var="specialty" items="${doctor.specialties}">
                                                <li>${specialty}</li>
                                                </c:forEach>
                                        </ul>
                                    </td>
                                    <td><fmt:formatNumber value="${doctor.price}" pattern="#,###" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${empty schedules}">
                                                <p class="text-center text-muted">This doctor's schedule is currently full. Please check other date or select another doctor.</p>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="schedule" items="${schedules}">
                                                    <label>
                                                        <input type="radio" name="selectedSchedule_${doctor.id}" value="${schedule.id}"
                                                               data-doctor-name="${doctor.name}" 
                                                               data-specialties="<c:forEach var='sp' items='${doctor.specialties}' varStatus='status'>${sp}${!status.last ? ', ' : ''}</c:forEach>" 
                                                               data-shift-time="${schedule.shift.timeStart} - ${schedule.shift.timeEnd}"
                                                               <c:if test="${!schedule.available}">disabled</c:if>
                                                               onchange="checkAppointment(${doctor.id}, ${schedule.shift.id}, '${schedule.scheduleDate}')">
                                                        ${schedule.shift.timeStart} - ${schedule.shift.timeEnd}
                                                    </label><br>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button id="bookBtn_${doctor.id}" disabled class="disabled-btn book-action-btn" onclick="openBookingModal(${doctor.id})">Book</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table> 
                    <c:if test="${!hasDoctor}">
                        <div class="empty-state">
                            <i class="fas fa-ban empty-state-icon"></i>
                            <p class="empty-state-text">No Available Doctor.<br>
                                You can try another day to make an appointment with your doctor.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Booking Modal -->
        <div id="bookingModal" class="modal" style="display: none;">
            <div class="modal-content">
                <span class="close" onclick="closeModal()">&times;</span>
                <h3>Your Booking Details</h3>
                <p><strong>Doctor Name:</strong> <span id="modalDoctorName"></span></p>
                <p><strong>Specialties:</strong> <span id="modalSpecialties"></span></p>
                <p><strong>Time Slot:</strong> <span id="modalShiftTime"></span></p>

                <!-- Radio buttons for choosing action -->
                <label>
                    <input type="radio" name="action" value="createInvoice" id="createInvoiceRadio"> Create Invoice
                </label>
                <label>
                    <input type="radio" name="action" value="payAtHospital" id="payAtHospitalRadio"> Pay at Hospital
                </label><br>

                <button onclick="closeModal()">Close</button>
                <button id="confirmBooking" onclick="confirmBooking()">Confirm Booking</button> <!-- Confirm Booking Button -->
            </div>
        </div>

        <!-- Load jQuery from CDN -->
        <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

        <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        const doctorRows = document.querySelectorAll(".clickable-row");
                        doctorRows.forEach(row => {
                            row.addEventListener("click", function () {
                                updateDoctorSidebar(this);
                            });
                        });
                    });

                    function checkAppointment(doctorId, shiftId, scheduleDate) {
                        $.ajax({
                            url: "../CheckAppointmentServlet",
                            type: "GET",
                            data: {
                                doctorId: doctorId,
                                shiftId: shiftId,
                                scheduleDate: scheduleDate,
                            },
                            success: function (response) {
                                let selectedSchedule = document.querySelector("input[name='selectedSchedule_" + doctorId + "']:checked");
                                let bookButton = document.getElementById("bookBtn_" + doctorId);

                                if (response === "exists") {
                                    alert("You already have an appointment on this date and shift.");
                                    bookButton.disabled = true; // Disable the button when appointment exists
                                } else {
                                    bookButton.disabled = !selectedSchedule; // Only enable if a schedule is selected
                                }
                            }
                        });
                    }

                    function updateDoctorSidebar(row) {
                        const sidebarContent = document.getElementById("doctor-sidebar-content");

                        const doctorName = row.getAttribute("data-doctor-name");
                        const doctorRating = parseFloat(row.getAttribute("data-rating"));
                        const doctorCertificates = row.getAttribute("data-certificates");
                        const doctorImage = row.getAttribute("data-image");

                        let stars = "";
                        for (let i = 0; i < Math.floor(doctorRating); i++) {
                            stars += '<i class="fas fa-star"></i>';
                        }
                        if (doctorRating - Math.floor(doctorRating) >= 0.5) {
                            stars += '<i class="fas fa-star-half-alt"></i>';
                        }

                        sidebarContent.innerHTML =
                                '<div class="doctor-sidebar-info">' +
                                '<img src="../' + doctorImage + '" alt="Doctor Image" class="doctor-img">' +
                                '<h3>' + doctorName + '</h3>' +
                                '<div class="rating">' + stars + '</div>' +
                                '<h4>Certificates:</h4>' +
                                '<p>' + (doctorCertificates ? doctorCertificates : "No certificates available") + '</p>' +
                                '</div>';
                    }

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

                        // Set modal content dynamically
                        document.getElementById("modalDoctorName").innerText = selectedSchedule.getAttribute("data-doctor-name");
                        document.getElementById("modalSpecialties").innerText = selectedSchedule.getAttribute("data-specialties");
                        document.getElementById("modalShiftTime").innerText = selectedSchedule.getAttribute("data-shift-time");

                        // Show the modal
                        document.getElementById("bookingModal").style.display = "block";

                        // Attach the confirm booking logic to the button
                        document.getElementById("confirmBooking").onclick = function () {
                            // Get selected action
                            const selectedAction = document.querySelector('input[name="action"]:checked');

                            if (!selectedAction) {
                                alert("Please select an action (Create Invoice or Pay at Hospital).");
                                return;
                            }

                            const action = selectedAction.value; // Get the selected action ('createInvoice' or 'payAtHospital')

                            // Get the schedule ID
                            let scheduleId = selectedSchedule.value;

                            // Redirect to the appropriate URL with the selected action
                            window.location.href = "../appointment/confirm?doctor=" + doctorId + "&schedule=" + scheduleId + "&action=" + action;
                        };
                    }


                    function closeModal() {
                        document.getElementById("bookingModal").style.display = "none";
                    }
        </script>
        <jsp:include page="../Footer.jsp"/>
    </body>
</html>
