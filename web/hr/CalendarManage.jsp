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
    <!-- Bootstrap CSS (phiên bản giống với header) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Select2 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    
    <style>
      /* Style chung cho sự kiện hiển thị trên lịch */
      .fc-daygrid-event, .fc-timegrid-event {
          font-size: 0.9rem;
          line-height: 1.2;
          padding: 2px 4px;
          border-radius: 4px;
          white-space: normal; /* Cho phép xuống dòng */
          margin-bottom: 2px;
      }
      /* Đảm bảo FullCalendar có stacking context riêng không ảnh hưởng tới header */
      .fc {
          z-index: 1 !important;
          position: relative;
          overflow: visible !important;
      }
      /* Chỉ áp dụng style cho dropdown trong FullCalendar */
      .fc .dropdown-menu {
          z-index: 1051 !important;
          position: absolute !important;
          top: 100% !important;
          /* Không ép display, để Bootstrap điều khiển */
      }
      /* Chỉnh Select2 dropdown */
      .select2-container {
          z-index: 1051 !important;
      }
      .select2-dropdown {
          position: absolute !important;
      }
    </style>
  </head>
  <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
      <!-- Include Header và Sidebar (Header đã load jQuery & Bootstrap phiên bản 5.3.0) -->
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
                  <!-- Header nội dung của trang Calendar -->
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
                      <!-- Bên trái: Form Assign Shift & danh sách bác sĩ -->
                      <div class="col-3">
                          <div class="card">
                              <div class="card-header">
                                  <h5 class="card-title">Available Doctors</h5>
                              </div>
                              <div class="card-body">
                                  <select class="form-control select2" id="doctorSelectView">
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
                                  <form id="shiftForm" action="${pageContext.request.contextPath}/hr/calendarmanage?action=assignShift" method="post">
                                      <div class="mb-3">
                                          <label class="form-label">Available Doctors</label>
                                          <select class="form-control" name="doctorId" id="doctorSelectForm">
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

      <!-- Chỉ load Select2 JS (các file jQuery & Bootstrap đã được load trong AdminHeader.jsp) -->
      <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
      <script>
          var calendar;
          $(document).ready(function () {
              // Khởi tạo Select2 cho các select
              $('#doctorSelectView').select2({
                  placeholder: "Select doctor",
                  allowClear: true,
                  dropdownParent: $('body')
              });
              $('#doctorSelectForm').select2({
                  placeholder: "Select doctor",
                  allowClear: true,
                  dropdownParent: $('body')
              });

              // Khởi tạo FullCalendar
              calendar = new FullCalendar.Calendar(document.getElementById('fullcalendar'), {
                  themeSystem: 'bootstrap5',
                  headerToolbar: {
                      left: 'prev,next today',
                      center: 'title',
                      right: 'dayGridMonth,timeGridWeek,timeGridDay'
                  },
                  initialView: 'dayGridMonth',
                  dayMaxEventRows: false,
                  moreLinkClick: 'popover',
                  expandRows: true,
                  slotMinTime: '06:00:00',
                  slotMaxTime: '20:00:00',
                  selectable: true,
                  select: function (info) {
                      console.log('Selected range:', info.startStr, 'to', info.endStr);
                  },
                  eventClick: function (info) {
                      var scheduleId = info.event.id;
                      var eventDate = info.event.startStr;
                      var shiftId = info.event.extendedProps.shiftId;
                      var doctor = info.event.extendedProps.doctor || {};
                      var doctorName = doctor.name || 'N/A';

                      $('#editScheduleId').val(scheduleId);
                      $('#editShiftDate').val(eventDate);
                      $('#editShiftType').val(shiftId);
                      $('#editDoctorName').val(doctorName);
                      $('#editModal').modal('show');
                  },
                  eventContent: function (info) {
                      var doctor = info.event.extendedProps.doctor || {},
                          doctorName = doctor.name || 'N/A',
                          specialties = doctor.specialties ? doctor.specialties.join(', ') : '',
                          shiftId = info.event.extendedProps.shiftId || '',
                          shiftLabel = shiftId ? 'K' + shiftId : '',
                          shiftTime = info.event.extendedProps.shiftTime || info.event.title || '',
                          shiftColors = {
                              '1': '#0d6efd',
                              '2': '#198754',
                              '3': '#dc3545',
                              '4': '#ffc107'
                          },
                          bgColor = shiftColors[shiftId] || '#0d6efd',
                          html = "";

                      if (info.view.type === 'timeGridWeek' || info.view.type === 'timeGridDay') {
                          html = '<div style="background-color: ' + bgColor + '; color: #fff; padding: 2px 4px; border-radius: 4px; white-space: normal;">' +
                                  '<div><strong>' + doctorName + ' - ' + shiftLabel + '</strong></div>' +
                                  '<div>' + shiftTime + '</div>' +
                                  '<div><small>' + specialties + '</small></div>' +
                                  '</div>';
                      } else {
                          html = '<div style="background-color: ' + bgColor + '; color: #fff; padding: 2px 4px; border-radius: 4px; white-space: normal;">' +
                                  '<div><strong>' + doctorName + ' ' + shiftLabel + '</strong></div>' +
                                  '<div>' + shiftTime + '</div>' +
                                  '</div>';
                      }
                      return {html: html};
                  },
                  events: function (info, successCallback, failureCallback) {
                      fetchEvents(info.start, info.end, successCallback, failureCallback);
                  }
              });
              calendar.render();

              // Xử lý nút Save (Update) trong modal
              $('#saveEditBtn').off('click').on('click', function () {
                  var scheduleId = $('#editScheduleId').val();
                  var shiftDate = $('#editShiftDate').val();
                  var shiftType = $('#editShiftType').val();

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

              $('#deleteBtn').off('click').on('click', function () {
                  if (!confirm('Are you sure you want to delete this shift?'))
                      return;
                  var scheduleId = $('#editScheduleId').val();
                  $.ajax({
                      url: window.contextPath + '/hr/calendarmanage?action=deleteShift',
                      type: 'POST',
                      data: {scheduleId: scheduleId},
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

          function fetchEvents(start, end, successCallback, failureCallback) {
              var startDate = start.toISOString().split('T')[0];
              var endDate = end.toISOString().split('T')[0];
              var url = window.contextPath + '/hr/calendarmanage?action=getEvents'
                      + '&start=' + startDate
                      + '&end=' + endDate;
              console.log('Fetching events from', startDate, 'to', endDate);
              fetch(url)
                      .then(function (response) {
                          if (!response.ok) {
                              throw new Error('Network response error: ' + response.statusText);
                          }
                          return response.json();
                      })
                      .then(function (data) {
                          console.log('Fetched events:', data);
                          successCallback(data);
                      })
                      .catch(function (error) {
                          console.error('Error fetching events:', error);
                          if (failureCallback)
                              failureCallback(error);
                      });
          }

          function updateCalendarView(cycle) {
              var today = new Date();
              if (cycle == 0) {
                  calendar.setOption('validRange', null);
              } else {
                  var endDate = new Date(today);
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

          // Nếu cần, kiểm tra các trường hợp khi mở dropdown Select2
          $(document).on('select2:open', function () {
              $('.fc').css('z-index', '1');
          });
      </script>
  </body>
</html>
