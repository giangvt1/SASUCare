<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="left-side sidebar-offcanvas">
    <style>
        .active{
            background-color: #3c8dbc;
        }
    </style>
    <section class="sidebar">
        <!-- User panel -->
        <div class="user-panel">
            <div class="image">
                <c:choose>
                    <c:when test="${not empty sessionScope.staff and not empty sessionScope.staff.img}">
                        <img src="${pageContext.request.contextPath}/${sessionScope.staff.img}" class="img-circle" alt="User Image" />
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/img/default-profile.jpg" class="img-circle" alt="User Image" />
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="info">
                <p>
                    Hello,
                    <c:choose>
                        <c:when test="${not empty sessionScope.account}">
                            ${sessionScope.account.displayname}
                        </c:when>
                        <c:otherwise>
                            Guest
                        </c:otherwise>
                    </c:choose>
                </p>
                <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
            </div>
        </div>
        <!-- Sidebar menu -->
        <ul class="sidebar-menu">

            <li class="active">
                <c:if test="${sessionScope.allowedUrls != null && sessionScope.allowedUrls.contains('/admin/ManageTypeCertificate')}">
                    <a class="active" href="${pageContext.request.contextPath}/admin/Dashboard.jsp">
                        <i class="fa fa-dashboard"></i> <span>Dashboard</span>
                    </a>
                        <a href="${pageContext.request.contextPath}/admin/accountlist">
                        <i class="fa fa-globe"></i> <span>Account List</span>
                    </a>
                        
                    <a href="${pageContext.request.contextPath}/admin/create">
                        <i class="fa fa-user-plus"></i> <span>Create Account</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/ManageTypeApplication">
                        <i class="fa fa-globe"></i> <span>Manage Type Application</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/ManageTypeCertificate">
                        <i class="fa fa-globe"></i> <span>Manage Type Certificate</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/SearchDoctor?page=1&sort=default&size=10">
                        <i class="fa fa-globe"></i> <span>Manage Doctor</span>
                    </a>
                </c:if> 
            </li>


            <c:if test="${sessionScope.allowedUrls != null && sessionScope.allowedUrls.contains('/hr/calendarmanage')}">

                <li> 
                    <a href="${pageContext.request.contextPath}/hr/ViewStaffApplication?staffId=${sessionScope.staff.id}">
                        <i class="fa fa-globe"></i> <span>Staff Applications</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/hr/ManageDoctorCertificates?staffId=${sessionScope.staff.id}">
                        <i class="fa fa-globe"></i> <span>Doctor Certificates</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/hr/calendarmanage">
                        <i class="fa fa-table"></i> <span>Doctor Calendar</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/ManageService">
                        <i class="fa fa-table"></i> <span>Services</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/hr/appointments">
                        <i class="fa fa-table"></i> <span>Approve Appointment</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/chatbox">
                        <i class="fa fa-table"></i> <span>Chat</span>
                    </a>
                </li>
            </c:if>

            <c:if test="${allowedUrls != null and (allowedUrls.contains('/doctor/SendApplication.jsp') or allowedUrls.contains('/doctor/ManageMedical.jsp'))}">
                <li>
                    <a href="${pageContext.request.contextPath}/doctor/appointmentsmanagement">
                        <i class="fa fa-envelope"></i> <span>Appointments</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/doctor/ViewApplication?staffId=${sessionScope.staff.id}">
                        <i class="fa fa-envelope"></i> <span>Manage Application</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/doctor/ManageCertificates?staffId=${sessionScope.staff.id}">
                        <i class="fa fa-envelope"></i> <span>Manage Certificate</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/doctor/SearchCustomer">
                        <i class="fa fa-medkit"></i> <span>Search Customer</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/doctor/calendar">
                        <i class="fa fa-medkit"></i> <span>Calendar</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/chatbox">
                        <i class="fa fa-table"></i> <span>Chat</span>
                    </a>
                </li>
            </c:if>
            <c:if test="${allowedUrls != null and (allowedUrls.contains('/finance/InvoiceManagement'))}">
                <li>
                    <a href="${pageContext.request.contextPath}/finance/revenue">
                        <i class="fa fa-envelope"></i> <span>Revenue chart</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/finance/InvoiceManagement">
                        <i class="fa fa-envelope"></i> <span>Invoices management</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/finance/doctorsalary">
                        <i class="fa fa-envelope"></i> <span>Doctor Salary</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/finance/DoctorSalaryChart">
                        <i class="fa fa-envelope"></i> <span>Doctor Salary Chart</span>
                    </a>
                </li>
            </c:if>

            <c:if test="${allowedUrls != null and (allowedUrls.contains('/hr/posts'))}">
                <li>
                    <a href="${pageContext.request.contextPath}/hr/posts">
                        <i class="fa fa-envelope"></i> <span>Post</span>
                    </a>
                </li>
            </c:if>    
            <%-- Add other menu items as needed --%>
        </ul>
    </section>

</aside>
<jsp:include page="/notification.jsp" />    