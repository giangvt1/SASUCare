<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>   
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Mange Doctors</title>
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    </head>
    <body class="skin-black">
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <div class="right-side">
            <h1 class="text-center text-bold mb-4" style="margin-bottom: 30px">Search doctors</h1>
            <form action="SearchDoctor" method="get" class="searchForm">
                <div class="filter-container">
                    <div class="filter-item" style="width: 92%">
                        <span>Full name</span>
                        <div class="search-input">
                            <input type="text" name="doctorName" placeholder="Search doctor name..." value="${param.doctorName}" onchange="this.form.submit()"/>
                        </div>
                    </div>
                    <div class="filter-item">
                        <span>Date of birth</span>
                        <input type="date" name="doctorDate" class="date" value="${param.doctorDate}" onchange="this.form.submit()" />
                    </div>

                    <div class="filter-item">
                        <span>Gender</span>
                        <select name="doctorGender" onchange="this.form.submit()">
                            <option value="" ${empty param.doctorGender ? 'selected' : ''}>All</option>
                            <option value="male" ${param.doctorGender == 'male' ? 'selected' : ''}>Male</option>
                            <option value="female" ${param.doctorGender == 'female' ? 'selected' : ''}>Female</option>
                        </select>
                    </div>

                    <div class="filter-item">
                        <span>Sort</span>
                        <select name="sort" id="sort" onchange="this.form.submit()">
                            <option value="default" ${empty param.sort == 'default' ? 'selected' : ''}>Default</option>
                            <option value="fullNameAZ" ${param.sort == 'fullNameAZ' ? 'selected' : ''}>Full name A-Z</option>
                            <option value="fullNameZA" ${param.sort == 'fullNameZA' ? 'selected' : ''}>Full name Z-A</option>
                            <option value="DOBLTH" ${param.sort == 'DOBLTH' ? 'selected' : ''}>DOB low to high</option>
                            <option value="DOBHTL" ${param.sort == 'DOBHTL' ? 'selected' : ''}>DOB high to low</option>
                        </select>
                    </div>

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
                <div class="submit-container">
                    <button type="submit" class="back-btn">Search</button>
                </div>
            </form>
            <div class="table-data mt-4">
                <table class="table" style="width:95%">
                    <h3 class="title">Doctor list</h3>
                    <thead>
                        <tr><th>#</th>
                            <th>Full Name</th>
                            <th>Gender</th>
                            <th>Date of Birth</th>
                            <th>Email</th>
                            <th>Address</th>
                            <th>Medical consultation</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="d" items="${doctors}" varStatus="i">
                            <tr><td class="index">${i.index + 1}</td>
                                <td>${d.name}</td>
                                <td>${d.gender?"Male":"Female"}</td>
                                <td><fmt:formatDate value="${d.dob}" pattern="dd/MM/yyyy"/></td>
                                <td>${d.email}</td>
                                <td>${d.address}</td>
                                <td><a href="DoctorMedicalConsultation?doctorId=${d.id}">View</a></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div class="pre-next-Btn">
                    <!-- Nút Previous -->
                    <c:if test="${currentPage > 1}">
                        <a class="page-link" href="SearchDoctor?page=${currentPage - 1}&doctorName=${param.doctorName}&doctorDate=${param.doctorDate}&doctorGender=${param.doctorGender}&sort=${param.sort}&size=${param.size}">Previous</a>
                    </c:if>
                    <!-- Phần phân trang -->
                    <div class="page-link-container">
                        <c:choose>
                            <c:when test="${totalPages <= 5}">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <a class="page-link ${i == currentPage ? 'active' : ''}" href="SearchDoctor?page=${i}&doctorName=${param.doctorName}&doctorDate=${param.doctorDate}&doctorGender=${param.doctorGender}&sort=${param.sort}&size=${param.size}">${i}</a>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <a class="page-link ${currentPage == 1 ? 'active' : ''}" href="SearchDoctor?page=1&doctorName=${param.doctorName}&doctorDate=${param.doctorDate}&doctorGender=${param.doctorGender}&sort=${param.sort}&size=${param.size}">1</a>
                                <c:if test="${currentPage > 2}">
                                    <span class="page-link">...</span>
                                </c:if>

                                <c:forEach begin="${currentPage - 1}" end="${currentPage + 1}" var="i">
                                    <c:if test="${i > 1 && i < totalPages}">
                                        <a class="page-link ${i == currentPage ? 'active' : ''}" href="SearchDoctor?page=${i}&doctorName=${param.doctorName}&doctorDate=${param.doctorDate}&doctorGender=${param.doctorGender}&sort=${param.sort}&size=${param.size}">${i}</a>
                                    </c:if>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages - 2}">
                                    <span class="page-link">...</span>
                                </c:if>
                                <a class="page-link ${currentPage == totalPages ? 'active' : ''}" href="SearchDoctor?page=${totalPages}&doctorName=${param.doctorName}&doctorDate=${param.doctorDate}&doctorGender=${param.doctorGender}&sort=${param.sort}&size=${param.size}">${totalPages}</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <!-- Nút Next -->
                    <c:if test="${currentPage < totalPages}">
                        <a class="page-link" href="SearchDoctor?page=${currentPage + 1}&doctorName=${param.doctorName}&doctorDate=${param.doctorDate}&doctorGender=${param.doctorGender}&sort=${param.sort}&size=${param.size}">Next</a>
                    </c:if>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <script src="https://npmcdn.com/flatpickr/dist/l10n/vn.js"></script>
        <script src="../js/doctor/doctor.js"></script>
    </body>
</html>
