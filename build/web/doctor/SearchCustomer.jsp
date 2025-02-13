<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>   
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
        <jsp:include page="../admin/AdminLeftSideBar.jsp"></jsp:include>
            <div class="right-side">
                <h1 class="text-center text-bold mb-4" style="margin-bottom: 30px;margin-top: 70px">Search customer</h1>
                <form action="SearchCustomer" method="get" class="sidebar-form" id="searchCustomerForm">
                    <div class="search-medical">
                        <input type="text" name="customerName" placeholder="Search customer name..." value="${param.customerName}" />
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
                <select name="sort" id="sort">
                    <option value="default" ${empty param.sort == 'default' ? 'selected' : ''}>Default</option>
                    <option value="customerNameAZ" ${param.sort == 'customerNameAZ' ? 'selected' : ''}>Customer name A-Z</option>
                    <option value="customerNameZA" ${param.sort == 'customerNameZA' ? 'selected' : ''}>Customer name Z-A</option>
                    <option value="customerDOBLTH" ${param.sort == 'customerDOBLTH' ? 'selected' : ''}>Customer DOB low to high</option>
                    <option value="customerDOBHTL" ${param.sort == 'customerDOBHTL' ? 'selected' : ''}>Customer DOB high to low</option>
                </select>

                <select name="size" id="size">
                    <option value="10" ${param.size == '10' ? 'selected' : ''}>10</option>
                    <option value="1" ${param.size == '1' ? 'selected' : ''}>1</option>
                    <option value="2" ${param.size == '2' ? 'selected' : ''}>2</option>
                    <option value="20" ${param.size == '20' ? 'selected' : ''}>20</option>
                </select>
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
                            <td><fmt:formatDate value="${c.dob}" pattern="dd/MM/yyyy" /></td>
                            <td>${c.phone_number}</td>
                            <td>${c.address}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <div class="pre-next-Btn">
                    <!-- Previous button -->
                    <a class="page-link" id="previousBtn"href="SearchCustomer?page=${currentPage - 1}&customerName=${param.customerName}&customerDate=${param.customerDate}&customerGender=${param.customerGender}&sort=${param.sort}&size=${param.size}">Previous</a>
                    <!-- Current Page -->
                    <span class="page-link page-num">Page ${currentPage}</span>
                    <!-- Next button -->
                    <a class="page-link"id="nextBtn" href="SearchCustomer?page=${currentPage + 1}&customerName=${param.customerName}&customerDate=${param.customerDate}&customerGender=${param.customerGender}&sort=${param.sort}&size=${param.size}">Next</a>
                </div>
            </div>
        </div>
        <script>
            let hasNextPage = document.querySelector(".hasNextPage");
            console.log(hasNextPage.textContent);
            let pre = document.querySelector("#previousBtn");
            let next = document.querySelector("#nextBtn");
            let p = document.querySelector(".page-num");
            if (p.textContent.trim() === "Page 1") {
                pre.classList.add("disabled");
            }
            if (p.textContent.trim() === "Page") {
                pre.classList.add("disabled");
                next.classList.add("disabled");
            }
            if (hasNextPage.textContent.trim() === "false") {
                next.classList.add("disabled");
            }
            console.log(hasNextPage);
        </script>
        <script>
            document.getElementById("sort").addEventListener("change", function () {
                document.getElementById("searchCustomerForm").submit();
            });

            document.getElementById("size").addEventListener("change", function () {
                document.getElementById("searchCustomerForm").submit();
            });
        </script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                let searchBtn = document.querySelector(".submit-search");

                function checkSearchFields() {
                    let name = document.querySelector("input[name='customerName']").value.trim();
                    let date = document.querySelector("input[name='customerDate']").value.trim();
                    let gender = document.querySelector("select[name='customerGender']").value;

                    // Kiểm tra nếu cả 3 trường đều rỗng thì vô hiệu hóa nút, ngược lại thì bật lên
                    if (name === "" && date === "" && (gender === "" || gender === null)) {
                        searchBtn.disabled = true;
                        searchBtn.classList.add("disabled");
                    } else {
                        searchBtn.disabled = false;
                        searchBtn.classList.remove("disabled");
                    }
                }

                // Gán sự kiện cho input và select
                document.querySelector("input[name='customerName']").addEventListener("input", checkSearchFields);
                document.querySelector("input[name='customerDate']").addEventListener("input", checkSearchFields);
                document.querySelector("select[name='customerGender']").addEventListener("change", checkSearchFields);

                // Kiểm tra trạng thái nút tìm kiếm ngay khi trang tải xong
                checkSearchFields();
            });
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
