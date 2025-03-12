document.addEventListener('DOMContentLoaded', function () {
    flatpickr(".date", {
        dateFormat: "Y-m-d",
        altInput: true,
        altFormat: "d/m/Y",
        locale: "vn"
    });
});

document.addEventListener('DOMContentLoaded', function () {
    let issueDateInput = document.getElementById("issueDate");
    flatpickr("#issueDate", {
        dateFormat: "Y-m-d",
        altInput: true,
        altFormat: "d/m/Y",
        clickOpens: false,
        locale: "vn",
        defaultDate: issueDateInput.value || ""
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

document.querySelector("form").addEventListener("submit", function (event) {
    let certificateName = document.getElementById("certificateName").value.trim();
    let issueDate = document.getElementById("issueDate").value.trim();
    let documentPath = document.getElementById("documentPath").value.trim();
    let mess = "";

    if (!certificateName)
        mess += "Certificate name cannot be empty\n";
    if (!issueDate)
        mess += "Issue date cannot be empty\n";
    if (!documentPath)
        mess += "Document path cannot be empty\n";
    if (mess) {
        alert(mess);
        event.preventDefault();
    }
});

document.querySelector("form").addEventListener("submit", function (event) {
    let reason = document.getElementById("reason").value.trim();
    let mess = "";
    if (reason === "") {
        mess += "Reason not null\n";

    }
    if (mess !== "") {
        alert(mess);
        event.preventDefault();
    }
});  