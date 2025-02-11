<%-- 
    Document   : CustomerMedicalDetail
    Created on : 27 thg 1, 2025, 19:23:49
    Author     : TRUNG
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <link rel="stylesheet" href="../css/doctor/customer_medical_detail_style.css"/>
    </head>
    <body class="skin-black"">
        <jsp:include page="../admin/AdminHeader.jsp"></jsp:include>
        <jsp:include page="../admin/AdminLeftSideBar.jsp"></jsp:include>
            <div class="right-side">
                <h1 class="text-center text-bold mb-4" style="margin-bottom: 30px;margin-top: 70px">Medical Records Summary</h1>
                <!--hien thong tin khach hang-->
                <h3 style="margin-left: 10px">Customer Informations</h3>
                <table class="table">
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
                        <td>${customer.dob}</td>
                        <td>${customer.phone_number}</td>
                        <td>${customer.address}</td>
                    </tr>
                </tbody>
            </table>
            <!--hien lich su benh an-->
            <h3 style="margin-left: 10px">Medical History</h3> 
            <a style="margin-left: 10px; font-size: 24px;" class="add-medical-history"
               href="CreateCustomerMedicalHistory?cid=${customer.id}">
                add
            </a>
            <table class="table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Detail</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="m" items="${medicalHistory}" varStatus="status">
                        <tr>
                        <tr><td class="index">${status.index + 1}</td>
                            <td>${m.name}</td>
                            <td>${m.detail}</td>
                            <td><a href="UpdateCustomerMedicalHistory?cid=${customer.id}&id=${m.id}&name=${m.name}&detail=${m.detail}"><button type="button">Update</button>
                                </a>/
                                <a href="#" onclick="doDelete(${status.index + 1}, 'DeleteCustomerMedicalHistory', '${customer.id}', '${m.id}')">
                                    <button type="button">Delete</button>
                                </a></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <!--hien visitHistory-->
            <h3 style="margin-left: 10px">Visit History</h3>
            <a style="margin-left: 10px; font-size: 24px;" class="add-visit-history"
               href="CreateCustomerVisitHistory?cid=${customer.id}">
                add
            </a>
            <table class="table">
                <thead>
                    <tr><th>#</th>
                        <th>Visit Date</th>
                        <th>Reason For Visit</th>
                        <th>Diagnoses</th>
                        <th>Treatment Plan</th>
                        <th>Next Appointment</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <div class="hasNextPage" hidden>${hasNextPage}</div>
                <c:forEach var="v" items="${visitHistoryList}" varStatus="status">
                    <tr><td class="index">${status.index + 1}</td>
                        <td>${v.visitDate}</td>
                        <td>${v.reasonForVisit}</td>
                        <td>${v.diagnoses}</td>
                        <td>${v.treatmentPlan}</td>
                        <td>${v.nextAppointment}</td>
                        <td><a href="UpdateCustomerVisitHistory?cid=${customer.id}&id=${v.id}&visitDate=${v.visitDate}&reasonForVisit=${v.reasonForVisit}&diagnoses=${v.diagnoses}&treatmentPlan=${v.treatmentPlan}&nextAppointment=${v.nextAppointment}"><button type="button">Update</button>
                            </a>
                            /<a href="#" onclick="doDelete(${status.index + 1}, 'DeleteCustomerVisitHistory', '${customer.id}', '${v.id}')">
                                <button type="button">Delete</button>
                            </a></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <div class="pre-next-Btn">
                <!-- Previous button -->
                <a class="page-link ${currentPage == 1 ? 'disabled' : ''}" 
                   id="previousBtn"
                   href="ShowCustomerMedicalDetail?page=${currentPage - 1}&cid=${customer.id}">
                    Previous
                </a>

                <!-- Current Page -->
                <span class="page-link page-num">Page ${currentPage}</span>

                <!-- Next button -->
                <a class="page-link ${!hasNextPage ? 'disabled' : ''}" 
                   id="nextBtn"
                   href="ShowCustomerMedicalDetail?page=${currentPage + 1}&cid=${customer.id}">
                    Next
                </a>
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

            function doDelete(index, url, cid, id) {
                if (confirm("Are you sure delete index: " + index + " ?"))
                {
                    window.location = url + "?cid=" + cid + "&id=" + id;
                }
            }
    </script>
</html>
