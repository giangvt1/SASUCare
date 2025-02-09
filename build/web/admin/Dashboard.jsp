<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard</title>
        <!-- Include CSS Files -->
        <link href="../css/admin/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/admin/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/admin/styleAdmin.css" rel="stylesheet" type="text/css" />
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            /* Chart Styling */
            .dashboard-content {
                background: whitesmoke;
                min-height: 80vh;
                margin-left: 250px; /* To avoid overlap with the sidebar */
            }

            .card {
                border-radius: 10px;
                margin-bottom: 20px;
                box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
            }

            .card h4 {
                font-size: 1.2rem;
            }

            .chart-container {
                position: relative;
                width: 100%;
                height: 300px;
                margin: 20px 0;
            }

            canvas {
                max-width: 100%;
                max-height: 100%;
            }
        </style>
    </head>
    <body class="skin-black" style="height: 1000px">
        <jsp:include page="AdminHeader.jsp"></jsp:include>
        <jsp:include page="AdminLeftSideBar.jsp"></jsp:include>

        <div class="container-fluid">
            <div class="row">
                <div class="col-md-10 offset-md-1 dashboard-content">
                    <h2 class="text-center">Admin Dashboard</h2>

                    <!-- Info Boxes -->
                    <div class="row">
                        <div class="col-lg-3 col-md-6">
                            <div class="card bg-primary text-white p-3">
                                <h4><i class="fa fa-users"></i> Total Users</h4>
                                <p><strong>1,250</strong></p>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <div class="card bg-success text-white p-3">
                                <h4><i class="fa fa-shopping-cart"></i> Orders</h4>
                                <p><strong>320</strong></p>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <div class="card bg-warning text-white p-3">
                                <h4><i class="fa fa-money"></i> Revenue</h4>
                                <p><strong>$15,200</strong></p>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <div class="card bg-danger text-white p-3">
                                <h4><i class="fa fa-exclamation-triangle"></i> Pending Issues</h4>
                                <p><strong>8</strong></p>
                            </div>
                        </div>
                    </div>

                    <!-- Charts -->
                    <div class="row mt-4">
                        <div class="col-md-6">
                            <canvas id="userChart"></canvas>
                        </div>
                        <div class="col-md-6">
                            <canvas id="orderChart"></canvas>
                        </div>
                    </div>

                    <!-- Recent Users Table -->
                    <div class="row mt-4">
                        <div class="col-md-12">
                            <h4>Recent Users</h4>
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

        <!-- jQuery and Bootstrap Scripts -->
        <script src="../js/jquery.min.js"></script>
        <script src="../js/bootstrap.min.js"></script>
        <script src="../js/Director/app.js"></script>
        <script src="../js/Director/dashboard.js"></script>

        <!-- Chart.js Script -->
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
    </body>
</html>
