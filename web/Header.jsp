<%-- 
    Document   : Footerjsp
    Created on : 13 thg 1, 2025, 21:30:59
    Author     : TRUNG
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <!-- Icon Font Stylesheet -->
        <link
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.0/css/all.min.css"
            rel="stylesheet"
            />
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css"
            rel="stylesheet"
            />

        <!-- Libraries Stylesheet -->
        <link href="${pageContext.request.contextPath}/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet" />
        <link
            href="${pageContext.request.contextPath}/lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css"
            rel="stylesheet"
            />
        <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <!-- Topbar Start -->
        <div class="container-fluid py-2 border-bottom d-none d-lg-block">
            <div class="container">
                <div class="row">
                    <div class="col-md-6 text-center text-lg-start mb-2 mb-lg-0">
                        <div class="d-inline-flex align-items-center">
                            <a class="text-decoration-none text-body pe-3" href=""><i class="bi bi-telephone me-2"></i>+012 345 6789</a>
                            <span class="text-body">|</span>
                            <a class="text-decoration-none text-body px-3" href=""><i class="bi bi-envelope me-2"></i>info@example.com</a>
                        </div>
                    </div>
                    <div class="col-md-6 text-center text-lg-end">
                        <div class="d-inline-flex align-items-center">
                            <a class="text-body px-2" href="">
                                <i class="fab fa-facebook-f"></i>
                            </a>
                            <a class="text-body px-2" href="">
                                <i class="fab fa-twitter"></i>
                            </a>
                            <a class="text-body px-2" href="${pageContext.request.contextPath}/system/login">
                                <i class="fab fa-linkedin-in"></i>
                            </a>
                            <a class="text-body px-2" href="">
                                <i class="fab fa-instagram"></i>
                            </a>
                            <a class="text-body ps-2" href="">
                                <i class="fab fa-youtube"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Topbar End -->


        <!-- Navbar Start -->
        <div class="container-fluid sticky-top bg-white shadow-sm nav-pad">
            <div class="container">
                <nav class="navbar navbar-expand-lg bg-white navbar-light py-3 py-lg-0">
                    <a href="${pageContext.request.contextPath}/Home.jsp" class="navbar-brand">
                        <h1 class="m-0 text-uppercase text-primary"><i class="fa fa-clinic-medical me-2"></i>SASUCare</h1>
                    </a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarCollapse">
                        <div class="navbar-nav ms-auto py-0">
                            <a href="${pageContext.request.contextPath}/Home.jsp" class="nav-item nav-link active">Home</a>
                            <a href="${pageContext.request.contextPath}/about.jsp" class="nav-item nav-link">About</a>
                            <a href="${pageContext.request.contextPath}/ServiceList" class="nav-item nav-link">Service</a>
                            <a href="${pageContext.request.contextPath}/posts" class="nav-item nav-link">Blog</a>
              
                            <div class="nav-item dropdown">
                                <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">Pages</a>
                                <div class="dropdown-menu m-0">
                                    <a href="${pageContext.request.contextPath}/customer/medical-history" class="dropdown-item">Medical Visit History</a>
                                    <a href="${pageContext.request.contextPath}/appointment/list" class="dropdown-item">My Appointments</a>
                                    <a href="${pageContext.request.contextPath}/customer/invoices" class="dropdown-item">Invoice</a>
                                </div>
                            </div>
                           
                            <c:if test="${not empty sessionScope.currentCustomer}">
                                <a href="${pageContext.request.contextPath}/profile?action=profile" class="nav-item nav-link">
                                    Welcome, ${sessionScope.currentCustomer.fullname}
                                </a>
                                <form action="${pageContext.request.contextPath}/logout" method="get" style="display:inline;">
                                    <button type="submit" class="nav-item nav-link btn btn-link">Logout</button>
                                </form>
                            </c:if>
                            <c:if test="${empty sessionScope.currentCustomer}">
                                <div class="d-flex align-items-center ms-auto">
                                    <button class="nav-item nav-link bg-primary nav-btn btn-register">Register</button>
                                    <button class="nav-item nav-link bg-primary nav-btn btn-login">Login</button>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </nav>
            </div>
        </div>
        <!-- Navbar End -->

        <c:if test="${empty sessionScope.account}">
            <!-- Login and Register Includes -->
            <jsp:include page="accesscontrol/Login.jsp"></jsp:include>
            <jsp:include page="accesscontrol/Register.jsp"></jsp:include>
        </c:if>

        <script>
            let loginButton = document.querySelector(".btn-login");
            let registerButton = document.querySelector(".btn-register");
            let loginContainer = document.querySelector(".login-container");
            let registerContainer = document.querySelector(".register-container");
            let closeLogin = document.querySelector(".close-login");
            let closeRegister = document.querySelector(".close-register");
            let changeLogin = document.querySelector(".change-login");
            let changeRegister = document.querySelector(".change-register");
            loginButton.addEventListener('click', () => {
                loginContainer.classList.remove("d-none");
            });
            registerButton.addEventListener('click', () => {
                registerContainer.classList.remove("d-none");
            });
            closeLogin.addEventListener('click', () => {
                loginContainer.classList.add("d-none");
            });
            closeRegister.addEventListener('click', () => {
                registerContainer.classList.add("d-none");
            });
            changeLogin.addEventListener('click', () => {
                registerContainer.classList.add("d-none");
                loginContainer.classList.remove("d-none");
            });
            changeRegister.addEventListener('click', () => {
                loginContainer.classList.add("d-none");
                registerContainer.classList.remove("d-none");
            });
        </script>
    </body>
</html>
