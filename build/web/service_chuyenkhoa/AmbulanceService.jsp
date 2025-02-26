<%-- 
    Document   : AmbulanceService
    Created on : Feb 5, 2025, 9:55:51 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
            padding: 20px;
            margin: 20px 0;
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
        <h1>Dịch Vụ Cứu Thương</h1>
        <p>Chúng tôi cung cấp dịch vụ cứu thương 24/7 để đảm bảo bạn nhận được sự chăm sóc kịp thời.</p>
    </div>
    
    <div class="card">
        <h2>Đội ngũ cứu thương</h2>
        <p>Đội ngũ nhân viên y tế chuyên nghiệp và giàu kinh nghiệm, luôn sẵn sàng hỗ trợ bạn trong mọi tình huống khẩn cấp.</p>
    </div>

    <div class="card">
        <h2>Trang thiết bị</h2>
        <p>Xe cứu thương được trang bị đầy đủ thiết bị y tế cần thiết để đảm bảo an toàn cho bệnh nhân trong suốt quá trình di chuyển.</p>
    </div>

    
</div>
    <jsp:include page="Footer.jsp"></jsp:include>
    </body>
</html>
