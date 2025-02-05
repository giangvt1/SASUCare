<%-- 
    Document   : AdminLeftSideBar
    Created on : 20 thg 1, 2025, 19:56:29
    Author     : TRUNG
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <aside class="left-side sidebar-offcanvas">
            <!-- Sidebar -->
            <section class="sidebar">
                <!-- User panel -->
                <div class="user-panel">
                    <div class="pull-left image">
                        <img src="../img/meoomdau.jpg" class="img-circle" alt="User Image" />
                    </div>
                    <div class="pull-left info">
                        <p>Hello, 
                            <% 
                                model.system.User account = (model.system.User) session.getAttribute("account");
                                if (account != null) {
                                    out.print(account.getDisplayname());
                                } else {
                                    out.print("Guest");
                                }
                            %>
                        </p>
                        <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
                    </div>

                </div>

              <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
            </div>
          </div>
          <!-- search form -->
          <form action="#" method="get" class="sidebar-form">
            <div class="input-group">
              <input
                type="text"
                name="q"
                class="form-control"
                placeholder="Search..."
              />
              <span class="input-group-btn">
                <button
                  type="submit"
                  name="seach"
                  id="search-btn"
                  class="btn btn-flat"
                >
                  <i class="fa fa-search"></i>
                </button>
              </span>
            </div>
          </form>
          <!-- /.search form -->
          <!-- sidebar menu: : style can be found in sidebar.less -->
          <ul class="sidebar-menu">
            <li class="active">
              <a href="index.html">
                <i class="fa fa-dashboard"></i> <span>Dashboard</span>
              </a>
            </li>
            <li>
              <a href="general.html">
                <i class="fa fa-gavel"></i> <span>General</span>
              </a>
            </li>

            <li>
              <a href="basic_form.html">
                <i class="fa fa-globe"></i> <span>Basic Elements</span>
              </a>
            </li>

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
                        <a href="../hr/accountlist">
                            <i class="fa fa-globe"></i> <span>Account List</span>
                        </a>
                    </li>
                    <li>
                        <a href="../hr/calendarmanage">
                            <i class="fa fa-table"></i> <span>Doctor Calendar</span>
                        </a>
                    </li>
                </ul>
            </section>
            <!-- /.sidebar -->
        </aside>
    </body>
</html>
