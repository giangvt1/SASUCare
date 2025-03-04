let calendar; // biến toàn cục cho calendar

document.addEventListener('DOMContentLoaded', function() {
    const calendarEl = document.getElementById('fullcalendar');
    const contextPath = window.contextPath || ''; // Đảm bảo JSP đã đặt window.contextPath
    calendar = new FullCalendar.Calendar(calendarEl, {
        themeSystem: 'bootstrap5',
        initialView: 'dayGridMonth',
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,timeGridDay'
        },
        views: {
            timeGridWeek: {
                titleFormat: { year: 'numeric', month: 'short', day: 'numeric' },
                slotLabelFormat: { hour: '2-digit', minute: '2-digit', hour12: false }
            },
            timeGridDay: {
                titleFormat: { year: 'numeric', month: 'short', day: 'numeric' },
                slotLabelFormat: { hour: '2-digit', minute: '2-digit', hour12: false }
            }
        },
        selectable: true,
        select: function(info) {
            handleDateSelection(info);
        },
        eventClick: function(info) {
            handleEventClick(info);
        },
        // Tùy chỉnh hiển thị event với thông tin chi tiết, bao gồm shiftId (hiển thị dưới dạng "K")
        eventContent: function(info) {
            const doctor = info.event.extendedProps.doctor || {};
            const doctorName = doctor.name || '';
            const specialties = doctor.specialties ? doctor.specialties.join(', ') : '';
            const shiftId = info.event.extendedProps.shiftId || '';  // Lấy shift id từ extendedProps
            const shiftLabel = shiftId ? 'K' + shiftId : '';
            const shiftTime = info.event.extendedProps.shiftTime || info.event.title || '';
            const html = `
                <div class="fc-event-custom">
                    <div><strong>${doctorName} ${shiftLabel}</strong></div>
                    <div><small>${specialties}</small></div>
                    <div>${shiftTime}</div>
                </div>
            `;
            return { html: html };
        },
        events: function(info, successCallback, failureCallback) {
            fetchEvents(info.start, info.end, successCallback, failureCallback);
        }
    });
    
    calendar.render();
    
    // Bind event cho cycle select (chỉ bind một lần)
    $('#cycleSelect').off('change').on('change', function() {
        updateCalendarView(this.value);
    });
    
    // Bind event cho nút assign shift (chỉ bind một lần)
    $('#assignShift').off('click').on('click', function(e) {
        e.preventDefault();
        assignShiftToDoctor();
    });
});

function handleDateSelection(info) {
    console.log('Selected range:', info.startStr, 'to', info.endStr);
    // Ở đây bạn có thể mở modal để nhập thông tin đặt lịch nếu cần
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
        if (failureCallback) failureCallback(error);
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
    
    console.log('Assigning shift:', { doctorId, shiftId, shiftDate });
    
    $.ajax({
        url: window.contextPath + '/hr/calendarmanage?action=assignShift',
        type: 'POST',
        data: {
            doctorId: doctorId,
            shiftType: shiftId,  // Server nhận shift id qua "shiftType"
            shiftDate: shiftDate
        },
        success: function(response) {
            console.log('Assign shift response:', response);
            if (response.success) {
                alert('Shift assigned successfully!');
                calendar.refetchEvents();
            } else {
                alert('Failed to assign shift.');
            }
        },
        error: function(xhr, status, error) {
            console.error('Error occurred:', status, error);
            alert('An error occurred while assigning shift.');
        }
    });
}
