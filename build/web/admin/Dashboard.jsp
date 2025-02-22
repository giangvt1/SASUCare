<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <%-- No need to include CSS/JS again here, it's in the header --%>
</head>
<body class="skin-black"> <%-- You can keep this class if you want, but ensure styles are in CSS --%>
    <jsp:include page="AdminHeader.jsp"></jsp:include>
    <jsp:include page="AdminLeftSideBar.jsp"></jsp:include>

    <div class="right-side"> <%-- Must have this for correct layout --%>
        <div class="dashboard-content">
            <h2 class="text-center mb-4">Admin Dashboard</h2>

            <div class="row">
                <div class="col-lg-3 col-md-6">
                    <div class="card bg-primary text-white p-3">
                        <h4><i class="fas fa-users"></i> Total Users</h4>
                        <p><strong>1,250</strong></p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="card bg-success text-white p-3">
                        <h4><i class="fas fa-shopping-cart"></i> Orders</h4>
                        <p><strong>320</strong></p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="card bg-warning text-white p-3">
                        <h4><i class="fas fa-dollar-sign"></i> Revenue</h4> <%-- Corrected Font Awesome icon --%>
                        <p><strong>$15,200</strong></p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="card bg-danger text-white p-3">
                        <h4><i class="fas fa-exclamation-triangle"></i> Pending Issues</h4>
                        <p><strong>8</strong></p>
                    </div>
                </div>
            </div>


            <div class="row mt-4">
                <div class="col-md-6 chart-container">
                    <canvas id="userChart"></canvas>
                </div>
                <div class="col-md-6 chart-container">
                    <canvas id="orderChart"></canvas>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col-md-12">
                    <h4>Recent Users</h4>
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>101</td>
                                    <td>john_doe</td>
                                    <td>john@example.com</td>
                                    <td>Manager</td>
                                    <td><span class="badge bg-success">Active</span></td>
                                </tr>
                                <tr>
                                    <td>102</td>
                                    <td>jane_smith</td>
                                    <td>jane@example.com</td>
                                    <td>Customer</td>
                                    <td><span class="badge bg-warning">Pending</span></td>
                                </tr>
                                <tr>
                                    <td>103</td>
                                    <td>admin_user</td>
                                    <td>admin@example.com</td>
                                    <td>Admin</td>
                                    <td><span class="badge bg-danger">Banned</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const userChart = new Chart(document.getElementById("userChart"), {
            type: "doughnut",
            data: {
                labels: ["Active Users", "Inactive Users"],
                datasets: [{
                        data: [1000, 250],
                        backgroundColor: ["#4CAF50", "#FFC107"]
                    }]
            }
        });

        const orderChart = new Chart(document.getElementById("orderChart"), {
            type: "bar",
            data: {
                labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
                datasets: [{
                        label: "Orders",
                        data: [30, 50, 40, 70, 60, 90],
                        backgroundColor: "#007BFF"
                    }]
            }
        });
    </script>
     <script src="${pageContext.request.contextPath}/js/Director/dashboard.js"></script>
</body>
</html>