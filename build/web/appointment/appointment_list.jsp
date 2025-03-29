<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Appointments</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="../static/css/appointment/appointments.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://pay.vnpay.vn/lib/vnpay/vnpay.min.js"></script>
    </head>

    <body>
        <%@ page import="java.util.Date" %>
        <%
            long currentTime = new Date().getTime(); // Get current timestamp (milliseconds)
            request.setAttribute("currentTime", currentTime); // Set it as a request attribute
        %>

        <jsp:include page="../Header.jsp"/>

        <div class="app-container">
            <div class="appointments-header">
                <h1>My Appointments</h1>
                <p>Manage your health appointments in one place</p>
            </div>

            <!-- Search Form -->
            <div class="search-container">
                <form class="search-form" action="../appointment/list" method="get">
                    <div class="search-wrapper">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" 
                               class="search-input" 
                               name="doctorName" 
                               placeholder="Search by doctor name"
                               value="${param.doctorName}">
                        <button type="submit" class="search-button">
                            Search
                        </button>
                    </div>
                </form>

                <a href="../appointment/doctor" class="new-appointment-btn">
                    <i class="fas fa-plus"></i> New Appointment
                </a>
            </div>

            <!-- Appointment Tabs -->
            <div class="appointment-tabs">
                <button class="tab-button active" data-tab="coming-up">Coming Up</button>
                <button class="tab-button" data-tab="pending">Pending</button>
                <button class="tab-button" data-tab="canceled">Canceled</button>
                <button class="tab-button" data-tab="completed">Completed</button>
            </div>

            <!-- Tab Contents -->
            <div class="tab-content-container">
                <!-- Confirmed Section -->
                <div class="tab-content active" id="coming-up">
                    <c:set var="hasConfirmedAppointments" value="false" />
                    <c:forEach var="appointment" items="${appointments}">
                        <c:if test="${appointment.status == 'Confirmed'}">
                            <c:set var="hasConfirmedAppointments" value="true" />
                            <div class="appointment-card">
                                <div class="appointment-left">
                                    <div class="doctor-avatar">
                                        <i class="fas fa-user-md"></i>
                                    </div>
                                    <div class="appointment-info">
                                        <h3 class="doctor-name">${appointment.doctor.name}</h3>
                                        <div class="appointment-meta">
                                            <span class="meta-item">
                                                <i class="far fa-calendar-alt"></i> ${appointment.doctorSchedule.scheduleDate}
                                            </span>
                                            <span class="meta-item">
                                                <i class="far fa-clock"></i> ${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}
                                            </span>
                                        </div>
                                        <div class="status-badge confirmed">
                                            <i class="fas fa-check-circle"></i> Confirmed
                                        </div>
                                    </div>
                                </div>
                                <div class="appointment-right">
                                    <c:if test="${appointment.invoice != null}">
                                        <div class="invoice-badge">
                                            <i class="fas fa-file-invoice-dollar"></i> Has Invoice
                                        </div>
                                    </c:if>
                                    <button class="view-details-btn" onclick="openAppointmentModal('${appointment.doctor.name}', '${appointment.doctorSchedule.scheduleDate}', '${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}', '${appointment.status}', ${appointment.invoice != null ? appointment.invoice.id : 'null'})">
                                        View Details
                                    </button>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>

                    <c:if test="${!hasConfirmedAppointments}">
                        <div class="empty-state">
                            <div class="empty-state-icon">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <h3>No Upcoming Appointments</h3>
                            <p>You don't have any confirmed appointments scheduled yet.</p>
                            <a href="../appointment/doctor" class="action-btn">Book an Appointment</a>
                        </div>
                    </c:if>
                </div>

                <!-- Pending Section -->
                <div class="tab-content" id="pending">
                    <c:set var="hasPendingAppointments" value="false" />
                    <c:forEach var="appointment" items="${appointments}">
                        <c:if test="${appointment.status == 'Pending' and appointment.doctorSchedule.scheduleDate.time >= currentTime}">
                            <c:set var="hasPendingAppointments" value="true" />
                            <div class="appointment-card">
                                <div class="appointment-left">
                                    <div class="doctor-avatar">
                                        <i class="fas fa-user-md"></i>
                                    </div>
                                    <div class="appointment-info">
                                        <h3 class="doctor-name">${appointment.doctor.name}</h3>
                                        <div class="appointment-meta">
                                            <span class="meta-item">
                                                <i class="far fa-calendar-alt"></i> ${appointment.doctorSchedule.scheduleDate}
                                            </span>
                                            <span class="meta-item">
                                                <i class="far fa-clock"></i> ${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}
                                            </span>
                                        </div>
                                        <div class="status-badge pending">
                                            <i class="fas fa-hourglass-half"></i> Pending
                                        </div>
                                    </div>
                                </div>
                                <div class="appointment-right">
                                    <div class="action-buttons">
                                        <button class="cancel-btn" onclick="cancelAppointment(${appointment.id})">
                                            <i class="fas fa-times"></i> Cancel
                                        </button>
                                        <button class="view-details-btn" onclick="openAppointmentModal('${appointment.doctor.name}', '${appointment.doctorSchedule.scheduleDate}', '${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}', '${appointment.status}')">
                                            View Details
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>

                    <c:if test="${!hasPendingAppointments}">
                        <div class="empty-state">
                            <div class="empty-state-icon">
                                <i class="fas fa-hourglass-half"></i>
                            </div>
                            <h3>No Pending Appointments</h3>
                            <p>You don't have any appointments in the pending state.</p>
                        </div>
                    </c:if>
                </div>

                <!-- Canceled Section -->
                <div class="tab-content" id="canceled">
                    <c:set var="hasCanceledAppointments" value="false" />
                    <c:forEach var="appointment" items="${appointments}">
                        <c:if test="${appointment.status == 'Canceled' }">
                            <c:set var="hasCanceledAppointments" value="true" />
                            <div class="appointment-card">
                                <div class="appointment-left">
                                    <div class="doctor-avatar">
                                        <i class="fas fa-user-md"></i>
                                    </div>
                                    <div class="appointment-info">
                                        <h3 class="doctor-name">${appointment.doctor.name}</h3>
                                        <div class="appointment-meta">
                                            <span class="meta-item">
                                                <i class="far fa-calendar-alt"></i> ${appointment.doctorSchedule.scheduleDate}
                                            </span>
                                            <span class="meta-item">
                                                <i class="far fa-clock"></i> ${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}
                                            </span>
                                        </div>
                                        <div class="status-badge canceled">
                                            <i class="fas fa-ban"></i> Canceled
                                        </div>
                                    </div>
                                </div>
                                <div class="appointment-right">
                                    <button class="view-details-btn" onclick="openAppointmentModal('${appointment.doctor.name}', '${appointment.doctorSchedule.scheduleDate}', '${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}', '${appointment.status}')">
                                        View Details
                                    </button>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>

                    <c:if test="${!hasCanceledAppointments}">
                        <div class="empty-state">
                            <div class="empty-state-icon">
                                <i class="fas fa-ban"></i>
                            </div>
                            <h3>No Canceled Appointments</h3>
                            <p>You don't have any canceled appointments.</p>
                        </div>
                    </c:if>
                </div>

                <!-- Completed Section -->
                <div class="tab-content" id="completed">
                    <c:set var="hasDoneAppointments" value="false" />
                    <c:forEach var="appointment" items="${appointments}">
                        <c:if test="${appointment.status == 'Completed'}">
                            <c:set var="hasDoneAppointments" value="true" />
                            <div class="appointment-card">
                                <div class="appointment-left">
                                    <div class="doctor-avatar">
                                        <i class="fas fa-user-md"></i>
                                    </div>
                                    <div class="appointment-info">
                                        <h3 class="doctor-name">${appointment.doctor.name}</h3>
                                        <div class="appointment-meta">
                                            <span class="meta-item">
                                                <i class="far fa-calendar-alt"></i> ${appointment.doctorSchedule.scheduleDate}
                                            </span>
                                            <span class="meta-item">
                                                <i class="far fa-clock"></i> ${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}
                                            </span>
                                        </div>
                                        <div class="status-badge completed">
                                            <i class="fas fa-check-double"></i> Completed
                                        </div>
                                    </div>
                                </div>
                                <div class="appointment-right">
                                    <button class="view-details-btn" onclick="openAppointmentModal('${appointment.doctor.name}', '${appointment.doctorSchedule.scheduleDate}', '${appointment.doctorSchedule.shift.timeStart} - ${appointment.doctorSchedule.shift.timeEnd}', '${appointment.status}')">
                                        View Details
                                    </button>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>

                    <c:if test="${!hasDoneAppointments}">
                        <div class="empty-state">
                            <div class="empty-state-icon">
                                <i class="fas fa-clipboard-check"></i>
                            </div>
                            <h3>No Completed Appointments</h3>
                            <p>You don't have any completed appointments yet.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <jsp:include page="../Footer.jsp"/>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Tab navigation
                const tabButtons = document.querySelectorAll('.tab-button');
                const tabContents = document.querySelectorAll('.tab-content');

                tabButtons.forEach(button => {
                    button.addEventListener('click', function () {
                        const tabId = this.getAttribute('data-tab');

                        // Remove active class from all buttons and contents
                        tabButtons.forEach(btn => btn.classList.remove('active'));
                        tabContents.forEach(content => {
                            content.classList.remove('active');
                            content.classList.remove('tab-transition');
                        });

                        // Add active class to current button and content
                        this.classList.add('active');
                        const activeContent = document.getElementById(tabId);
                        activeContent.classList.add('active');
                        activeContent.classList.add('tab-transition');
                    });
                });

                // Apply status-specific styling to appointment cards
                const comingUpCards = document.querySelectorAll('#coming-up .appointment-card');
                const pendingCards = document.querySelectorAll('#pending .appointment-card');
                const canceledCards = document.querySelectorAll('#canceled .appointment-card');
                const completedCards = document.querySelectorAll('#completed .appointment-card');

                comingUpCards.forEach(card => card.classList.add('confirmed'));
                pendingCards.forEach(card => card.classList.add('pending'));
                canceledCards.forEach(card => card.classList.add('canceled'));
                completedCards.forEach(card => card.classList.add('completed'));

                // Create modal elements if they don't exist
                if (!document.getElementById('appointmentModal')) {
                    createModalElements();
                }

                // Toast notification container
                if (!document.getElementById('toastContainer')) {
                    const toastContainerHTML = `<div id="toastContainer" class="toast-container"></div>`;
                    document.body.insertAdjacentHTML('beforeend', toastContainerHTML);
                }

                // Loader element
                if (!document.getElementById('loader')) {
                    const loaderHTML = `
            <div id="loader" class="loader">
                <div class="loader-spinner"></div>
            </div>
        `;
                    document.body.insertAdjacentHTML('beforeend', loaderHTML);
                }

                // Close modal when clicking the close button or outside the modal
                document.getElementById('closeModal')?.addEventListener('click', closeModal);
                window.addEventListener('click', function (event) {
                    if (event.target.classList.contains('modal')) {
                        closeModal();
                    }
                });

                // Handle search input enhancements
                const searchInput = document.querySelector('.search-input');
                if (searchInput) {
                    // Clear button functionality
                    searchInput.addEventListener('input', function () {
                        if (this.value.length > 0) {
                            if (!document.querySelector('.search-clear-btn')) {
                                const clearBtn = document.createElement('button');
                                clearBtn.className = 'search-clear-btn';
                                clearBtn.innerHTML = '<i class="fas fa-times-circle"></i>';
                                clearBtn.style.position = 'absolute';
                                clearBtn.style.right = '120px'; // Adjust based on search button width
                                clearBtn.style.top = '50%';
                                clearBtn.style.transform = 'translateY(-50%)';
                                clearBtn.style.background = 'none';
                                clearBtn.style.border = 'none';
                                clearBtn.style.color = 'var(--gray-500)';
                                clearBtn.style.cursor = 'pointer';

                                clearBtn.addEventListener('click', function () {
                                    searchInput.value = '';
                                    this.remove();
                                    searchInput.focus();
                                });

                                document.querySelector('.search-wrapper').appendChild(clearBtn);
                            }
                        } else {
                            const clearBtn = document.querySelector('.search-clear-btn');
                            if (clearBtn)
                                clearBtn.remove();
                        }
                    });

                    // Trigger search on Enter key
                    searchInput.addEventListener('keypress', function (e) {
                        if (e.key === 'Enter') {
                            e.preventDefault();
                            document.querySelector('.search-button').click();
                        }
                    });
                }
            });

