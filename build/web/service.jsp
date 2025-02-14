<%-- 
    Document   : service.jsp
    Created on : Jan 31, 2025, 9:34:20 AM
    Author     : admin
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <!--        <style>
          /* Căn giữa toàn bộ carousel */
          .styles_serviceHeader__rJZ7Q .ant-carousel {
            display: flex;
            justify-content: center;
            align-items: center;
          }
        
          /* Căn giữa các item và đảm bảo khoảng cách đều */
          .slick-list {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
          }
        
          .slick-track {
            display: flex;
            justify-content: space-evenly; /* Đảm bảo các item cách đều */
            align-items: center;
            width: 100%;
          }
        
          /* Các item trong carousel */
          .slick-slide {
            display: flex;
            justify-content: center;
            align-items: center;
            width: auto;
            padding: 10px; /* Khoảng cách giữa các item */
          }
        
          /* Căn giữa và làm cho biểu tượng lớn hơn */
          .styles_card__706JX {
            text-align: center;
          }
        
          /* Điều chỉnh kích thước biểu tượng */
          .styles_card__706JX i {
            font-size: 60px; /* Điều chỉnh kích thước biểu tượng */
            color: #003553; /* Màu sắc của biểu tượng */
            margin-bottom: 10px; /* Khoảng cách giữa biểu tượng và tiêu đề */
          }
        
          /* Đảm bảo tiêu đề nằm dưới biểu tượng */
          .styles_title__IzDio {
            margin-top: 5px;
            font-size: 16px; /* Kích thước chữ tiêu đề */
            text-align: center;
          }
        </style>-->

        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f4f4f4;
            }
            .container {
                max-width: 1200px;
                margin: auto;
                padding: 20px;
            }
            .heading {
                text-align: center;
                margin-bottom: 40px;
            }
            .card {
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                margin: 20px;
                overflow: hidden;
                transition: transform 0.3s;
                flex: 1 1 calc(33% - 40px);
                max-width: calc(33% - 40px);
            }
            .card:hover {
                transform: scale(1.05);
            }
            .card img {
                width: 100%;
                height: auto;
            }
            .card-content {
                padding: 20px;
                text-align: center;
            }
            .card-content h3 {
                margin: 0 0 10px;
            }
            .more {
                color: #007bff;
                text-decoration: none;
            }
            .grid {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
            }
        </style>

    </head>



    <body>
        <jsp:include page="Header.jsp"></jsp:include>




            <div class="container">
                <div class="heading">
                    <h1>Chuyên khoa điều trị</h1>
                </div>
                <div class="grid">
                <c:forEach var="service" items="${services}">
                    <div class="card">
                        <c:choose>
                            <c:when test="${service.id == 1}">

                                <img src="https://png.pngtree.com/png-vector/20240430/ourmid/pngtree-medical-check-up-schedule-vector-png-image_12344159.png" alt="Cấp cứu">
                                <div class="card-content">
                                    <h3>${service.name}</h3>
                                    <a class="more" href="khoacapcuu.jsp">More →</a>
                                </div>

                            </c:when>
                            <c:when test="${service.id == 2}">
                                <img src="https://cdn.pixabay.com/photo/2021/01/27/06/48/medical-5953866_960_720.png" alt="Đặt Khám Bác Sĩ">
                                <div class="card-content">
                                    <h3>${service.name}</h3>
                                    <a class="more" href="khoatimmach.jsp">More →</a>
                                </div>

                            </c:when>
                            <c:when test="${service.id == 3}">
                                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTr9WUs4R_V4y9Oi-a6xL1SL4q8WjXY6S23DjgOLsT-fcd8lQkcIdqMohza1ZXR9zUEDuA&usqp=CAU" alt="Call Video Với Bác Sĩ">
                                <div class="card-content">
                                    <h3>${service.name}</h3>
                                    <a class="more" href="khoaxuongkhop.jsp">More →</a>
                                </div>


                            </c:when>
                            <c:when test="${service.id == 4}">
                                <img src="https://png.pngtree.com/png-vector/20230222/ourmid/pngtree-blood-test-line-icon-png-image_6613520.png" alt="Đặt lịch xét nghiệm">
                                <div class="card-content">
                                    <h3>${service.name}</h3>
                                    <a class="more" href="TestPackage">More →</a>
                                </div>

                            </c:when>
                            <c:when test="${service.id == 5}">
                                <img src="https://media.istockphoto.com/id/1211178700/vi/vec-to/medical-shield-line-icon-b%E1%BA%A3o-v%E1%BB%87-s%E1%BB%A9c-kh%E1%BB%8Fe-ph%E1%BA%B3ng-ch%C3%A9o-vect%C6%A1-y-t%E1%BA%BF.jpg?s=170667a&w=0&k=20&c=23k39Blz-vn47AWsf1vydP1CNJYaRkHGYJ5UJgF9ygo=" alt="Gói Khám Sức Khỏe">
                                <div class="card-content">
                                    <h3>${service.name}</h3>
                                    <a class="more" href="SearchPackageServlet">More →</a>
                                </div>

                            </c:when>
                            <c:when test="${service.id == 6}">
                                <img src="https://cdn-icons-png.flaticon.com/512/2907/2907474.png" alt="Đặt lịch tiêm chủng">
                                <div class="card-content">
                                    <h3>${service.name}</h3>
                                    <a class="more" href="VaccinePackage">More →</a>
                                </div>

                            </c:when>
                            <c:when test="${service.id == 7}">
                                <img src="https://w7.pngwing.com/pngs/24/963/png-transparent-doctor-icon-screenshot-physician-health-professional-health-care-doctor-of-medicine-stethoscope-miscellaneous-rectangle-logo-thumbnail.png" alt="Khám Ngoài Giờ">
                                <div class="card-content">
                                    <h3>${service.name}</h3>
                                    <a class="more" href="khoaxuongkhop.jsp">More →</a>
                                </div>

                            </c:when>
                            <c:when test="${service.id == 8}">
                                <img src="https://png.pngtree.com/png-vector/20201226/ourmid/pngtree-care-icon-png-image_2647740.jpg" alt="Y tế tại nhà">
                                <div class="card-content">
                                    <h3>${service.name}</h3>
                                    <a class="more" href="khoaxuongkhop.jsp">More →</a>
                                </div>

                            </c:when>
                            <c:when test="${service.id == 9}">
                                <img src="https://static.thenounproject.com/png/1168142-200.png" alt="Thanh Toán Viện Phí">
                                <div class="card-content">
                                    <h3>${service.name}</h3>
                                    <a class="more" href="khoaxuongkhop.jsp">More →</a>
                                </div>

                            </c:when>
                            <c:otherwise>
                                <img src="https://via.placeholder.com/100" alt="Dịch vụ khác">
                            </c:otherwise>
                        </c:choose>

                    </div>
                </c:forEach>
            </div>
        </div>


        <!--<div class="grid">
                <div class="card">
                    <img src="https://png.pngtree.com/png-vector/20240430/ourmid/pngtree-medical-check-up-schedule-vector-png-image_12344159.png" alt="Cấp cứu">
                    <div class="card-content">
                        <h3>Đặt Khám Tại Cơ Sở</h3>
                        <a class="more" href="khoacapcuu.jsp">More →</a>
                    </div>
                </div>
                <div class="card">
                    <img src="https://cdn.pixabay.com/photo/2021/01/27/06/48/medical-5953866_960_720.png" alt="Tim mạch">
                    <div class="card-content">
                        <h3>Đặt Khám Bác Sĩ</h3>
                        <a class="more" href="khoatimmach.jsp">More →</a>
                    </div>
                </div>
                <div class="card">
                    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTr9WUs4R_V4y9Oi-a6xL1SL4q8WjXY6S23DjgOLsT-fcd8lQkcIdqMohza1ZXR9zUEDuA&usqp=CAU" alt="Xương Khớp">
                    <div class="card-content">
                        <h3>Call Video Với Bác Sĩ</h3>
                        <a class="more" href="khoaxuongkhop.jsp">More →</a>
                    </div>
                </div>
                <div class="card">
                    <img src="https://png.pngtree.com/png-vector/20230222/ourmid/pngtree-blood-test-line-icon-png-image_6613520.png" alt="Hô Hấp">
                    <div class="card-content">
                        <h3>Đặt lịch xét nghiệm</h3>
                        <a class="more" href="TestPackage">More →</a>
                    </div>
                </div>
                <div class="card">
                    <img src="https://media.istockphoto.com/id/1211178700/vi/vec-to/medical-shield-line-icon-b%E1%BA%A3o-v%E1%BB%87-s%E1%BB%A9c-kh%E1%BB%8Fe-ph%E1%BA%B3ng-ch%C3%A9o-vect%C6%A1-y-t%E1%BA%BF.jpg?s=170667a&w=0&k=20&c=23k39Blz-vn47AWsf1vydP1CNJYaRkHGYJ5UJgF9ygo=" alt="Tiêu hóa">
                    <div class="card-content">
                        <h3>Gói Khám Sức Khỏe</h3>
                        <a class="more" href="SearchPackageServlet">More →</a>
                    </div>
                </div>
                <div class="card">
                    <img src="https://cdn-icons-png.flaticon.com/512/2907/2907474.png" alt="Hô Hấp">
                    <div class="card-content">
                        <h3>Đặt lịch tiêm chủng</h3>
                        <a class="more" href="VaccinePackage">More →</a>
                    </div>
                </div>
                <div class="card">
                    <img src="https://w7.pngwing.com/pngs/24/963/png-transparent-doctor-icon-screenshot-physician-health-professional-health-care-doctor-of-medicine-stethoscope-miscellaneous-rectangle-logo-thumbnail.png" alt="Khoa Nhi">
                    <div class="card-content">
                        <h3>Khám Ngoài giờ</h3>
                        <a class="more" href="khoanhi.jsp">More →</a>
                    </div>
                </div>
                <div class="card">
                    <img src="https://png.pngtree.com/png-vector/20201226/ourmid/pngtree-care-icon-png-image_2647740.jpg" alt="Thần kinh">
                    <div class="card-content">
                        <h3>Y tế tại nhà</h3>
                        <a class="more" href="#">More →</a>
                    </div>
                </div>
                <div class="card">
                    <img src="https://static.thenounproject.com/png/1168142-200.png" alt="Răng Hàm Mặt">
                    <div class="card-content">
                        <h3>Thanh Toán Viện Phí</h3>
                        <a class="more" href="#">More →</a>
                    </div>
                </div>
                
            </div>
        </div>-->


        <jsp:include page="Footer.jsp"></jsp:include>
        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/waypoints/waypoints.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>
        <script src="lib/tempusdominus/js/moment.min.js"></script>
        <script src="lib/tempusdominus/js/moment-timezone.min.js"></script>
        <script src="lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>
    </body>
</html>
