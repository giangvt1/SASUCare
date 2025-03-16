<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>   
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Search Customer</title>
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    </head>
    <body class="skin-black">
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <div class="right-side">
            <h1 class="text-center text-bold mb-4" style="margin-bottom: 30px">Search customer</h1>
            <form action="SearchCustomer" method="get" class="searchForm">
                <div class="filter-container">
                    <div class="filter-item" style="width: 92%">
                        <span>Full name</span>
                        <div class="search-input">
                            <input type="text" name="customerName" placeholder="Search customer name..." value="${param.customerName}" onchange="this.form.submit()"/>
                        </div>
                    </div>
                    <div class="filter-item">
                        <span>Date of birth</span>
                        <input type="date" name="customerDate" class="date" value="${param.customerDate}" onchange="this.form.submit()" />
                    </div>

                    <div class="filter-item">
                        <span>Gender</span>
                        <select name="customerGender" onchange="this.form.submit()">
                            <option value="" ${empty param.customerGender ? 'selected' : ''}>All</option>
                            <option value="male" ${param.customerGender == 'male' ? 'selected' : ''}>Male</option>
                            <option value="female" ${param.customerGender == 'female' ? 'selected' : ''}>Female</option>
                        </select>
                    </div>

                    <div class="filter-item">
                        <span>Sort</span>
                        <select name="sort" id="sort" onchange="this.form.submit()">
                            <option value="default" ${empty param.sort == 'default' ? 'selected' : ''}>Default</option>
                            <option value="fullNameAZ" ${param.sort == 'fullNameAZ' ? 'selected' : ''}>Full name A-Z</option>
                            <option value="fullNameZA" ${param.sort == 'fullNameZA' ? 'selected' : ''}>Full name Z-A</option>
                            <option value="DOBLTH" ${param.sort == 'fullDOBLTH' ? 'selected' : ''}>DOB low to high</option>
                            <option value="DOBHTL" ${param.sort == 'fullDOBHTL' ? 'selected' : ''}>DOB high to low</option>
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
                    <h3 class="title">Customer Results</h3>
                    <thead>
                        <tr><th>#</th>
                            <th>Full Name</th>
                            <th>Gender</th>
                            <th>Date of Birth</th>
                            <th>Phone Number</th>
                            <th>Address</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${customers}" varStatus="i">
                            <tr><td class="index">${i.index + 1}</td>
                                <td><a href="ShowCustomerMedicalDetail?cId=${c.id}">${c.fullname}</a></td>
                                <td>${c.gender?"Male":"Female"}</td>
                                <td><fmt:formatDate value="${c.dob}" pattern="dd/MM/yyyy" /></td>
                                <td>${c.phone_number}</td>
                                <td>${c.address}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div class="pre-next-Btn">
                    <!-- Nút Previous -->
                    <c:if test="${currentPage > 1}">
                        <a class="page-link" href="SearchCustomer?page=${currentPage - 1}&customerName=${param.customerName}&customerDate=${param.customerDate}&customerGender=${param.customerGender}&sort=${param.sort}&size=${param.size}">Previous</a>
                    </c:if>
                    <!-- Phần phân trang -->
                    <div class="page-link-container">
                        <c:choose>
                            <c:when test="${totalPages <= 5}">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <a class="page-link ${i == currentPage ? 'active' : ''}" href="SearchCustomer?page=${i}&customerName=${param.customerName}&customerDate=${param.customerDate}&customerGender=${param.customerGender}&sort=${param.sort}&size=${param.size}">${i}</a>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <a class="page-link ${currentPage == 1 ? 'active' : ''}" href="SearchCustomer?page=1&customerName=${param.customerName}&customerDate=${param.customerDate}&customerGender=${param.customerGender}&sort=${param.sort}&size=${param.size}">1</a>
                                <c:if test="${currentPage > 2}">
                                    <span class="page-link">...</span>
                                </c:if>

                                <c:forEach begin="${currentPage - 1}" end="${currentPage + 1}" var="i">
                                    <c:if test="${i > 1 && i < totalPages}">
                                        <a class="page-link ${i == currentPage ? 'active' : ''}" href="SearchCustomer?page=${i}&customerName=${param.customerName}&customerDate=${param.customerDate}&customerGender=${param.customerGender}&sort=${param.sort}&size=${param.size}">${i}</a>
                                    </c:if>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages - 2}">
                                    <span class="page-link">...</span>
                                </c:if>
                                <a class="page-link ${currentPage == totalPages ? 'active' : ''}" href="SearchCustomer?page=${totalPages}&customerName=${param.customerName}&customerDate=${param.customerDate}&customerGender=${param.customerGender}&sort=${param.sort}&size=${param.size}">${totalPages}</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <!-- Nút Next -->
                    <c:if test="${currentPage < totalPages}">
                        <a class="page-link" href="SearchCustomer?page=${currentPage + 1}&customerName=${param.customerName}&customerDate=${param.customerDate}&customerGender=${param.customerGender}&sort=${param.sort}&size=${param.size}">Next</a>
                    </c:if>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <script src="https://npmcdn.com/flatpickr/dist/l10n/vn.js"></script>
        <script src="../js/doctor/doctor.js"></script>
    </body>
</html>
