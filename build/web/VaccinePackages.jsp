<%-- 
    Document   : VaccinePackages
    Created on : Feb 10, 2025, 3:16:10 AM
    Author     : admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Vaccine" %>
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
        
        <title>Vaccine Packages</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .container { width: 60%; margin: 0 auto; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f4f4f4; }
        .form-container { margin-top: 20px; padding: 15px; border: 1px solid #ccc; background: #f9f9f9; }
    </style>
</head>
<body>
    <jsp:include page="Header.jsp"/>
    <div class="container">
        <h2>Vaccine Packages</h2>
        
        <!-- Form thêm/sửa vaccine -->
        <div class="form-container">
            <form action="VaccinePackage" method="post">
                <input type="hidden" name="id" value="${editVaccine.id}">
                <label>Name:</label>
                <input type="text" name="name" value="${editVaccine.name}" required>
                <label>Description:</label>
                <input type="text" name="description" value="${editVaccine.description}" required>
                <label>Price:</label>
                <input type="number" step="0.01" name="price" value="${editVaccine.price}" required>
                <label>Duration:</label>
                <input type="number" name="duration" value="${editVaccine.duration_minutes}" required>
                <label>Category:</label>
                <select name="category">
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat}" ${editVaccine.category == cat ? 'selected' : ''}>${cat}</option>
                    </c:forEach>
                </select>
                <button type="submit">${editVaccine.id == null ? 'Add' : 'Update'}</button>
            </form>
        </div>

        <!-- Danh sách vaccine -->
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Price</th>
                    <th>Duration</th>
                    <th>Category</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="vaccine" items="${vaccines}">
                    <tr>
                        <td>${vaccine.id}</td>
                        <td>${vaccine.name}</td>
                        <td>${vaccine.description}</td>
                        <td>${vaccine.price}</td>
                        <td>${vaccine.duration_minutes}</td>
                        <td>${vaccine.category}</td>
                        <td>
                            <a href="VaccinePackage?action=edit&id=${vaccine.id}">Edit</a> |
                            <a href="VaccinePackage?action=delete&id=${vaccine.id}" onclick="return confirm('Are you sure?')">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    <jsp:include page="Footer.jsp"/>

    </body>
</html>
