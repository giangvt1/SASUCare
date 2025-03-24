<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>500 - Internal Server Error</title>
  <style>
      body {
          font-family: Arial, sans-serif;
          background-color: #ffe0b2; /* nền cam nhạt */
          color: #e65100; /* chữ cam đậm */
          text-align: center;
          padding: 50px;
      }
      .container {
          display: inline-block;
          padding: 30px;
          border: 2px solid #e65100;
          background-color: #fff;
          border-radius: 8px;
      }
      a {
          text-decoration: none;
          color: #e65100;
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
      <h1>500 - Internal Server Error</h1>
      <p>${errorMessage != null ? errorMessage : "Có lỗi xảy ra trên server. Vui lòng thử lại sau."}</p>
      <p>
          <a href="${pageContext.request.contextPath}/system/login">Go back to Login Page</a>
          |
          <a href="javascript:history.back()">Go back to Previous Page</a>
      </p>
  </div>
</body>
</html>
