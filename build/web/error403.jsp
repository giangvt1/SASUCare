<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>403 - Access Denied</title>
  <style>
      body {
          font-family: Arial, sans-serif;
          background-color: #fff9c4; /* nền vàng nhạt */
          color: #f57f17; /* chữ vàng đậm */
          text-align: center;
          padding: 50px;
      }
      .container {
          display: inline-block;
          padding: 30px;
          border: 2px solid #f57f17;
          background-color: #fff;
          border-radius: 8px;
      }
      a {
          text-decoration: none;
          color: #f57f17;
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
      <h1>403 - Access Denied</h1>
      <p>${errorMessage != null ? errorMessage : "Bạn không có quyền truy cập trang này."}</p>
      <p>
          <a href="${pageContext.request.contextPath}/system/login">Go back to Login Page</a>
          |
          <a href="javascript:history.back()">Go back to Previous Page</a>
      </p>
  </div>
</body>
</html>
