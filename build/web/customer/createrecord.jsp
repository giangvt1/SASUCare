<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Form Đăng Ký</title>
    <!-- Bootstrap 5 CSS (CDN) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom CSS nếu cần -->
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
                <!-- Nếu action update thì gửi thêm thông tin action và record_id (nếu cần) -->
                <c:if test="${action == 'update'}">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="recordId" value="${record.record_id}"/>
                </c:if>
                
                <!-- Họ và tên, Ngày sinh -->
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

                <!-- Số điện thoại, Giới tính -->
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

                <!-- Nghề nghiệp, Mã định danh/CCCD/Passport -->
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
                               pattern="^(\\d{12}|[A-Z0-9]{8,9})$"
                               title="Nhập CCCD (12 chữ số) hoặc Passport (8-9 ký tự, chữ in hoa và số)"
                               value="<c:out value='${action == "update" ? record.idNumber : ""}'/>">
                    </div>
                </div>

                <!-- Địa chỉ Email, Dân tộc -->
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

                <!-- Tỉnh/Thành, Quận/Huyện -->
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

                <!-- Phường/Xã, Số nhà/Tên đường/Ấp thôn xóm -->
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

    <!-- JavaScript kiểm tra đầu vào -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const today = new Date().toISOString().split("T")[0];
            document.getElementById("dob").setAttribute("max", today);
        });

        document.getElementById("registrationForm").addEventListener("submit", function(e) {
            let valid = true;

            // Kiểm tra Họ và tên: chỉ kiểm tra định dạng cho phép chữ cái có dấu và khoảng trắng
            const fullName = document.getElementById("fullName").value.trim();

            // Kiểm tra Ngày sinh (không cho phép ngày tương lai)
            const dobValue = document.getElementById("dob").value;
            if (dobValue) {
                const dobDate = new Date(dobValue);
                const today = new Date();
                if (dobDate > today) {
                    alert("Ngày sinh không được lớn hơn ngày hiện tại.");
                    valid = false;
                }
            }

            // Kiểm tra Số điện thoại
            const phone = document.getElementById("phone").value.trim();
            const phoneRegex = /^0\d{9,10}$/;
            if (!phoneRegex.test(phone)) {
                alert("Số điện thoại không hợp lệ. Vui lòng nhập số điện thoại bắt đầu bằng số 0 và có 10-11 chữ số.");
                valid = false;
            }

            // Kiểm tra Giới tính đã chọn
            const gender = document.getElementById("gender").value;
            if (gender === "") {
                alert("Vui lòng chọn giới tính.");
                valid = false;
            }

            // Kiểm tra Nghề nghiệp
            const job = document.getElementById("job").value.trim();
            if (job === "") {
                alert("Vui lòng nhập nghề nghiệp.");
                valid = false;
            }

            // Kiểm tra Mã định danh/CCCD/Passport
            const idNumber = document.getElementById("idNumber").value.trim();
            const idRegex = /^(\d{12}|[A-Z0-9]{8,9})$/;
            if (!idRegex.test(idNumber)) {
                alert("Mã định danh/CCCD/Passport không hợp lệ. Vui lòng nhập CCCD (12 chữ số) hoặc Passport (8-9 ký tự, chữ in hoa và số).");
                valid = false;
            }

            if (!valid) {
                e.preventDefault();
            }
        });
    </script>

</body>
</html>
