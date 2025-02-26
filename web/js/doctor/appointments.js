// DOM Elements
const searchInput = document.getElementById('searchInput');
const filterButtons = document.querySelectorAll('.filter-btn');
const viewButtons = document.querySelectorAll('.view-btn');
const appointmentModal = document.getElementById('appointmentModal');

// Filter Appointments
function filterAppointments(filter) {
    document.querySelectorAll('.appointment-slot').forEach(appointment => {
        const status = appointment.dataset.status ? appointment.dataset.status.toLowerCase() : "";
        appointment.style.display = (filter === 'all' || status === filter) ? 'flex' : 'none';
    });
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

// View Toggle Handlers
viewButtons.forEach(button => {
    button.addEventListener('click', () => {
        viewButtons.forEach(btn => btn.classList.remove('active'));
        button.classList.add('active');
        // Future: Implement switching between timeline and calendar views
    });
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
    fetch(`/doctor/api/appointment?id=${appointmentId}`)
        .then(response => response.json())
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

// Approve Appointment
function approveAppointment(appointmentId) {
    if (confirm('Are you sure you want to approve this appointment?')) {
        const approveButton = document.querySelector(`[data-appointment-id="${appointmentId}"] .approve-btn`);
        if (approveButton) approveButton.classList.add('loading');

        fetch(`/doctor/api/appointment/approve?id=${appointmentId}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' }
        })
        .then(response => response.json())
        .then(() => {
            const appointmentElement = document.querySelector(`[data-appointment-id="${appointmentId}"]`);
            if (appointmentElement) {
                appointmentElement.dataset.status = 'confirmed';
                appointmentElement.style.opacity = '0.5'; // Visual indicator
            }
        })
        .catch(error => {
            console.error('Error approving appointment:', error);
            alert('Failed to approve appointment.');
        })
        .finally(() => {
            if (approveButton) approveButton.classList.remove('loading');
        });
    }
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
    if (event.target === appointmentModal) closeModal();
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
