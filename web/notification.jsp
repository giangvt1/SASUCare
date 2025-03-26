<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="notification-container" id="notificationContainer">
    <div class="notification-icon">
        <i class="fa fa-bell"></i> <!-- Bell icon -->
        <span class="badge badge-danger notification-count" style="display: none;">0</span> <!-- Notification count, hidden initially -->
    </div>
    <div class="notification-message" id="notificationMessage" style="display: none;">
        <p>You have <span id="newCount">0</span> new appointments!</p> <!-- Message content -->
        <button class="close-notification" onclick="closeNotification()">×</button> <!-- Close button -->
    </div>
</div>

<style>
    .notification-container {
        position: fixed;
        bottom: 20px; /* Distance from the bottom */
        right: 20px;  /* Distance from the right */
        z-index: 1000; /* Ensure the notification is above other elements */
    }

    .notification-icon {
        position: relative;
        display: inline-block;
        cursor: pointer;
    }

    .notification-icon .fa-bell {
        font-size: 24px;
        color: #333;
    }

    .notification-count {
        position: absolute;
        top: -5px;
        right: -5px;
        font-size: 12px;
        padding: 2px 6px;
        border-radius: 50%;
    }

    .notification-message {
        position: absolute;
        bottom: 35px;
        right: 0;
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 5px;
        padding: 10px;
        box-shadow: 0 -2px 5px rgba(0,0,0,0.2);
        min-width: 200px;
    }

    .notification-message p {
        margin: 0;
        font-size: 14px;
    }

    .close-notification {
        position: absolute;
        top: 5px;
        right: 5px;
        background: none;
        border: none;
        font-size: 16px;
        cursor: pointer;
        color: #999;
    }

    .close-notification:hover {
        color: #333;
    }
</style>


<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script>
    $(document).ready(function () {
        // Function to check for new appointments
        function checkNewAppointments() {
            $.ajax({
                url: '/SWP391_GR6/CheckNewAppointmentServlet', // The endpoint from the servlet
                method: 'GET',
                dataType: 'json',
                success: function (response) {
                    console.log('Response:', response);  // Debugging the response
                    if (response.newCount && response.newCount > 0) {
                        $('#newCount').text(response.newCount);  // Display the count of new appointments
                        $('.notification-count').text(response.newCount).show();  // Show the badge with new appointments
//                        $('#notificationMessage').slideDown();  // Show the notification message if new appointments exist
                    } else {
                        $('.notification-count').hide();  // Hide the badge if no new appointments
                        $('#notificationMessage').hide();  // Hide the notification message if no new appointments
                    }
                },
                error: function () {
                    console.log('Error checking new appointments');
                }
            });
        }

        // Check every 30 seconds for new appointments
        setInterval(checkNewAppointments, 30000);

        // Check when the page loads
        checkNewAppointments();  // Only open if there are new appointments

        // Ensure that the notification toggle is only attached once
        $('.notification-icon').off('click').on('click', function () {
            console.log('Toggling notification visibility');
            $('#notificationMessage').slideToggle();
        });
    });

    // Close the notification
    function closeNotification() {
        $('#notificationMessage').slideUp();  // Hide the notification when the close button is clicked
    }
</script>
