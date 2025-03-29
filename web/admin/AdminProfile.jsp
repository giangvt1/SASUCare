<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update Profile</title>
    <%-- ALL CSS and JS includes are now in AdminHeader.jsp --%>
    <style>
        /* Styles specific to this page (others should be in admin_styles.css) */
        .profile-img img {
            max-width: 150px; /* Control image size */
            height: auto;
            border-radius: 50%; /* Make image circular */
        }
    </style>
    <script>
        setTimeout(function () {
                var successMsg = document.querySelector('.alert-success');
                if (successMsg) {
                    successMsg.style.display = 'none';
                }
                var errorMsg = document.querySelector('.alert-danger');
                if (errorMsg) {
                    errorMsg.style.display = 'none';
                }
            }, 1000);
    </script>
</head>
<body>
    <jsp:include page="../admin/AdminHeader.jsp" />
    <jsp:include page="../admin/AdminLeftSideBar.jsp" />

    <div class="right-side">
        <div class="main-content"> <%-- Main content container --%>
            <h2 class="text-center">Update Profile</h2>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">${errorMessage}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/system/profile" method="POST" enctype="multipart/form-data" onsubmit="return validateProfile();">
                <div class="mb-3"> <%-- Use Bootstrap spacing utility --%>
                    <label for="img" class="form-label">Profile Image (JPG or PNG only)</label>
                    <c:if test="${not empty staff.img}">
                        <div class="profile-img"> <%-- Container for image styling --%>
                            <img src="${pageContext.request.contextPath}/${staff.img}" alt="Profile Image" class="img-thumbnail" />
                        </div>
                    </c:if>
                    <input type="file" class="form-control-file" id="img" name="img" accept=".jpg,.png">
                </div>

                <div class="mb-3">
                    <label for="fullname" class="form-label">Full Name</label>
                    <input type="text" class="form-control" id="fullname" name="fullname" value="${staff.fullname}" required>
                </div>

                <div class="mb-3">
                    <label for="gender" class="form-label">Gender</label>
                    <select class="form-control" id="gender" name="gender">
                        <option value="true" <c:if test="${staff.gender}">selected</c:if>>Male</option>
                        <option value="false" <c:if test="${!staff.gender}">selected</c:if>>Female</option>
                    </select>
                </div>
               <%-- other form controls --%>
               <div class="mb-3">
                    <label for="address">Address</label>
                    <input type="text" class="form-control" id="address" name="address" value="${staff.address}">
                </div>
                <div class="mb-3">
                    <label for="dob">Date of Birth</label>
                    <input type="date" class="form-control" id="dob" name="dob" value="${staff.dob}">
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-primary">Save Profile</button>
                </div>

            </form>
        </div> <%-- Close main-content --%>
    </div> <%-- Close right-side --%>

 <%-- No need JS here --%>
</body>
</html>
