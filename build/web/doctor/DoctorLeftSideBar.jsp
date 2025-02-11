<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Sidebar</title>
    </head>
    <body>
        <aside class="left-side sidebar-offcanvas" style="position: fixed">
            <!-- Sidebar -->
            <section class="sidebar">
                <!-- User panel -->
                <div class="user-panel">
                    <div class="pull-left image">
                        <img src="img/26115.jpg" class="img-circle" alt="User Image" />
                    </div>
                    <div class="pull-left info">
                        <p>Hello, 
                            @@
                        </p>
                        <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
                    </div>
                </div>


                <!-- Sidebar menu -->
                <ul class="sidebar-menu">
                    <li class="active dash-board">
                        <a href="../doctor/Dashboard.jsp">
                            <i class="fa fa-dashboard"></i> <span>Dash Board</span>
                        </a>
                    </li>
                    <li class="manage-medical">
                        <a href="../doctor/ManageMedical.jsp">
                            <i class="fa fa-user-plus"></i> <span>Manage Medical</span>
                        </a>
                    </li>
                    <li class="manage-application">
                        <a href="../doctor/SendApplication.jsp">
                            <i class="fa fa-file"></i> <span>Manage Application</span>
                        </a>
                    </li>
                    <li class="manage-calendar">
                        <a href="SimpleTables.jsp">
                            <i class="fa fa-tasks"></i> <span>Manage Calendar</span>
                        </a>
                    </li>
                </ul>
            </section>
            <!-- /.sidebar -->
        </aside>
        <!-- jQuery 2.0.2 -->
        <script src="../js/jquery.min.js" type="text/javascript"></script>
        <!-- Bootstrap -->
        <script src="../js/bootstrap.min.js" type="text/javascript"></script>
        <!-- Director App -->
        <script src="../js/Director/app.js" type="text/javascript"></script>

        <!-- Director dashboard demo (This is only for demo purposes) -->
        <script src="../js/Director/dashboard.js" type="text/javascript"></script>
    </body>
</html>
