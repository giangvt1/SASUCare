<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Doctor Weekly Schedule</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FullCalendar CSS -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/main.min.css" rel="stylesheet" />
    <!-- Custom Admin CSS (nếu có) -->
    <link href="${pageContext.request.contextPath}/css/admin_styles.css" rel="stylesheet">
    <style>
        .schedule-table {
            margin-top: 20px;
        }
        .schedule-table th, .schedule-table td {
            text-align: center;
            vertical-align: middle;
        }
        /* Style cho sự kiện FullCalendar */
        .fc-event-custom-style {
            background-color: #0d6efd; /* Màu xanh bootstrap */
            color: #fff;
            padding: 2px 4px;
            border-radius: 4px;
            margin-bottom: 2px;
            font-size: 0.85rem;
            white-space: normal;
        }
    </style>
</head>
<body>
    <!-- Include Header và Sidebar -->
    <jsp:include page="../admin/AdminHeader.jsp" />
    <jsp:include page="../admin/AdminLeftSideBar.jsp" />

    <!-- Đặt biến contextPath toàn cục cho JS -->
    <script>
        window.contextPath = '${pageContext.request.contextPath}';
    </script>

    <!-- Hiển thị alert nếu có success/error -->
    <c:if test="${param.success == '1'}">
        <script>alert('Assign Shift successfully!');</script>
    </c:if>
    <c:if test="${param.error == '1'}">
        <script>alert('Assign Shift failed!');</script>
    </c:if>
    <c:if test="${param.error == 'Exception'}">
        <script>alert('Assign Shift failed!');</script>
    </c:if>

    <div class="right-side">
        <main class="main-content">
            <div class="container-fluid p-0">
                <!-- Tiêu đề -->
                <div class="mb-4">
                    <h2>Weekly Schedule for Dr. ${doctor.name}</h2>
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

    <!-- Modal Edit/Delete Shift (nếu cần) -->
    <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="editModalLabel">Edit or Delete Shift</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <!-- Hiển thị thông tin bác sĩ (read-only) -->
            <div class="mb-3">
                <label for="editDoctorName" class="form-label">Doctor</label>
                <input type="text" class="form-control" id="editDoctorName" readonly>
            </div>
            <form id="editShiftForm">
              <input type="hidden" id="editScheduleId">
              <div class="mb-3">
                <label for="editShiftDate" class="form-label">Select Date</label>
                <input type="date" class="form-control" id="editShiftDate">
              </div>
              <div class="mb-3">
                <label for="editShiftType" class="form-label">Shift Type</label>
                <select class="form-select" id="editShiftType">
                  <c:forEach items="${shifts}" var="shift">
                    <option value="${shift.id}">
                      ${shift.timeStart} - ${shift.timeEnd}
                    </option>
                  </c:forEach>
                </select>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-danger" id="deleteBtn">Delete</button>
            <button type="button" class="btn btn-primary" id="saveEditBtn">Save</button>
          </div>
        </div>
      </div>
    </div>
    <!-- End Modal -->

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <!-- FullCalendar JS -->
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>
    
    <script>
        var calendar;

        $(document).ready(function () {
            // Khởi tạo select2 cho select danh sách bác sĩ
            $('#doctorSelect').select2({
                placeholder: "Select doctors",
                allowClear: true
            });

            // Hàm khởi tạo FullCalendar
            function initCalendar() {
                calendar = new FullCalendar.Calendar(document.getElementById('fullcalendar'), {
                    themeSystem: 'bootstrap5',
                    headerToolbar: {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'dayGridMonth,dayGridWeek,dayGridDay'
                    },
                    // Bắt đầu tuần hiển thị:
                    initialView: 'dayGridWeek',
                    // Di chuyển calendar tới ngày weekStart:
                    initialDate: '${weekStart}',

                    dayMaxEventRows: 3,
                    moreLinkClick: 'popover',
                    expandRows: true,
                    selectable: true,
                    // Khi click vào sự kiện, mở modal
                    eventClick: function (info) {
                        const scheduleId = info.event.id;
                        const eventDate = info.event.startStr;
                        const shiftId = info.event.extendedProps.shiftId;
                        const doctor = info.event.extendedProps.doctor || {};
                        const doctorName = doctor.name || 'N/A';

                        // Điền dữ liệu vào modal
                        $('#editScheduleId').val(scheduleId);
                        $('#editShiftDate').val(eventDate);
                        $('#editShiftType').val(shiftId);
                        $('#editDoctorName').val(doctorName);

                        // Mở modal
                        $('#editModal').modal('show');
                    },
                    // Gán class custom style
                    eventClassNames: function(arg) {
                        return ['fc-event-custom-style'];
                    },
                    // Tùy chỉnh nội dung hiển thị
                    eventContent: function(info) {
                        const doctor = info.event.extendedProps.doctor || {};
                        const doctorName = doctor.name || 'N/A';
                        const shiftId = info.event.extendedProps.shiftId || '';
                        const shiftLabel = shiftId ? 'K' + shiftId : '';
                        const shiftTime = info.event.extendedProps.shiftTime || info.event.title || '';
                        const html = `
                            <div>
                                <div><strong>${doctorName} ${shiftLabel}</strong></div>
                                <div>${shiftTime}</div>
                            </div>
                        `;
                        return { html: html };
                    },
                    // Tạo mảng events từ weeklySchedules
                    events: function(info, successCallback, failureCallback) {
                        var events = [];
                        <c:forEach items="${weeklySchedules}" var="schedule">
                            events.push({
                                id: "${schedule.id}",
                                title: "${schedule.shift.timeStart} - ${schedule.shift.timeEnd}",
                                start: "${schedule.scheduleDate}",
                                extendedProps: {
                                    doctor: {
                                        name: "${schedule.doctor.name}"
                                    },
                                    shiftId: "${schedule.shift.id}",
                                    shiftTime: "${schedule.shift.timeStart} - ${schedule.shift.timeEnd}"
                                }
                            });
                        </c:forEach>
                        successCallback(events);
                    }
                });
                calendar.render();
            }
            
            // Khởi tạo FullCalendar khi tab Calendar được kích hoạt
            $('a[data-bs-toggle="tab"]').on('shown.bs.tab', function (e) {
                if ($(e.target).attr("id") === "calendar-tab") {
                    if (!calendar) {
                        initCalendar();
                    } else {
                        calendar.refetchEvents();
                    }
                }
            });
            
            // Xử lý nút Save (Update) trong modal
            $('#saveEditBtn').off('click').on('click', function () {
                const scheduleId = $('#editScheduleId').val();
                const shiftDate = $('#editShiftDate').val();
                const shiftType = $('#editShiftType').val();

                // AJAX updateShift
                $.ajax({
                    url: window.contextPath + '/hr/calendarmanage?action=updateShift',
                    type: 'POST',
                    data: {
                        scheduleId: scheduleId,
                        shiftDate: shiftDate,
                        shiftType: shiftType
                    },
                    success: function (response) {
                        if (response.success) {
                            alert('Update successfully!');
                            $('#editModal').modal('hide');
                            if (calendar) calendar.refetchEvents();
                        } else {
                            alert('Update failed!');
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error('Error occurred:', status, error);
                        alert('An error occurred while updating shift.');
                    }
                });
            });

            // Nút Delete
            $('#deleteBtn').off('click').on('click', function () {
                if (!confirm('Are you sure you want to delete this shift?')) return;
                const scheduleId = $('#editScheduleId').val();
                
                // AJAX deleteShift
                $.ajax({
                    url: window.contextPath + '/hr/calendarmanage?action=deleteShift',
                    type: 'POST',
                    data: { scheduleId: scheduleId },
                    success: function (response) {
                        if (response.success) {
                            alert('Deleted successfully!');
                            $('#editModal').modal('hide');
                            if (calendar) calendar.refetchEvents();
                        } else {
                            alert('Delete failed!');
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error('Error occurred:', status, error);
                        alert('An error occurred while deleting shift.');
                    }
                });
            });
        });
    </script>
</body>
</html>
