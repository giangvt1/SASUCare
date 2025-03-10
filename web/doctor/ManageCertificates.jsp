<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>   
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Certificates.jsp</title>
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
    </head>
    <body class="skin-black">
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <div class="right-side">
            <div class="table-data mt-4">
                <table class="table" style="width:95%">
                    <h3 class="title">Certificates list</h3>
                    <thead>
                        <tr><th>#</th>
                            <th>Certificate name</th>
                            <th>Type name</th>
                            <th>Issuing authority</th>
                            <th>Issue date</th>
                            <th>Expiration date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${certificates}" varStatus="i">
                            <tr><td class="index">${i.index + 1}</td>
                                <td>${c.certificateName}</td>
                                <td>${c.typeName}</td>
                                <td>${c.issuingAuthority}</td>
                                <td><fmt:formatDate value="${c.issueDate}" pattern="dd/MM/yyyy" /></td>
                                <td><fmt:formatDate value="${c.expirationDate}" pattern="dd/MM/yyyy" /></td>
                                <td>${c.status}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
