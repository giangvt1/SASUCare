<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor List</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h2>Doctor List</h2>
    <table border="1">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Degree</th>
                <th>Specialty</th>
                <th>Gender</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="doctor" items="${doctors}">
                <tr>
                    <td>${doctor.id}</td>
                    <td>${doctor.name}</td>
                    <td>${doctor.degree}</td>
                    <td>${doctor.specialty}</td>
                    <td>${doctor.gender ? "Male" : "Female"}</td>
                    <td>
                        <a href="/appointment/doctor/specialties?doctorId=${doctor.id}">Book Appointment</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>
