document.addEventListener('DOMContentLoaded', function () {
    flatpickr(".date", {
        dateFormat: "Y-m-d",
        altInput: true,
        altFormat: "d/m/Y",
        locale: "vn"
    });
});

document.addEventListener('DOMContentLoaded', function () {
    let visitDateInput = document.getElementById("visitDate");
    let nextAppointmentInput = document.getElementById("nextAppointment");

    flatpickr("#visitDate", {
        enableTime: true,
        dateFormat: "Y-m-d H:i",
        altInput: true,
        time_24hr: true,
        altFormat: "d/m/Y H:i",
        locale: "vn",
        defaultDate: visitDateInput.value || new Date() // Nếu có giá trị thì dùng, nếu không thì lấy ngày hiện tại
    });

    flatpickr("#nextAppointment", {
        enableTime: true,
        dateFormat: "Y-m-d H:i",
        altInput: true,
        time_24hr: true,
        altFormat: "d/m/Y H:i",
        locale: "vn",
        defaultDate: nextAppointmentInput.value || "" // Chỉ gán nếu có giá trị
    });
});

document.addEventListener("DOMContentLoaded", function () {
    let now = new Date();
    let vietnamTime = new Date(now.getTime() + (7 * 60 * 60 * 1000));

    function formatDateTime(date) {
        let offset = date.getTimezoneOffset();
        let localISOTime = new Date(date.getTime() - offset).toISOString().slice(0, 16);
        return localISOTime;
    }

    let visitDateInput = document.getElementById("visitDate");
    visitDateInput.value = formatDateTime(vietnamTime);

    let nextAppointmentInput = document.getElementById("nextAppointment");
    if (!nextAppointmentInput.value) {
        nextAppointmentInput.value = "";
    }
});

document.querySelector("form").addEventListener("submit", function (event) {
    let reasonForVisit = document.getElementById("reasonForVisit").value.trim();
    let visitDate = document.getElementById("visitDate").value.trim();
    let diagnoses = document.getElementById("diagnoses").value.trim();
    let treatmentPlan = document.getElementById("treatmentPlan").value.trim();
    let mess = "";

    if (!reasonForVisit)
        mess += "Reason For Visit cannot be empty\\n";
    if (!visitDate)
        mess += "Visit Date cannot be empty\\n";
    if (!diagnoses)
        mess += "Diagnoses cannot be empty\\n";
    if (!treatmentPlan)
        mess += "Treatment Plan cannot be empty\\n";

    if (mess) {
        alert(mess);
        event.preventDefault();
    }
});