// Function to create modal elements
            function createModalElements() {
                const modalHTML = `
        <div id="appointmentModal" class="modal appointment-modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Appointment Details</h2>
                    <button id="closeModal" class="close-modal">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="appointment-detail">
                        <span class="detail-label">Doctor</span>
                        <div class="detail-value" id="modalDoctorName"></div>
                    </div>
                    <div class="appointment-detail">
                        <span class="detail-label">Date</span>
                        <div class="detail-value" id="modalDate"></div>
                    </div>
                    <div class="appointment-detail">
                        <span class="detail-label">Time</span>
                        <div class="detail-value" id="modalTimeSlot"></div>
                    </div>
                    <div class="appointment-detail">
                        <span class="detail-label">Status</span>
                        <div class="detail-value" id="modalStatus"></div>
                    </div>
                    <div id="invoiceDetails" style="display:none; margin-top: 20px; border-top: 1px solid var(--gray-200); padding-top: 15px;">
                        <h3>Invoice Details</h3>
                        <div class="appointment-detail">
                            <span class="detail-label">Amount</span>
                            <div class="detail-value" id="invoiceAmount"></div>
                        </div>
                        <div class="appointment-detail">
                            <span class="detail-label">Status</span>
                            <div class="detail-value" id="invoiceStatus"></div>
                        </div>
                        <div class="appointment-detail">
                            <span class="detail-label">Due Date</span>
                            <div class="detail-value" id="invoiceDate"></div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button id="payInvoiceButton" class="payment-btn">
                        <i class="fas fa-credit-card"></i> Proceed to Payment
                    </button>
                </div>
            </div>
        </div>
    `;

                document.body.insertAdjacentHTML('beforeend', modalHTML);
            }

