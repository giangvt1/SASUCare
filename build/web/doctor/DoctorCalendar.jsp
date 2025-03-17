<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Doctor Weekly Schedule</title>
        <!-- Bootstrap CSS (phiên bản dùng chung với header) -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- FullCalendar CSS -->
        <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/main.min.css" rel="stylesheet" />
        <!-- Custom CSS (nếu cần) -->
        <link href="${pageContext.request.contextPath}/css/doctor_styles.css" rel="stylesheet">
        <style>
            .schedule-table {
                margin-top: 20px;
            }
            .schedule-table th, .schedule-table td {
                text-align: center;
                vertical-align: middle;
            }
            /* FullCalendar style */
            .fc {
                z-index: 1 !important;
                position: relative;
                overflow: visible !important;
            }
            .fc .dropdown-menu {
                z-index: 1051 !important;
                position: absolute !important;
                top: 100% !important;
            }
            #fullcalendar {
                background-color: #ffffff;
                border: 1px solid #dee2e6;
                border-radius: 0.25rem;
                padding: 1rem;
                box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
                margin-top: 1rem;
            }
            /* Toolbar style */
            .fc .fc-toolbar-title {
                font-size: 1.25rem;
                font-weight: 500;
            }
            .fc .fc-button {
                border: none;
                background-color: transparent;
                font-size: 1rem;
                color: #0d6efd;
            }
            .fc .fc-button:hover {
                background-color: #e9ecef;
            }
        </style>
    </head>
    <body>
        <!-- Include Header và Sidebar (jQuery & Bootstrap được load từ AdminHeader.jsp) -->
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <!-- Đặt biến contextPath toàn cục cho JS -->
        <script>
            window.contextPath = '${pageContext.request.contextPath}';
        </script>

        <div class="right-side">
            <main class="main-content">
                <div class="container-fluid p-0">
                    <!-- Tiêu đề trang -->
                    <div class="mb-4">
                        <h2>Weekly Schedule</h2>
                        <p>Week: <strong>${weekStart}</strong> to <strong>${weekEnd}</strong></p>
                    </div>
                    <!-- Navigation Tab -->
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
                        <!-- Table View: hiển thị danh sách lịch -->
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
                        <!-- Calendar View: hiển thị lịch bằng FullCalendar -->
                        <div class="tab-pane fade" id="calendarView" role="tabpanel" aria-labelledby="calendar-tab">
                            <div id="fullcalendar"></div>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <!-- Modal hiển thị chi tiết ca khi bấm vào sự kiện (nếu cần) -->
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

        <!-- FullCalendar JS (jQuery & Bootstrap đã được load trong AdminHeader.jsp) -->
        <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>
        <script>
            var calendar;
            $(document).ready(function () {
                // Khi tab Calendar được active, khởi tạo FullCalendar nếu chưa có
                $('button[data-bs-toggle="tab"]').on('shown.bs.tab', function (e) {
                    if ($(e.target).attr("id") === "calendar-tab") {
                        if (!calendar) {
                            initCalendar();
                        } else {
                            // Khi quay lại tab Calendar, có thể refetchEvents() nếu cần
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
                        // View mặc định
                        initialView: 'dayGridWeek',
                        dayMaxEventRows: 3,
                        moreLinkClick: 'popover',
                        expandRows: true,
                        selectable: false,
                        // Lấy events động qua AJAX
                        events: function(info, successCallback, failureCallback) {
                            var startDate = info.startStr.split('T')[0]; // "YYYY-MM-DD"
                            var endDate = info.endStr.split('T')[0];
                            // Gọi action=getEvents
                            $.ajax({
                                url: window.contextPath + '/doctor/calendar?action=getEvents',
                                type: 'GET',
                                data: {
                                    start: startDate,
                                    end: endDate
                                },
                                success: function(response) {
                                    successCallback(response);
                                },
                                error: function() {
                                    failureCallback();
                                }
                            });
                        },
                        eventContent: function (info) {
                            var shiftId = info.event.extendedProps.shiftId;
                            var shiftColors = {
                                '1': '#0d6efd',
                                '2': '#198754',
                                '3': '#dc3545',
                                '4': '#ffc107'
                            };
                            var bgColor = shiftColors[shiftId] || '#0d6efd';
                            var title = info.event.title || '';
                            var shiftTime = info.event.extendedProps.shiftTime || '';
                            var appointmentId = info.event.extendedProps.appointmentId;
                            var appointmentStatus = info.event.extendedProps.appointmentStatus || "";
                            var customerName = info.event.extendedProps.customerName || "";

                            var html = '<div style="background-color:' + bgColor + '; color:#fff; padding:8px 12px; border-radius:4px; white-space: normal;">';
                            html += '<div style="font-size:1.1rem; font-weight:bold;">' + title + '</div>';
                            html += '<div style="font-size:1rem;">' + shiftTime + '</div>';
                            if (appointmentId) {
                                html += '<div style="font-size:0.9rem; margin-top:4px;">Appointment: ' + appointmentId + '</div>';
                                html += '<div style="font-size:0.9rem;">Customer: ' + customerName + '</div>';
                                html += '<div style="font-size:0.9rem;">Status: ' + appointmentStatus + '</div>';
                            }
                            html += '</div>';
                            return {html: html};
                        },
                        eventClick: function (info) {
                            var shiftTime = info.event.extendedProps.shiftTime || "No details available";
                            $("#shiftTimeDetail").text("Shift Time: " + shiftTime);
                            var modal = new bootstrap.Modal(document.getElementById('shiftDetailModal'));
                            modal.show();
                        }
                    });
                    calendar.render();
                }
            });
        </script>
    </body>
</html>
