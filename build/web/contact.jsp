<%-- 
    Document   : contact
    Created on : Feb 5, 2025, 8:30:53 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        
        <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center; /* Canh giữa nội dung */
            margin: 20px;
        }
        .contact-container {
            display: flex; /* Sử dụng Flexbox để sắp xếp */
            justify-content: center; /* Canh giữa các phần thông tin */
            flex-wrap: wrap; /* Cho phép xuống dòng nếu không đủ chỗ */
        }
        .contact-info {
            margin: 10px; /* Cách đều giữa các thông tin */
            padding: 20px;
            border-radius: 5px;
            background-color: #e7f1ff; /* Màu nền */
            width: 250px; /* Đặt chiều rộng cố định */
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); /* Đổ bóng */
        }
        h1 {
            margin-bottom: 30px;
        }
        h3 {
            margin: 0;
        }
        p {
            margin: 5px 0; /* Cách đều giữa các đoạn văn */
        }
        form {
            margin-top: 30px; /* Khoảng cách phía trên form */
            text-align: left; /* Canh trái cho các label và input */
            display: inline-block; /* Để form không rộng quá */
            width: 300px; /* Đặt chiều rộng cố định cho form */
        }
        label {
            margin: 10px 0 5px; /* Khoảng cách cho label */
            display: block; /* Để label nằm ngang */
        }
        input, textarea {
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            width: 100%; /* Chiều rộng đầy đủ */
        }
        button {
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%; /* Chiều rộng đầy đủ */
        }
        button:hover {
            background-color: #45a049;
        }
    </style>
    </head>
    <body>
        <jsp:include page="Header.jsp"></jsp:include>
        

    <h1>LIÊN HỆ</h1>
    
    <div class="contact-container">
        <div class="contact-info">
            <h3>Cơ sở 1:</h3>
        <p>43 Hàng Bạc, Hoàn Kiếm, Hà Nội</p>
        <p>Điện thoại: 0964783083</p>
        <p>Email: Medinova@gmail.com</p>
        </div>
        
        <div class="contact-info">
            <h3>Cơ sở 2:</h3>
        <p>Phú Mỹ, Thủ Dầu Một, Bình Dương</p>
        <p>Điện thoại: 0964801683</p>
        <p>Email: Medinova@gmail.com</p>
        </div>
        
        <div class="contact-info">
            <h3>Cơ sở 3:</h3>
        <p> Phường Bến Thành, Quận 1, Tp Hồ Chí Minh</p>
        <p>Điện thoại: 0964801683</p>
        <p>Email: Medinova@gmail.com</p>
        </div>
    </div>

    <form>
        <label for="name">Tên</label>
        <input type="text" id="name" name="name" required>

        <label for="email">Email</label>
        <input type="email" id="email" name="email" required>

        <label for="phone">Số điện thoại</label>
        <input type="tel" id="phone" name="phone" required>

        <label for="address">Địa chỉ</label>
        <input type="text" id="address" name="address" required>

        <label for="content">Nội dung</label>
        <textarea id="content" name="content" rows="4" required></textarea>

        <button type="submit">Gửi</button>
    </form>
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