// Function to close modal
            function closeModal() {
                document.querySelectorAll('.modal').forEach(modal => {
                    modal.style.display = 'none';
                });
            }

// Function to open appointment modal
            // Function to open appointment modal
            function openAppointmentModal(doctorName, date, timeSlot, status, invoiceId) {
                document.getElementById("modalDoctorName").innerText = doctorName;
                document.getElementById("modalDate").innerText = date;
                document.getElementById("modalTimeSlot").innerText = timeSlot;
                document.getElementById("modalStatus").innerText = status;

                // Set status class to change the color based on status
                const modalStatus = document.getElementById("modalStatus");
                modalStatus.className = "detail-value status-" + status.toLowerCase();

                // Hide payment button by default
                const payInvoiceButton = document.getElementById("payInvoiceButton");
                payInvoiceButton.style.display = 'none';

                // Handle invoice details
                if (invoiceId !== 'null' && status === 'Confirmed') {
                    showLoader();
                    fetch(`../invoice/` + invoiceId)
                            .then(response => response.json())
                            .then(invoice => {
                                hideLoader();
                                // Display invoice details
                                document.getElementById("invoiceAmount").innerText = formatCurrency(invoice.amount);
                                document.getElementById("invoiceStatus").innerText = invoice.status;
                                document.getElementById("invoiceDate").innerText = invoice.expireDate;

                                // Show invoice section
                                document.getElementById("invoiceDetails").style.display = 'block';

                                // Only show payment button for Confirmed appointments with Pending invoices
                                if (invoice.status === 'Pending') {
                                    payInvoiceButton.style.display = 'inline-flex';
                                    payInvoiceButton.onclick = function () {
                                        payInvoice(invoice.id, invoice.amount, invoice.txnRef);
                                    };
                                }
                            })
                            .catch(error => {
                                hideLoader();
                                console.error('Error fetching invoice:', error);
                                document.getElementById("invoiceDetails").style.display = 'none';
                                showToast('Error', 'Failed to load invoice details', 'error');
                            });
                } else {
                    document.getElementById("invoiceDetails").style.display = 'none';
                }

                // Show the modal
                document.getElementById("appointmentModal").style.display = "block";
            }

