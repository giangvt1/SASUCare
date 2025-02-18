<%-- 
    Document   : price
    Created on : Feb 5, 2025, 11:16:12 AM
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
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 40px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #007bff;
            color: white;
        }
        .button {
            display: inline-block;
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            margin-top: 20px;
            text-align: center;
        }
        .button:hover {
            background-color: #0056b3;
        }
    </style>
    </head>
    <body>
        <jsp:include page="Header.jsp"></jsp:include>
        
        <div class="container">
    <div class="heading">
        <h1>Giá cả dịch vụ</h1>
        <p>Chúng tôi cung cấp nhiều dịch vụ y tế với giá cả hợp lý và chất lượng cao.</p>
    </div>
    
    <table>
        <thead>
            <tr>
                <th>Dịch vụ</th>
                <th>Mô tả</th>
                <th>Giá (VNĐ)</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Khám Bệnh Tổng Quát</td>
                <td>Khám sức khỏe tổng thể, kiểm tra các dấu hiệu cơ bản của cơ thể.</td>
                <td>500,000</td>
            </tr>
            <tr>
                <td>Khám Sản Khoa</td>
                <td>Khám phụ khoa, kiểm tra sức khỏe cho phụ nữ và thai kỳ.</td>
                <td>600,000</td>
            </tr>
            <tr>
                <td>Siêu Âm Tim Mạch</td>
                <td>Kiểm tra và đánh giá sức khỏe tim mạch bằng siêu âm.</td>
                <td>800,000</td>
            </tr>
            <tr>
                <td>Siêu Âm Bụng</td>
                <td>Kiểm tra các cơ quan trong ổ bụng (gan, thận, ruột, v.v.)</td>
                <td>700,000</td>
            </tr>
            <tr>
                <td>Xét Nghiệm Máu</td>
                <td>Kiểm tra các chỉ số máu như huyết sắc tố, đường huyết.</td>
                <td>200,000</td>
            </tr>
            <tr>
                <td>Chụp X-quang</td>
                <td>Kiểm tra xương và khớp bằng chụp X-quang.</td>
                <td>400,000</td>
            </tr>
            <tr>
                <td>Phẫu Thuật Tiểu Phẫu</td>
                <td>Các phẫu thuật nhỏ, bao gồm cắt u, khâu vết thương.</td>
                <td>1,500,000</td>
            </tr>
            <tr>
                <td>Nội Soi Dạ Dày</td>
                <td>Kiểm tra niêm mạc dạ dày bằng nội soi.</td>
                <td>2,000,000</td>
            </tr>
            <tr>
                <td>Khám Nha Khoa</td>
                <td>Khám răng miệng, phát hiện các bệnh lý về răng miệng.</td>
                <td>300,000</td>
            </tr>
            <tr>
                <td>Chăm Sóc Da Liễu</td>
                <td>Khám và điều trị các bệnh lý về da, mụn, dị ứng, v.v.</td>
                <td>350,000</td>
            </tr>
            <tr>
                <td>Vật Lý Trị Liệu</td>
                <td>Điều trị các bệnh lý về cơ, xương khớp bằng vật lý trị liệu.</td>
                <td>600,000</td>
            </tr>
            <tr>
                <td>Khám Mắt</td>
                <td>Khám mắt, kiểm tra thị lực và các bệnh lý về mắt.</td>
                <td>400,000</td>
            </tr>
            <tr>
                <td>Khám Tai Mũi Họng</td>
                <td>Khám các bệnh lý về tai, mũi, họng.</td>
                <td>500,000</td>
            </tr>
            <tr>
                <td>Xét Nghiệm Đường Huyết</td>
                <td>Kiểm tra mức đường huyết trong cơ thể.</td>
                <td>150,000</td>
            </tr>
            <tr>
                <td>Chụp CT Scanner</td>
                <td>Kiểm tra các bộ phận trong cơ thể bằng chụp cắt lớp vi tính.</td>
                <td>3,000,000</td>
            </tr>
            <tr>
                <td>Khám Phẫu Thuật Mắt</td>
                <td>Khám và phẫu thuật các vấn đề về mắt.</td>
                <td>1,200,000</td>
            </tr>
            <tr>
                <td>Kiểm Tra Mẫu Da</td>
                <td>Kiểm tra các dấu hiệu ung thư da hoặc các vấn đề da liễu.</td>
                <td>500,000</td>
            </tr>
            <tr>
                <td>Khám Tâm Lý</td>
                <td>Tư vấn và kiểm tra sức khỏe tâm lý.</td>
                <td>700,000</td>
            </tr>
            <tr>
                <td>Xét Nghiệm HIV</td>
                <td>Kiểm tra nhiễm HIV trong cơ thể.</td>
                <td>250,000</td>
            </tr>
            <tr>
                <td>Siêu Âm Thai Kỳ</td>
                <td>Kiểm tra sự phát triển của thai nhi.</td>
                <td>800,000</td>
            </tr>
            <tr>
                <td>Khám Chuyên Khoa Nội Tiết</td>
                <td>Kiểm tra các vấn đề liên quan đến nội tiết tố và bệnh lý liên quan.</td>
                <td>1,000,000</td>
            </tr>
            <tr>
                <td>Chăm Sóc Sức Khỏe Tâm Thần</td>
                <td>Điều trị và tư vấn các bệnh về sức khỏe tâm thần.</td>
                <td>1,000,000</td>
            </tr>
            <tr>
                <td>Tiêm Phòng Vắc Xin</td>
                <td>Tiêm phòng các loại vắc xin cần thiết cho trẻ em và người lớn.</td>
                <td>300,000</td>
            </tr>
            <tr>
                <td>Khám Bệnh Trẻ Em</td>
                <td>Khám sức khỏe tổng quát cho trẻ em.</td>
                <td>400,000</td>
            </tr>
            <tr>
                <td>Khám Bệnh Nhi Khoa</td>
                <td>Khám và điều trị các bệnh lý cho trẻ em.</td>
                <td>500,000</td>
            </tr>
        </tbody>
    </table>

    <a class="button" href="tel:02439743556">Gọi ngay để đặt lịch hẹn</a>
    <a class="button" href="#">Đặt lịch hẹn trực tuyến</a>
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
