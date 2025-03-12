<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Doctor Dashboard - Appointments</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/doctor/appointments.css">
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
                    <div class="stat-card">
                        <i class="fas fa-clock"></i>
                        <div class="stat-info">
                            <span class="stat-value">${requestScope.pendingAppointments.size()}</span>
                            <span class="stat-label">Pending Approval</span>
                        </div>
                    </div>
                </div>
            </header>

            <div class="controls-section">
                <div class="search-filters">
                    <div class="search-box">
                        <input type="text" id="searchInput" placeholder="Search by patient name or ID">
                        <i class="fas fa-search"></i>
                    </div>
                    <div class="filter-group">
                        <button class="filter-btn active" data-filter="all">All</button>
                        <button class="filter-btn" data-filter="today">Today</button>
                        <button class="filter-btn" data-filter="pending">Pending</button>
                        <button class="filter-btn" data-filter="confirmed">Confirmed</button>
                    </div>
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
                        <button class="date-nav-btn" onclick="previousDay()">
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        <span id="currentDate">${requestScope.currentDate}</span>
                        <button class="date-nav-btn" onclick="nextDay()">
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
                                    <p><i class="fas fa-notes-medical"></i> ${appointment.reason}</p>
                                    <p><i class="fas fa-clock"></i> ${appointment.duration} minutes</p>
                                </div>
                                <div class="appointment-actions">
                                    <button class="action-btn view-btn" onclick="viewDetails('${appointment.id}')">
                                        <i class="fas fa-eye"></i> View
                                    </button>
                                    <c:if test="${appointment.status == 'Pending'}">
                                        <button class="action-btn approve-btn" onclick="approveAppointment('${appointment.id}')">
                                            <i class="fas fa-check"></i> Approve
                                        </button>
                                    </c:if>
                                    <button class="action-btn reschedule-btn" onclick="rescheduleAppointment('${appointment.id}')">
                                        <i class="fas fa-calendar-alt"></i> Reschedule
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

            <div class="upcoming-appointments">
                <h2>Upcoming Appointments</h2>
                <div class="appointment-cards">
                    <c:forEach var="appointment" items="${requestScope.upcomingAppointments}">
                        <div class="appointment-card">
                            <div class="card-header">
                                <span class="appointment-date">
                                    <fmt:formatDate value="${appointment.doctorSchedule.scheduleDate}" pattern="yyyy-MM-dd"/>
                                </span>
                                <span class="appointment-status ${appointment.status.toLowerCase()}">${appointment.status}</span>
                            </div>
                            <div class="card-body">
                                <div class="patient-info">
                                    <h3>${appointment.customer.fullname}</h3>
                                    <p>${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}</p>
                                </div>
                            </div>
                            <div class="card-actions">
                                <button onclick="viewDetails('${appointment.id}')" class="btn-outline">
                                    <i class="fas fa-info-circle"></i> Details
                                </button>
                                <button onclick="updateStatus('${appointment.id}')" class="btn-primary">
                                    <i class="fas fa-check-circle"></i> Update Status
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
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

        <script>
            // DOM Elements
            const searchInput = document.getElementById('searchInput');
            const filterButtons = document.querySelectorAll('.filter-btn');
            const viewButtons = document.querySelectorAll('.view-btn');
            const appointmentModal = document.getElementById('appointmentModal');

// Filter Appointments
            function filterAppointments(filter) {
                if (filter === 'pending') {
                    // Redirect to /doctor/waiting-appointment when "Pending" is clicked
                    window.location.href = '../doctor/waiting-appointment';
                } else {
                    // Normal filtering for other statuses
                    document.querySelectorAll('.appointment-slot').forEach(appointment => {
                        const status = appointment.dataset.status ? appointment.dataset.status.toLowerCase() : "";
                        appointment.style.display = (filter === 'all' || status === filter) ? 'flex' : 'none';
                    });
                }
            }

// Search Functionality
            searchInput?.addEventListener('input', (e) => {
                const searchTerm = e.target.value.toLowerCase();
                document.querySelectorAll('.appointment-slot').forEach(appointment => {
                    const patientNameEl = appointment.querySelector('.patient-details h3');
                    const patientIdEl = appointment.querySelector('.patient-id');

                    if (patientNameEl && patientIdEl) {
                        const patientName = patientNameEl.textContent.toLowerCase();
                        const patientId = patientIdEl.textContent.toLowerCase();
                        appointment.style.display = (patientName.includes(searchTerm) || patientId.includes(searchTerm)) ? 'flex' : 'none';
                    }
                });
            });

// Filter Button Click Handlers
            filterButtons.forEach(button => {
                button.addEventListener('click', () => {
                    filterButtons.forEach(btn => btn.classList.remove('active'));
                    button.classList.add('active');
                    filterAppointments(button.dataset.filter);
                });
            });


// Initialize on Page Load
            document.addEventListener('DOMContentLoaded', () => {
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get("filter") === "pending") {
                    filterAppointments("pending");
                }
            });


            // Date Navigation
            function formatDate(date) {
                return new Intl.DateTimeFormat('en-US', {
                    weekday: 'long',
                    year: 'numeric',
                    month: 'long',
                    day: 'numeric'
                }).format(date);
            }

            let currentDate = new Date();

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

    let apiUrl = `/SWP391_GR6/doctor/api/appointment?id=`+ appointmentId;
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
            document.getElementById('modalReason').textContent = appointment.reason || "No reason provided";
            document.getElementById('modalHistory').textContent = appointment.history || "No medical history available";
            document.getElementById('modalNotes').value = appointment.notes || "";

            openModal();
        })
        .catch(error => {
            console.error('Error fetching appointment details:', error);
            alert('Failed to load appointment details.');
        });
}



            // Reschedule Appointment (Placeholder)
            function rescheduleAppointment(appointmentId) {
                alert('Reschedule functionality to be implemented');
            }

            // Save Notes
            function saveNotes() {
                const notes = document.getElementById('modalNotes').value;
                alert('Notes saved successfully');
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
