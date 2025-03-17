<%-- 
    Document   : Home.jsp
    Created on : 13 thg 1, 2025, 21:45:44
    Author     : TRUNG
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>HOME</title>
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
        <link href="../lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <link href="css/login_style.css" rel="stylesheet" type="text/css"/>
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        
        <style>
          .chat-container {
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 300px;
            background: white;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            display: none;
          }
          .chat-header {
            background: #007bff;
            color: white;
            padding: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
          }
          .chat-body {
            max-height: 300px;
            overflow-y: auto;
            padding: 10px;
            display: block;
          }
          .chat-footer {
            padding: 10px;
            display: flex;
            gap: 5px;
          }
          .message {
            display: flex;
            align-items: center;
            margin: 5px 0;
          }
          .received img {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            margin-right: 10px;
          }
          .received p, .sent p {
            background: #f1f1f1;
            padding: 5px 10px;
            border-radius: 10px;
          }
          .sent p {
            background: #007bff;
            color: white;
            align-self: flex-end;
          }
          .chat-icon {
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 50px;
            height: 50px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
          }
          .message.sent {
              justify-content: flex-end;
          }
        </style>
    </head>
    <body>
        <jsp:include page="Header.jsp"></jsp:include>
        <!-- Hero Start -->
        <div class="container-fluid bg-primary py-5 mb-5 hero-header">
            <div class="container py-5">
                <div class="row justify-content-start">
                    <div class="col-lg-8 text-center text-lg-start">
                        <h5
                            class="d-inline-block text-primary text-uppercase border-bottom border-5"
                            style="border-color: rgba(256, 256, 256, 0.3) !important"
                            >
                            Welcome To SASUCare
                        </h5>
                        <h1 class="display-1 text-white mb-md-4">
                            Best Healthcare Solution In Your City
                        </h1>
                        <div class="pt-2">
                            <a href="" class="btn btn-light rounded-pill py-md-3 px-md-5 mx-2"
                               >Find Doctor</a
                            >
                        <c:choose>
                            <c:when test="${not empty sessionScope.currentCustomer}">
                                <!-- Content when currentCustomer is not empty -->
                                <a href="${pageContext.request.contextPath}/listrecord"
                                   class="btn btn-outline-light rounded-pill py-md-3 px-md-5 mx-2">
                                    Appointment
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/appointment"
                                   class="btn btn-outline-light rounded-pill py-md-3 px-md-5 mx-2">
                                    Appointment
                                </a>
                            </c:otherwise>
                        </c:choose>
                            
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Hero End -->

        <!-- About Start -->
        <div class="container-fluid py-5">
            <div class="container">
                <div class="row gx-5">
                    <div class="col-lg-5 mb-5 mb-lg-0" style="min-height: 500px">
                        <div class="position-relative h-100">
                            <img
                                class="position-absolute w-100 h-100 rounded"
                                src="img/about.jpg"
                                style="object-fit: cover"
                                />
                        </div>
                    </div>
                    <div class="col-lg-7">
                        <div class="mb-4">
                            <h5
                                class="d-inline-block text-primary text-uppercase border-bottom border-5"
                                >
                                About Us
                            </h5>
                            <h1 class="display-4">
                                Best Medical Care For Yourself and Your Family
                            </h1>
                        </div>
                        <p>
                            Tempor erat elitr at rebum at at clita aliquyam consetetur. Diam
                            dolor diam ipsum et, tempor voluptua sit consetetur sit. Aliquyam
                            diam amet diam et eos sadipscing labore. Clita erat ipsum et lorem
                            et sit, sed stet no labore lorem sit. Sanctus clita duo justo et
                            tempor consetetur takimata eirmod, dolores takimata consetetur
                            invidunt magna dolores aliquyam dolores dolore. Amet erat amet et
                            magna
                        </p>
                        <div class="row g-3 pt-3">
                            <div class="col-sm-3 col-6">
                                <div class="bg-light text-center rounded-circle py-4">
                                    <i class="fa fa-3x fa-user-md text-primary mb-3"></i>
                                    <h6 class="mb-0">
                                        Qualified<small class="d-block text-primary">Doctors</small>
                                    </h6>
                                </div>
                            </div>
                            <div class="col-sm-3 col-6">
                                <div class="bg-light text-center rounded-circle py-4">
                                    <i class="fa fa-3x fa-procedures text-primary mb-3"></i>
                                    <h6 class="mb-0">
                                        Emergency<small class="d-block text-primary"
                                                        >Services</small
                                        >
                                    </h6>
                                </div>
                            </div>
                            <div class="col-sm-3 col-6">
                                <div class="bg-light text-center rounded-circle py-4">
                                    <i class="fa fa-3x fa-microscope text-primary mb-3"></i>
                                    <h6 class="mb-0">
                                        Accurate<small class="d-block text-primary">Testing</small>
                                    </h6>
                                </div>
                            </div>
                            <div class="col-sm-3 col-6">
                                <div class="bg-light text-center rounded-circle py-4">
                                    <i class="fa fa-3x fa-ambulance text-primary mb-3"></i>
                                    <h6 class="mb-0">
                                        Free<small class="d-block text-primary">Ambulance</small>
                                    </h6>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- About End -->

        <!-- Services Start -->
        <div class="container-fluid py-5">
            <div class="container">
                <div class="text-center mx-auto mb-5" style="max-width: 500px">
                    <h5
                        class="d-inline-block text-primary text-uppercase border-bottom border-5"
                        >
                        Services
                    </h5>
                    <h1 class="display-4">Excellent Medical Services</h1>
                </div>
                <div class="row g-5">
                    <div class="col-lg-4 col-md-6">
                        <div
                            class="service-item bg-light rounded d-flex flex-column align-items-center justify-content-center text-center"
                            >
                            <div class="service-icon mb-4">
                                <i class="fa fa-2x fa-user-md text-white"></i>
                            </div>
                            <h4 class="mb-3">Emergency Care</h4>
                            <p class="m-0">
                                Kasd dolor no lorem nonumy sit labore tempor at justo rebum
                                rebum stet, justo elitr dolor amet sit
                            </p>
                            <a class="btn btn-lg btn-primary rounded-pill" href="capcuu.jsp">
                                
                                <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div
                            class="service-item bg-light rounded d-flex flex-column align-items-center justify-content-center text-center"
                            >
                            <div class="service-icon mb-4">
                                <i class="fa fa-2x fa-procedures text-white"></i>
                            </div>
                            <h4 class="mb-3">Operation & Surgery</h4>
                            <p class="m-0">
                                Kasd dolor no lorem nonumy sit labore tempor at justo rebum
                                rebum stet, justo elitr dolor amet sit
                            </p>
                            <a class="btn btn-lg btn-primary rounded-pill" href="Operation.jsp">
                                <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div
                            class="service-item bg-light rounded d-flex flex-column align-items-center justify-content-center text-center"
                            >
                            <div class="service-icon mb-4">
                                <i class="fa fa-2x fa-stethoscope text-white"></i>
                            </div>
                            <h4 class="mb-3">Outdoor Checkup</h4>
                            <p class="m-0">
                                Kasd dolor no lorem nonumy sit labore tempor at justo rebum
                                rebum stet, justo elitr dolor amet sit
                            </p>
                            <a class="btn btn-lg btn-primary rounded-pill" href="OutdoorCheckup.jsp">
                                <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div
                            class="service-item bg-light rounded d-flex flex-column align-items-center justify-content-center text-center"
                            >
                            <div class="service-icon mb-4">
                                <i class="fa fa-2x fa-ambulance text-white"></i>
                            </div>
                            <h4 class="mb-3">Ambulance Service</h4>
                            <p class="m-0">
                                Kasd dolor no lorem nonumy sit labore tempor at justo rebum
                                rebum stet, justo elitr dolor amet sit
                            </p>
                            <a class="btn btn-lg btn-primary rounded-pill" href="AmbulanceService.jsp">
                                <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div
                            class="service-item bg-light rounded d-flex flex-column align-items-center justify-content-center text-center"
                            >
                            <div class="service-icon mb-4">
                                <i class="fa fa-2x fa-pills text-white"></i>
                            </div>
                            <h4 class="mb-3">Medicine & Pharmacy</h4>
                            <p class="m-0">
                                Kasd dolor no lorem nonumy sit labore tempor at justo rebum
                                rebum stet, justo elitr dolor amet sit
                            </p>
                            <a class="btn btn-lg btn-primary rounded-pill" href="Medicine.jsp">
                                <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-6">
                        <div
                            class="service-item bg-light rounded d-flex flex-column align-items-center justify-content-center text-center"
                            >
                            <div class="service-icon mb-4">
                                <i class="fa fa-2x fa-microscope text-white"></i>
                            </div>
                            <h4 class="mb-3">Blood Testing</h4>
                            <p class="m-0">
                                Kasd dolor no lorem nonumy sit labore tempor at justo rebum
                                rebum stet, justo elitr dolor amet sit
                            </p>
                            <a class="btn btn-lg btn-primary rounded-pill" href="BloodTesting.jsp">
                                <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Services End -->

        <!-- Appointment Start -->
        <div class="container-fluid bg-primary my-5 py-5">
            <div class="container py-5">
                <div class="row gx-5">
                    <div class="col-lg-6 mb-5 mb-lg-0">
                        <div class="mb-4">
                            <h5
                                class="d-inline-block text-white text-uppercase border-bottom border-5"
                                >
                                Appointment
                            </h5>
                            <h1 class="display-4">Make An Appointment For Your Family</h1>
                        </div>
                        <p class="text-white mb-5">
                            Eirmod sed tempor lorem ut dolores. Aliquyam sit sadipscing kasd
                            ipsum. Dolor ea et dolore et at sea ea at dolor, justo ipsum duo
                            rebum sea invidunt voluptua. Eos vero eos vero ea et dolore eirmod
                            et. Dolores diam duo invidunt lorem. Elitr ut dolores magna sit.
                            Sea dolore sanctus sed et. Takimata takimata sanctus sed.
                        </p>
                        <a class="btn btn-dark rounded-pill py-3 px-5 me-3" href=""
                           >Find Doctor</a
                        >
                        <a class="btn btn-outline-dark rounded-pill py-3 px-5" href=""
                           >Read More</a
                        >
                    </div>
                    <div class="col-lg-6">
                        <div class="bg-white text-center rounded p-5">
                            <h1 class="mb-4">Book An Appointment</h1>
                            <form>
                                <div class="row g-3">
                                    <div class="col-12 col-sm-6">
                                        <select
                                            class="form-select bg-light border-0"
                                            style="height: 55px"
                                            >
                                            <option selected>Choose Department</option>
                                            <option value="1">Department 1</option>
                                            <option value="2">Department 2</option>
                                            <option value="3">Department 3</option>
                                        </select>
                                    </div>
                                    <div class="col-12 col-sm-6">
                                        <select
                                            class="form-select bg-light border-0"
                                            style="height: 55px"
                                            >
                                            <option selected>Select Doctor</option>
                                            <option value="1">Doctor 1</option>
                                            <option value="2">Doctor 2</option>
                                            <option value="3">Doctor 3</option>
                                        </select>
                                    </div>
                                    <div class="col-12 col-sm-6">
                                        <input
                                            type="text"
                                            class="form-control bg-light border-0"
                                            placeholder="Your Name"
                                            style="height: 55px"
                                            />
                                    </div>
                                    <div class="col-12 col-sm-6">
                                        <input
                                            type="email"
                                            class="form-control bg-light border-0"
                                            placeholder="Your Email"
                                            style="height: 55px"
                                            />
                                    </div>
                                    <div class="col-12 col-sm-6">
                                        <div class="date" id="date" data-target-input="nearest">
                                            <input
                                                type="text"
                                                class="form-control bg-light border-0 datetimepicker-input"
                                                placeholder="Date"
                                                data-target="#date"
                                                data-toggle="datetimepicker"
                                                style="height: 55px"
                                                />
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6">
                                        <div class="time" id="time" data-target-input="nearest">
                                            <input
                                                type="text"
                                                class="form-control bg-light border-0 datetimepicker-input"
                                                placeholder="Time"
                                                data-target="#time"
                                                data-toggle="datetimepicker"
                                                style="height: 55px"
                                                />
                                        </div>
                                    </div>
                                    <div class="col-12">
                                        <button class="btn btn-primary w-100 py-3" type="submit">
                                            Make An Appointment
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Appointment End -->

        <!-- Pricing Plan Start -->
        <div class="container-fluid py-5">
            <div class="container">
                <div class="text-center mx-auto mb-5" style="max-width: 500px">
                    <h5
                        class="d-inline-block text-primary text-uppercase border-bottom border-5"
                        >
                        Medical Packages
                    </h5>
                    <h1 class="display-4">Awesome Medical Programs</h1>
                </div>
                <div
                    class="owl-carousel price-carousel position-relative"
                    style="padding: 0 45px 45px 45px"
                    >
                    <div class="bg-light rounded text-center">
                        <div class="position-relative">
                            <img class="img-fluid rounded-top" src="img/price-1.jpg" alt="" />
                            <div
                                class="position-absolute w-100 h-100 top-50 start-50 translate-middle rounded-top d-flex flex-column align-items-center justify-content-center"
                                style="background: rgba(29, 42, 77, 0.8)"
                                >
                                <h3 class="text-white">Pregnancy Care</h3>
                                <h1 class="display-4 text-white mb-0">
                                    <small
                                        class="align-top fw-normal"
                                        style="font-size: 22px; line-height: 45px"
                                        >$</small
                                    >49<small
                                        class="align-bottom fw-normal"
                                        style="font-size: 16px; line-height: 40px"
                                        >/ Year</small
                                    >
                                </h1>
                            </div>
                        </div>
                        <div class="text-center py-5">
                            <p>Emergency Medical Treatment</p>
                            <p>Highly Experienced Doctors</p>
                            <p>Highest Success Rate</p>
                            <p>Telephone Service</p>
                            <a href="" class="btn btn-primary rounded-pill py-3 px-5 my-2"
                               >Apply Now</a
                            >
                        </div>
                    </div>
                    <div class="bg-light rounded text-center">
                        <div class="position-relative">
                            <img class="img-fluid rounded-top" src="img/price-2.jpg" alt="" />
                            <div
                                class="position-absolute w-100 h-100 top-50 start-50 translate-middle rounded-top d-flex flex-column align-items-center justify-content-center"
                                style="background: rgba(29, 42, 77, 0.8)"
                                >
                                <h3 class="text-white">Health Checkup</h3>
                                <h1 class="display-4 text-white mb-0">
                                    <small
                                        class="align-top fw-normal"
                                        style="font-size: 22px; line-height: 45px"
                                        >$</small
                                    >99<small
                                        class="align-bottom fw-normal"
                                        style="font-size: 16px; line-height: 40px"
                                        >/ Year</small
                                    >
                                </h1>
                            </div>
                        </div>
                        <div class="text-center py-5">
                            <p>Emergency Medical Treatment</p>
                            <p>Highly Experienced Doctors</p>
                            <p>Highest Success Rate</p>
                            <p>Telephone Service</p>
                            <a href="" class="btn btn-primary rounded-pill py-3 px-5 my-2"
                               >Apply Now</a
                            >
                        </div>
                    </div>
                    <div class="bg-light rounded text-center">
                        <div class="position-relative">
                            <img class="img-fluid rounded-top" src="img/price-3.jpg" alt="" />
                            <div
                                class="position-absolute w-100 h-100 top-50 start-50 translate-middle rounded-top d-flex flex-column align-items-center justify-content-center"
                                style="background: rgba(29, 42, 77, 0.8)"
                                >
                                <h3 class="text-white">Dental Care</h3>
                                <h1 class="display-4 text-white mb-0">
                                    <small
                                        class="align-top fw-normal"
                                        style="font-size: 22px; line-height: 45px"
                                        >$</small
                                    >149<small
                                        class="align-bottom fw-normal"
                                        style="font-size: 16px; line-height: 40px"
                                        >/ Year</small
                                    >
                                </h1>
                            </div>
                        </div>
                        <div class="text-center py-5">
                            <p>Emergency Medical Treatment</p>
                            <p>Highly Experienced Doctors</p>
                            <p>Highest Success Rate</p>
                            <p>Telephone Service</p>
                            <a href="" class="btn btn-primary rounded-pill py-3 px-5 my-2"
                               >Apply Now</a
                            >
                        </div>
                    </div>
                    <div class="bg-light rounded text-center">
                        <div class="position-relative">
                            <img class="img-fluid rounded-top" src="img/price-4.jpg" alt="" />
                            <div
                                class="position-absolute w-100 h-100 top-50 start-50 translate-middle rounded-top d-flex flex-column align-items-center justify-content-center"
                                style="background: rgba(29, 42, 77, 0.8)"
                                >
                                <h3 class="text-white">Operation & Surgery</h3>
                                <h1 class="display-4 text-white mb-0">
                                    <small
                                        class="align-top fw-normal"
                                        style="font-size: 22px; line-height: 45px"
                                        >$</small
                                    >199<small
                                        class="align-bottom fw-normal"
                                        style="font-size: 16px; line-height: 40px"
                                        >/ Year</small
                                    >
                                </h1>
                            </div>
                        </div>
                        <div class="text-center py-5">
                            <p>Emergency Medical Treatment</p>
                            <p>Highly Experienced Doctors</p>
                            <p>Highest Success Rate</p>
                            <p>Telephone Service</p>
                            <a href="" class="btn btn-primary rounded-pill py-3 px-5 my-2"
                               >Apply Now</a
                            >
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Pricing Plan End -->

        <!-- Team Start -->
        <div class="container-fluid py-5">
            <div class="container">
                <div class="text-center mx-auto mb-5" style="max-width: 500px">
                    <h5
                        class="d-inline-block text-primary text-uppercase border-bottom border-5"
                        >
                        Our Doctors
                    </h5>
                    <h1 class="display-4">Qualified Healthcare Professionals</h1>
                </div>
                <div class="owl-carousel team-carousel position-relative">
                    <div class="team-item">
                        <div class="row g-0 bg-light rounded overflow-hidden">
                            <div class="col-12 col-sm-5 h-100">
                                <img
                                    class="img-fluid h-100"
                                    src="img/team-1.jpg"
                                    style="object-fit: cover"
                                    />
                            </div>
                            <div class="col-12 col-sm-7 h-100 d-flex flex-column">
                                <div class="mt-auto p-4">
                                    <h3>Doctor Name</h3>
                                    <h6 class="fw-normal fst-italic text-primary mb-4">
                                        Cardiology Specialist
                                    </h6>
                                    <p class="m-0">
                                        Dolor lorem eos dolor duo eirmod sea. Dolor sit magna rebum
                                        clita rebum dolor
                                    </p>
                                </div>
                                <div class="d-flex mt-auto border-top p-4">
                                    <a
                                        class="btn btn-lg btn-primary btn-lg-square rounded-circle me-3"
                                        href="#"
                                        ><i class="fab fa-twitter"></i
                                        ></a>
                                    <a
                                        class="btn btn-lg btn-primary btn-lg-square rounded-circle me-3"
                                        href="#"
                                        ><i class="fab fa-facebook-f"></i
                                        ></a>
                                    <a
                                        class="btn btn-lg btn-primary btn-lg-square rounded-circle"
                                        href="#"
                                        ><i class="fab fa-linkedin-in"></i
                                        ></a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="team-item">
                        <div class="row g-0 bg-light rounded overflow-hidden">
                            <div class="col-12 col-sm-5 h-100">
                                <img
                                    class="img-fluid h-100"
                                    src="img/team-2.jpg"
                                    style="object-fit: cover"
                                    />
                            </div>
                            <div class="col-12 col-sm-7 h-100 d-flex flex-column">
                                <div class="mt-auto p-4">
                                    <h3>Doctor Name</h3>
                                    <h6 class="fw-normal fst-italic text-primary mb-4">
                                        Cardiology Specialist
                                    </h6>
                                    <p class="m-0">
                                        Dolor lorem eos dolor duo eirmod sea. Dolor sit magna rebum
                                        clita rebum dolor
                                    </p>
                                </div>
                                <div class="d-flex mt-auto border-top p-4">
                                    <a
                                        class="btn btn-lg btn-primary btn-lg-square rounded-circle me-3"
                                        href="#"
                                        ><i class="fab fa-twitter"></i
                                        ></a>
                                    <a
                                        class="btn btn-lg btn-primary btn-lg-square rounded-circle me-3"
                                        href="#"
                                        ><i class="fab fa-facebook-f"></i
                                        ></a>
                                    <a
                                        class="btn btn-lg btn-primary btn-lg-square rounded-circle"
                                        href="#"
                                        ><i class="fab fa-linkedin-in"></i
                                        ></a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="team-item">
                        <div class="row g-0 bg-light rounded overflow-hidden">
                            <div class="col-12 col-sm-5 h-100">
                                <img
                                    class="img-fluid h-100"
                                    src="img/team-3.jpg"
                                    style="object-fit: cover"
                                    />
                            </div>
                            <div class="col-12 col-sm-7 h-100 d-flex flex-column">
                                <div class="mt-auto p-4">
                                    <h3>Doctor Name</h3>
                                    <h6 class="fw-normal fst-italic text-primary mb-4">
                                        Cardiology Specialist
                                    </h6>
                                    <p class="m-0">
                                        Dolor lorem eos dolor duo eirmod sea. Dolor sit magna rebum
                                        clita rebum dolor
                                    </p>
                                </div>
                                <div class="d-flex mt-auto border-top p-4">
                                    <a
                                        class="btn btn-lg btn-primary btn-lg-square rounded-circle me-3"
                                        href="#"
                                        ><i class="fab fa-twitter"></i
                                        ></a>
                                    <a
                                        class="btn btn-lg btn-primary btn-lg-square rounded-circle me-3"
                                        href="#"
                                        ><i class="fab fa-facebook-f"></i
                                        ></a>
                                    <a
                                        class="btn btn-lg btn-primary btn-lg-square rounded-circle"
                                        href="#"
                                        ><i class="fab fa-linkedin-in"></i
                                        ></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Team End -->

        <!-- Search Start -->
        <div class="container-fluid bg-primary my-5 py-5">
            <div class="container py-5">
                <div class="text-center mx-auto mb-5" style="max-width: 500px">
                    <h5
                        class="d-inline-block text-white text-uppercase border-bottom border-5"
                        >
                        Find A Doctor
                    </h5>
                    <h1 class="display-4 mb-4">Find A Healthcare Professionals</h1>
                    <h5 class="text-white fw-normal">
                        Duo ipsum erat stet dolor sea ut nonumy tempor. Tempor duo lorem eos
                        sit sed ipsum takimata ipsum sit est. Ipsum ea voluptua ipsum sit
                        justo
                    </h5>
                </div>
                <div class="mx-auto" style="width: 100%; max-width: 600px">
                    <div class="input-group">
                        <select
                            class="form-select border-primary w-25"
                            style="height: 60px"
                            >
                            <option selected>Department</option>
                            <option value="1">Department 1</option>
                            <option value="2">Department 2</option>
                            <option value="3">Department 3</option>
                        </select>
                        <input
                            type="text"
                            class="form-control border-primary w-50"
                            placeholder="Keyword"
                            />
                        <button class="btn btn-dark border-0 w-25">Search</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- Search End -->

        <!-- Testimonial Start -->
        <div class="container-fluid py-5">
            <div class="container">
                <div class="text-center mx-auto mb-5" style="max-width: 500px">
                    <h5
                        class="d-inline-block text-primary text-uppercase border-bottom border-5"
                        >
                        Testimonial
                    </h5>
                    <h1 class="display-4">Patients Say About Our Services</h1>
                </div>
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="owl-carousel testimonial-carousel">
                            <div class="testimonial-item text-center">
                                <div class="position-relative mb-5">
                                    <img
                                        class="img-fluid rounded-circle mx-auto"
                                        src="img/testimonial-1.jpg"
                                        alt=""
                                        />
                                    <div
                                        class="position-absolute top-100 start-50 translate-middle d-flex align-items-center justify-content-center bg-white rounded-circle"
                                        style="width: 60px; height: 60px"
                                        >
                                        <i class="fa fa-quote-left fa-2x text-primary"></i>
                                    </div>
                                </div>
                                <p class="fs-4 fw-normal">
                                    Dolores sed duo clita tempor justo dolor et stet lorem kasd
                                    labore dolore lorem ipsum. At lorem lorem magna ut et, nonumy
                                    et labore et tempor diam tempor erat. Erat dolor rebum sit
                                    ipsum.
                                </p>
                                <hr class="w-25 mx-auto" />
                                <h3>Patient Name</h3>
                                <h6 class="fw-normal text-primary mb-3">Profession</h6>
                            </div>
                            <div class="testimonial-item text-center">
                                <div class="position-relative mb-5">
                                    <img
                                        class="img-fluid rounded-circle mx-auto"
                                        src="img/testimonial-2.jpg"
                                        alt=""
                                        />
                                    <div
                                        class="position-absolute top-100 start-50 translate-middle d-flex align-items-center justify-content-center bg-white rounded-circle"
                                        style="width: 60px; height: 60px"
                                        >
                                        <i class="fa fa-quote-left fa-2x text-primary"></i>
                                    </div>
                                </div>
                                <p class="fs-4 fw-normal">
                                    Dolores sed duo clita tempor justo dolor et stet lorem kasd
                                    labore dolore lorem ipsum. At lorem lorem magna ut et, nonumy
                                    et labore et tempor diam tempor erat. Erat dolor rebum sit
                                    ipsum.
                                </p>
                                <hr class="w-25 mx-auto" />
                                <h3>Patient Name</h3>
                                <h6 class="fw-normal text-primary mb-3">Profession</h6>
                            </div>
                            <div class="testimonial-item text-center">
                                <div class="position-relative mb-5">
                                    <img
                                        class="img-fluid rounded-circle mx-auto"
                                        src="img/testimonial-3.jpg"
                                        alt=""
                                        />
                                    <div
                                        class="position-absolute top-100 start-50 translate-middle d-flex align-items-center justify-content-center bg-white rounded-circle"
                                        style="width: 60px; height: 60px"
                                        >
                                        <i class="fa fa-quote-left fa-2x text-primary"></i>
                                    </div>
                                </div>
                                <p class="fs-4 fw-normal">
                                    Dolores sed duo clita tempor justo dolor et stet lorem kasd
                                    labore dolore lorem ipsum. At lorem lorem magna ut et, nonumy
                                    et labore et tempor diam tempor erat. Erat dolor rebum sit
                                    ipsum.
                                </p>
                                <hr class="w-25 mx-auto" />
                                <h3>Patient Name</h3>
                                <h6 class="fw-normal text-primary mb-3">Profession</h6>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Testimonial End -->

        <!-- Blog Start -->
        <div class="container-fluid py-5">
            <div class="container">
                <div class="text-center mx-auto mb-5" style="max-width: 500px">
                    <h5
                        class="d-inline-block text-primary text-uppercase border-bottom border-5"
                        >
                        Blog Post
                    </h5>
                    <h1 class="display-4">Our Latest Medical Blog Posts</h1>
                </div>
                <div style="
                     text-align: right;
                     text-decoration: underline;">
                    <a href="posts">View All Blogs >></a></div>
                <div class="row g-5">
                <div class="row g-5">
                    <div class="col-xl-4 col-lg-6">
                        <div class="bg-light rounded overflow-hidden">
                            <img class="img-fluid w-100" src="img/blog-1.jpg" alt="" />
                            <div class="p-4">
                                <a class="h3 d-block mb-3" href=""
                                   >Dolor clita vero elitr sea stet dolor justo diam</a
                                >
                                <p class="m-0">
                                    Dolor lorem eos dolor duo et eirmod sea. Dolor sit magna rebum
                                    clita rebum dolor stet amet justo
                                </p>
                            </div>
                            <div class="d-flex justify-content-between border-top p-4">
                                <div class="d-flex align-items-center">
                                    <img
                                        class="rounded-circle me-2"
                                        src="img/user.jpg"
                                        width="25"
                                        height="25"
                                        alt=""
                                        />
                                    <small>John Doe</small>
                                </div>
                                <div class="d-flex align-items-center">
                                    <small class="ms-3"
                                           ><i class="far fa-eye text-primary me-1"></i>12345</small
                                    >
                                    <small class="ms-3"
                                           ><i class="far fa-comment text-primary me-1"></i>123</small
                                    >
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-4 col-lg-6">
                        <div class="bg-light rounded overflow-hidden">
                            <img class="img-fluid w-100" src="img/blog-2.jpg" alt="" />
                            <div class="p-4">
                                <a class="h3 d-block mb-3" href=""
                                   >Dolor clita vero elitr sea stet dolor justo diam</a
                                >
                                <p class="m-0">
                                    Dolor lorem eos dolor duo et eirmod sea. Dolor sit magna rebum
                                    clita rebum dolor stet amet justo
                                </p>
                            </div>
                            <div class="d-flex justify-content-between border-top p-4">
                                <div class="d-flex align-items-center">
                                    <img
                                        class="rounded-circle me-2"
                                        src="img/user.jpg"
                                        width="25"
                                        height="25"
                                        alt=""
                                        />
                                    <small>John Doe</small>
                                </div>
                                <div class="d-flex align-items-center">
                                    <small class="ms-3"
                                           ><i class="far fa-eye text-primary me-1"></i>12345</small
                                    >
                                    <small class="ms-3"
                                           ><i class="far fa-comment text-primary me-1"></i>123</small
                                    >
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-4 col-lg-6">
                        <div class="bg-light rounded overflow-hidden">
                            <img class="img-fluid w-100" src="img/blog-3.jpg" alt="" />
                            <div class="p-4">
                                <a class="h3 d-block mb-3" href=""
                                   >Dolor clita vero elitr sea stet dolor justo diam</a
                                >
                                <p class="m-0">
                                    Dolor lorem eos dolor duo et eirmod sea. Dolor sit magna rebum
                                    clita rebum dolor stet amet justo
                                </p>
                            </div>
                            <div class="d-flex justify-content-between border-top p-4">
                                <div class="d-flex align-items-center">
                                    <img
                                        class="rounded-circle me-2"
                                        src="img/user.jpg"
                                        width="25"
                                        height="25"
                                        alt=""
                                        />
                                    <small>John Doe</small>
                                </div>
                                <div class="d-flex align-items-center">
                                    <small class="ms-3"
                                           ><i class="far fa-eye text-primary me-1"></i>12345</small
                                    >
                                    <small class="ms-3"
                                           ><i class="far fa-comment text-primary me-1"></i>123</small
                                    >
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Blog End -->
        
            <section>
  <!-- Form nhập thông tin -->
  <div id="info-form" class="info-form" style="display: none;">
    <div class="form-header">
      <h5>Nhập thông tin của bạn</h5>
      <button id="close-btn" class="close-btn">×</button>
    </div>
    <div class="form-group">
      <label for="fullName">Họ và tên:</label>
      <input type="text" id="fullName" class="form-control" placeholder="Nhập họ và tên" required>
    </div>
    <div class="form-group">
      <label for="email">Gmail:</label>
      <input type="email" id="email-1" class="form-control" placeholder="Nhập Gmail" required>
    </div>
    <button id="submit-info" class="btn btn-primary">Xác nhận</button>
  </div>

