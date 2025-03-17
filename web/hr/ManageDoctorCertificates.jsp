<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>List doctor certificates</title>
    </head>
    <body class="skin-black">
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
        <div class="right-side">
            <style>
                .filter-item {
                    width: 46%;
                }
            </style>
            <h2 class="mb-3 text-center title">List doctor certificates</h2>
            <form action="ManageDoctorCertificates" method="get" class="searchForm">
                <input type="hidden" name="staffId" value="${sessionScope.staff.id}" />
                <div  class="row d-flex justify-content-center">
                    <div class="filter-container">
                        <div class="filter-item" style="width: 94%">
                            <span>Certificate name</span>
                            <div class="search-input">
                                <input type="text" name="certificateName" placeholder="Search certificate name..." value="${param.certificateName}" onchange="this.form.submit()"/>
                            </div>
                        </div>
                        <div class="filter-item" style="width: 94%">
                            <span>Doctor name</span>
                            <div class="search-input">
                                <input type="text" name="doctorName" placeholder="Search doctor name..." value="${param.doctorName}" onchange="this.form.submit()"/>
                            </div>
                        </div>
                        <div class="filter-item">
                            <span for="typeName">Type name</span>
                            <select name="typeName" id="typeName" onchange="this.form.submit()">
                                <option value="" ${empty param.typeName ? 'selected' : ''}>All</option>
                                <c:forEach var="type" items="${typeList}">
                                    <option value="${type.name}" ${param.typeName == type.name ? 'selected' : ''}>${type.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <!-- Status -->
                        <div class="filter-item">
                            <span for="status">Status</span>
                            <select name="status" id="status" onchange="this.form.submit()">
                                <option value="" ${empty param.status ? 'selected' : ''}>All</option>
                                <option value="Pending" ${param.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                <option value="Approved" ${param.status == 'Approved' ? 'selected' : ''}>Approved</option>
                                <option value="Rejected" ${param.status == 'Rejected' ? 'selected' : ''}>Rejected</option>
                            </select>
                        </div>

                        <!-- Sort -->
                        <div class="filter-item">
                            <span for="status">Sort</span>
                            <select name="sort" id="sort" onchange="this.form.submit()">
                                <option value="default" ${empty param.sort == 'default' ? 'selected' : ''}>Default</option>
                                <option value="certificateNameAZ" ${param.sort == 'certificateNameAZ' ? 'selected' : ''}>Certificate name A-Z</option>
                                <option value="certificateNameZA" ${param.sort == 'certificateNameZA' ? 'selected' : ''}>Certificate name Z-A</option>
                                <option value="IDOTN" ${param.sort == 'IDOTN' ? 'selected' : ''}>Issue date oldest to newest</option>
                                <option value="IDNTO" ${param.sort == 'IDNTO' ? 'selected' : ''}>Issue date newest to oldest</option>
                                <option value="EDOTN" ${param.sort == 'EDOTN' ? 'selected' : ''}>Expiration date oldest to newest</option>
                                <option value="EDNTO" ${param.sort == 'EDNTO' ? 'selected' : ''}>Expiration date newest to oldest</option>
                            </select>
                        </div>
                        <!-- Size -->
                        <div class="filter-item">
                            <span for="size">Sise each table</span>
                            <select name="size" id="size" onchange="this.form.submit()">
                                <option value="10" ${param.size == '10' ? 'selected' : ''}>10</option>
                                <option value="5" ${param.size == '5' ? 'selected' : ''}>5</option>
                                <option value="20" ${param.size == '20' ? 'selected' : ''}>20</option>
                                <option value="100" ${param.size == '100' ? 'selected' : ''}>100</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="submit-container">
                    <button type="submit" class="back-btn">Search</button>
                </div>
            </form>
            <div class="table-data mt-4">
                <div style="margin-bottom: 30px"></div>
                <table class="table" style="width: 95%; color: black">
                    <thead>
                        <tr style="background-color: #007bff">
                            <th>#</th>
                            <th>Doctor ID</th>
                            <th>Doctor name</th>
                            <th>Certificate name</th>
                            <th>Type name</th>
                            <th>Issue date</th>
                            <th>Status</th>
                            <th>Check note</th>
                            <th>Document path</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${certificates}" varStatus="i">
                            <tr><td class="index">${i.index + 1}</td>
                                <td>${c.doctorId}</td>
                                <td>${c.doctorName}</td>
                                <td>${c.certificateName}</td>
                                <td>${c.typeName}</td>
                                <td><fmt:formatDate value="${c.issueDate}" pattern="dd/MM/yyyy" /></td>
                                <td>${c.status}</td>
                                <td>${c.checkNote}</td>
                                <td><a href="${c.documentPath}" target="_blank">View</td>
                                <td> <c:if test="${fn:toLowerCase(c.status) == 'pending'}">
                                        <a style="display: block;width: 110px;margin: 0" class="add-btn" href="EditDoctorCertificate?certificateId=${c.certificateId}&status=Approved">Approved</a>
                                        <a style="display: block;width: 110px" class="delete-btn" href="EditDoctorCertificate?certificateId=${c.certificateId}&cer&status=Rejected">Rejected</a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>    
                    </tbody>
                </table>
                <div class="pre-next-Btn">
                    <!-- Nút Previous -->
                    <c:if test="${currentPage > 1}">
                        <a class="page-link" href="ManageDoctorCertificates?staffId=${sessionScope.staff.id}&certificateName=${param.certificateName}&doctorName=${param.doctorName}&typeName=${param.typeName}&page=${currentPage - 1}&status=${param.status}&sort=${param.sort}&size=${param.size}">Previous</a>
                    </c:if>
                    <!-- Phần phân trang -->
                    <div class="page-link-container">
                        <c:choose>
                            <c:when test="${totalPages <= 5}">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <a class="page-link ${i == currentPage ? 'active' : ''}" href="ManageDoctorCertificates?staffId=${sessionScope.staff.id}&certificateName=${param.certificateName}&doctorName=${param.doctorName}&typeName=${param.typeName}&page=${i}&status=${param.status}&sort=${param.sort}&size=${param.size}">${i}</a>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <a class="page-link ${currentPage == 1 ? 'active' : ''}" href="ManageDoctorCertificates?staffId=${sessionScope.staff.id}&certificateName=${param.certificateName}&doctorName=${param.doctorName}&typeName=${param.typeName}&page=1&status=${param.status}&sort=${param.sort}&size=${param.size}">1</a>
                                <c:if test="${currentPage > 2}">
                                    <span class="page-link">...</span>
                                </c:if>

                                <c:forEach begin="${currentPage - 1}" end="${currentPage + 1}" var="i">
                                    <c:if test="${i > 1 && i < totalPages}">
                                        <a class="page-link ${i == currentPage ? 'active' : ''}" href="ManageDoctorCertificates?staffId=${sessionScope.staff.id}&certificateName=${param.certificateName}&doctorName=${param.doctorName}&typeName=${param.typeName}&page=${i}&status=${param.status}&sort=${param.sort}&size=${param.size}">${i}</a>
                                    </c:if>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages - 2}">
                                    <span class="page-link">...</span>
                                </c:if>
                                <a class="page-link ${currentPage == totalPages ? 'active' : ''}" href="ManageDoctorCertificates?staffId=${sessionScope.staff.id}&certificateName=${param.certificateName}&doctorName=${param.doctorName}&typeName=${param.typeName}&page=${totalPages}&status=${param.status}&sort=${param.sort}&size=${param.size}">${totalPages}</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <!-- Nút Next -->
                    <c:if test="${currentPage < totalPages}">
                        <a class="page-link" href="ManageDoctorCertificates?staffId=${sessionScope.staff.id}&certificateName=${param.certificateName}&doctorName=${param.doctorName}&typeName=${param.typeName}&page=${currentPage + 1}&status=${param.status}&sort=${param.sort}&size=${param.size}">Next</a>
                    </c:if>
                </div>
            </div>
        </div>

    </body>
</html>
