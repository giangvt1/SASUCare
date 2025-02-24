document.addEventListener("DOMContentLoaded", function () {
    autoRefreshAppointments();
    setupSearchFilter();
});

function autoRefreshAppointments() {
    setInterval(fetchAppointments, 30000); // Refresh every 30 seconds
}

function fetchAppointments() {
    fetch(`${window.location.origin}/doctor/dashboard?ajax=true`)
        .then(response => response.text())
        .then(data => {
            document.querySelector(".appointments-timeline").innerHTML = data;
        })
        .catch(error => console.error("Error fetching appointments:", error));
}

function setupSearchFilter() {
    document.getElementById("searchInput").addEventListener("keyup", function () {
        let query = this.value.trim().toLowerCase();
        document.querySelectorAll(".appointment-card").forEach(card => {
            let patientName = card.querySelector(".patient-details h3").textContent.toLowerCase();
            let patientId = card.querySelector(".patient-id").textContent.toLowerCase();
            card.style.display = (patientName.includes(query) || patientId.includes(query)) ? "block" : "none";
        });
    });
}

function approveAppointment(appointmentId) {
    fetch(`${window.location.origin}/doctor/appointment/action`, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `appointmentId=${appointmentId}&action=approve`
    })
    .then(response => response.ok ? fetchAppointments() : alert("Error approving appointment"))
    .catch(error => console.error("Error:", error));
}

function rescheduleAppointment(appointmentId) {
    alert("Reschedule feature coming soon!"); // Placeholder
}
