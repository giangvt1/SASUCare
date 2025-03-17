<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>   
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Doctor Medical Consultation</title>
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
    </head>
    <body class="skin-black"">
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <div class="right-side">
            <a class="back-btn" href="../admin/SearchDoctor?page=1&sort=default&size=10">
                Back
            </a>
            <h1 class="text-center text-bold mb-4" style="margin-bottom: 30px">Medical Records Summary</h1>
            <div class="table-data mt-4">
                <h3 class="title">Doctor Informations</h3>
                <table class="table" style="width:95%">
                    <thead>
                        <tr>
                            <th>Full Name</th>
                            <th>Gender</th>
                            <th>Date of Birth</th>
                            <th>Email</th>   
                            <th>Address</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>${doctor.name}</td>
                            <td>${doctor.gender?"Male":"Female"}</td>
                            <td><fmt:formatDate value="${doctor.dob}" pattern="dd/MM/yyyy" /></td>
                            <td>${doctor.email}</td>
                            <td>${doctor.address}</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="table-data mt-4">
                <h3 class="title">Medical Consultation</h3>
                <form style="margin: 0" action="DoctorMedicalConsultation" method="get" class="sidebar-form" id="searchdoctorForm">
                    <input type="hidden" name="doctorId" value="${doctor.id}" />
                    <div style="display: flex; justify-content: start; margin-left: 2.5%; margin-top: 20px; gap: 0;" class="filter-container">
                        <div class="filter-item">
                            <span>Size each table</span>
                            <select name="size" id="size" onchange="this.form.submit()">
                                <option value="10" ${param.size == '10' ? 'selected' : ''}>10</option>
                                <option value="5" ${param.size == '5' ? 'selected' : ''}>5</option>
                                <option value="20" ${param.size == '20' ? 'selected' : ''}>20</option>
                                <option value="100" ${param.size == '100' ? 'selected' : ''}>100</option>
                            </select>
                        </div>
                    </div>
                </form>

                <table class="table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Visit Date</th>
                            <th>Reason For Visit</th>
                            <th>Diagnoses</th>
                            <th>Treatment Plan</th>
                            <th>Customer name</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="v" items="${visitHistoryList}" varStatus="status">
                            <tr>
                                <td class="index">${status.index + 1}</td>
                                <td><fmt:formatDate value="${v.visitDate}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                                <td>${v.reasonForVisit}</td>
                                <td>${v.diagnoses}</td>
                                <td>${v.treatmentPlan}</td>
                                <td>${v.customerName}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- Phân trang -->
                <div class="pre-next-Btn">
                    <!-- Nút Previous -->
                    <c:if test="${page > 1}">
                        <a class="page-link" href="DoctorMedicalConsultation?page=${page - 1}&doctorId=${doctor.id}&size=${param.size}">Previous</a>
                    </c:if>

                    <!-- Số trang -->
                    <div class="page-link-container">
                        <c:choose>
                            <c:when test="${totalPages <= 5}">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <a class="page-link ${i == page ? 'active' : ''}" href="DoctorMedicalConsultation?page=${i}&doctorId=${doctor.id}&size=${param.size}">${i}</a>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <a class="page-link ${page == 1 ? 'active' : ''}" href="DoctorMedicalConsultation?page=1&doctorId=${doctor.id}&size=${param.size}">1</a>
                                <c:if test="${page > 2}">
                                    <span>...</span>
                                </c:if>
                                <c:forEach begin="${page - 1}" end="${page + 1}" var="i">
                                    <c:if test="${i > 1 && i < totalPages}">
                                        <a class="page-link ${i == page ? 'active' : ''}" href="DoctorMedicalConsultation?page=${i}&doctorId=${doctor.id}&size=${param.size}">${i}</a>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${page < totalages - 2}">
                                    <span>...</span>
                                </c:if>
                                <a class="page-link ${page == totalPages ? 'active' : ''}" href="DoctorMedicalConsultation?page=${totalVisitPages}&doctorId=${doctor.id}&size=${param.size}">${totalVisitPages}</a>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Nút Next -->
                    <c:if test="${page < totalPages}">
                        <a class="page-link" href="DoctorMedicalConsultation?page=${page + 1}&doctorId=${doctor.id}&size=${param.size}">Next</a>
                    </c:if>
                </div>

            </div>
    </body>

</html>
