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
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <%-- Include Header and Sidebar --%>
        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />

        <!-- Đặt biến contextPath toàn cục cho JS -->
        <script>
            window.contextPath = '${pageContext.request.contextPath}';
        </script>

        <div class="right-side">
            <main class="main-content">
                <div class="container-fluid p-0">
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="card-title mb-0">Doctor Schedule Management</h5>
                                    <div>
                                        <select class="form-select me-2" id="cycleSelect">
                                            <option value="0">Current Month</option>
                                            <option value="3">3 Months</option>
                                            <option value="6">6 Months</option>
                                            <option value="12">12 Months</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <!-- Nếu chỉ gán cho 1 bác sĩ, bỏ attribute "multiple" -->
                        <div class="col-3">
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

                            <div class="card mt-3">
                                <div class="card-header">
                                    <h5 class="card-title">Shift Management</h5>
                                </div>
                                <div class="card-body">
                                    <form id="shiftForm">
                                        <div class="mb-3">
                                            <label class="form-label">Shift Type</label>
                                            <select class="form-select" id="shiftType">
                                                <c:forEach items="${shifts}" var="shift">
                                                    <!-- Giá trị option chứa shift id -->
                                                    <option value="${shift.id}">${shift.timeStart} - ${shift.timeEnd}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Select Date</label>
                                            <input type="date" class="form-control" id="shiftDate">
                                        </div>
                                        <!-- Thêm select cho Recurrence -->
                                        <div class="mb-3">
                                            <label class="form-label">Recurrence (months)</label>
                                            <select class="form-select" id="assignCycle">
                                                <option value="0">No Recurrence</option>
                                                <option value="3">3 Months</option>
                                                <option value="6">6 Months</option>
                                                <option value="12">12 Months</option>
                                            </select>
                                        </div>

                                        <button type="button" class="btn btn-primary" id="assignShift">Assign Shift</button>
                                    </form>
                                </div>
                            </div>
                        </div>

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

        <!-- Scripts -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <script src="../js/fullcalendar.js" type="text/javascript"></script>
        <script>
            var calendar; // biến toàn cục cho calendar

            $(document).ready(function () {
                $('#doctorSelect').select2({
                    placeholder: "Select doctors",
                    allowClear: true
                });

                calendar = new FullCalendar.Calendar(document.getElementById('fullcalendar'), {
                    themeSystem: 'bootstrap5',
                    initialView: 'dayGridMonth',
                    headerToolbar: {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'dayGridMonth,timeGridWeek,timeGridDay'
                    },
                    views: {
                        timeGridWeek: {
                            titleFormat: {year: 'numeric', month: 'short', day: 'numeric'},
                            slotLabelFormat: {hour: '2-digit', minute: '2-digit', hour12: false}
                        },
                        timeGridDay: {
                            titleFormat: {year: 'numeric', month: 'short', day: 'numeric'},
                            slotLabelFormat: {hour: '2-digit', minute: '2-digit', hour12: false}
                        }
                    },
                    selectable: true,
                    select: function (info) {
                        handleDateSelection(info);
                    },
                    eventClick: function (info) {
                        handleEventClick(info);
                    },
                    // Tùy chỉnh hiển thị event với thông tin chi tiết, bao gồm hiển thị K<shiftId>
                    eventContent: function (info) {
                        const doctor = info.event.extendedProps.doctor || {};
                        const doctorName = doctor.name || '';
                        const specialties = doctor.specialties ? doctor.specialties.join(', ') : '';
                        const shiftId = info.event.extendedProps.shiftId || '';
                        const shiftLabel = shiftId ? 'K' + shiftId : '';
                        const shiftTime = info.event.extendedProps.shiftTime || info.event.title || '';
                        const html = `
                            <div class="fc-event-custom">
                                <div><strong>${doctorName} ${shiftLabel}</strong></div>
                                <div><small>${specialties}</small></div>
                                <div>${shiftTime}</div>
                            </div>
                        `;
                        return {html: html};
                    },
                    events: function (info, successCallback, failureCallback) {
                        fetchEvents(info.start, info.end, successCallback, failureCallback);
                    }
                });

                calendar.render();

                // Bind event cho cycle select (để lọc sự kiện view calendar)
                $('#cycleSelect').off('change').on('change', function () {
                    updateCalendarView(this.value);
                });

                // Bind event cho nút assign shift (chỉ bind một lần)
                $('#assignShift').off('click').on('click', function (e) {
                    e.preventDefault();
                    assignShiftToDoctor();
                });
            });

            function handleDateSelection(info) {
                console.log('Selected range:', info.startStr, 'to', info.endStr);
            }

            function handleEventClick(info) {
                alert(`Doctor: ${info.event.extendedProps.doctor.name || 'N/A'}\nShift: ${info.event.extendedProps.shiftTime || info.event.title}`);
            }

            function fetchEvents(start, end, successCallback, failureCallback) {
                const startDate = start.toISOString().split('T')[0];
                const endDate = end.toISOString().split('T')[0];
                const url = window.contextPath + '/hr/calendarmanage?action=getEvents&start=' + startDate + '&end=' + endDate;

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
                            if (failureCallback)
                                failureCallback(error);
                        });
            }

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

            function assignShiftToDoctor() {
                const doctorId = $('#doctorSelect').val();
                const shiftId = $('#shiftType').val();
                const shiftDate = $('#shiftDate').val();
                const cycle = parseInt($('#assignCycle').val());  // Lấy giá trị recurrence (0,3,6,12)

                console.log('Assigning shift:', {doctorId, shiftId, shiftDate, cycle});

                // 1) Kiểm tra xem người dùng có chọn recurrence > 0 không
                if (cycle > 0) {
                    // 2) Kiểm tra xem shiftDate có phải là Thứ Tư không
                    // Trong JS, getDay() trả về: 0=Chủ nhật, 1=Thứ Hai, 2=Thứ Ba, 3=Thứ Tư, ...
                    const dt = new Date(shiftDate);
                    const dayOfWeek = dt.getDay();
                    if (dayOfWeek !== 3) { // 3 = Wednesday
                        alert('Bạn đã chọn lặp lại (Recurrence), vui lòng chọn ngày gốc là Thứ Tư!');
                        return; // Không gửi AJAX
                    }
                }

                // Nếu OK, tiếp tục gửi AJAX
                $.ajax({
                    url: window.contextPath + '/hr/calendarmanage?action=assignShift',
                    type: 'POST',
                    data: {
                        doctorId: doctorId,
                        shiftType: shiftId,
                        shiftDate: shiftDate,
                        cycle: cycle
                    },
                    success: function (response) {
                        console.log('Assign shift response:', response);
                        if (response.success) {
                            alert('Shift assigned successfully!');
                            calendar.refetchEvents();
                        } else {
                            alert('Failed to assign shift.');
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error('Error occurred:', status, error);
                        alert('An error occurred while assigning shift.');
                    }
                });
            }


        </script>
    </body>
</html>
