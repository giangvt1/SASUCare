<%-- 
    Document   : doctor_specialties
    Created on : Feb 4, 2025, 12:48:59 PM
    Author     : Golden  Lightning
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Specialty</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h2>Select a Specialty</h2>
    <form action="/appointment/doctor/service" method="GET">
        <input type="hidden" name="doctorId" value="${doctorId}">
        
        <ul>
            <c:forEach var="specialty" items="${specialties}">
                <li>
                    <input type="radio" name="specialty" value="${specialty}" required> ${specialty}
                </li>
            </c:forEach>
        </ul>
        
        <button type="submit">Next</button>
    </form>
</body>
</html>
