<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Calendar Manage</title>
        <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/main.min.css" rel="stylesheet" />
        <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <%-- Include Header and Sidebar --%>
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />

        <div class="right-side"> <%-- Use right-side class --%>
            <main class="main-content">
                <div class="container-fluid p-0">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title">FullCalendar</h5>
                        </div>
                        <div class="card-body">
                            <div id="fullcalendar"></div>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <!-- Include FullCalendar JS *after* jQuery and Bootstrap -->
        <script src="${pageContext.request.contextPath}/js/fullcalendar.js"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                var calendarEl = document.getElementById("fullcalendar");
                var calendar = new FullCalendar.Calendar(calendarEl, {
                    themeSystem: "bootstrap5", // Use Bootstrap 5 theme
                    initialView: "dayGridMonth",
                    initialDate: "2021-07-07",
                    headerToolbar: {
                        left: "prev,next today",
                        center: "title",
                        right: "dayGridMonth,timeGridWeek,timeGridDay"
                    },
                    events: [/* Your event data */]
                });
                calendar.render();
            });
        </script>
        <%-- ... other scripts (if needed) specific to this page ... --%>

    </body>
</html>