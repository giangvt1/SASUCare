<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Sidebar</title>
        <!-- Add your CSS libraries -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    </head>
    <body>
        <aside class="left-side sidebar-offcanvas">
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


                <!-- Search form -->
                <form action="#" method="get" class="sidebar-form">
                    <div class="input-group">
                        <input type="text" name="q" class="form-control" placeholder="Search...">
                        <span class="input-group-btn">
                            <button type="submit" name="search" id="search-btn" class="btn btn-flat">
                                <i class="fa fa-search"></i>
                            </button>
                        </span>
                    </div>
                </form>

                <!-- Sidebar menu -->
                <ul class="sidebar-menu">
                    <li class="active">
                        <a href="../admin/Dashboard.jsp">
                            <i class="fa fa-dashboard"></i> <span>Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="../hr/create">
                            <i class="fa fa-user-plus"></i> <span>Create Account</span>
                        </a>
                    </li>
                    <li>
                        <a href="BasicElements.jsp">
                            <i class="fa fa-globe"></i> <span>Basic Elements</span>
                        </a>
                    </li>
                    <li>
                        <a href="SimpleTables.jsp">
                            <i class="fa fa-table"></i> <span>Simple Tables</span>
                        </a>
                    </li>
                </ul>
            </section>
            <!-- /.sidebar -->
        </aside>
    </body>
</html>
