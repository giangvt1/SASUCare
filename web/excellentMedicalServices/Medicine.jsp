<%-- 
    Document   : Medicine
    Created on : Feb 5, 2025, 11:34:03 AM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <jsp:include page="Header.jsp"></jsp:include>
        <div class="heading">
        <h1>Dược phẩm</h1>
    </div>
    <div class="card">
        <img src="medicine.jpg" alt="Dược phẩm">
        <p>Khám phá các loại thuốc và hướng dẫn sử dụng tại trung tâm dược phẩm của chúng tôi. Liên hệ với dược sĩ để được tư vấn.</p>
        <a class="button" href="#">Tìm thuốc</a>
    </div>
        
        
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
