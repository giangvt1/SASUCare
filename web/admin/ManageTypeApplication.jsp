<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage type application</title>
        <link rel="stylesheet" href="../css/doctor/doctor_style.css"/>
    </head>
    <body class="skin-black">
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <div class="right-side">
            <style>
                .filter-item {
                    width: 45%;
                }
            </style>
            <form action="ManageTypeApplication" method="get">
                <div  class="d-flex justify-content-between"> 
                    <div class="filter-item" style="width: 10%">
                        <span for="size">Sise each table</span>
                        <select name="size" id="size" onchange="this.form.submit()" style="width: 45%">
                            <option value="10" ${param.size == '10' ? 'selected' : ''}>10</option>
                            <option value="5" ${param.size == '5' ? 'selected' : ''}>5</option>
                            <option value="20" ${param.size == '20' ? 'selected' : ''}>20</option>
                            <option value="100" ${param.size == '100' ? 'selected' : ''}>100</option>
                        </select>
                    </div>
                    <div class="d-flex align-items-end" style="width: 50% ">
                        <div class="filter-item" style="width: 100%">
                            <span>Type name</span>
                            <div class="search-input">
                                <input type="text" name="typeName" placeholder="Search type name..." value="${param.typeName}" onchange="this.form.submit()"/>
                            </div>
                        </div>
                        <div class="submit-container" style="height: 40px">
                            <button type="submit" class="back-btn">Search</button>
                        </div>
                    </div>
                </div>

            </form>

            <div class="table-data mt-4">
                <h2 class="mb-3 text-center title">List type applications</h2>
                <div style="margin-bottom: 30px"></div>
                <a class="add-btn" href="../admin/EditTypeApplication">Add type application</a>
                <table class="table" style="width:95%">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Type name</th>
                            <th>Staff manage name</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="typeApp" items="${typeList}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td>${typeApp.name}</td>
                                <td>${typeApp.staffManageName}</td>
                                <td><a class="edit-btn" href="../admin/EditTypeApplication?id=${typeApp.id}&name=${typeApp.name}&staffManage=${typeApp.staffManageId}">Edit</a></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <div class="pre-next-Btn">
                    <!-- Nút Previous -->
                    <c:if test="${currentPage > 1}">
                        <a class="page-link" href="?&typeName=${param.typeName}&page=${currentPage - 1}&size=${param.size}">Previous</a>
                    </c:if>
                    <!-- Phần phân trang -->
                    <div class="page-link-container">
                        <c:choose>
                            <c:when test="${totalPages <= 5}">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <a class="page-link ${i == currentPage ? 'active' : ''}" href="?&typeName=${param.typeName}&page=${i}&size=${param.size}">${i}</a>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <a class="page-link ${currentPage == 1 ? 'active' : ''}" href="?&typeName=${param.typeName}&page=1&size=${param.size}">1</a>
                                <c:if test="${currentPage > 2}">
                                    <span class="page-link">...</span>
                                </c:if>

                                <c:forEach begin="${currentPage - 1}" end="${currentPage + 1}" var="i">
                                    <c:if test="${i > 1 && i < totalPages}">
                                        <a class="page-link ${i == currentPage ? 'active' : ''}" href="?&typeName=${param.typeName}&page=${i}&size=${param.size}">${i}</a>
                                    </c:if>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages - 2}">
                                    <span class="page-link">...</span>
                                </c:if>
                                <a class="page-link ${currentPage == totalPages ? 'active' : ''}" href="?&typeName=${param.typeName}&page=${totalPages}&size=${param.size}">${totalPages}</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <!-- Nút Next -->
                    <c:if test="${currentPage < totalPages}">
                        <a class="page-link" href="ManageTypeApplication?&typeName=${param.typeName}&page=${currentPage + 1}&size=${param.size}">Next</a>
                    </c:if>
                </div>
            </div>
        </div>  
        <script src="../js/doctor/doctor.js"></script>
    </body>
</html>
