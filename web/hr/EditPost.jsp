<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Edit Post</title>
        <%-- No CSS or JS includes here, they are in AdminHeader.jsp --%>
    </head>
    <body>
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />

        <div class="right-side">
            <div class="main-content"> <%-- Main content container --%>
                <h2>Edit Post</h2>

                <c:if test="${not empty success}">
                    <div class="alert alert-success">${success}</div> <%-- Success alert --%>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div> <%-- Error alert --%>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/hr/edit-post" enctype="multipart/form-data">

                    <div class="mb-3"> <%-- Use Bootstrap spacing utility --%>
                        <label for="title" class="form-label">Title</label>
                        <input type="hidden" class="form-control" id="id" name="id" value="${p.id}">
                        <input type="text" class="form-control" id="title" name="title" required value="${p.title}">
                    </div>

                    <div class="mb-3">
                        <label for="content" class="form-label">Content</label>
                        <textarea class="form-control" id="content" name="content" required>${p.content}</textarea>
                    </div>

                    <div class="mb-3">
                        <label for="image" class="form-label">Image</label>
                        <input type="file" class="form-control" id="image" name="image" onchange="previewImage(this)"/>
                        <input type="hidden" class="form-control" name="oldImage" value="${p.image}"/>
                        <img src="${pageContext.request.contextPath}/${p.image}" alt="Image post" class="img-preview" id="img-preview-id"
                             style="width: 200px; border: 1px solid #ddd; border-radius: 5px;" />
                    </div>

                    <div class="mb-3">
                        <label for="status" class="form-label">Status</label>
                        <select name="status" class="form-control">
                            <option value="1" ${p.status == true ? 'selected' : ''}>Active</option>
                            <option value="0" ${p.status == false ? 'selected' : ''}>InActive</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary">Save</button>
                    <a href="${pageContext.request.contextPath}/hr/posts" class="btn btn-secondary">Cancel</a>
                </form>
            </div> <%-- Close .main-content --%>
        </div> <%-- Close .right-side --%>

        <%-- No need for script includes here, they are already in AdminHeader.jsp --%>
        <script type="text/javascript">
            function previewImage(input) {
                const preview = document.getElementById('img-preview-id');

                // Kiểm tra xem có file được chọn hay không
                if (input.files && input.files[0]) {
                    // Hiển thị preview của hình ảnh
                    preview.src = window.URL.createObjectURL(input.files[0]);
                    preview.style.display = "block"; // Hiển thị ảnh
                } else {
                    preview.style.display = "none"; // Ẩn ảnh nếu không có file nào
                }
            }
        </script>
    </body>
</html>