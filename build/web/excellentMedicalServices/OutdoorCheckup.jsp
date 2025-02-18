<%-- 
    Document   : OutdoorCheckup
    Created on : Feb 5, 2025, 9:53:19 PM
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
        <h1>Khám Ngoài Giờ</h1>
        <p>Chúng tôi cung cấp dịch vụ khám ngoài giờ để đáp ứng nhu cầu của bạn.</p>
    </div>
    
    <div class="card">
        <h2>Giờ mở cửa</h2>
        <p>Khám ngoài giờ từ 17:00 đến 21:00 các ngày trong tuần.</p>
        <p>Chúng tôi hiểu rằng sức khỏe không chờ đợi, vì vậy chúng tôi sẵn sàng phục vụ bạn vào buổi tối.</p>
    </div>

    <div class="card">
        <h2>Dịch vụ</h2>
        <p>Chúng tôi cung cấp các dịch vụ khám bệnh tổng quát, khám chuyên khoa, và các dịch vụ y tế khác ngoài giờ hành chính.</p>
        <a class="button" href="#">Đặt lịch hẹn ngay</a>
    </div>

    
</div>
    <jsp:include page="Footer.jsp"></jsp:include>

    </body>
</html>