// Function to cancel appointment
            function cancelAppointment(appointmentId) {
                if (confirm("Are you sure you want to cancel this appointment?")) {
                    showLoader();
                    window.location.href = "../appointment/cancel?appointmentId=" + appointmentId;
                }
            }

// Function to pay invoice
            function payInvoice(invoiceId, amount, txnRef) {
                if (!txnRef) {
                    showToast('Error', 'Transaction reference is missing!', 'error');
                    return;
                }

                showLoader();
                let data = new URLSearchParams();
                data.append('amount', amount);
                data.append('vnp_TxnRef', txnRef);
                data.append('bankCode', 'VNBANK');
                data.append('language', 'vn');

                fetch('/SWP391_GR6/vnpayajax', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: data
                })
                        .then(response => response.json())
                        .then(x => {
                            hideLoader();
                            if (x.code === '00') {
                                window.location.href = x.data;
                            } else {
                                showToast('Error', x.message || 'Payment processing failed', 'error');
                            }
                        })
                        .catch(error => {
                            hideLoader();
                            console.error("Error processing payment:", error);
                            showToast('Error', 'An error occurred while processing the payment', 'error');
                        });
            }

// Format currency function
            function formatCurrency(amount) {
                return new Intl.NumberFormat('en-US', {
                    style: 'currency',
                    currency: 'VND'
                }).format(amount);
            }

