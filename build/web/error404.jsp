<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>404 - Page Not Found</title>
  <style>
      body {
          font-family: Arial, sans-serif;
          background-color: #ffe6e6; /* nền đỏ nhạt */
          color: #b30000; /* chữ đỏ đậm */
          text-align: center;
          padding: 50px;
      }
      .container {
          display: inline-block;
          padding: 30px;
          border: 2px solid #b30000;
          background-color: #fff;
          border-radius: 8px;
      }
      a {
          text-decoration: none;
          color: #b30000;
          font-weight: bold;
          margin: 0 10px;
      }
      a:hover {
          text-decoration: underline;
      }
  </style>
</head>
<body>
  <div class="container">
      <h1>404 - Page Not Found</h1>
      <p>${errorMessage != null ? errorMessage : "Trang bạn yêu cầu không tồn tại."}</p>
      <p>
          <a href="${pageContext.request.contextPath}/system/login">Go back to Login Page</a>
          |
          <a href="javascript:history.back()">Go back to Previous Page</a>
      </p>
  </div>
</body>
</html>
