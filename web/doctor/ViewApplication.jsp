<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>   
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>List Application</title>
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    </head>
    <body class="skin-black">
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <div class="right-side">
            <style>
                .filter-item {
                    width: 30%;
                }
            </style>
            <h2 class="mb-3 text-center title">Danh sách đơn</h2>
            <form action="ViewApplication" method="post" class="searchForm" id="searchForm">
                <div class="row d-flex justify-content-center">
                    <div class="filter-container">
                        <div class="filter-item">
                            <span for="typeName">Tên đơn</span>
                            <select name="name" id="name" onchange="this.form.submit()">
                                <option value="" ${empty param.name ? 'selected' : ''}>Tất cả</option>
                                <c:forEach var="type" items="${typeList}">
                                    <option value="${type.name}" ${param.name == type.name ? 'selected' : ''}>${type.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="filter-item">
                            <span for="dateSend">Ngày gửi</span>
                            <input type="date" class="form-control date" name="dateSend" value="${param.dateSend}" onchange="this.form.submit()" />
                        </div>

                        <div class="filter-item">
                            <span for="status">Trạng thái</span>
                            <select name="status" id="status" onchange="this.form.submit()">
                                <option value="" ${empty param.status ? 'selected' : ''}>Tất cả</option>
                                <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Chờ duyệt</option>
                                <option value="approved" ${param.status == 'approved' ? 'selected' : ''}>Đã duyệt</option>
                                <option value="rejected" ${param.status == 'rejected' ? 'selected' : ''}>Từ chối</option>
                            </select>
                        </div>

                        <div class="filter-item">
                            <span for="sort">Sắp xếp</span>
                            <select name="sort" id="sort" onchange="this.form.submit()">
                                <option value="default" ${param.sort == 'default' ? 'selected' : ''}>Mặc định</option>
                                <option value="dateLTH" ${param.sort == 'dateLTH' ? 'selected' : ''}>Ngày tăng dần</option>
                                <option value="dateHTL" ${param.sort == 'dateHTL' ? 'selected' : ''}>Ngày giảm dần</option>
                            </select>
                        </div>

                        <div class="filter-item">
                            <span for="size">Số lượng mỗi trang</span>
                            <select name="size" id="size" onchange="this.form.submit()">
                                <option value="10" ${param.size == '10' ? 'selected' : ''}>10</option>
                                <option value="5" ${param.size == '5' ? 'selected' : ''}>5</option>
                                <option value="20" ${param.size == '20' ? 'selected' : ''}>20</option>
                                <option value="100" ${param.size == '100' ? 'selected' : ''}>100</option>
                            </select>
                        </div>
                    </div>
                </div>

                <input type="hidden" name="page" id="pageInput">

                <div class="submit-container">
                    <button type="submit" class="back-btn">Tìm kiếm</button>
                </div>
            </form>

            <div class="table-data mt-4">
                <div style="margin-bottom: 30px"></div>
                <a class="add-btn" href="../doctor/SendApplication">Gửi đơn</a>
                <table class="table" style="width:95%">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Tên đơn</th>
                            <th>Ngày gửi</th>
                            <th>Lý do</th>
                            <th>Trạng thái</th>
                            <th>Phản hồi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="app" items="${applications}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td>${app.typeName}</td>
                                <td><fmt:formatDate value="${app.dateSend}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                                <td>${app.reason}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${fn:toLowerCase(app.status) == 'pending'}">Chờ duyệt</c:when>
                                        <c:when test="${fn:toLowerCase(app.status) == 'approved'}">Đã duyệt</c:when>
                                        <c:when test="${fn:toLowerCase(app.status) == 'rejected'}">Bị từ chối</c:when>
                                        <c:otherwise>Không xác định</c:otherwise>
                                    </c:choose>
                                </td>

                                <td>${app.reply}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <div class="pre-next-Btn">
                    <c:if test="${currentPage > 1}">
                        <button class="page-link" type="button" onclick="submitPage(${currentPage - 1})">Trước</button>
                    </c:if>

                    <div class="page-link-container">
                        <c:choose>
                            <c:when test="${totalPages <= 5}">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <button class="page-link ${i == currentPage ? 'active' : ''}" type="button" onclick="submitPage(${i})">${i}</button>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <button class="page-link ${currentPage == 1 ? 'active' : ''}" type="button" onclick="submitPage(1)">1</button>

                                <c:if test="${currentPage > 2}">
                                    <span class="page-link">...</span>
                                </c:if>

                                <c:forEach begin="${currentPage - 1}" end="${currentPage + 1}" var="i">
                                    <c:if test="${i > 1 && i < totalPages}">
                                        <button class="page-link ${i == currentPage ? 'active' : ''}" type="button" onclick="submitPage(${i})">${i}</button>
                                    </c:if>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages - 2}">
                                    <span class="page-link">...</span>
                                </c:if>

                                <button class="page-link ${currentPage == totalPages ? 'active' : ''}" type="button" onclick="submitPage(${totalPages})">${totalPages}</button>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <c:if test="${currentPage < totalPages}">
                        <button class="page-link" type="button" onclick="submitPage(${currentPage + 1})">Tiếp</button>
                    </c:if>
                </div>

            </div>
        </div>
        <script>
            function submitPage(page) {
                event.preventDefault();
                document.getElementById("pageInput").value = page;
                document.getElementById("searchForm").submit();
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <script src="https://npmcdn.com/flatpickr/dist/l10n/vn.js"></script>
        <script src="../js/doctor/doctor.js"></script>
    </body>
</html>
