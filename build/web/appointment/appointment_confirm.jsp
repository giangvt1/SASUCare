<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Confirm Your Appointment</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h2>Confirm Your Appointment</h2>

    <p><strong>Doctor:</strong> ${doctor.name}</p>
    <p><strong>Specialty:</strong> ${doctor.specialty}</p>
    <p><strong>Appointment Date:</strong> ${schedule.scheduleDate}</p>
    <p><strong>Time Slot:</strong> ${schedule.timeStart} - ${schedule.timeEnd}</p>
    <!--<p><strong>Your Name:</strong> {customer.name}</p>-->
    <!--<p><strong>Email:</strong> {customer.gmail}</p>-->

    <form action="confirm" method="post">
        <!--<input type="hidden" name="customer" value="{customer.id}">-->
        <input type="hidden" name="doctor" value="${doctor.id}">
        <input type="hidden" name="schedule" value="${schedule.id}">
        <button type="submit">Confirm Booking</button>
    </form>

    <a href="/appointment/doctor">Cancel</a>
</body>
</html>
