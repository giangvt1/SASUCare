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
    let dateSendInput = document.getElementById("dateSend");
    let dateReplyInput = document.getElementById("dateReply");
    flatpickr("#visitDate", {
        enableTime: true,
        dateFormat: "Y-m-d H:i",
        altInput: true,
        time_24hr: true,
        altFormat: "d/m/Y H:i",
        locale: "vn",
        defaultDate: visitDateInput.value || new Date()
    });
    flatpickr("#nextAppointment", {
        enableTime: true,
        dateFormat: "Y-m-d H:i",
        altInput: true,
        time_24hr: true,
        altFormat: "d/m/Y H:i",
        locale: "vn",
        defaultDate: nextAppointmentInput.value || ""
    });
    flatpickr("#dateSend", {
        enableTime: true,
        dateFormat: "Y-m-d H:i",
        altInput: true,
        time_24hr: true,
        altFormat: "d/m/Y H:i",
        locale: "vn",
        defaultDate: dateSendInput.value || ""
    });
    flatpickr("#dateReply", {
        enableTime: true,
        dateFormat: "Y-m-d H:i",
        altInput: true,
        time_24hr: true,
        altFormat: "d/m/Y H:i",
        locale: "vn",
        defaultDate: dateReplyInput.value || new Date()
    });
});

document.addEventListener('DOMContentLoaded', function () {
    let dateSendInput = document.getElementById("dateSend");
    let dateReplyInput = document.getElementById("dateReply");
    flatpickr("#dateSend", {
        enableTime: true,
        dateFormat: "Y-m-d H:i",
        altInput: true,
        time_24hr: true,
        altFormat: "d/m/Y H:i",
        locale: "vn",
        clickOpens: false,
        defaultDate: dateSendInput.value || ""
    });
    flatpickr("#dateReply", {
        enableTime: true,
        dateFormat: "Y-m-d H:i",
        altInput: true,
        time_24hr: true,
        altFormat: "d/m/Y H:i",
        locale: "vn",
        clickOpens: false,
        defaultDate: dateReplyInput.value || new Date()
    });
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
