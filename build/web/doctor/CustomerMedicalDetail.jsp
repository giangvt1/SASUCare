<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>   
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Customer Medical Detail</title>
        <link href="../css/admin/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <!-- font Awesome -->
        <link href="../css/admin/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/admin/styleAdmin.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
    </head>
    <body class="skin-black"">
        <jsp:include page="../admin/AdminHeader.jsp"></jsp:include>
        <jsp:include page="../admin/AdminLeftSideBar.jsp"></jsp:include>
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
                                <th>Full Name</th>
                                <th>Gender</th>
                                <th>Date of Birth</th>
                                <th>Phone Number</th>   
                                <th>Address</th>
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
                <h3 class="title">Medical History</h3>
                <a class="add-btn" href="EditCustomerMedicalHistory.jsp?cId=${customer.id}">Add record</a>
                <a class="export-btn" href="MedicalHistoryExportServlet?cId=${customer.id}&pageMedical=${currentMedicalPage}&sizeMedical=${param.sizeMedical}">Export to excel</a>

                <form style="margin: 0" action="ShowCustomerMedicalDetail" method="get" class="sidebar-form" id="searchCustomerForm">
                    <input type="hidden" name="cId" value="${customer.id}" />
                    <div style="display: flex; justify-content: start; margin-left: 2.5%; margin-top: 20px; gap: 0;" class="filter-container">
                        <div class="filter-item">
                            <span>Size each table</span>
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
                            <th>Name</th>
                            <th>Detail</th>
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
                        <a class="page-link" href="ShowCustomerMedicalDetail?pageMedical=${currentMedicalPage - 1}&cId=${customer.id}&sizeMedical=${param.sizeMedical}">Previous</a>
                    </c:if>

                    <!-- Số trang -->
                    <div class="page-link-container">
                        <c:choose>
                            <c:when test="${totalMedicalPages <= 5}">
                                <c:forEach begin="1" end="${totalMedicalPages}" var="i">
                                    <a class="page-link ${i == currentMedicalPage ? 'active' : ''}" href="ShowCustomerMedicalDetail?pageMedical=${i}&cId=${customer.id}&sizeMedical=${param.sizeMedical}">${i}</a>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <a class="page-link ${currentMedicalPage == 1 ? 'active' : ''}" href="ShowCustomerMedicalDetail?pageMedical=1&cId=${customer.id}&sizeMedical=${param.sizeMedical}">1</a>
                                <c:if test="${currentMedicalPage > 2}">
                                    <span>...</span>
                                </c:if>
                                <c:forEach begin="${currentMedicalPage - 1}" end="${currentMedicalPage + 1}" var="i">
                                    <c:if test="${i > 1 && i < totalMedicalPages}">
                                        <a class="page-link ${i == currentMedicalPage ? 'active' : ''}" href="ShowCustomerMedicalDetail?pageMedical=${i}&cId=${customer.id}&sizeMedical=${param.sizeMedical}">${i}</a>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${currentMedicalPage < totalMedicalPages - 2}">
                                    <span>...</span>
                                </c:if>
                                <a class="page-link ${currentMedicalPage == totalMedicalPages ? 'active' : ''}" href="ShowCustomerMedicalDetail?pageMedical=${totalMedicalPages}&cId=${customer.id}&sizeMedical=${param.sizeMedical}">${totalMedicalPages}</a>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Nút Next -->
                    <c:if test="${currentMedicalPage < totalMedicalPages}">
                        <a class="page-link" href="ShowCustomerMedicalDetail?pageMedical=${currentMedicalPage + 1}&cId=${customer.id}&sizeMedical=${param.sizeMedical}">Next</a>
                    </c:if>
                </div>
            </div>

            <!--hien visitHistory-->
            <div class="table-data mt-4">
                <h3 class="title">Visit History</h3>
                <a class="add-btn" href="EditCustomerVisitHistory.jsp?cId=${customer.id}">Add record</a>
                <a class="export-btn" href="VisitHistoryExportServlet?cId=${customer.id}&pageVisit=${currentVisitPage}&sizeVisit=${param.sizeVisit}">Export to excel</a>
                <form style="margin: 0" action="ShowCustomerMedicalDetail" method="get" class="sidebar-form" id="searchCustomerForm">
                    <input type="hidden" name="cId" value="${customer.id}" />
                    <div style="display: flex; justify-content: start; margin-left: 2.5%; margin-top: 20px; gap: 0;" class="filter-container">
                        <div class="filter-item">
                            <span>Size each table</span>
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
                            <th>Visit Date</th>
                            <th>Reason For Visit</th>
                            <th>Diagnoses</th>
                            <th>Treatment Plan</th>
                            <th>Next Appointment</th>
                            <th>Action</th>
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
                                <td><fmt:formatDate value="${v.nextAppointment}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                                <td>
                                    <a href="EditCustomerVisitHistory.jsp?cId=${customer.id}
                                       &id=${v.id}
                                       &visitDate=${URLEncoder.encode(v.visitDate.toString(), 'UTF-8')}
                                       &reasonForVisit=${URLEncoder.encode(v.reasonForVisit, 'UTF-8')}
                                       &diagnoses=${URLEncoder.encode(v.diagnoses, 'UTF-8')}
                                       &treatmentPlan=${URLEncoder.encode(v.treatmentPlan, 'UTF-8')}
                                       &nextAppointment=${URLEncoder.encode(v.nextAppointment.toString(), 'UTF-8')}">
                                        <button type="button">Update</button>
                                    </a> 
                                    /
                                    <a href="#" onclick="doDelete(${v.id}, 'DeleteCustomerVisitHistory', '${customer.id}')">
                                        <button type="button">Delete</button>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- Phân trang -->
                <div class="pre-next-Btn">
                    <!-- Nút Previous -->
                    <c:if test="${currentVisitPage > 1}">
                        <a class="page-link" href="ShowCustomerMedicalDetail?pageVisit=${currentVisitPage - 1}&cId=${customer.id}&sizeVisit=${param.sizeVisit}">Previous</a>
                    </c:if>

                    <!-- Số trang -->
                    <div class="page-link-container">
                        <c:choose>
                            <c:when test="${totalVisitPages <= 5}">
                                <c:forEach begin="1" end="${totalVisitPages}" var="i">
                                    <a class="page-link ${i == currentVisitPage ? 'active' : ''}" href="ShowCustomerMedicalDetail?pageVisit=${i}&cId=${customer.id}&sizeVisit=${param.sizeVisit}">${i}</a>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <a class="page-link ${currentVisitPage == 1 ? 'active' : ''}" href="ShowCustomerMedicalDetail?pageVisit=1&cId=${customer.id}&sizeVisit=${param.sizeVisit}">1</a>
                                <c:if test="${currentVisitPage > 2}">
                                    <span>...</span>
                                </c:if>
                                <c:forEach begin="${currentVisitPage - 1}" end="${currentVisitPage + 1}" var="i">
                                    <c:if test="${i > 1 && i < totalVisitPages}">
                                        <a class="page-link ${i == currentVisitPage ? 'active' : ''}" href="ShowCustomerMedicalDetail?pageVisit=${i}&cId=${customer.id}&sizeVisit=${param.sizeVisit}">${i}</a>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${currentVisitPage < totalVisitPages - 2}">
                                    <span>...</span>
                                </c:if>
                                <a class="page-link ${currentVisitPage == totalVisitPages ? 'active' : ''}" href="ShowCustomerMedicalDetail?pageVisit=${totalVisitPages}&cId=${customer.id}&sizeVisit=${param.sizeVisit}">${totalVisitPages}</a>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Nút Next -->
                    <c:if test="${currentVisitPage < totalVisitPages}">
                        <a class="page-link" href="ShowCustomerMedicalDetail?pageVisit=${currentVisitPage + 1}&cId=${customer.id}&sizeVisit=${param.sizeVisit}">Next</a>
                    </c:if>
                </div>

            </div>
            <script>
                let hasNextPage = document.querySelector(".hasNextPage");
                console.log(hasNextPage.textContent);
                let pre = document.querySelector("#previousBtn");
                let next = document.querySelector("#nextBtn");
                let p = document.querySelector(".page-num"); // Lấy số trang

                // Kiểm tra xem trang hiện tại có phải là trang đầu tiên không
                if (p.textContent.trim() === "Page 1") {
                    pre.classList.add("disabled");  // Vô hiệu hóa nút Previous
                }
                if (p.textContent.trim() === "Page") {
                    pre.classList.add("disabled");  // Vô hiệu hóa nút Previous
                    next.classList.add("disabled");
                }
                // Kiểm tra số lượng chỉ số, nếu ít hơn 10 thì vô hiệu hóa nút Next
                if (hasNextPage.textContent.trim() === "false") {
                    next.classList.add("disabled");  // Vô hiệu hóa nút Next
                }
            </script>
            <!-- jQuery 2.0.2 -->
            <script src="../js/jquery.min.js" type="text/javascript"></script>
            <!-- Bootstrap -->
            <script src="../js/bootstrap.min.js" type="text/javascript"></script>
            <!-- Director App -->
            <script src="../js/Director/app.js" type="text/javascript"></script>
    </body>
    <script>
                document.querySelectorAll(".sidebar-menu > li").forEach((li) => {
                    li.classList.remove("active");
                });
                let manageMedical = document.querySelector(".manage-medical");
                manageMedical.classList.add("active");

                function doDelete(index, url, cId, id) {
                    if (confirm("Are you sure delete index: " + index + " ?"))
                    {
                        window.location = url + "?cId=" + cId + "&id=" + id;
                    }
                }
    </script>
</html>
