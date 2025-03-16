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
                                <option value="unpaid" <c:if test="${param.status eq 'unpaid'}">selected</c:if>>Unpaid</option>
                                <option value="partial" <c:if test="${param.status eq 'partial'}">selected</c:if>>Partially Paid</option>
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
                            <button type="reset" class="btn btn-outline-secondary ms-2" onclick="resetFilters()">
                                <i class="fas fa-undo me-2"></i> Reset
                            </button>
                            <a href="${pageContext.request.contextPath}/customer/invoices/export?customerId=${param.customerId}&status=${param.status}&startDate=${param.startDate}&endDate=${param.endDate}" class="btn btn-outline-secondary ms-2">
                                <i class="fas fa-file-export me-2"></i> Export
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
                    <div class="sort-direction">
                        <button type="button" id="sortDirectionBtn" class="btn btn-sm btn-outline-secondary" onclick="toggleSortDirection()">
                            <i id="sortIcon" class="fas fa-sort-amount-${param.sortDirection eq 'asc' ? 'up' : 'down'}"></i>
                        </button>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Invoice No.</th>
                                    <th>Date</th>
                                    <th>Due Date</th>
                                    <th>Visit</th>
                                    <th>Status</th>
                                    <th class="text-end">Total</th>
                                    <th class="text-end">Paid</th>
                                    <th class="text-end">Remaining</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:if test="${not empty invoices}">
                                    <c:forEach var="invoice" items="${invoices}">
                                        <tr>
                                            <td>${invoice.id}</td>
                                            <td><fmt:formatDate value="${invoice.createdDate}" pattern="yyyy-MM-dd" /></td>
                                            <td><fmt:formatDate value="${invoice.expireDate}" pattern="yyyy-MM-dd" /></td>
                                            <td>
                                                <c:if test="${not empty invoice.appointmentId}">
                                                    ${invoice.appointmentId}
                                                </c:if>
                                                <c:if test="${empty invoice.appointmentId}">N/A</c:if>
                                                </td>
                                                <td>
                                                    <span class="status-badge status-${invoice.status}">${invoice.status}</span>
                                            </td>
                                            <td class="amount-cell">$</td>
                                            <td class="amount-cell">$</td>
                                            <td class="amount-cell">$</td>
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/customer/invoice-details/${invoice.id}" class="btn btn-sm btn-primary btn-view">
                                                    <i class="fas fa-eye"></i> View
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:if>
                                <c:if test="${empty invoices}">
                                    <tr>
                                        <td colspan="9" class="text-center py-4">No invoices found matching your criteria.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${pagination.totalPages > 1}">
                        <nav aria-label="Invoice pagination">
                            <ul class="pagination">
                                <!-- Previous Page -->
                                <li class="page-item ${pagination.currentPage <= 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pagination.currentPage > 1 ? pageContext.request.contextPath.concat('/invoices?customerId=').concat(param.customerId).concat('&page=').concat(pagination.currentPage - 1).concat('&status=').concat(param.status).concat('&startDate=').concat(param.startDate).concat('&endDate=').concat(param.endDate).concat('&sortBy=').concat(param.sortBy).concat('&sortDirection=').concat(param.sortDirection) : '#'}" aria-label="Previous">
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
                                                <a class="page-link" href="${pageContext.request.contextPath}/invoices?customerId=${param.customerId}&page=${pageNumber}&status=${param.status}&startDate=${param.startDate}&endDate=${param.endDate}&sortBy=${param.sortBy}&sortDirection=${param.sortDirection}">${pageNumber}</a>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>

                                <!-- Next Page -->
                                <li class="page-item ${pagination.currentPage >= pagination.totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pagination.currentPage < pagination.totalPages ? pageContext.request.contextPath.concat('/invoices?customerId=').concat(param.customerId).concat('&page=').concat(pagination.currentPage + 1).concat('&status=').concat(param.status).concat('&startDate=').concat(param.startDate).concat('&endDate=').concat(param.endDate).concat('&sortBy=').concat(param.sortBy).concat('&sortDirection=').concat(param.sortDirection) : '#'}" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>
        <jsp:include page="../Footer.jsp"/>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                    function toggleSortDirection() {
                        const sortDirectionInput = document.getElementById('sortDirectionInput');
                        const sortIcon = document.getElementById('sortIcon');

                        if (sortDirectionInput.value === 'asc') {
                            sortDirectionInput.value = 'desc';
                            sortIcon.className = 'fas fa-sort-amount-down';
                        } else {
                            sortDirectionInput.value = 'asc';
                            sortIcon.className = 'fas fa-sort-amount-up';
                        }

                        // Submit the form
                        document.querySelector('form').submit();
                    }

                    function resetFilters() {
                        // Reset all form fields
                        document.getElementById('statusFilter').value = '';
                        document.getElementById('startDate').value = '';
                        document.getElementById('endDate').value = '';
                        document.getElementById('sortBy').value = 'date';
                        document.getElementById('sortDirectionInput').value = 'desc';

                        // Submit the form with reset values
                        document.querySelector('form').submit();
                    }
        </script>
    </body>
</html>
