<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Calendar Manage</title>
    <!-- FullCalendar CSS -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/main.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Select2 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />

    <!-- CSS tùy chỉnh cho sự kiện (hiển thị dưới dạng block có màu) -->
    <style>
        .fc-event-custom-style {
            background-color: #0d6efd; /* Màu xanh Bootstrap */
            color: #fff;
            padding: 2px 4px;
            border-radius: 4px;
            margin-bottom: 2px;
            font-size: 0.75rem;
            white-space: normal;
        }
    </style>
</head>
<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
    <!-- Include Header and Sidebar -->
    <jsp:include page="../admin/AdminHeader.jsp" />
    <jsp:include page="../admin/AdminLeftSideBar.jsp" />

    <!-- Đặt biến contextPath toàn cục cho JS -->
    <script>
        window.contextPath = '${pageContext.request.contextPath}';
    </script>

    <!-- Hiển thị alert nếu có success hoặc error -->
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
                <!-- Header -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="card-title mb-0">Doctor Schedule Management</h5>
                                <div></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <!-- Bên trái: Form Assign Shift -->
                    <div class="col-3">
                        <!-- Danh sách bác sĩ (không dùng cho form) -->
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title">Available Doctors</h5>
                            </div>
                            <div class="card-body">
                                <select class="form-control" id="doctorSelect">
                                    <c:forEach items="${doctors}" var="doctor">
                                        <option value="${doctor.id}">${doctor.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <!-- Form Assign Shift -->
                        <div class="card mt-3">
                            <div class="card-header">
                                <h5 class="card-title">Shift Management</h5>
                            </div>
                            <div class="card-body">
                                <form id="shiftForm" action="${pageContext.request.contextPath}/hr/calendarmanage?action=assignShift" method="post">
                                    <div class="mb-3">
                                        <label class="form-label">Available Doctors</label>
                                        <select class="form-control" name="doctorId" id="doctorSelect">
                                            <c:forEach items="${doctors}" var="doctor">
                                                <option value="${doctor.id}">${doctor.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Shift Type</label>
                                        <select class="form-select" name="shiftType" id="shiftType">
                                            <c:forEach items="${shifts}" var="shift">
                                                <option value="${shift.id}">
                                                    ${shift.timeStart} - ${shift.timeEnd}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Select Date</label>
                                        <input type="date" class="form-control" name="shiftDate" id="shiftDate">
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Recurrence (months)</label>
                                        <select class="form-select" name="cycle" id="assignCycle">
                                            <option value="0">No Recurrence</option>
                                            <option value="3">3 Months</option>
                                            <option value="6">6 Months</option>
                                            <option value="12">12 Months</option>
                                        </select>
                                    </div>
                                    <button type="submit" class="btn btn-primary">Assign Shift</button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Bên phải: FullCalendar -->
                    <div class="col-9">
                        <div class="card">
                            <div class="card-body">
                                <div id="fullcalendar"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Modal Edit/Delete Shift -->
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
              <!-- Hidden field chứa scheduleId -->
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
    
    <!-- Không load file js cũ nữa -->
    <!-- <script src="../js/fullcalendar.js" type="text/javascript"></script> -->

    <script>
        var calendar;

        $(document).ready(function () {
            // Khởi tạo select2 cho doctorSelect
            $('#doctorSelect').select2({
                placeholder: "Select doctors",
                allowClear: true
            });

            // Khởi tạo FullCalendar sử dụng dayGrid (không có lưới giờ)
            calendar = new FullCalendar.Calendar(document.getElementById('fullcalendar'), {
                themeSystem: 'bootstrap5',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,dayGridWeek,dayGridDay'
                },
                initialView: 'dayGridMonth',
                dayMaxEventRows: 3,
                moreLinkClick: 'popover',
                expandRows: true,
                selectable: true,
                select: function (info) {
                    console.log('Selected range:', info.startStr, 'to', info.endStr);
                },
                // Khi click vào sự kiện, mở modal để Edit/Delete
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

                    // Hiển thị modal
                    $('#editModal').modal('show');
                },
                // Tùy chỉnh hiển thị sự kiện
                eventContent: function (info) {
                    const doctor = info.event.extendedProps.doctor || {};
                    const doctorName = doctor.name || 'N/A';
                    const specialties = doctor.specialties ? doctor.specialties.join(', ') : '';
                    const shiftId = info.event.extendedProps.shiftId || '';
                    const shiftLabel = shiftId ? 'K' + shiftId : '';
                    const shiftTime = info.event.extendedProps.shiftTime || info.event.title || '';
                    const html = `
                        <div>
                            <div><strong>${doctorName} ${shiftLabel}</strong></div>
                            <div><small>${specialties}</small></div>
                            <div>${shiftTime}</div>
                        </div>
                    `;
                    return { html: html };
                },
                events: function (info, successCallback, failureCallback) {
                    fetchEvents(info.start, info.end, successCallback, failureCallback);
                }
            });

            calendar.render();

            // Xử lý nút Save (Update) trong modal
            $('#saveEditBtn').off('click').on('click', function () {
                const scheduleId = $('#editScheduleId').val();
                const shiftDate = $('#editShiftDate').val();
                const shiftType = $('#editShiftType').val();

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
                            calendar.refetchEvents();
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

            // Xử lý nút Delete trong modal
            $('#deleteBtn').off('click').on('click', function () {
                if (!confirm('Are you sure you want to delete this shift?')) return;

                const scheduleId = $('#editScheduleId').val();
                $.ajax({
                    url: window.contextPath + '/hr/calendarmanage?action=deleteShift',
                    type: 'POST',
                    data: { scheduleId: scheduleId },
                    success: function (response) {
                        if (response.success) {
                            alert('Deleted successfully!');
                            $('#editModal').modal('hide');
                            calendar.refetchEvents();
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

        // Hàm fetchEvents: gọi AJAX để lấy danh sách sự kiện cho FullCalendar
        function fetchEvents(start, end, successCallback, failureCallback) {
            const startDate = start.toISOString().split('T')[0];
            const endDate = end.toISOString().split('T')[0];
            const url = window.contextPath + '/hr/calendarmanage?action=getEvents'
                        + '&start=' + startDate
                        + '&end=' + endDate;

            console.log('Fetching events from', startDate, 'to', endDate);

            fetch(url)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response error: ' + response.statusText);
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('Fetched events:', data);
                    successCallback(data);
                })
                .catch(error => {
                    console.error('Error fetching events:', error);
                    if (failureCallback) failureCallback(error);
                });
        }

        // Nếu cần, hàm updateCalendarView(cycle) để thay đổi phạm vi lịch
        function updateCalendarView(cycle) {
            const today = new Date();
            if (cycle == 0) {
                calendar.setOption('validRange', null);
            } else {
                const endDate = new Date(today);
                endDate.setMonth(today.getMonth() + parseInt(cycle));
                calendar.setOption('validRange', {
                    start: today,
                    end: endDate
                });
            }
            calendar.changeView('dayGridMonth');
            calendar.gotoDate(today);
            calendar.refetchEvents();
        }
    </script>
</body>
</html>
