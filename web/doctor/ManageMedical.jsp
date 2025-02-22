<%-- 
    Document   : ManageMedical
    Created on : 25 thg 1, 2025, 20:22:11
    Author     : TRUNG
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Medical</title>
        <link href="../css/admin/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <!-- font Awesome -->
        <link href="../css/admin/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/admin/styleAdmin.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="../css/doctor/manage_medical_style.css"/>
    </head>
    <body class="skin-black">
        <jsp:include page="../admin/AdminHeader.jsp"></jsp:include>
        <jsp:include page="DoctorLeftSideBar.jsp"></jsp:include>
            <div class="right-side">
                <h1 class="text-center text-bold mb-4" style="margin-bottom: 30px;margin-top: 70px">Medical Records Summary</h1>
                <form action="SearchCustomer" method="get" class="sidebar-form">
                    <div class="search-medical">
                        <input type="text" name="customerName" placeholder="Search customer..." value="${param.customerName}" />
                    <span class="fa fa-search search-icon"></span>
                </div>
                <div class="filter-medical">
                    <input type="date" name="customerDate" value="${param.customerDate}" />
                    <select name="customerGender">
                        <option value="" disabled ${empty param.customerGender ? 'selected' : ''}>Gender</option>
                        <option value="male" ${param.customerGender == 'male' ? 'selected' : ''}>Male</option>
                        <option value="female" ${param.customerGender == 'female' ? 'selected' : ''}>Female</option>
                    </select>
                </div>
                <input class="submit-search" type="submit" value="Search" />
            </form>
            <div class="customer-list mt-4">
                <h3 style="margin-left: 10px">Customer Results</h3>
                <table class="table">
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
                        <!-- Duyệt qua danh sách khách hàng -->
                    <div class="hasNextPage" hidden>${hasNextPage}</div>
                    <c:forEach var="c" items="${customers}" varStatus="status">
                        <tr><td class="index">${status.index + 1}</td>
                            <td><a href="ShowCustomerMedicalDetail?cid=${c.id}">${c.fullname}</a></td>
                            <td>${c.gender?"Male":"Female"}</td>
                            <td>${c.dob}</td>
                            <td>${c.phone_number}</td>
                            <td>${c.address}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <div class="pre-next-Btn">
                    <!-- Previous button -->
                    <a class="page-link" id="previousBtn"href="SearchCustomer?page=${currentPage - 1}&customerName=${param.customerName}&customerDate=${param.customerDate}&customerGender=${param.customerGender}">Previous</a>
                    <!-- Current Page -->
                    <span class="page-link page-num">Page ${currentPage}</span>
                    <!-- Next button -->
                    <a class="page-link"id="nextBtn" href="SearchCustomer?page=${currentPage + 1}&customerName=${param.customerName}&customerDate=${param.customerDate}&customerGender=${param.customerGender}">Next</a>
                </div>
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
            console.losg(hasNextPage);
        </script>

        <!-- jQuery 2.0.2 -->
        <script src="../js/jquery.min.js" type="text/javascript"></script>
        <!-- Bootstrap -->
        <script src="../js/bootstrap.min.js" type="text/javascript"></script>
        <!-- Director App -->
        <script src="../js/Director/app.js" type="text/javascript"></script>
        <script>
            document.querySelectorAll(".sidebar-menu > li").forEach((li) => {
                li.classList.remove("active");
            });
            let manageMedical = document.querySelector(".manage-medical");
            manageMedical.classList.add("active");
        </script>
    </body>
</html>