// Toast notification function
            function showToast(title, message, type) {
                const toastContainer = document.getElementById('toastContainer');

                const toast = document.createElement('div');
                toast.className = 'toast toast-' + type;

                toast.innerHTML = `
        <div class="toast-icon">
            <i class="fas ` + type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle' + `"></i>
        </div>
        <div class="toast-content">
            <div class="toast-title">` + title + `</div>
            <div class="toast-message">` + message + `</div>
        </div>
        <button class="toast-close">
            <i class="fas fa-times"></i>
        </button>
    `;

                toastContainer.appendChild(toast);

                // Auto-remove after 5 seconds
                setTimeout(function () {
                    toast.style.opacity = '0';
                    setTimeout(function () {
                        toast.remove();
                    }, 300);
                }, 5000);

                // Close button functionality
                toast.querySelector('.toast-close').addEventListener('click', function () {
                    toast.style.opacity = '0';
                    setTimeout(function () {
                        toast.remove();
                    }, 300);
                });
            }

// Loader functions
            function showLoader() {
                const loader = document.getElementById('loader');
                if (loader) {
                    loader.style.display = 'flex';
                }
            }

            function hideLoader() {
                const loader = document.getElementById('loader');
                if (loader) {
                    loader.style.display = 'none';
                }
            }

            // Function to pay invoice
            function payInvoice(invoiceId, amount, txnRef) {
                if (!txnRef) {
                    showToast('Error', 'Transaction reference is missing!', 'error');
                    return;
                }

                showLoader();
                let data = new URLSearchParams();
                data.append('amount', amount);
                data.append('vnp_TxnRef', txnRef);
                data.append('bankCode', 'VNBANK');
                data.append('language', 'vn');

                fetch('/SWP391_GR6/vnpayajax', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: data
                })
                        .then(response => response.json())
                        .then(x => {
                            hideLoader();
                            if (x.code === '00') {
                                window.location.href = x.data;
                            } else {
                                showToast('Error', x.message || 'Payment processing failed', 'error');
                            }
                        })
                        .catch(error => {
                            hideLoader();
                            console.error("Error processing payment:", error);
                            showToast('Error', 'An error occurred while processing the payment', 'error');
                        });
            }
        </script>
    </body>
</html>