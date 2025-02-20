<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <!-- Title -->
        <title>Calendar Manage</title>

        <link href="../css/admin/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/admin/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/admin/styleAdmin.css" rel="stylesheet" type="text/css"/>
        <style>
            .main-content {
                margin-top: 50px;
                margin-left: 260px;
                padding: 20px;
            }
            .alert {
                margin-top: 20px;
            }
        </style>

        <!-- Settings and Analytics -->
        <script src="../js/settings.js" type="text/javascript"></script>
        <script async src="https://www.googletagmanager.com/gtag/js?id=UA-120946860-10"></script>
        <script>
            window.dataLayer = window.dataLayer || [];
            function gtag() {
                dataLayer.push(arguments);
            }
            gtag('js', new Date());
            gtag('config', 'UA-120946860-10', {'anonymize_ip': true});
        </script>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <div class="main">
                <!-- Include Header and Left Sidebar -->
                <jsp:include page="../admin/AdminHeader.jsp" />
                <jsp:include page="../admin/AdminLeftSideBar.jsp" />

                <!-- Main Content -->
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
        </div>
        <script src="../js/jquery.min.js" type="text/javascript"></script>
        <script src="../js/bootstrap.min.js" type="text/javascript"></script>
        <script src="../js/main.js" type="text/javascript"></script>
        <!-- Scripts -->
        <script src="../js/fullcalendar.js" type="text/javascript"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                var calendarEl = document.getElementById("fullcalendar");
                var calendar = new FullCalendar.Calendar(calendarEl, {
                    themeSystem: "bootstrap",
                    initialView: "dayGridMonth",
                    initialDate: "2021-07-07",
                    headerToolbar: {
                        left: "prev,next today",
                        center: "title",
                        right: "dayGridMonth,timeGridWeek,timeGridDay"
                    },
                    events: [
                        {title: "All Day Event", start: "2021-07-01"},
                        {title: "Long Event", start: "2021-07-07", end: "2021-07-10"},
                        {groupId: "999", title: "Repeating Event", start: "2021-07-09T16:00:00"},
                        {groupId: "999", title: "Repeating Event", start: "2021-07-16T16:00:00"},
                        {title: "Conference", start: "2021-07-11", end: "2021-07-13"},
                        {title: "Meeting", start: "2021-07-12T10:30:00", end: "2021-07-12T12:30:00"},
                        {title: "Lunch", start: "2021-07-12T12:00:00"},
                        {title: "Meeting", start: "2021-07-12T14:30:00"},
                        {title: "Birthday Party", start: "2021-07-13T07:00:00"},
                        {title: "Click for Google", url: "http://google.com/", start: "2021-07-28"}
                    ]
                });
                setTimeout(function () {
                    calendar.render();
                }, 250);
            });
        </script>
        <script>
            document.addEventListener("DOMContentLoaded", function (event) {
                setTimeout(function () {
                    if (localStorage.getItem('popState') !== 'shown') {
                        if (window.notyfccess",
                                message: "Get access to all 500+ components and 45+ pages with AdminKit PRO. <u><a class=\"text-white\" href=\"https://adminkit.io/pricing\" target=\"_blank\">More info</a></u> 🚀",
                                duration: 10000,
                                ripple: true,
                                dismissible: false,
                                position: {
                                    x: "left", && typeof window.notyf.open === 'function') {
                            window.notyf.open({
                                type: "success",
                                message: "Get access to all 500+ components and 45+ pages with AdminKit PRO. <u><a class=\"text-white\" href=\"https://adminkit.io/pricing\" target=\"_blank\">More info</a></u> 🚀",
                                duration: 10000,
                                ripple: true,
                                dismissible: false,
                                position: {
                                    x: "left",
                                    y: "bottom"
                                }
                            });
                        }
                        localStorage.setItem('popState', 'shown');
                    }
                }, 15000);
            });
        </script>
    </body>
</html>