<!-- HTML của bạn (giữ nguyên) -->
<div id="chat-box" class="chat-container" style="display: none;">
  <div class="chat-header" id="chat-toggle">
    <h5 class="mb-0">Chat</h5>
    <button id="toggle-chat" class="btn btn-primary btn-sm">▲</button>
  </div>
  <div class="chat-body">
    <div class="chat-messages">
      <div class="message received">
        <img src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-chat/ava3-bg.webp" alt="avatar">
        <p>Hi, What can we help you?</p>
      </div>
    </div>
  </div>
  <div class="chat-footer">
    <input type="text" class="form-control" placeholder="Type a message">
    <button class="btn btn-primary">Send</button>
  </div>
</div>
<button id="chat-icon" class="chat-icon">
  <i class="fas fa-comment"></i>
</button>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
<<script src="./js/chat/customer_chat.js"></script>
<style>
  .info-form {
    position: fixed;
    bottom: 20px;
    right: 20px;
    width: 300px;
    padding: 20px;
    background: #fff;
    border: 1px solid #ddd;
    border-radius: 5px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    z-index: 1000;
  }
  .form-group {
    margin-bottom: 15px;
  }
  .chat-icon {
    position: fixed;
    bottom: 20px;
    right: 20px;
    width: 50px;
    height: 50px;
    background-color: #007bff;
    border: none;
    border-radius: 50%;
    color: white;
    font-size: 20px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
  }
  .form-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
  }
  .close-btn {
    background: none;
    border: none;
    font-size: 20px;
    cursor: pointer;
    color: #000;
    padding: 0;
    line-height: 1;
  }
  .close-btn:hover {
    color: #ff0000;
  }
</style>
    </body>
</html>
