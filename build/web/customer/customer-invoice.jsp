<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Invoice History - ${currentCustomer.fullname}</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
    </head>
    <body>
        <jsp:include page="../Header.jsp"/>

        <div class="container">
            <div class="page-header">
                <h1 class="mb-4">Invoice History</h1>
                <p class="text-muted">View and manage your medical invoices</p>
            </div>

            <!-- Filter Section -->
            <div class="card filter-card mb-4">
                <div class="card-header">
                    <i class="fas fa-filter me-2"></i> Filter Invoices
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/customer/invoices" method="get" class="row g-3">
                        <div class="col-md-3">
                            <label for="statusFilter" class="form-label">Status</label>
                            <select id="statusFilter" name="status" class="form-select">
                                <option value="" <c:if test="${empty param.status}">selected</c:if>>All Statuses</option>
                                <option value="paid" <c:if test="${param.status eq 'paid'}">selected</c:if>>Paid</option>
                                <option value="pending" <c:if test="${param.status eq 'pending'}">selected</c:if>>Unpaid</option>
                                <option value="overdue" <c:if test="${param.status eq 'overdue'}">selected</c:if>>Overdue</option>
                                <option value="cancelled" <c:if test="${param.status eq 'cancelled'}">selected</c:if>>Cancelled</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="startDate" class="form-label">From Date</label>
                                <input type="date" id="startDate" name="startDate" class="form-control" value="${param.startDate}">
                        </div>
                        <div class="col-md-3">
                            <label for="endDate" class="form-label">To Date</label>
                            <input type="date" id="endDate" name="endDate" class="form-control" value="${param.endDate}">
                        </div>
                        <div class="col-md-3">
                            <label for="sortBy" class="form-label">Sort By</label>
                            <select id="sortBy" name="sortBy" class="form-select">
                                <option value="date" <c:if test="${empty param.sortBy || param.sortBy eq 'date'}">selected</c:if>>Date</option>
                                <option value="amount" <c:if test="${param.sortBy eq 'amount'}">selected</c:if>>Amount</option>
                                <option value="dueDate" <c:if test="${param.sortBy eq 'dueDate'}">selected</c:if>>Due Date</option>
                                </select>
                            </div>
                            <input type="hidden" name="sortDirection" value="${empty param.sortDirection ? 'desc' : param.sortDirection}" id="sortDirectionInput">
                        <div class="col-12 mt-4">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search me-2"></i> Apply Filters
                            </button>
                            <button type="reset" class="btn btn-outline-secondary ms-2" onclick="window.location.href = '/SWP391_GR6/customer/invoices';">
                                <i class="fas fa-undo me-2"></i> Reset
                            </button>
                            <a href="${pageContext.request.contextPath}/customer/invoices/export?format=csv" class="btn btn-outline-secondary ms-2">
                                <i class="fas fa-file-csv me-2"></i> Export to CSV
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Summary Section -->
            <div class="row summary-info">
                <div class="col-md-3 mb-3">
                    <div class="summary-card">
                        <h5>Total Invoices</h5>
                        <span class="count">${invoiceSummary.total}</span>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="summary-card">
                        <h5>Paid</h5>
                        <span class="count text-success">${invoiceSummary.paid}</span>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="summary-card">
                        <h5>Unpaid</h5>
                        <span class="count text-secondary">${invoiceSummary.unpaid}</span>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="summary-card">
                        <h5>Overdue</h5>
                        <span class="count text-danger">${invoiceSummary.overdue}</span>
                    </div>
                </div>
            </div>

            <!-- Invoices Table -->
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <span><i class="fas fa-file-invoice-dollar me-2"></i> Your Invoices</span>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Invoice Info.</th>
                                    <th>Date</th>
                                    <th>Due Date</th>
                                    <th>Status</th>
                                    <th>Total</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="invoice" items="${invoices}">
                                    <tr>
                                        <td>${invoice.orderInfo}</td>
                                        <td><fmt:formatDate value="${invoice.createdDate}" pattern="dd-MM-yyyy" /></td>
                                        <td><fmt:formatDate value="${invoice.expireDate}" pattern="dd-MM-yyyy" /></td>
                                        <td>
                                            <span class="status-badge status-${invoice.status}">${invoice.status}</span>
                                        </td>
                                        <td class="amount-cell"><fmt:formatNumber value="${invoice.amount}" pattern="#,###"/> VND</td>
                                        <td class="text-center">
                                            <button class="btn btn-sm btn-primary btn-view" onclick="viewInvoiceDetails(${invoice.id})">
                                                <i class="fas fa-eye"></i> View
                                            </button>
                                            <c:if test="${invoice.status != 'Paid'}">
                                                <button class="pay" onclick="payInvoice(${invoice.id}, ${invoice.amount}, ${invoice.txnRef})">Pay Invoice</button>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <c:if test="${pagination.totalPages > 0}">
            <nav aria-label="Invoice pagination">
                <ul class="pagination">
                    <!-- Previous Page -->
                    <li class="page-item ${pagination.currentPage <= 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pagination.currentPage > 1 ? pageContext.request.contextPath.concat('/customer/invoices?customerId=').concat(param.customerId).concat('&page=').concat(pagination.currentPage - 1).concat('&status=').concat(param.status).concat('&startDate=').concat(param.startDate).concat('&endDate=').concat(param.endDate).concat('&sortBy=').concat(param.sortBy).concat('&sortDirection=').concat(param.sortDirection) : '#'}" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>

                    <!-- Page Numbers -->
                    <c:forEach begin="1" end="${pagination.totalPages}" var="pageNumber">
                        <c:choose>
                            <c:when test="${pageNumber == pagination.currentPage}">
                                <li class="page-item active">
                                    <span class="page-link">${pageNumber}</span>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/customer/invoices?customerId=page=${pageNumber}&status=${param.status}&startDate=${param.startDate}&endDate=${param.endDate}&sortBy=${param.sortBy}&sortDirection=${param.sortDirection}">${pageNumber}</a>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <!-- Next Page -->
                    <li class="page-item ${pagination.currentPage >= pagination.totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pagination.currentPage < pagination.totalPages ? pageContext.request.contextPath.concat('/customer/invoices?customerId=').concat(param.customerId).concat('&page=').concat(pagination.currentPage + 1).concat('&status=').concat(param.status).concat('&startDate=').concat(param.startDate).concat('&endDate=').concat(param.endDate).concat('&sortBy=').concat(param.sortBy).concat('&sortDirection=').concat(param.sortDirection) : '#'}" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </c:if>


        <!-- Invoice Details Modal -->
        <div id="invoiceDetailsModal" class="modal fade" tabindex="-1" aria-labelledby="invoiceDetailsModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="invoiceDetailsModalLabel">Invoice Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div id="invoiceDetailsContent">
                            <!-- Invoice details will be loaded here via AJAX -->
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../Footer.jsp"/>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                    function viewInvoiceDetails(invoiceId) {
                                                        // Send AJAX request to fetch invoice details
                                                        fetch(`/SWP391_GR6/customer/invoice-details/` + invoiceId)
                                                                .then(response => response.json())
                                                                .then(data => {
                                                                    // Populate the modal with the invoice details
                                                                    const invoice = data.invoice;
                                                                    const transaction = data.transaction;
                                                                    const appointment = data.appointment;

                                                                    const formattedAmount = new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(invoice.amount);

                                                                    const content = `
                <h6>Invoice Information:</h6>
                <p><strong>Order Info:</strong> ` + invoice.orderInfo + `</p>
                <p><strong>Status:</strong> ` + invoice.status + `</p>
                <p><strong>Amount:</strong> ` + formattedAmount + `</p>
         
                <p><strong>Expire Date:</strong> ` + invoice.expireDate + `</p>

                <h6>Transaction Information:</h6>
                <p><strong>Transaction Date:</strong> ` + transaction.transactionDate + `</p>
                <p><strong>Transaction Status:</strong> ` + transaction.status + `</p>

                <h6>Appointment Information:</h6>
                <p><strong>Appointment with doctor:</strong> ` + appointment.doctor.name + `</p>
                <p><strong>Appointment Date:</strong> ` + appointment.doctorSchedule.scheduleDate + ` | ` + appointment.doctorSchedule.shift.timeStart +" - "+ appointment.doctorSchedule.shift.timeEnd +  `</p>
            `;
                                                                    // Set the modal content
                                                                    document.getElementById('invoiceDetailsContent').innerHTML = content;

                                                                    // Show the modal
                                                                    var myModal = new bootstrap.Modal(document.getElementById('invoiceDetailsModal'));
                                                                    myModal.show();
                                                                })
                                                                .catch(error => {
                                                                    console.error('Error fetching invoice details:', error);
                                                                    alert('Failed to load invoice details.');
                                                                });
                                                    }

                                                    function payInvoice(invoiceId, amount, txnRef) {
                                                        if (!txnRef) {
                                                            alert("Transaction reference is missing!");
                                                            return;
                                                        }

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
                                                                    if (x.code === '00') {
                                                                        window.location.href = x.data;
                                                                    } else {
                                                                        alert(x.message);
                                                                    }
                                                                })
                                                                .catch(error => {
                                                                    console.error("Error processing payment:", error);
                                                                    alert("An error occurred while processing the payment.");
                                                                });
                                                    }

        </script>
    </body>
</html>