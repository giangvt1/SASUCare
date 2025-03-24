<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.YearMonth" %>
<%@ page import="java.time.format.TextStyle" %>
<%@ page import="java.util.Locale" %>

<%
    // Get current date
    LocalDate currentDate = LocalDate.now();
    int selectedMonth = request.getParameter("month") != null ? Integer.parseInt(request.getParameter("month")) : currentDate.getMonthValue();
    int selectedYear = request.getParameter("year") != null ? Integer.parseInt(request.getParameter("year")) : currentDate.getYear();

    // Set up the month and year for the calendar
    YearMonth yearMonth = YearMonth.of(selectedYear, selectedMonth);
    int daysInMonth = yearMonth.lengthOfMonth();
    LocalDate firstOfMonth = LocalDate.of(selectedYear, selectedMonth, 1);
    int startDayOfWeek = firstOfMonth.getDayOfWeek().getValue() % 7; // Adjust to 0-based index (0=Sunday)
%>

<%@ page import="java.text.SimpleDateFormat, java.time.ZoneId, java.util.Date" %>
<%
    // Parse the date if it's a String
Date date = Date.from(currentDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
    SimpleDateFormat sdf = new SimpleDateFormat("EEEE, dd-MM-yyyy"); // "EEEE" for day name
    String sdfDate = sdf.format(date);
%>


<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Doctor Dashboard - Appointments</title>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="../static/css/doctor/appointments.css">
        <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/main.min.css" rel="stylesheet" />
        <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>
        <style>
            .calendar-container {
                background: white;
                padding: 1.5rem;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                margin-top: 20px;
            }

            .calendar {
                width: 100%;
                border-collapse: collapse;
            }

            .calendar th, .calendar td {
                width: 14.28%;
                padding: 12px;
                text-align: center;
                border: 1px solid #ddd;
            }

            .calendar th {
                background-color: #2196F3;
                color: white;
            }

            .calendar td.empty {
                background-color: #E3F2FD;
            }

            .calendar td.day {
                cursor: pointer;
                transition: background-color 0.2s ease-in-out;
            }

            .calendar td.day:hover {
                background-color: #BBDEFB;
            }

            .calendar td.disabled-day {
                background-color: #f5f5f5;
                color: #888;
                cursor: not-allowed;
            }

            .bullet-point {
                width: 6px;
                height: 6px;
                background-color: #2196F3;
                border-radius: 50%;
                display: inline-block;
                margin-top: 2px;
            }

            /* Complete Appointment Modal */
            .complete-appointment-modal {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                z-index: 1100;
            }

            .complete-modal-content {
                background: white;
                border-radius: var(--border-radius);
                width: 90%;
                max-width: 500px;
                margin: 4rem auto;
                max-height: 90vh;
                overflow-y: auto;
            }

            .complete-modal-header {
                padding: 1.25rem;
                border-bottom: 1px solid var(--grey-200);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .complete-modal-body {
                padding: 1.5rem;
            }

            .complete-modal-actions {
                padding: 1.25rem;
                border-top: 1px solid var(--grey-200);
                display: flex;
                justify-content: flex-end;
                gap: 1rem;
            }

        </style>
    </head>
    <body>
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <div class="dashboard-container right-side">
            <header class="dashboard-header">
                <h1>Appointment Management</h1>
                <div class="quick-stats">
                    <div class="stat-card">
                        <i class="fas fa-calendar-check"></i>
                        <div class="stat-info">
                            <span class="stat-value">${requestScope.todayAppointments.size()}</span>
                            <span class="stat-label">Today's Appointments</span>
                        </div>
                    </div>
                </div>
            </header>


            <div class="controls-section" >  
                <div class="search-filters" style="display: none;">
                    <div class="search-box">
                        <input type="text" id="searchInput" placeholder="Search by patient name or ID">
                        <i class="fas fa-search"></i>
                    </div>
                </div>
                <div class="view-controls">
                    <button class="view-btn active" data-view="timeline">
                        <i class="fas fa-stream"></i> Complete appointment
                    </button>
                    <button class="view-btn" data-view="calendar">
                        <i class="fas fa-calendar-alt"></i> Today
                    </button>
                </div>
            </div>

            <div class="appointments-timeline">
                <div class="timeline-header">
                    <h2>Today's Schedule</h2>
                    <div class="date-nav">
                        <button class="date-nav-btn" onclick="changeScheduleDate(-1)">
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        <!--<span id="currentDate">${requestScope.currentDate}</span>-->
                        <span id="currentDate"><%= sdfDate %></span>
                        <button class="date-nav-btn" onclick="changeScheduleDate(1)">
                            <i class="fas fa-chevron-right"></i>
                        </button>
                    </div>

                </div>

                <div class="timeline-slots">
                    <c:forEach var="appointment" items="${requestScope.todayAppointments}">
                        <div class="appointment-slot" data-status="${appointment.status}">
                            <div class="time-indicator">
                                <fmt:formatDate value="${appointment.doctorSchedule.shift.timeStart}" pattern="HH:mm"/> - <fmt:formatDate value="${appointment.doctorSchedule.shift.timeEnd}" pattern="HH:mm"/>
                            </div>
                            <div class="appointment-card">
                                <div class="patient-info">
                                    <img src="${pageContext.request.contextPath}/img/patient-placeholder.svg" alt="Patient" class="patient-avatar">
                                    <div class="patient-details">
                                        <h3>${appointment.customer.fullname}</h3>
                                        <span class="patient-id">ID: ${appointment.customer.id}</span>
                                    </div>
                                </div>
                                <div class="appointment-details">
                                    ${appointment.customer.phone_number}
                                </div>
                                <div class="appointment-actions">
                                    <button class="action-btn view-btn" onclick="viewDetails('${appointment.id}')">
                                        <i class="fas fa-eye"></i> View
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty requestScope.todayAppointments}">
                        <div class="empty-state">
                            <i class="fas fa-calendar-day empty-state-icon"></i>
                            <p class="empty-state-text">No appointments scheduled for today</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="appointments-timeline">
                <div class="timeline-header">
                    <h2>Watting to confirm</h2>                   

                </div>

                <div class="timeline-slots">
                    <c:forEach var="appointment" items="${requestScope.waittingAppointment}">
                        <div class="appointment-slot" data-status="${appointment.status}">
                            <div class="time-indicator">
                                <fmt:formatDate value="${appointment.doctorSchedule.shift.timeStart}" pattern="HH:mm"/> - <fmt:formatDate value="${appointment.doctorSchedule.shift.timeEnd}" pattern="HH:mm"/>
                            </div>
                            <div class="appointment-card">
                                <div class="patient-info">
                                    <img src="${appointment.customer.google_id.picture}" alt="Patient" class="patient-avatar">
                                    <div class="patient-details">
                                        <h3>${appointment.customer.fullname}</h3>
                                        <span class="patient-id">ID: ${appointment.customer.id}</span>
                                    </div>
                                </div>
                                <div class="appointment-details">
                                    Phone number:  ${appointment.customer.phone_number}
                                </div>
                                <div class="appointment-actions">
                                    <button class="action-btn view-btn" onclick="viewDetails('${appointment.id}')">
                                        <i class="fas fa-eye"></i> View
                                    </button>
                                    <button class="btn-success" id="completeAppointmentBtn" onclick="openCompleteAppointmentModal('${appointment.id}')">
                                        <i class="fas fa-check-circle"></i> Confirm Appointment
                                    </button>
                                </div>
                            </div>
                        </div>

                    </c:forEach>
                </div>
                <c:if test="${empty requestScope.waittingAppointment}">
                    <div class="empty-state">
                        <i class="fas fa-calendar-day empty-state-icon"></i>
                        <p class="empty-state-text">No appointments need to confirm</p>
                    </div>
                </c:if>
            </div>


            <!-- Appointment Details Modal -->
            <div id="appointmentModal" class="modal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h2>Appointment Details</h2>
                        <button class="close-btn" onclick="closeModal()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="patient-header">
                            <img src="" alt="Patient" id="modalPatientImage" class="patient-avatar large">
                            <div class="patient-info">
                                <h3 id="modalPatientName"></h3>
                                <p id="modalPatientId"></p>
                            </div>
                        </div>
                        <div class="modal-body">
                            <div class="patient-header">
                                <!--<img src="" alt="Patient" id="modalPatientImage" class="patient-avatar large">-->
                                <div class="patient-info">
                                    <h3 id="modalPatientName"></h3>
                                    <p id="modalPatientId"></p>
                                </div>
                            </div>
                            <div class="appointment-info">
                                <div class="info-group">
                                    <label>Date & Time</label>
                                    <p id="modalDateTime"></p>
                                </div>
                                <div class="info-group">
                                    <label>Reason for Visit</label>
                                    <p id="modalReason"></p>
                                    <button class="btn-secondary" id="viewHistoryBtn">View all Patient's history</button>
                                </div>
                                <div class="info-group">
                                    <label>Medical History</label>
                                    <p id="modalHistory"></p>

                                </div>
                                <div class="info-group">
                                    <label>Phone number</label>
                                    <p id="modalPatientPhone"></p>
                                </div>
                                <div class="info-group">
                                    <label>Notes</label>
                                    <textarea id="modalNotes" placeholder="Add appointment notes..."></textarea>
                                </div>
                            </div>
                            <div class="modal-actions">
                                <button class="btn-secondary" onclick="closeModal()">Close</button>
                                <button class="btn-primary" onclick="saveNotes()">Save Notes</button>
                           
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <div class="calendar-container">
                <h2>Doctor's Schedule</h2>

                <!-- Month & Year Selection -->
                <form method="get">
                    <label for="month">Month:</label>
                    <select id="month" name="month">
                        <c:forEach var="m" begin="1" end="12">
                            <option value="${m}" ${selectedMonth == m ? "selected" : ""}>${m}</option>
                        </c:forEach>
                    </select>

                    <label for="year">Year:</label>
                    <select id="year" name="year">
                        <c:forEach var="y" begin="2022" end="2030">
                            <option value="${y}" ${selectedYear == y ? "selected" : ""}>${y}</option>
                        </c:forEach>
                    </select>

                    <button type="submit">Select</button>
                </form>

                <!-- Calendar Table -->
                <table class="calendar">
                    <thead>
                        <tr>
                            <th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th>Fri</th><th>Sat</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <% 
                                int dayOfWeekCounter = 0;
                                for (int i = 0; i < startDayOfWeek; i++) {
                            %>
                            <td class="empty"></td>
                            <% 
                                    dayOfWeekCounter++;
                                }

                                for (int day = 1; day <= daysInMonth; day++) {
                                    if (dayOfWeekCounter % 7 == 0 && dayOfWeekCounter != 0) {
                            %>
                        </tr><tr>
                            <% } 

                            LocalDate loopDate = LocalDate.of(selectedYear, selectedMonth, day);
                            boolean isDisabled = loopDate.isBefore(LocalDate.now());

                            %>
                            <td class="<%= isDisabled ? "disabled-day" : "day" %>"
                                data-date="<%= loopDate.toString() %>"
                                <%= isDisabled ? "" : "onclick=\"fetchAppointmentsByDate('" + loopDate.toString() + "')\"" %>>
                                <%= day %>
                                <!-- Bullet point for days with appointments -->
                                <c:if test="${appointmentsOnDate.contains(loopDate)}">
                                    <span class="bullet-point"></span>
                                </c:if>
                            </td>

                            <% 
                                    dayOfWeekCounter++;
                                }

                                while (dayOfWeekCounter % 7 != 0) {
                            %>
                            <td class="empty"></td>
                            <% 
                                    dayOfWeekCounter++;
                                }
                            %>
                        </tr>
                    </tbody>
                </table>
            </div>


            <!-- Complete Appointment Confirmation Modal -->
            <div id="completeAppointmentModal" class="complete-appointment-modal" style="display: none">
                <div class="complete-modal-content">
                    <div class="complete-modal-header">
                        <h2>Complete Appointment</h2>
                        <button class="close-btn" onclick="closeComModal()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <div class="complete-modal-body">
                        <p>Mark this appointment to completed</p>
                        <input type="hidden" id="completeAppointmentId" value="">

                        <div class="form-group">
                            <label for="completeAppointmentSummary">Appointment Summary</label>
                            <textarea id="completeAppointmentSummary" class="form-control" placeholder="Enter a summary of the appointment..."></textarea>
                        </div>

                        <div class="form-group">
                            <label for="completeAppointmentNotes">Notes</label>
                            <textarea id="completeAppointmentNotes" class="form-control" placeholder="Additional notes..."></textarea>
                        </div>
                    </div>
                    <div class="complete-modal-actions">
                        <button class="btn-secondary" onclick="closeComModal()">Cancel</button>
                        <button class="btn-success" onclick="ConfirmAppointment( 'Done', 'completeAppointmentSummary', 'completeAppointmentNotes')">
                            <i class="fas fa-check-circle"></i> Complete Appointment
                        </button>

                        <button class="btn-fail" onclick="ConfirmAppointment( 'Not Complete', 'completeAppointmentSummary', 'completeAppointmentNotes')">
                            <i class="fas fa-times-circle"></i> Not Complete
                        </button>

                    </div>
                </div>
            </div>

        </div>


        <script>

            // Function to confirm the appointment
            function ConfirmAppointment(action, summaryFieldId, notesFieldId) {
                // Get the appointment ID from the hidden input field
                const appointmentId = document.getElementById('completeAppointmentId').value;

                // Get the summary and notes values
                const summary = document.getElementById(summaryFieldId).value;
                const notes = document.getElementById(notesFieldId).value;

                // Check if the appointmentId is valid
                if (!appointmentId) {
                    console.error("Appointment ID is missing.");
                    alert("Error: Appointment ID is missing.");
                    return;
                }

                // Prepare the request data to be sent to the backend
                const requestData = {
                    appointmentId: appointmentId,
                    action: action,
                    summary: summary, // For email purposes, not saved to DB
                    notes: notes // For email purposes, not saved to DB
                };

                // Send the data to the server via fetch (POST request)
                fetch('/SWP391_GR6/doctor/confirmApp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(requestData)  // Send data as JSON
                })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                alert('Appointment confirmed successfully!');
                                closeComModal();  // Close modal after success
                                window.location.reload(); // Reload the page to reflect changes
                            } else {
                                alert('There was an issue confirming the appointment');
                            }
                        })
                        .catch(error => {
                            console.error('Error confirming appointment:', error);
                            alert('An error occurred while confirming the appointment.');
                        });
            }



            // Close modal function
            // Function to close only the Complete Appointment modal
            window.closeCompleteAppointmentModal = function () {
                document.getElementById('completeAppointmentModal').style.display = 'none';
            };
            function closeModal() {
                appointmentModal.style.display = 'none';
                document.getElementById('completeAppointmentModal').style.display = 'none';
                document.body.classList.remove('modal-open'); // Restores scrolling

            }

            function closeComModal() {
                document.getElementById('completeAppointmentModal').style.display = 'none';
                document.body.classList.remove('modal-open'); // Restores scrolling

            }



            function openCompleteAppointmentModal(appointmentId) {

                document.getElementById('completeAppointmentId').value = appointmentId;
                document.getElementById('completeAppointmentNotes').value = document.getElementById('modalNotes').value;
                document.getElementById('completeAppointmentModal').style.display = 'block';
            }
            ;


            document.querySelector('.view-btn[data-view="calendar"]').addEventListener("click", function () {
                // Get today's date
                const today = new Date();

                // Format today's date for backend (YYYY-MM-DD)
                const newDate = today.getFullYear() + "-" +
                        String(today.getMonth() + 1).padStart(2, "0") + "-" +
                        String(today.getDate()).padStart(2, "0");

                // Format today's date for display ("Sunday, 17-03-2024")
                const dayName = today.toLocaleDateString("en-GB", {weekday: "long"});
                const formattedDate = dayName + ", " +
                        String(today.getDate()).padStart(2, "0") + "-" +
                        String(today.getMonth() + 1).padStart(2, "0") + "-" +
                        today.getFullYear();

                // Update the displayed date
                document.getElementById('currentDate').textContent = formattedDate;

                // Fetch appointments for today
                fetchAppointmentsByDate(newDate);
            });


            // Set global variables for context path and doctor ID
            const contextPath = '${pageContext.request.contextPath}';
            const doctorId = ${docID}; // Ensure doctorId is set in JSP scope, e.g., sessionScope.doctorId or requestScope.doctorId

            // Function to fetch appointments by date
            function fetchAppointmentsByDate(date) {
                // Construct the API URL with date and doctorId parameters
                const apiUrl = contextPath + `/doctor/api/appointments?date=` + date + `&doctorId=` + doctorId;

                // Fetch appointments from the servlet
                fetch(apiUrl)
                        .then(response => {
                            if (!response.ok) {
                                throw new Error(`HTTP error! Status: ${response.status}`);
                            }
                            return response.json();
                        })
                        .then(appointments => {
                            // Get the timeline slots container
                            const timelineSlots = document.querySelector('.timeline-slots');
                            timelineSlots.innerHTML = ''; // Clear existing content

                            // Check if there are appointments
                            if (appointments.length === 0) {
                                timelineSlots.innerHTML = `
                <div class="empty-state">
                    <i class="fas fa-calendar-day empty-state-icon"></i>
                    <p class="empty-state-text">No appointments scheduled for this day</p>
                </div>
            `;
                            } else {
                                // Populate timeline with appointments
                                appointments.forEach(appointment => {
                                    const slotHtml = `
                    <div class="appointment-slot" data-status="` + appointment.status + `">
                        <div class="time-indicator">
           ` + appointment.doctorSchedule.shift.timeStart + `- ` + appointment.doctorSchedule.shift.timeEnd + `
                        </div>
                        <div class="appointment-card">
                            <div class="patient-info">
                                <img src="` + appointment.customer.google_id.picture +`" alt="Patient" class="patient-avatar">
                                <div class="patient-details">
                                    <h3>` + appointment.customer.fullname + `</h3>
                                    <span class="patient-id">ID: ` + appointment.customer.id + `</span>
                                </div>
                            </div>
                            <div class="appointment-details">
           Phone number: ` + appointment.customer.phone_number + `
                            </div>
                            <div class="appointment-actions">
                                <button class="action-btn view-btn" onclick="viewDetails('` + appointment.id + `')">
                                    <i class="fas fa-eye"></i> View
                                </button>
                            </div>
                        </div>
                    </div>
                `;
                                    timelineSlots.innerHTML += slotHtml;
                                });
                            }
                            //Format the date properly before updating the display
                            const dateObj = new Date(date);

                            const dayName = dateObj.toLocaleDateString("en-GB", {weekday: "long"});
                            const day = String(dateObj.getDate()).padStart(2, "0");
                            const month = String(dateObj.getMonth() + 1).padStart(2, "0"); // Months are 0-based
                            const year = dateObj.getFullYear();

                            // Concatenating strings using `+`
                            const formattedDate = dayName + ", " + day + "-" + month + "-" + year;

                            document.getElementById('currentDate').textContent = formattedDate;

                        })
                        .catch(error => {
                            console.error('Error fetching appointments:', error);
                            alert('Failed to load appointments. Please try again.');
                        });
            }

            // Function to handle date navigation (previous/next buttons)
            function changeScheduleDate(delta) {
                const currentDateSpan = document.getElementById('currentDate');
                const rawDate = currentDateSpan.textContent.trim(); // Ensure no extra spaces

                // Split to extract "17-03-2024" from "Sunday, 17-03-2024"
                const dateParts = rawDate.split(', ')[1]?.split('-');

                if (!dateParts || dateParts.length !== 3) {
                    console.error("Invalid date format:", rawDate);
                    return;
                }

                // Convert extracted parts into numbers
                const day = parseInt(dateParts[0], 10);
                const month = parseInt(dateParts[1], 10) - 1; // JavaScript months are 0-based
                const year = parseInt(dateParts[2], 10);

                // Create Date object and adjust the date
                const currentDate = new Date(year, month, day);
                currentDate.setDate(currentDate.getDate() + delta);

                // Format the new date for the backend (YYYY-MM-DD)
                const newDate = currentDate.getFullYear() + "-" +
                        String(currentDate.getMonth() + 1).padStart(2, "0") + "-" +
                        String(currentDate.getDate()).padStart(2, "0");

                // Format the displayed date as "Sunday, 17-03-2024"
                const dayName = currentDate.toLocaleDateString("en-GB", {weekday: "long"});
                const formattedDate = dayName + ", " +
                        String(currentDate.getDate()).padStart(2, "0") + "-" +
                        String(currentDate.getMonth() + 1).padStart(2, "0") + "-" +
                        currentDate.getFullYear();

                // Update the displayed date
                currentDateSpan.textContent = formattedDate;

                // Fetch new appointments
                fetchAppointmentsByDate(newDate);
            }


            // Fetch & Display Appointment Details in Modal
            function viewDetails(appointmentId) {
                if (!appointmentId) {
                    console.error("Appointment ID is missing.");
                    alert("Error: Appointment ID is missing.");
                    return;
                }

                let apiUrl = `/SWP391_GR6/doctor/api/appointment/details?id=` + appointmentId;
                console.log("Fetching appointment from:", apiUrl); // Debugging

                fetch(apiUrl)
                        .then(response => {
                            if (!response.ok) {
                                throw new Error(`HTTP error! Status: ${response.status}`);
                            }
                            return response.json();
                        })
                        .then(data => {
                            const appointment = data.appointment;
                            const customer = data.customer;

                            // Ensure appointment and customer data exist
                            if (!appointment || !customer) {
                                console.error('Invalid response structure');
                                alert('Failed to load appointment details.');
                                return;
                            }

                            // Ensure modal elements exist
                            const patientNameElem = document.getElementById('modalPatientName');
                            const patientIdElem = document.getElementById('modalPatientId');
                            const patientImageUrl = customer.google_id.picture || '/path/to/default/image.jpg';  // Default image if picture is missing
                            const dateTimeElem = document.getElementById('modalDateTime');
                            const reasonElem = document.getElementById('modalReason');
                            const historyElem = document.getElementById('modalHistory');
                            const patientPhoneElem = document.getElementById('modalPatientPhone');
                            const notesElem = document.getElementById('modalNotes');
                            const viewHistoryBtnElem = document.getElementById('viewHistoryBtn');
                            const img = document.getElementById('modalPatientImage');

                            if (!patientNameElem || !patientIdElem || !dateTimeElem || !reasonElem || !historyElem || !patientPhoneElem || !notesElem || !viewHistoryBtnElem || !img) {
                                console.error("Modal elements not found in DOM.");
                                return;
                            }

                            // Update modal content with appointment and customer details
                            patientNameElem.textContent = customer.fullname || "N/A";
//                            patientIdElem.textContent = "ID: " + customer.id;
                            img.src = patientImageUrl;
                            dateTimeElem.textContent = appointment.doctorSchedule.scheduleDate || "N/A";
                            reasonElem.textContent = "Reason: " + (appointment.reason || "No reason provided");
                            historyElem.textContent = "Medical History: " + (appointment.history || "No medical history available");
                            patientPhoneElem.textContent = customer.phone_number || "No phone number available";
                            notesElem.value = appointment.notes || "";  // Placeholder for notes

                            // Set up the "View History" button to redirect to the patient's medical details page
                            viewHistoryBtnElem.onclick = function () {
                                window.location.href = contextPath + `/doctor/ShowCustomerMedicalDetail?cId=` + customer.id;
                            };

                            // Open the modal
                            openModal();
                        })
                        .catch(error => {
                            console.error('Error fetching appointment details:', error);
                            alert('Failed to load appointment details.');
                        });
            }

