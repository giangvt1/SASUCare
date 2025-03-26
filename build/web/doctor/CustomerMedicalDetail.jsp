<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>   
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Customer Medical Detail</title>
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
    </head>
    <body class="skin-black"">
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <div class="right-side">
            <a class="back-btn" href="../doctor/SearchCustomer?page=1&sort=default&size=10">
                Back
            </a>
            <h1 class="text-center text-bold mb-4" style="margin-bottom: 30px">Medical Records Summary</h1>
            <div class="table-data mt-4">
                <h3 class="title">Customer Informations</h3>
                <table class="table" style="width:95%">
                    <thead>
                        <tr>
                            <th>Tên khách hàng</th>
                            <th>Giới tính</th>
                            <th>Ngày sinh</th>
                            <th>SĐT</th>   
                            <th>Địa chỉ</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>${customer.fullname}</td>
                            <td>${customer.gender?"Male":"Female"}</td>
                            <td><fmt:formatDate value="${customer.dob}" pattern="dd/MM/yyyy" /></td>
                            <td>${customer.phone_number}</td>
                            <td>${customer.address}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- Hiển thị lịch sử bệnh án -->
            <div class="table-data mt-4">
                <h3 class="title">Tiền sử bệnh án</h3>
                <c:if test="${not empty appointmentId}">
                    <a class="add-btn" href="EditCustomerMedicalHistory.jsp?customerId=${customer.id}&appointmentId=${appointmentId}">Thêm bản ghi</a>
                </c:if>
                <a class="export-btn" href="MedicalHistoryExportServlet?customerId=${customer.id}&pageMedical=${currentMedicalPage}&sizeMedical=${param.sizeMedical}">Xuất file excel</a>
                <a style="background-color: yellow" class="export-btn" href="MedicalHistoryExportPDFServlet?customerId=${customer.id}&pageMedical=${currentMedicalPage}&sizeMedical=${param.sizeMedical}">Xuất file pdf</a>
                <form style="margin: 0" action="ShowCustomerMedicalDetail" method="get" class="sidebar-form" id="searchCustomerForm">
                    <input type="hidden" name="customerId" value="${customer.id}" />
                    <div style="display: flex; justify-content: start; margin-left: 2.5%; margin-top: 20px; gap: 0;" class="filter-container">
                        <div class="filter-item">
                            <span>Số bản ghi mỗi bảng</span>
                            <select name="sizeMedical" id="sizeMedical" onchange="this.form.submit()">
                                <option value="10" ${param.sizeMedical == '10' ? 'selected' : ''}>10</option>
                                <option value="5" ${param.sizeMedical == '5' ? 'selected' : ''}>5</option>
                                <option value="20" ${param.sizeMedical == '20' ? 'selected' : ''}>20</option>
                                <option value="100" ${param.sizeMedical == '100' ? 'selected' : ''}>100</option>
                            </select>
                        </div>
                    </div>
                </form>

                <table class="table" style="width:95%">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Tên</th>
                            <th>Mô tả</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="m" items="${medicalHistory}" varStatus="status">
                            <tr>
                                <td class="index">${status.index + 1}</td>
                                <td>${m.name}</td>
                                <td>${m.detail}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- Phân trang -->
                <div class="pre-next-Btn">
                    <!-- Nút Previous -->
                    <c:if test="${currentMedicalPage > 1}">
                        <a class="page-link" href="ShowCustomerMedicalDetail?pageMedical=${currentMedicalPage - 1}&customerId=${customer.id}&sizeMedical=${param.sizeMedical}">Trước</a>
                    </c:if>

                    <!-- Số trang -->
                    <div class="page-link-container">
                        <c:choose>
                            <c:when test="${totalMedicalPages <= 5}">
                                <c:forEach begin="1" end="${totalMedicalPages}" var="i">
                                    <a class="page-link ${i == currentMedicalPage ? 'active' : ''}" href="ShowCustomerMedicalDetail?pageMedical=${i}&customerId=${customer.id}&sizeMedical=${param.sizeMedical}">${i}</a>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <a class="page-link ${currentMedicalPage == 1 ? 'active' : ''}" href="ShowCustomerMedicalDetail?pageMedical=1&customerId=${customer.id}&sizeMedical=${param.sizeMedical}">1</a>
                                <c:if test="${currentMedicalPage > 2}">
                                    <span>...</span>
                                </c:if>
                                <c:forEach begin="${currentMedicalPage - 1}" end="${currentMedicalPage + 1}" var="i">
                                    <c:if test="${i > 1 && i < totalMedicalPages}">
                                        <a class="page-link ${i == currentMedicalPage ? 'active' : ''}" href="ShowCustomerMedicalDetail?pageMedical=${i}&customerId=${customer.id}&sizeMedical=${param.sizeMedical}">${i}</a>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${currentMedicalPage < totalMedicalPages - 2}">
                                    <span>...</span>
                                </c:if>
                                <a class="page-link ${currentMedicalPage == totalMedicalPages ? 'active' : ''}" href="ShowCustomerMedicalDetail?pageMedical=${totalMedicalPages}&customerId=${customer.id}&sizeMedical=${param.sizeMedical}">${totalMedicalPages}</a>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Nút Next -->
                    <c:if test="${currentMedicalPage < totalMedicalPages}">
                        <a class="page-link" href="ShowCustomerMedicalDetail?pageMedical=${currentMedicalPage + 1}&customerId=${customer.id}&sizeMedical=${param.sizeMedical}">Sau</a>
                    </c:if>
                </div>
            </div>

            <!--hien visitHistory-->
            <div class="table-data mt-4">
                <h3 class="title">Lịch sử thăm khám</h3>
                <c:if test="${not empty appointmentId}">
                    <a class="add-btn" href="EditCustomerVisitHistory.jsp?customerId=${customer.id}&appointmentId=${appointmentId}">Thêm bản ghi</a>
                </c:if>
                <a class="export-btn" href="VisitHistoryExportServlet?customerId=${customer.id}&pageVisit=${currentVisitPage}&sizeVisit=${param.sizeVisit}">Xuất file excel</a>
                <a style="background-color: yellow" class="export-btn" href="VisitHistoryExportPDFServlet?customerId=${customer.id}&pageVisit=${currentVisitPage}&sizeVisit=${param.sizeVisit}">Xuất file pdf</a>
                <form style="margin: 0" action="ShowCustomerMedicalDetail" method="get" class="sidebar-form" id="searchCustomerForm">
                    <input type="hidden" name="customerId" value="${customer.id}" />
                    <div style="display: flex; justify-content: start; margin-left: 2.5%; margin-top: 20px; gap: 0;" class="filter-container">
                        <div class="filter-item">
                            <span>Số bản ghi mỗi bảng</span>
                            <select name="sizeVisit" id="sizeVisit" onchange="this.form.submit()">
                                <option value="10" ${param.sizeVisit == '10' ? 'selected' : ''}>10</option>
                                <option value="5" ${param.sizeVisit == '5' ? 'selected' : ''}>5</option>
                                <option value="20" ${param.sizeVisit == '20' ? 'selected' : ''}>20</option>
                                <option value="100" ${param.sizeVisit == '100' ? 'selected' : ''}>100</option>
                            </select>
                        </div>
                    </div>
                </form>

                <table class="table" style="width:95%">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Ngày thăm khám</th>
                            <th>Lý do</th>
                            <th>Chẩn đoán</th>
                            <th>Phác đồ điều chị</th>
                            <th>Ghi chú</th>
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
                                <td>${v.note}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- Phân trang -->
                <div class="pre-next-Btn">
                    <!-- Nút Previous -->
                    <c:if test="${currentVisitPage > 1}">
                        <a class="page-link" href="ShowCustomerMedicalDetail?pageVisit=${currentVisitPage - 1}&customerId=${customer.id}&sizeVisit=${param.sizeVisit}">Trước</a>
                    </c:if>

                    <!-- Số trang -->
                    <div class="page-link-container">
                        <c:choose>
                            <c:when test="${totalVisitPages <= 5}">
                                <c:forEach begin="1" end="${totalVisitPages}" var="i">
                                    <a class="page-link ${i == currentVisitPage ? 'active' : ''}" href="ShowCustomerMedicalDetail?pageVisit=${i}&customerId=${customer.id}&sizeVisit=${param.sizeVisit}">${i}</a>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <a class="page-link ${currentVisitPage == 1 ? 'active' : ''}" href="ShowCustomerMedicalDetail?pageVisit=1&customerId=${customer.id}&sizeVisit=${param.sizeVisit}">1</a>
                                <c:if test="${currentVisitPage > 2}">
                                    <span>...</span>
                                </c:if>
                                <c:forEach begin="${currentVisitPage - 1}" end="${currentVisitPage + 1}" var="i">
                                    <c:if test="${i > 1 && i < totalVisitPages}">
                                        <a class="page-link ${i == currentVisitPage ? 'active' : ''}" href="ShowCustomerMedicalDetail?pageVisit=${i}&customerId=${customer.id}&sizeVisit=${param.sizeVisit}">${i}</a>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${currentVisitPage < totalVisitPages - 2}">
                                    <span>...</span>
                                </c:if>
                                <a class="page-link ${currentVisitPage == totalVisitPages ? 'active' : ''}" href="ShowCustomerMedicalDetail?pageVisit=${totalVisitPages}&customerId=${customer.id}&sizeVisit=${param.sizeVisit}">${totalVisitPages}</a>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Nút Next -->
                    <c:if test="${currentVisitPage < totalVisitPages}">
                        <a class="page-link" href="ShowCustomerMedicalDetail?pageVisit=${currentVisitPage + 1}&customerId=${customer.id}&sizeVisit=${param.sizeVisit}">Sau</a>
                    </c:if>
                </div>

            </div>
    </body>
    <script>
        document.querySelectorAll(".sidebar-menu > li").forEach((li) => {
            li.classList.remove("active");
        });
        function doDelete(index, url, customerId, id) {
            if (confirm("Are you sure delete index: " + index + " ?"))
            {
                window.location = url + "?customerId=" + customerId + "&id=" + id;
            }
        }
    </script>
</html>
