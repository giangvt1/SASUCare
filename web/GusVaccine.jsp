<%-- 
    Document   : GusVaccine
    Created on : Feb 20, 2025, 7:10:04 AM
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
        <h2>Vaccine Packages</h2>
        <div class="container">
    
    <form action="VaccinePackage" method="get">
        <input type="text" name="keyword" placeholder="Nhập từ khóa..." value="${param.keyword}">

    
    <select name="category">
        <option value="all">Tất cả danh mục</option>
        <c:forEach var="cat" items="${categories}">
            <option value="${cat}" ${param.category == cat ? 'selected' : ''}>${cat}</option>
        </c:forEach>
    </select>

    <button type="submit">Tìm kiếm</button>
    </form>

    <table border="1">
        <thead>
            <tr>
                <th>Id</th>
                <th>Name</th>
                <th>Description</th>
                <th>Price</th>
                <th>Duration</th>
                <th>Category</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="vaccine" items="${vaccines}">
                <tr>
                    <td>${vaccine.id}</td>
                    <td><a href="packageDetail.jsp?vaccineId=${vaccine.id}">${vaccine.name}</a></td>
                    
                    <td>${vaccine.description}</td>
                    <td>${vaccine.price}</td>
                    <td>${vaccine.duration_minutes}</td>
                    <td>${vaccine.category}</td>
                    <td>
                        <a href="bookAppointment?vaccineId=${vaccine.id}">Đặt lịch</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
        
    </table>
        </div>
        <jsp:include page="Footer.jsp"></jsp:include>
    </body>
</html>
