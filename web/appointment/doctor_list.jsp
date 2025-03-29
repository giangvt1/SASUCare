<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Book Your Appointment</title>
        <!-- Font Awesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="../static/css/appointment/doctor-choose-style.css">
    </head>
    <body>
        <jsp:include page="../Header.jsp"></jsp:include>

            <div class="container">
                <div class="page-header">
                    <h1>Book Your Appointment</h1>
                    <p class="subtitle">Select a doctor and available time slot to schedule your visit</p>
                </div>

                <!-- Search Bar and Filter Section -->
                <div class="search-filter-card">
                    <form id="searchForm" action="../appointment/doctor" method="get">
                        <!-- Hidden input for the selected date -->
                        <input type="hidden" id="selectedDate" name="date" value="${selectedDate}" required>

                    <div class="search-filter-grid">
                        <!-- Search by doctor name -->
                        <div class="search-input-wrapper">
                            <i class="fas fa-search search-icon"></i>
                            <input type="text" id="doctorName" name="name" placeholder="Search by doctor's name" value="${param.name}" class="search-input">
                        </div>

                        <!-- Button to open the multi-select department modal -->
                        <button type="button" onclick="openDepartmentModal()" class="filter-btn">
                            <i class="fas fa-filter"></i>
                            Select Departments
                            <c:if test="${not empty param.specialties}">
                                <span class="filter-count">${fn:length(param.specialties)}</span>
                            </c:if>
                        </button>

                        <!-- Container for dynamically generated hidden inputs -->
                        <div id="selectedSpecialtiesContainer" style="display: none;">
                            <c:forEach var="specialty" items="${param.specialties}">
                                <input type="hidden" name="specialties" value="${specialty}">
                            </c:forEach>
                        </div>

                        <div class="action-buttons">
                            <button type="submit" class="primary-btn">
                                <i class="fas fa-search"></i> Search
                            </button>
                            <button type="button" onclick="resetFilters()" class="secondary-btn">
                                <i class="fas fa-redo-alt"></i> Reset
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Main container with sidebar and content -->
            <div class="main-container">
                <!-- Sidebar for Doctor Details -->
                <div class="doctor-sidebar" id="doctor-sidebar">
                    <div id="doctor-sidebar-content">
                        <div class="no-doctor-selected">
                            <div class="avatar">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <h3>Doctor Details</h3>
                            <p>Select a doctor from the list to view their details</p>
                        </div>
                    </div>
                </div>

                <!-- Main content area with doctor list -->
                <div class="main-content">
                    <div class="doctor-list-card">
                        <c:set var="hasDoctor" value="false" />

                        <c:choose>
                            <c:when test="${not empty doctorMap}">
                                <table class="doctor-table">
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

                                                <td>
                                                    <div class="doctor-name-cell">
                                                        <div class="doctor-avatar">
                                                            <i class="fas fa-user-md"></i>
                                                        </div>
                                                        <span>${doctor.name}</span>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="specialty-tags">
                                                        <c:forEach var="specialty" items="${doctor.specialties}">
                                                            <span class="specialty-tag">${specialty}</span>
                                                        </c:forEach>
                                                    </div>
                                                </td>
                                                <td class="price-cell">
                                                    <fmt:formatNumber value="${doctor.price}" pattern="#,###" />
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${empty schedules}">
                                                            <p class="no-slots-message">No available slots</p>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="time-slot-select">
                                                                <select id="scheduleSelect_${doctor.id}" 
                                                                        name="selectedSchedule_${doctor.id}" 
                                                                        onchange="checkAppointment(${doctor.id}, this.value, '${schedule.scheduleDate}')">
                                                                    <option value="">Select a time slot</option>
                                                                    <c:forEach var="schedule" items="${schedules}">
                                                                        <option value="${schedule.id}" 
                                                                                data-doctor-name="${doctor.name}" 
                                                                                data-specialties="<c:forEach var='sp' items='${doctor.specialties}' varStatus='status'>${sp}${!status.last ? ', ' : ''}</c:forEach>" 
                                                                                data-shift-time="${schedule.shift.timeStart} - ${schedule.shift.timeEnd}"
                                                                                <c:if test="${!schedule.available}">disabled</c:if>>
                                                                            ${schedule.shift.timeStart} - ${schedule.shift.timeEnd}
                                                                            <c:if test="${!schedule.available}"> (Booked)</c:if>
                                                                            </option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <button id="bookBtn_${doctor.id}" 
                                                            disabled 
                                                            class="book-btn disabled" 
                                                            onclick="openBookingModal(${doctor.id})">
                                                        Book
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <div class="empty-state-icon">
                                        <i class="fas fa-calendar-times"></i>
                                    </div>
                                    <h3>No Available Doctors</h3>
                                    <p>You can try another day to make an appointment with your doctor.</p>
                                 <button class="primary-btn" onclick="navigate()">Try Another Date</button>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Multi-Select Modal for Departments -->
        <div id="departmentModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Select Specialties</h3>
                    <span class="close" onclick="closeDepartmentModal()">&times;</span>
                </div>

                <div class="modal-body">
                    <p>Select one or more medical specialties to filter doctors</p>

                    <div class="checkbox-container">
                        <c:forEach var="specialty" items="${departments}">
                            <div class="checkbox-item">
                                <input type="checkbox" 
                                       id="specialty-${specialty.id}"
                                       class="specialty-checkbox" 
                                       value="${specialty.id}" 
                                       <c:if test="${fn:contains(param.specialties, specialty.id)}">checked</c:if>>
                                <label for="specialty-${specialty.id}">${specialty.name}</label>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="modal-footer">
                    <button class="secondary-btn" onclick="closeDepartmentModal()">Cancel</button>
                    <button class="primary-btn" onclick="applySelectedSpecialties()">Apply Filters</button>
                </div>
            </div>
        </div>

        <!-- Booking Modal -->
        <div id="bookingModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Your Booking Details</h3>
                    <span class="close" onclick="closeModal()">&times;</span>
                </div>

                <div class="modal-body">
                    <div class="booking-details">
                        <div class="doctor-info">
                            <div class="doctor-avatar">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <div>
                                <h4 id="modalDoctorName"></h4>
                                <p id="modalSpecialties"></p>
                            </div>
                        </div>

                        <div class="appointment-details">
                            <div class="detail-item">
                                <span class="detail-label">Date</span>
                                <span class="detail-value" id="modalDate"></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Time</span>
                                <span class="detail-value" id="modalShiftTime"></span>
                            </div>
                        </div>
                    </div>

                    <div class="payment-options">
                        <h4>Payment Method</h4>

                        <div class="payment-radio-group">
                            <div class="payment-option">
                                <input type="radio" name="action" value="createInvoice" id="createInvoiceRadio">
                                <label for="createInvoiceRadio">
                                    <span class="option-title">Pay Online</span>
                                    <span class="option-description">Create an invoice for online payment</span>
                                </label>
                            </div>

                            <div class="payment-option">
                                <input type="radio" name="action" value="payAtHospital" id="payAtHospitalRadio">
                                <label for="payAtHospitalRadio">
                                    <span class="option-title">Pay at Hospital</span>
                                    <span class="option-description">Pay during your visit</span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button class="secondary-btn" onclick="closeModal()">Cancel</button>
                    <button id="confirmBooking" class="primary-btn" onclick="confirmBooking()">Confirm Booking</button>
                </div>
            </div>
        </div>

        <!-- Load jQuery from CDN -->
        <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

        <script>
             function navigate() {
        window.location.href = '/SWP391_GR6/appointment';  // This will redirect to /SWP391_GR6/appointment
    }
                        // Current date for modal display
                        const currentDate = new Date().toLocaleDateString('en-US', {
                            year: 'numeric',
                            month: 'long',
                            day: 'numeric'
                        });

                        document.addEventListener("DOMContentLoaded", function () {
                            // Initialize doctor row click handlers
                            const doctorRows = document.querySelectorAll(".clickable-row");
                            doctorRows.forEach(row => {
                                row.addEventListener("click", function () {
                                    updateDoctorSidebar(this);
                                });
                            });

                            // Fill modal date with current date
                            document.getElementById("modalDate").textContent = currentDate;
                        });

                        function checkAppointment(doctorId, shiftId, scheduleDate) {
                            if (!shiftId) {
                                document.getElementById("bookBtn_" + doctorId).disabled = true;
                                document.getElementById("bookBtn_" + doctorId).classList.add("disabled");
                                return;
                            }

                            $.ajax({
                                url: "../CheckAppointmentServlet",
                                type: "GET",
                                data: {
                                    doctorId: doctorId,
                                    shiftId: shiftId,
                                    scheduleDate: scheduleDate,
                                },
                                success: function (response) {
                                    let bookButton = document.getElementById("bookBtn_" + doctorId);

                                    if (response === "exists") {
                                        alert("You already have an appointment on this date and shift.");
                                        bookButton.disabled = true;
                                        bookButton.classList.add("disabled");
                                    } else {
                                        bookButton.disabled = false;
                                        bookButton.classList.remove("disabled");
                                    }
                                }
                            });
                        }

                        function updateDoctorSidebar(row) {
                            const sidebarContent = document.getElementById("doctor-sidebar-content");

                            const doctorName = row.getAttribute("data-doctor-name");
                            const doctorRating = parseFloat(row.getAttribute("data-rating")) || 0;
                            const doctorCertificates = row.getAttribute("data-certificates").trim().split('\n');
                            const doctorImage = row.getAttribute("data-image");

                            // Generate stars for rating
                            let stars = "";
                            for (let i = 0; i < 5; i++) {
                                if (i < Math.floor(doctorRating)) {
                                    stars += '<i class="fas fa-star"></i>';
                                } else if (i === Math.floor(doctorRating) && doctorRating % 1 !== 0) {
                                    stars += '<i class="fas fa-star-half-alt"></i>';
                                } else {
                                    stars += '<i class="far fa-star"></i>';
                                }
                            }

                            // Get specialties from the row
                            const specialtiesElements = row.querySelectorAll('.specialty-tag');
                            const specialties = Array.from(specialtiesElements).map(el => el.textContent);

                            // Create sidebar HTML
                            let html = `
                    <div class="doctor-profile">
                        <div class="doctor-header">
                            <div class="doctor-avatar">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <h3>` + doctorName + ` </h3>
                            <div class="star-rating">
                                ` + stars + ` <span>(` + doctorRating + `)</span>
                            </div>
                        </div>
                    
                        <div class="doctor-section">
                            <h4>Qualifications</h4>
                            <ul class="certificate-list">
                `;

                            // Add certificates
                            doctorCertificates.forEach(cert => {
                                if (cert.trim()) {
                                    html += `
                            <li>
                                <i class="fas fa-certificate"></i>
                                <span>` + cert.trim() + `</span>
                            </li>
                        `;
                                }
                            });

                            html += `
                            </ul>
                        </div>
                    
                        <div class="doctor-section">
                            <h4>Specialties</h4>
                            <div class="specialty-tags">
                `;

                            // Add specialties
                            specialties.forEach(specialty => {
                                html += `<span class="specialty-tag">+` + specialty + `</span>`;
                            });

                            html += `
                            </div>
                        </div>
                    
                        <div class="doctor-section">
                            <h4>Book this doctor</h4>
                            <button class="book-action-btn" onclick="openBookingModal(` + row.getAttribute('data-doctor-id') + `)">
                                Book Appointment
                            </button>
                        </div>
                    </div>
                `;

                            sidebarContent.innerHTML = html;
                        }

                        function openDepartmentModal() {
                            document.getElementById("departmentModal").style.display = "block";
                        }

                        function closeDepartmentModal() {
                            document.getElementById("departmentModal").style.display = "none";
                        }

                        function applySelectedSpecialties() {
                            const checkboxes = document.querySelectorAll(".specialty-checkbox:checked");
                            const specialtiesContainer = document.getElementById("selectedSpecialtiesContainer");

                            // Clear previous inputs
                            specialtiesContainer.innerHTML = "";

                            // Create hidden inputs for each selected specialty
                            checkboxes.forEach(checkbox => {
                                const input = document.createElement("input");
                                input.type = "hidden";
                                input.name = "specialties";
                                input.value = checkbox.value;
                                specialtiesContainer.appendChild(input);
                            });

                            // Submit the form
                            document.getElementById("searchForm").submit();
                        }

                        function resetFilters() {
                            document.getElementById("doctorName").value = "";
                            document.getElementById("selectedSpecialtiesContainer").innerHTML = "";
                            document.querySelectorAll(".specialty-checkbox").forEach(cb => cb.checked = false);
                            document.getElementById("searchForm").submit();
                        }

                        function openBookingModal(doctorId) {
                            const select = document.getElementById("scheduleSelect_" + doctorId);

                            if (!select || !select.value) {
                                alert("Please select a time slot first");
                                return;
                            }

                            const selectedOption = select.options[select.selectedIndex];

                            // Populate modal data
                            document.getElementById("modalDoctorName").textContent = selectedOption.getAttribute("data-doctor-name");
                            document.getElementById("modalSpecialties").textContent = selectedOption.getAttribute("data-specialties");
                            document.getElementById("modalShiftTime").textContent = selectedOption.getAttribute("data-shift-time");

                            // Clear radio selection
                            document.querySelectorAll('input[name="action"]').forEach(radio => radio.checked = false);

                            // Show modal
                            document.getElementById("bookingModal").style.display = "block";

                            document.getElementById("confirmBooking").onclick = function () {
                                // Get selected action
                                const selectedAction = document.querySelector('input[name="action"]:checked');

                                if (!selectedAction) {
                                    alert("Please select an action (Create Invoice or Pay at Hospital).");
                                    return;
                                }

                                const action = selectedAction.value; // Get the selected action ('createInvoice' or 'payAtHospital')

                                // Get the schedule ID
                                let scheduleId = select.value;

                                // Redirect to the appropriate URL with the selected action
                                window.location.href = "../appointment/confirm?doctor=" + doctorId + "&schedule=" + scheduleId + "&action=" + action;
                            };
                        }

                        function closeModal() {
                            document.getElementById("bookingModal").style.display = "none";
                        }

                        // Attach the confirm booking logic to the button



                        // Close modals when clicking outside
                        window.onclick = function (event) {
                            const departmentModal = document.getElementById("departmentModal");
                            const bookingModal = document.getElementById("bookingModal");

                            if (event.target === departmentModal) {
                                departmentModal.style.display = "none";
                            }

                            if (event.target === bookingModal) {
                                bookingModal.style.display = "none";
                            }
                        }
        </script>
        <jsp:include page="../Footer.jsp"/>
    </body>

</html>