// Function to open the modal
            function openModal() {
                const modal = document.getElementById('appointmentModal');
                modal.style.display = 'block';
                document.body.classList.add('modal-open'); // Prevents scrolling
            }

// Function to close the modal
            function closeModal() {
                const modal = document.getElementById('appointmentModal');
                modal.style.display = 'none';
                document.body.classList.remove('modal-open'); // Restores scrolling
            }





            // Save Notes
            function saveNotes() {
                const notes = document.getElementById('modalNotes').value;
                alert('this function does not available yet');
                closeModal();
            }

            // Modal Controls
            function openModal() {
                appointmentModal.style.display = 'block';
                document.body.classList.add('modal-open'); // Prevents scrolling
            }


            // Close modal when clicking outside
            window.addEventListener('click', (event) => {
                if (event.target === appointmentModal)
                    closeModal();
            });
            // Initialize on Page Load
            document.addEventListener('DOMContentLoaded', updateDateDisplay);
            // Add Loading States to Buttons
            document.querySelectorAll('button').forEach(button => {
                button.addEventListener('click', () => {
                    if (!button.classList.contains('date-nav-btn')) {
                        button.classList.add('loading');
                        setTimeout(() => button.classList.remove('loading'), 1000);
                    }
                });
            });





        </script>
    </body>
</html>
