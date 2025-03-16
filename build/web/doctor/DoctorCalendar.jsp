<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor Weekly Schedule</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FullCalendar CSS -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/main.min.css" rel="stylesheet" />
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/doctor_styles.css" rel="stylesheet">
    <style>
        .schedule-table {
            margin-top: 20px;
        }
        .schedule-table th, .schedule-table td {
            text-align: center;
            vertical-align: middle;
        }
    </style>
</head>
<body>
    <!-- Include Header và Sidebar (nếu có giao diện riêng cho bác sĩ) -->
    <jsp:include page="../admin/AdminHeader.jsp" />
    <jsp:include page="../admin/AdminLeftSideBar.jsp" />

    <!-- Đặt biến contextPath toàn cục cho JS -->
    <script>
        window.contextPath = '${pageContext.request.contextPath}';
    </script>

    <div class="right-side">
        <main class="main-content">
            <div class="container-fluid p-0">
                <!-- Tiêu đề -->
                <div class="mb-4">
                    <h2>Weekly Schedule</h2>
                    <p>Week: <strong>${weekStart}</strong> to <strong>${weekEnd}</strong></p>
                </div>
                <!-- Tab navigation -->
                <ul class="nav nav-tabs" id="scheduleTab" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="table-tab" data-bs-toggle="tab" data-bs-target="#tableView"
                                type="button" role="tab" aria-controls="tableView" aria-selected="true">
                            Table View
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="calendar-tab" data-bs-toggle="tab" data-bs-target="#calendarView"
                                type="button" role="tab" aria-controls="calendarView" aria-selected="false">
                            Calendar View
                        </button>
                    </li>
                </ul>
                <div class="tab-content" id="scheduleTabContent">
                    <!-- Table View -->
                    <div class="tab-pane fade show active" id="tableView" role="tabpanel" aria-labelledby="table-tab">
                        <table class="table table-bordered schedule-table mt-3">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Shift Time</th>
                                    <th>Shift Label</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${weeklySchedules}" var="schedule">
                                    <tr>
                                        <td>${schedule.scheduleDate}</td>
                                        <td>${schedule.shift.timeStart} - ${schedule.shift.timeEnd}</td>
                                        <td>K${schedule.shift.id}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${schedule.available}">
                                                    Available
                                                </c:when>
                                                <c:otherwise>
                                                    Not Available
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <!-- Calendar View -->
                    <div class="tab-pane fade" id="calendarView" role="tabpanel" aria-labelledby="calendar-tab">
                        <div id="fullcalendar" class="mt-3"></div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Modal hiển thị chi tiết ca khi bấm vào sự kiện -->
    <div class="modal fade" id="shiftDetailModal" tabindex="-1" aria-labelledby="shiftDetailModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header bg-primary text-white">
            <h5 class="modal-title" id="shiftDetailModalLabel">Shift Details</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
              <p id="shiftTimeDetail" class="mb-0"></p>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>

    <!-- In JSON events từ attribute của servlet -->
    <script>
        var doctorEvents = ${doctorEventsJson};
    </script>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- FullCalendar JS -->
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>
    <script>
        var calendar;
        $(document).ready(function () {
            $('button[data-bs-toggle="tab"]').on('shown.bs.tab', function (e) {
                if ($(e.target).attr("id") === "calendar-tab") {
                    if (!calendar) {
                        initCalendar();
                    } else {
                        calendar.refetchEvents();
                    }
                }
            });

            function initCalendar() {
                calendar = new FullCalendar.Calendar(document.getElementById('fullcalendar'), {
                    themeSystem: 'bootstrap5',
                    headerToolbar: {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'dayGridMonth,dayGridWeek,dayGridDay'
                    },
                    initialView: 'dayGridWeek',
                    initialDate: '${weekStart}',
                    dayMaxEventRows: 3,
                    moreLinkClick: 'popover',
                    expandRows: true,
                    selectable: false,
                    eventClick: function(info) {
                        var shiftTime = info.event.extendedProps.shiftTime || "No details available";
                        $("#shiftTimeDetail").text("Shift Time: " + shiftTime);
                        var modal = new bootstrap.Modal(document.getElementById('shiftDetailModal'));
                        modal.show();
                    },
                    events: doctorEvents
                });
                calendar.render();
            }
        });
        
    </script>
</body>
</html>
