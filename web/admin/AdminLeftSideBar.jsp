<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="left-side sidebar-offcanvas">
    <style>
        .active{
            background-color: #3c8dbc;
        }
    </style>
    <section class="sidebar">
        <!-- Bảng điều khiển người dùng -->
        <div class="user-panel">
            <div class="image">
                <c:choose>
                    <c:when test="${not empty sessionScope.staff and not empty sessionScope.staff.img}">
                        <img src="${pageContext.request.contextPath}/${sessionScope.staff.img}" class="img-circle" alt="Ảnh người dùng" />
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/img/default-profile.jpg" class="img-circle" alt="Ảnh người dùng" />
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="info">
                <p>
                    Xin chào,
                    <c:choose>
                        <c:when test="${not empty sessionScope.account}">
                            ${sessionScope.account.displayname}
                        </c:when>
                        <c:otherwise>
                            Khách
                        </c:otherwise>
                    </c:choose>
                </p>
                <a href="#"><i class="fa fa-circle text-success"></i> Đang trực tuyến</a>
            </div>
        </div>

        <!-- Menu điều hướng -->
        <ul class="sidebar-menu">
            <li class="active">
                <c:if test="${sessionScope.allowedUrls != null && sessionScope.allowedUrls.contains('/admin/ManageTypeCertificate')}">
                    <a class="active" href="${pageContext.request.contextPath}/admin/Dashboard.jsp">
                        <i class="fa fa-dashboard"></i> <span>Bảng điều khiển</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/accountlist">
                        <i class="fa fa-globe"></i> <span>Danh sách tài khoản</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/create">
                        <i class="fa fa-user-plus"></i> <span>Tạo tài khoản</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/ManageTypeApplication">
                        <i class="fa fa-globe"></i> <span>Quản lý loại đơn</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/ManageTypeCertificate">
                        <i class="fa fa-globe"></i> <span>Quản lý loại chứng chỉ</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/SearchDoctor?page=1&sort=default&size=10">
                        <i class="fa fa-globe"></i> <span>Quản lý bác sĩ</span>
                    </a>
                </c:if> 
            </li>

            <c:if test="${sessionScope.allowedUrls != null && sessionScope.allowedUrls.contains('/hr/calendarmanage')}">
                <li> 
                    <a href="${pageContext.request.contextPath}/hr/ViewStaffApplication?staffId=${sessionScope.staff.id}">
                        <i class="fa fa-globe"></i> <span>Đơn của nhân viên</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/hr/ManageDoctorCertificates?staffId=${sessionScope.staff.id}">
                        <i class="fa fa-globe"></i> <span>Chứng chỉ của bác sĩ</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/hr/calendarmanage">
                        <i class="fa fa-table"></i> <span>Lịch bác sĩ</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/ManageService">
                        <i class="fa fa-table"></i> <span>Dịch vụ</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/hr/appointments">
                        <i class="fa fa-table"></i> <span>Phê duyệt lịch hẹn</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/chatbox">
                        <i class="fa fa-table"></i> <span>Trò chuyện</span>
                    </a>
                </li>
            </c:if>

            <c:if test="${allowedUrls != null and (allowedUrls.contains('/doctor/SendApplication.jsp') or allowedUrls.contains('/doctor/ManageMedical.jsp'))}">
                <li>
                    <a href="${pageContext.request.contextPath}/doctor/appointmentsmanagement">
                        <i class="fa fa-envelope"></i> <span>Lịch hẹn</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/doctor/ViewApplication">
                        <i class="fa fa-envelope"></i> <span>Đơn từ</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/doctor/ManageCertificates?staffId=${sessionScope.staff.id}">
                        <i class="fa fa-envelope"></i> <span>Chứng chỉ</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/doctor/SearchCustomer">
                        <i class="fa fa-medkit"></i> <span>Khách hàng</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/doctor/calendar">
                        <i class="fa fa-medkit"></i> <span>Lịch làm việc</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/chatbox">
                        <i class="fa fa-table"></i> <span>Trò chuyện</span>
                    </a>
                </li>
            </c:if>

            <c:if test="${allowedUrls != null and (allowedUrls.contains('/finance/InvoiceManagement'))}">
                <li>
                    <a href="${pageContext.request.contextPath}/finance/revenue">
                        <i class="fa fa-envelope"></i> <span>Biểu đồ doanh thu</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/finance/InvoiceManagement">
                        <i class="fa fa-envelope"></i> <span>Quản lý hóa đơn</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/finance/doctorsalary">
                        <i class="fa fa-envelope"></i> <span>Lương bác sĩ</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/finance/DoctorSalaryChart">
                        <i class="fa fa-envelope"></i> <span>Biểu đồ lương bác sĩ</span>
                    </a>
                </li>
            </c:if>

            <c:if test="${allowedUrls != null and (allowedUrls.contains('/hr/posts'))}">
                <li>
                    <a href="${pageContext.request.contextPath}/hr/posts">
                        <i class="fa fa-envelope"></i> <span>Bài viết</span>
                    </a>
                </li>
            </c:if>    
        </ul>
    </section>
</aside>
<jsp:include page="/notification.jsp" />    