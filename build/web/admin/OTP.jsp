<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>OTP Verification</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <style>
      body {
          background: #f8f9fa;
          font-family: 'Arial', sans-serif;
      }
      .container {
          margin-top: 50px;
          max-width: 500px;
      }
      .card {
          padding: 30px;
          border: none;
          border-radius: 10px;
          box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
      }
      .btn-custom {
          background-color: #007bff;
          border: none;
          color: #fff;
      }
      .btn-custom:hover {
          background-color: #0056b3;
      }
  </style>
</head>
<body>
  <div class="container">
    <div class="card">
      <h2 class="text-center">Forgot Password</h2>
      <%
          String generatedOTP = (String) session.getAttribute("generatedOTP");
          String error = (String) request.getAttribute("error");
          String message = (String) request.getAttribute("message");
      %>
      
      <!-- Always display alerts if they exist -->
      <% if(error != null){ %>
          <div class="alert alert-danger" role="alert"><%= error %></div>
      <% } %>
      <% if(message != null){ %>
          <div class="alert alert-info" role="alert"><%= message %></div>
      <% } %>
      
      <% if (generatedOTP == null) { %>
          <!-- Step 1: Input Gmail -->
          <h4 class="text-center">Enter your Gmail address</h4>
          <form action="${pageContext.request.contextPath}/system/forgetpassword" method="post">
              <div class="form-group">
                  <label for="gmail">Gmail:</label>
                  <input type="email" id="gmail" name="gmail" class="form-control" placeholder="Enter your Gmail" required>
              </div>
              <button type="submit" class="btn btn-custom btn-block">Send OTP</button>
          </form>
      <% } else { %>
          <!-- Step 2: Input OTP -->
          <h4 class="text-center">Enter the OTP sent to your email</h4>
          <form action="${pageContext.request.contextPath}/system/forgetpassword" method="post">
              <div class="form-group">
                  <label for="OTP">OTP:</label>
                  <input type="text" id="OTP" name="OTP" class="form-control" placeholder="Enter OTP" required>
              </div>
              <button type="submit" class="btn btn-custom btn-block">Verify OTP</button>
          </form>
      <% } %>
    </div>
  </div>
  <!-- Bootstrap JS and dependencies -->
  <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
