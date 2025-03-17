<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Form Đăng Ký</title>
    <!-- Bootstrap 5 CSS (CDN) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <style>
        .form-label {
            font-weight: 500;
        }
        .required::after {
            content: " *";
            color: red;
        }
        .form-container {
            background-color: #f9f9f9;
            padding: 1.5rem;
            border-radius: 0.5rem;
            margin-top: 1rem;
        }
        h2 {
            margin-top: 1rem;
        }
    </style>
</head>
<body>
    <jsp:include page="/Header.jsp"/>
    <div class="container">
        <h2 class="mt-4 mb-3">Vui lòng cung cấp thông tin chính xác để được phục vụ tốt nhất.</h2>

        <div class="form-container">
            <h4 class="mb-3">Thông tin bắt buộc nhập</h4>
            <form id="registrationForm" action="${pageContext.request.contextPath}/record" method="post">
                <!-- Hidden fields for update action -->
                <c:if test="${action == 'update'}">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="recordId" value="${record.record_id}"/>
                </c:if>
                
                <!-- Full Name and Date of Birth -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="fullName" class="form-label required">Họ và tên (CHỮ IN HOA, có dấu)</label>
                        <input type="text" class="form-control" id="fullName" name="fullName"
                               placeholder="VD: NGUYỄN VĂN BẢO" required
                               value="<c:out value='${action == "update" ? record.fullName : ""}'/>">
                    </div>
                    <div class="col-md-6">
                        <label for="dob" class="form-label required">Ngày sinh (năm/tháng/ngày)</label>
                        <input type="date" class="form-control" id="dob" name="dob" required
                               value="<c:out value='${action == "update" ? record.dob : ""}'/>">
                    </div>
                </div>

                <!-- Phone Number and Gender -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="phone" class="form-label required">Số điện thoại</label>
                        <input type="tel" class="form-control" id="phone" name="phone"
                               placeholder="Nhập số điện thoại" required
                               value="<c:out value='${action == "update" ? record.phone : ""}'/>">
                    </div>
                    <div class="col-md-6">
                        <label for="gender" class="form-label required">Giới tính</label>
                        <select class="form-select" id="gender" name="gender" required>
                            <option value="">-- Chọn --</option>
                            <option value="nam" <c:if test="${action == 'update' && record.gender == 'nam'}">selected</c:if>>Nam</option>
                            <option value="nu" <c:if test="${action == 'update' && record.gender == 'nu'}">selected</c:if>>Nữ</option>
                            <option value="khac" <c:if test="${action == 'update' && record.gender == 'khac'}">selected</c:if>>Khác</option>
                        </select>
                    </div>
                </div>

                <!-- Occupation and ID Number -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="job" class="form-label required">Nghề nghiệp</label>
                        <input type="text" class="form-control" id="job" name="job" placeholder="Nhập nghề nghiệp" required
                               value="<c:out value='${action == "update" ? record.job : ""}'/>">
                    </div>
                    <div class="col-md-6">
                        <label for="idNumber" class="form-label required">Mã định danh/CCCD/Passport</label>
                        <input type="text" class="form-control" id="idNumber" name="idNumber"
                               placeholder="Nhập số CCCD/Passport" required
                               pattern="^(\d{12}|[A-Z0-9]{8,9})$"
                               title="Nhập CCCD (12 chữ số) hoặc Passport (8-9 ký tự, chữ in hoa và số)"
                               value="<c:out value='${action == "update" ? record.idNumber : ""}'/>">
                    </div>
                </div>

                <!-- Email and Ethnicity -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="email" class="form-label">Địa chỉ Email</label>
                        <input type="email" class="form-control" id="email" name="email"
                               placeholder="Nhập địa chỉ Email"
                               value="<c:out value='${action == "update" ? record.email : ""}'/>">
                    </div>
                    <div class="col-md-6">
                        <label for="nation" class="form-label">Dân tộc</label>
                        <input type="text" class="form-control" id="nation" name="nation" placeholder="Kinh, Hoa,..."
                               value="<c:out value='${action == "update" ? record.nation : ""}'/>">
                    </div>
                </div>

                <hr class="my-4">
                <h5 class="mb-3">Địa chỉ theo CCCD</h5>

                <!-- Province and District -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="province" class="form-label required">Tỉnh/Thành</label>
                        <input type="text" class="form-control" id="province" name="province"
                               placeholder="Nhập Tỉnh/Thành" required
                               value="<c:out value='${action == "update" ? record.province : ""}'/>">
                    </div>
                    <div class="col-md-6">
                        <label for="district" class="form-label required">Quận/Huyện</label>
                        <input type="text" class="form-control" id="district" name="district"
                               placeholder="Nhập Quận/Huyện" required
                               value="<c:out value='${action == "update" ? record.district : ""}'/>">
                    </div>
                </div>

                <!-- Ward and Address Details -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="ward" class="form-label required">Phường/Xã</label>
                        <input type="text" class="form-control" id="ward" name="ward"
                               placeholder="Nhập Phường/Xã" required
                               value="<c:out value='${action == "update" ? record.ward : ""}'/>">
                    </div>
                    <div class="col-md-6">
                        <label for="addressDetail" class="form-label required">Số nhà/Tên đường/Ấp thôn xóm</label>
                        <input type="text" class="form-control" id="addressDetail" name="addressDetail"
                               placeholder="Nhập địa chỉ chi tiết" required
                               value="<c:out value='${action == "update" ? record.addressDetail : ""}'/>">
                    </div>
                </div>

                <!-- Form Buttons -->
                <div class="d-flex justify-content-end">
                    <button type="reset" class="btn btn-secondary me-2">Nhập lại</button>
                    <button type="submit" class="btn btn-primary">
                        <c:choose>
                            <c:when test="${action == 'update'}">
                                Cập nhật
                            </c:when>
                            <c:otherwise>
                                Tạo mới
                            </c:otherwise>
                        </c:choose>
                    </button>
                </div>
            </form>
        </div>
    </div>
    <jsp:include page="/Footer.jsp"/>

    <!-- Bootstrap 5 JS (CDN) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Input Validation JavaScript -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const today = new Date().toISOString().split("T")[0];
            document.getElementById("dob").setAttribute("max", today);
        });

        document.getElementById("registrationForm").addEventListener("submit", function(e) {
            let valid = true;
            let errorMessage = "";

            // Validate Full Name
            const fullNameInput = document.getElementById("fullName").value;
            const fullNameTrimmed = fullNameInput.trim();
            if (fullNameInput !== fullNameTrimmed) {
                errorMessage += "Họ và tên không được bắt đầu hoặc kết thúc bằng dấu cách.\n";
                valid = false;
            } else {
                const nameRegex = /^[A-ZÀ-ỸĂÂĐÊÔƠƯ]+(?: [A-ZÀ-ỸĂÂĐÊÔƠƯ]+)*$/;
                if (!nameRegex.test(fullNameTrimmed)) {
                    errorMessage += "Họ và tên phải là chữ in hoa, có dấu, không chứa số hoặc ký tự đặc biệt, và không có nhiều hơn một dấu cách giữa các từ.\n";
                    valid = false;
                } else if (fullNameTrimmed.includes("  ")) {
                    errorMessage += "Họ và tên không được chứa nhiều dấu cách liên tiếp.\n";
                    valid = false;
                }
            }

            // Validate Date of Birth
            const dobValue = document.getElementById("dob").value;
            if (dobValue) {
                const dobDate = new Date(dobValue);
                const today = new Date();
                if (dobDate > today) {
                    errorMessage += "Ngày sinh không được lớn hơn ngày hiện tại.\n";
                    valid = false;
                }
            } else {
                errorMessage += "Vui lòng nhập ngày sinh.\n";
                valid = false;
            }

            // Validate Phone Number
            const phone = document.getElementById("phone").value.trim();
            const phoneRegex = /^0\d{9,10}$/;
            if (!phoneRegex.test(phone)) {
                errorMessage += "Số điện thoại không hợp lệ. Vui lòng nhập số điện thoại bắt đầu bằng số 0 và có 10-11 chữ số.\n";
                valid = false;
            }

            // Validate Gender
            const gender = document.getElementById("gender").value;
            if (gender === "") {
                errorMessage += "Vui lòng chọn giới tính.\n";
                valid = false;
            }

            // Validate Occupation
            const jobInput = document.getElementById("job").value;
            const jobTrimmed = jobInput.trim();
            if (jobTrimmed === "") {
                errorMessage += "Vui lòng nhập nghề nghiệp.\n";
                valid = false;
            } else if (jobInput !== jobTrimmed) {
                errorMessage += "Nghề nghiệp không được bắt đầu hoặc kết thúc bằng dấu cách.\n";
                valid = false;
            } else if (jobTrimmed.includes("  ")) {
                errorMessage += "Nghề nghiệp không được chứa nhiều dấu cách liên tiếp.\n";
                valid = false;
            }

            // Validate ID Number
            const idNumber = document.getElementById("idNumber").value.trim();
            const idRegex = /^(\d{12}|[A-Z0-9]{8,9})$/;
            if (!idRegex.test(idNumber)) {
                errorMessage += "Mã định danh/CCCD/Passport không hợp lệ. Vui lòng nhập CCCD (12 chữ số) hoặc Passport (8-9 ký tự, chữ in hoa và số).\n";
                valid = false;
            }

            // Validate Email
            const email = document.getElementById("email").value.trim();
            if (email !== "") {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    errorMessage += "Địa chỉ Email không hợp lệ.\n";
                    valid = false;
                }
            }

            // Validate Ethnicity
            const nationInput = document.getElementById("nation").value;
            const nationTrimmed = nationInput.trim();
            if (nationTrimmed !== "") {
                if (nationInput !== nationTrimmed) {
                    errorMessage += "Dân tộc không được bắt đầu hoặc kết thúc bằng dấu cách.\n";
                    valid = false;
                } else if (nationTrimmed.includes("  ")) {
                    errorMessage += "Dân tộc không được chứa nhiều dấu cách liên tiếp.\n";
                    valid = false;
                }
            }

            // Validate Province
            const provinceInput = document.getElementById("province").value;
            const provinceTrimmed = provinceInput.trim();
            if (provinceTrimmed === "") {
                errorMessage += "Vui lòng nhập Tỉnh/Thành.\n";
                valid = false;
            } else if (provinceInput !== provinceTrimmed) {
                errorMessage += "Tỉnh/Thành không được bắt đầu hoặc kết thúc bằng dấu cách.\n";
                valid = false;
            } else if (provinceTrimmed.includes("  ")) {
                errorMessage += "Tỉnh/Thành không được chứa nhiều dấu cách liên tiếp.\n";
                valid = false;
            }

            // Validate District
            const districtInput = document.getElementById("district").value;
            const districtTrimmed = districtInput.trim();
            if (districtTrimmed === "") {
                errorMessage += "Vui lòng nhập Quận/Huyện.\n";
                valid = false;
            } else if (districtInput !== districtTrimmed) {
                errorMessage += "Quận/Huyện không được bắt đầu hoặc kết thúc bằng dấu cách.\n";
                valid = false;
            } else if (districtTrimmed.includes("  ")) {
                errorMessage += "Quận/Huyện không được chứa nhiều dấu cách liên tiếp.\n";
                valid = false;
            }

            // Validate Ward
            const wardInput = document.getElementById("ward").value;
            const wardTrimmed = wardInput.trim();
            if (wardTrimmed === "") {
                errorMessage += "Vui lòng nhập Phường/Xã.\n";
                valid = false;
            } else if (wardInput !== wardTrimmed) {
                errorMessage += "Phường/Xã không được bắt đầu hoặc kết thúc bằng dấu cách.\n";
                valid = false;
            } else if (wardTrimmed.includes("  ")) {
                errorMessage += "Phường/Xã không được chứa nhiều dấu cách liên tiếp.\n";
                valid = false;
            }

            // Validate Address Detail
            const addressDetailInput = document.getElementById("addressDetail").value;
            const addressDetailTrimmed = addressDetailInput.trim();
            if (addressDetailTrimmed === "") {
                errorMessage += "Vui lòng nhập Số nhà/Tên đường/Ấp thôn xóm.\n";
                valid = false;
            } else if (addressDetailInput !== addressDetailTrimmed) {
                errorMessage += "Địa chỉ chi tiết không được bắt đầu hoặc kết thúc bằng dấu cách.\n";
                valid = false;
            } else if (addressDetailTrimmed.includes("  ")) {
                errorMessage += "Địa chỉ chi tiết không được chứa nhiều dấu cách liên tiếp.\n";
                valid = false;
            }

            // Display errors and prevent submission if invalid
            if (!valid) {
                alert(errorMessage);
                e.preventDefault();
            }
        });
    </script>
</body>
</html>