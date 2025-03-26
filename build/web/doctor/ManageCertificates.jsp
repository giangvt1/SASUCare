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
            <form action="ManageCertificates" method="get" class="searchForm">
                <input type="hidden" name="staffId" value="${sessionScope.staff.id}" />
                <div class="filter-container">
                    <div class="filter-item" style="width: 92%">
                        <span>Certificate name</span>
                        <div class="search-input">
                            <input type="text" name="certificateName" placeholder="Search certificate name..." value="${param.certificateName}" onchange="this.form.submit()"/>
                        </div>
                    </div>
                    <div class="filter-item">
                        <span for="typeName">Type</span>
                        <select name="typeName" id="typeName" onchange="this.form.submit()">
                            <option value="" ${empty param.typeName ? 'selected' : ''}>All</option>
                            <c:forEach var="type" items="${typeList}">
                                <option value="${type.name}" ${param.typeName == type.name ? 'selected' : ''}>${type.name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="filter-item">
                        <span for="status">Status</span>
                        <select name="status" id="status" onchange="this.form.submit()">
                            <option value="" ${empty param.status ? 'selected' : ''}>All</option>
                            <option value="Pending" ${param.status == 'Pending' ? 'selected' : ''}>Pending</option>
                            <option value="Approved" ${param.status == 'Approved' ? 'selected' : ''}>Approved</option>
                            <option value="Rejected" ${param.status == 'Rejected' ? 'selected' : ''}>Rejected</option>
                        </select>
                    </div>

                    <div class="filter-item">
                        <span>Sort</span>
                        <select name="sort" id="sort" onchange="this.form.submit()">
                            <option value="default" ${empty param.sort == 'default' ? 'selected' : ''}>Default</option>
                            <option value="certificateNameAZ" ${param.sort == 'certificateNameAZ' ? 'selected' : ''}>	Certificate name A-Z</option>
                            <option value="certificateNameZA" ${param.sort == 'certificateNameZA' ? 'selected' : ''}>	Certificate name Z-A</option>
                            <option value="IDOTN" ${param.sort == 'IDOTN' ? 'selected' : ''}>Issue date oldest to newest</option>
                            <option value="IDNTO" ${param.sort == 'IDNTO' ? 'selected' : ''}>Issue date newest to oldest</option>
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
                <div style="margin-bottom: 30px"></div>
                <a class="add-btn" href="EditCertificate">Add certificate</a>
                <table class="table" style="width:95%">
                    <h3 class="title">Certificates list</h3>
                    <thead>
                        <tr><th>#</th>
                            <th>Tên chứng chỉ</th>
                            <th>Loại chứng chỉ</th>
                            <th>Ngày cấp</th>
                            <th>Trạng thái</th>
                            <th>Phản hồi</th>
                            <th>File</th>
                            <th>Đường dẫn</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${certificates}" varStatus="i">
                            <tr><td class="index">${i.index + 1}</td>
                                <td>${c.certificateName}</td>
                                <td>${c.typeName}</td>
                                <td><fmt:formatDate value="${c.issueDate}" pattern="dd/MM/yyyy" /></td>
                                <td>${c.status}</td>
                                <td>${c.checkNote}</td>
                                <td>
                                    <c:if test="${not empty c.file}">
                                        <a href="${pageContext.request.contextPath}/${c.file}" target="_blank">Xem</a>
                                    </c:if>
                                </td>
                                <td><a href="${c.documentPath}" target="_blank">View</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <div class="pre-next-Btn">
                    <!-- Nút Previous -->
                    <c:if test="${currentPage > 1}">
                        <a class="page-link" href="ManageCertificates?staffId=${sessionScope.staff.id}&page=${currentPage - 1}&certificateName=${param.certificateName}&typeName=${param.typeName}&status=${param.status}&sort=${param.sort}&size=${param.size}">Previous</a>
                    </c:if>
                    <div class="page-link-container">
                        <c:choose>
                            <c:when test="${totalPages <= 5}">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <a class="page-link ${i == currentPage ? 'active' : ''}" href="ManageCertificates?staffId=${sessionScope.staff.id}&page=${i}&certificateName=${param.certificateName}&typeName=${param.typeName}&status=${param.status}&sort=${param.sort}&size=${param.size}">${i}</a>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <a class="page-link ${currentPage == 1 ? 'active' : ''}" href="ManageCertificates?staffId=${sessionScope.staff.id}&page=1&certificateName=${param.certificateName}&typeName=${param.typeName}&status=${param.status}&sort=${param.sort}&size=${param.size}">1</a>
                                <c:if test="${currentPage > 2}">
                                    <span class="page-link">...</span>
                                </c:if>

                                <c:forEach begin="${currentPage - 1}" end="${currentPage + 1}" var="i">
                                    <c:if test="${i > 1 && i < totalPages}">
                                        <a class="page-link ${i == currentPage ? 'active' : ''}" href="ManageCertificates?staffId=${sessionScope.staff.id}&page=${i}&certificateName=${param.certificateName}&typeName=${param.typeName}&status=${param.status}&sort=${param.sort}&size=${param.size}">${i}</a>
                                    </c:if>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages - 2}">
                                    <span class="page-link">...</span>
                                </c:if>
                                <a class="page-link ${currentPage == totalPages ? 'active' : ''}" href="ManageCertificates?staffId=${sessionScope.staff.id}&page=${totalPages}&certificateName=${param.certificateName}&typeName=${param.typeName}&status=${param.status}&sort=${param.sort}&size=${param.size}">${totalPages}</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <!-- Nút Next -->
                    <c:if test="${currentPage < totalPages}">
                        <a class="page-link" href="ManageCertificates?staffId=${sessionScope.staff.id}&page=${currentPage + 1}&certificateName=${param.certificateName}&typeName=${param.typeName}&status=${param.status}&sort=${param.sort}&size=${param.size}">Next</a>
                    </c:if>
                </div>
            </div>
        </div>
    </body>
</html>
