<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Reset Password</title>
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
          background-color: #28a745;
          border: none;
          color: #fff;
      }
      .btn-custom:hover {
          background-color: #218838;
      }
  </style>
</head>
<body>
  <div class="container">
    <div class="card">
      <h2 class="text-center">Reset Your Password</h2>
      <% if(request.getAttribute("error") != null){ %>
          <div class="alert alert-danger" role="alert">
              <%= request.getAttribute("error") %>
          </div>
      <% } %>
      <form action="${pageContext.request.contextPath}/system/resetpassword" method="post">
          <!-- Hidden field in case session is lost -->
          <input type="hidden" name="gmail" value="<%= session.getAttribute("gmail") != null ? session.getAttribute("gmail") : "" %>" />
          <div class="form-group">
              <label for="password">New Password:</label>
              <input type="password" id="password" name="password" class="form-control" placeholder="Enter new password" required>
          </div>
          <div class="form-group">
              <label for="confirmPassword">Confirm Password:</label>
              <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Confirm new password" required>
          </div>
          <button type="submit" class="btn btn-custom btn-block">Reset Password</button>
      </form>
    </div>
  </div>
  <!-- Bootstrap JS and dependencies -->
  <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
