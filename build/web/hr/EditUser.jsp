<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <title>Edit User</title>

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
            }, 2000);
        </script>
    </head>
    <body>
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />

        <div class="right-side">
            <div class="main-content"> <%-- Main content container --%>
                <h2>Edit User</h2>

                <c:if test="${not empty success}">
                    <div class="alert alert-success">${success}</div> <%-- Success alert --%>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div> <%-- Error alert --%>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/hr/edit">
                    <input type="hidden" name="username" value="${user.username}" />

                    <div class="mb-3"> <%-- Use Bootstrap spacing utility --%>
                        <label for="displayname" class="form-label">Display Name</label>
                        <input type="text" class="form-control" id="displayname" name="displayname" value="${user.displayname}" required>
                    </div>

                    <div class="mb-3">
                        <label for="gmail" class="form-label">Email</label>
                        <input type="email" class="form-control" id="gmail" name="gmail" value="${user.gmail}" required>
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label">Phone</label>
                        <input type="text" class="form-control" id="phone" name="phone" value="${user.phone}">
                    </div>

                    <button type="submit" class="btn btn-primary">Save Changes</button>
                    <a href="${pageContext.request.contextPath}/hr/accountlist" class="btn btn-secondary">Cancel</a>
                </form>
            </div> <%-- Close .main-content --%>
        </div> <%-- Close .right-side --%>

        <%-- No need for script includes here, they are already in AdminHeader.jsp --%>
    </body>
</html>