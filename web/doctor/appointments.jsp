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

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Doctor Dashboard - Appointments</title>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/doctor/appointments.css">
        <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/main.min.css" rel="stylesheet" />
        <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>
        <style>.calendar-container {
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
        }</style>
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
                <!--                    <div class="stat-card">
                                        <i class="fas fa-clock"></i>
                                        <div class="stat-info">
                                            <span class="stat-value">${requestScope.pendingAppointments.size()}</span>
                                            <span class="stat-label">Pending Approval</span>
                                        </div>
                                    </div>-->
            </div>
        </header>

        <div class="controls-section">
            <div class="search-filters">
                <div class="search-box">
                    <input type="text" id="searchInput" placeholder="Search by patient name or ID">
                    <i class="fas fa-search"></i>
                </div>
                <!--                    <div class="filter-group">
                                        <button class="filter-btn active" data-filter="all">All</button>
                                        <button class="filter-btn" data-filter="today">Today</button>
                                        <button class="filter-btn" data-filter="pending">Pending</button>
                                        <button class="filter-btn" data-filter="confirmed">Confirmed</button>
                                    </div>-->
            </div>
            <div class="view-controls">
                <button class="view-btn active" data-view="timeline">
                    <i class="fas fa-stream"></i> Timeline
                </button>
                <button class="view-btn" data-view="calendar">
                    <i class="fas fa-calendar-alt"></i> Calendar
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
                    <span id="currentDate">${requestScope.currentDate}</span>
                    <button class="date-nav-btn" onclick="changeScheduleDate(1)">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                </div>

            </div>

            <div class="timeline-slots">
                <c:forEach var="appointment" items="${requestScope.todayAppointments}">
                    <div class="appointment-slot" data-status="${appointment.status}">
                        <div class="time-indicator">
                            <fmt:formatDate value="${appointment.doctorSchedule.scheduleDate}" pattern="HH:mm"/>
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
                                <!--<p><i class="fas fa-notes-medical"></i> appointment.reason</p>-->
                                <!--<p><i class="fas fa-clock"></i> appointment.duration minutes</p>-->
                            </div>
                            <div class="appointment-actions">
                                <button class="action-btn view-btn" onclick="viewDetails('${appointment.id}')">
                                    <i class="fas fa-eye"></i> View
                                </button>
                                <!--                                    <c:if test="${appointment.status == 'Pending'}">
                                                                        <button class="action-btn approve-btn" onclick="approveAppointment('${appointment.id}')">
                                                                            <i class="fas fa-check"></i> Approve
                                                                        </button>
                                </c:if>
                                <button class="action-btn reschedule-btn" onclick="rescheduleAppointment('${appointment.id}')">
                                    <i class="fas fa-calendar-alt"></i> Reschedule
                                </button>-->
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
                            <img src="" alt="Patient" id="modalPatientImage" class="patient-avatar large">
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
                            </div>
                            <div class="info-group">
                                <label>Medical History</label>
                                <p id="modalHistory"></p>
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
                            onclick="fetchAppointmentsByDate('<%= loopDate.toString() %>')">
                            <%= day %>
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




        <script>
            // DOM Elements
            const searchInput = document.getElementById('searchInput');
            const filterButtons = document.querySelectorAll('.filter-btn');
            const viewButtons = document.querySelectorAll('.view-btn');
            const appointmentModal = document.getElementById('appointmentModal');
            // Get the context path for AJAX requests
            const contextPath = '${pageContext.request.contextPath}';
            let currentDate = new Date(); // Track the selected date
            
            // **Fetch appointments for a given date**
            function fetchAppointmentsByDate(date) {
                if (!date || date === 'null' || date.trim() === "") {
                    console.error("Invalid date provided:", date);
                    return;
                }
                
                let doctorId = 16; // Ensure doctorId is correctly set
                let apiUrl = `${contextPath}/doctor/api/appointments?date=${date}&doctorId=${doctorId}`;
                        
                        console.log("Fetching appointments from:", apiUrl);
                        
                        fetch(apiUrl)
                                .then(response => {
                                    if (!response.ok) {
                                        return response.text().then(text => {
                                            throw new Error(text);
                                        });
                                    }
                                    return response.json();
                                })
                                .then(data => updateScheduleUI(data, date))
                                .catch(error => console.error('Error fetching appointments:', error));
                    }
                    
                    
                    
                    // **Update "Today's Schedule" dynamically**
                    function updateScheduleUI(appointments, date) {
                        let scheduleContainer = document.querySelector('.timeline-slots');
                        let dateDisplay = document.getElementById('currentDate');
                        dateDisplay.textContent = new Date(date).toDateString();
                        scheduleContainer.innerHTML = '';
                        
                        if (appointments.length === 0) {
                            scheduleContainer.innerHTML = `
            <div class="empty-state">
                <i class="fas fa-calendar-day empty-state-icon"></i>
                <p class="empty-state-text">No appointments scheduled for this day.</p>
            </div>`;
                            return;
                        }
                        
                        appointments.forEach(appointment => {
                            let scheduleDate = new Date(appointment.doctorSchedule.scheduleDate);
                            let timeStart = scheduleDate.toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'});
                            let timeEndDate = new Date(scheduleDate.getTime() + 30 * 60000);
                            let timeEnd = timeEndDate.toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'});
                            
                            let appointmentHTML = `
            <div class="appointment-slot" data-status="${appointment.status}">
                <div class="time-indicator">${timeStart} - ${timeEnd}</div>
                <div class="appointment-card">
                    <div class="patient-info">
                        <div class="patient-details">
                            <h3>${appointment.customer.fullname}</h3>
                            <span class="patient-id">ID: ${appointment.customer.id}</span>
                        </div>
                    </div>
                    <div class="appointment-details">
                        <p><i class="fas fa-notes-medical"></i></p>
                    </div>
                </div>
            </div>`;
                            scheduleContainer.innerHTML += appointmentHTML;
                        });
                    }
                    
                    // **Change schedule date when clicking Previous/Next**
                    function changeScheduleDate(offset) {
                        currentDate.setDate(currentDate.getDate() + offset);
                        let formattedDate = currentDate.toISOString().split('T')[0];
                        fetchAppointmentsByDate(formattedDate);
                    }
                    
                    // **Clicking on a calendar date updates "Today's Schedule"**
                    document.querySelectorAll('.day').forEach(cell => {
                        cell.addEventListener('click', function () {
                            let selectedDate = this.getAttribute('data-date');
                            fetchAppointmentsByDate(selectedDate);
                        });
                    });
                    
                    // **Format and Display Date**
                    function formatDate(date) {
                        return new Intl.DateTimeFormat('en-US', {
                            weekday: 'long',
                            year: 'numeric',
                            month: 'long',
                            day: 'numeric'
                        }).format(date);
                    }
                    
                    function updateDateDisplay() {
                        document.getElementById('currentDate').textContent = formatDate(currentDate);
                    }
                    
                    // **Run this on Page Load**
                    document.addEventListener('DOMContentLoaded', updateDateDisplay);
                    
                    
                    
                    function updateDateDisplay() {
                        document.getElementById('currentDate').textContent = formatDate(currentDate);
                    }
                    
                    function previousDay() {
                        currentDate.setDate(currentDate.getDate() - 1);
                        updateDateDisplay();
                    }
                    
                    function nextDay() {
                        currentDate.setDate(currentDate.getDate() + 1);
                        updateDateDisplay();
                    }
                    
                    
                    
                    // Fetch & Display Appointment Details in Modal
                    function viewDetails(appointmentId) {
                        if (!appointmentId) {
                            console.error("Appointment ID is missing.");
                            alert("Error: Appointment ID is missing.");
                            return;
                        }
                        
                        let apiUrl = `/SWP391_GR6/doctor/api/appointment?id=` + appointmentId;
                        console.log("Fetching appointment from:", apiUrl); // Debugging
                        
                        fetch(apiUrl)
                                .then(response => {
                                    if (!response.ok) {
                                        throw new Error(`HTTP error! Status: ${response.status}`);
                                    }
                                    return response.json();
                                })
                                .then(appointment => {
                                    document.getElementById('modalPatientName').textContent = appointment.customer.fullname;
                                    document.getElementById('modalPatientId').textContent = "ID: " + appointment.customer.id;
                                    document.getElementById('modalDateTime').textContent = appointment.doctorSchedule.scheduleDate;
                                    document.getElementById('modalReason').textContent = "No reason provided";
                                    document.getElementById('modalHistory').textContent = "No medical history available";
                                    document.getElementById('modalNotes').value = "";
                                    openModal();
                                })
                                .catch(error => {
                                    console.error('Error fetching appointment details:', error);
                                    alert('Failed to load appointment details.');
                                });
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
                    
                    function closeModal() {
                        appointmentModal.style.display = 'none';
                        document.body.classList.remove('modal-open'); // Restores scrolling
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
