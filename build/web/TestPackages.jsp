<%-- 
    Document   : TestPackages
    Created on : Feb 10, 2025, 3:37:14 AM
    Author     : admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
        body { font-family: Arial, sans-serif; }
        .container { width: 60%; margin: 0 auto; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f4f4f4; }
        .error { color: red; }
        .filter-container { margin-top: 10px; }
    </style>
        
    </head>
    <body>
        <jsp:include page="Header.jsp"></jsp:include>
        <h2>Test Packages</h2>
        <div class="container">

    
    <form action="TestPackage" method="get">
    <input type="text" name="keyword" placeholder="Search by name" value="${keyword}" />
    <input type="submit" value="Search" />
</form>


    <table border="1">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Description</th>
                <th>Price</th>
                <th>Duration</th>
                <th>Category</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="test" items="${Test}">
                <tr>
                    <td>${test.id}</td>
                    <td><a href="packageDetail.jsp?testId=${test.id}">${test.name}</a></td>
                    <td>${test.description}</td>
                    <td>${test.price}</td>
                    <td>${test.duration_minutes}</td>
                    <td>${test.category}</td>
                    <td>
                        <a href="bookAppointment?testId=${test.id}">Đặt lịch</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    </div>
    <jsp:include page="Footer.jsp"></jsp:include>
    </body>
</html>
