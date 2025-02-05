<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Book Your Appointment</title>
        <link rel="stylesheet" href="styles.css">
    </head>
    <body>
        <jsp:include page="../Header.jsp"></jsp:include>
            <h2>Book Your Appointment</h2>

            <!-- Search Bar -->
            <form action="appointment/doctor" method="get">
                <input type="date" name="date" value="${selectedDate}" required>
            <input type="text" name="search" placeholder="Search by name or specialist">
            <button type="submit">Search</button>
        </form>

        <!-- Doctor List Table -->
        <table border="1">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Specialist</th>
                    <th>Time Slot</th>
                    <th>Book</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="entry" items="${doctorMap}">
                    <c:set var="doctor" value="${entry.key}" />
                    <c:set var="shifts" value="${entry.value}" />
                    <tr>
                        <td>${doctor.name}</td>
                        <td>${doctor.specialty}</td>
                        <td>
                            <c:forEach var="shift" items="${shifts}">
                                <input type="radio" name="selectedShift_${doctor.id}" value="${shift.id}" 
                                       data-doctor-name="${doctor.name}" 
                                       data-specialty="${doctor.specialty}" 
                                       data-shift-time="${shift.timeStart} - ${shift.timeEnd}"
                                       onchange="enableBookButton(${doctor.id})">
                                ${shift.timeStart} - ${shift.timeEnd}
                            </c:forEach>
                        </td>
                        <td>
                            <button id="bookBtn_${doctor.id}" disabled class="disabled-btn" onclick="openBookingModal(${doctor.id})">Book</button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- Booking Modal -->
        <div id="bookingModal" class="modal" style="display: none;">
            <div class="modal-content">
                <span class="close" onclick="closeModal()">&times;</span>
                <h3>Your Booking Details</h3>
                <p><strong>Doctor Name:</strong> <span id="modalDoctorName"></span></p>
                <p><strong>Specialist:</strong> <span id="modalSpecialty"></span></p>
                <p><strong>Time Slot:</strong> <span id="modalShiftTime"></span></p>
                <button onclick="closeModal()">Close</button>
                <button id="confirmBooking">Confirm Booking</button>
            </div>
        </div>
        <%--<jsp:include page="../Footer.jsp"></jsp:include>--%>
            <script>
                function enableBookButton(doctorId) {
                    let bookButton = document.getElementById("bookBtn_" + doctorId);
                    bookButton.disabled = false;
                    bookButton.classList.remove("disabled-btn");
                    bookButton.classList.add("active-btn");
                }

                function openBookingModal(doctorId) {
                    console.log("Opening modal for doctor:", doctorId); // Debugging log

                    let selectedShift = document.querySelector("input[name='selectedShift_" + doctorId + "']:checked");

                    if (!selectedShift) {
                        alert("Please select a time slot before booking.");
                        return; // Exit if no shift is selected
                    }

                    console.log("Selected shift:", selectedShift.value); // Debugging log

                    document.getElementById("modalDoctorName").innerText = selectedShift.getAttribute("data-doctor-name");
                    document.getElementById("modalSpecialty").innerText = selectedShift.getAttribute("data-specialty");
                    document.getElementById("modalShiftTime").innerText = selectedShift.getAttribute("data-shift-time");

                    document.getElementById("confirmBooking").onclick = function () {
                        let shiftId = selectedShift.value;
                        console.log("Redirecting to confirm booking:", shiftId);
                        window.location.href = "../appointment/confirm?doctor="+ doctorId +"&shift="+ shiftId;
                    };

                    document.getElementById("bookingModal").style.display = "block";
                }



                function closeModal() {
                    document.getElementById("bookingModal").style.display = "none";
                }
        </script>
    </body>
</html>
