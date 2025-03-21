<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Invoice Details - Invoice #${invoice.id}</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
  <link rel="stylesheet" href="../static/css/customer/invoices.css">

 
</head>
<body>
       <jsp:include page="../Header.jsp"/>
        <style>
      :root {
    --primary-blue: #2563EB;
    --light-blue: #EFF6FF;
    --success-green: #10B981;
    --error-red: #EF4444;
    --warning-yellow: #F59E0B;
    --text-dark: #1F2937;
    --text-muted: #64748B;
}

/* Animations */
@keyframes slideUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

@keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.1); }
    100% { transform: scale(1); }
}

@keyframes wave {
    0% { transform: translateX(0); }
    50% { transform: translateX(5px); }
    100% { transform: translateX(0); }
}

@keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-3px); }
}

@keyframes blink {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.5; }
}

/* Animation Classes */
.animate-slide-up {
    animation: slideUp 0.5s ease-out forwards;
}

.animate-fade-in {
    animation: fadeIn 0.3s ease-out forwards;
}

.pulse {
    animation: pulse 2s infinite;
}

.wave-animation {
    animation: wave 2s infinite;
}

.bounce {
    animation: bounce 1s infinite;
}

.blink {
    animation: blink 1.5s infinite;
}

/* Base Styles */
body {
    font-family: 'Inter', system-ui, -apple-system, sans-serif;
    line-height: 1.6;
    color: var(--text-dark);
    background-color: var(--light-blue);
    margin: 0;
    padding: 20px;
}

.invoice-container {
    max-width: 800px;
    margin: 0 auto;
    background: white;
    padding: 2rem;
    border-radius: 16px;
    box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.container:hover {
    transform: translateY(-2px);
    box-shadow: 0 15px 30px -5px rgba(0, 0, 0, 0.15);
}

/* Header Styles */
.page-header {
    margin-bottom: 2rem;
    padding-bottom: 1rem;
    border-bottom: 2px solid var(--light-blue);
}

.invoice-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 1.5rem;
    margin-bottom: 2rem;
}

.invoice-id {
    font-size: 1.5rem;
    font-weight: 600;
    color: var(--primary-blue);
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.invoice-date {
    display: flex;
    align-items: center;
    gap: 1rem;
    color: var(--text-muted);
    font-size: 0.95rem;
}

.date-item {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    transition: color 0.3s ease;
}

.date-item:hover {
    color: var(--primary-blue);
}

/* Status Badges */
.status-badge {
    display: inline-flex;
    align-items: center;
    padding: 0.5rem 1rem;
    border-radius: 9999px;
    font-weight: 600;
    font-size: 0.875rem;
    transition: all 0.3s ease;
}

.status-badge.small {
    padding: 0.25rem 0.75rem;
    font-size: 0.75rem;
}

.status-badge:hover {
    transform: translateY(-1px);
    filter: brightness(1.1);
}

.status-success {
    background-color: #DCFCE7;
    color: var(--success-green);
}

.status-pending {
    background-color: #FEF3C7;
    color: var(--warning-yellow);
}

.status-failed {
    background-color: #FEE2E2;
    color: var(--error-red);
}

/* Summary Section */
.invoice-summary {
    background-color: var(--light-blue);
    padding: 1.5rem;
    border-radius: 12px;
    margin: 1.5rem 0;
    transition: all 0.3s ease;
}

.invoice-summary:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.1);
}

.summary-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0.75rem 0;
}

.summary-item .label {
    color: var(--text-muted);
    font-weight: 500;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.summary-item .value {
    color: var(--primary-blue);
    font-weight: 600;
    font-size: 1.5rem;
    transition: transform 0.3s ease;
}

.summary-item:hover .value {
    transform: scale(1.05);
}

/* Meta Section */
.meta-section {
    background-color: white;
    padding: 1.5rem;
    border-radius: 12px;
    border: 1px solid #E5E7EB;
    transition: all 0.3s ease;
}

.meta-section:hover {
    border-color: var(--primary-blue);
    box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.1);
}

.appointment-info {
    background-color: var(--light-blue);
    padding: 1rem;
    border-radius: 8px;
    margin-top: 1rem;
}

.highlight {
    color: var(--primary-blue);
    font-weight: 600;
}

/* Transaction Card */
.transaction-card {
    border-radius: 12px;
    border: 1px solid #E5E7EB;
    margin: 1.5rem 0;
    overflow: hidden;
    transition: all 0.3s ease;
}

.transaction-card:hover {
    border-color: var(--primary-blue);
    box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.1);
}

/* Table Styles */
.table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
}

.table th,
.table td {
    padding: 1rem;
    text-align: left;
    border-bottom: 1px solid #E5E7EB;
}

.table th {
    font-weight: 600;
    color: var(--text-muted);
    text-transform: uppercase;
    font-size: 0.75rem;
    letter-spacing: 0.05em;
}

.transaction-row {
    transition: all 0.3s ease;
}

.transaction-row:hover {
    background-color: var(--light-blue);
    transform: translateX(5px);
}

/* Pay Button */
.pay {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
    background-color: var(--primary-blue);
    color: white;
    padding: 1rem 2rem;
    border-radius: 8px;
    border: none;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    margin: 1rem 0;
    width: 100%;
    position: relative;
    overflow: hidden;
}

.pay:hover:not(:disabled) {
    background-color: #1D4ED8;
    transform: translateY(-2px);
    box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.2);
}

.pay:disabled {
    opacity: 0.7;
    cursor: not-allowed;
    background-color: var(--text-muted);
}

/* Toast Notifications */
.toast-container {
    z-index: 1050;
}

.toast {
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    opacity: 0;
    transition: opacity 0.3s ease;
}

.toast.show {
    opacity: 1;
}

/* Info Message */
.info-message {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.75rem;
    border-radius: 8px;
    background-color: var(--light-blue);
    margin: 0.5rem 0;
}

/* Responsive Design */
@media (max-width: 640px) {
    .container {
        padding: 1rem;
    }

    .invoice-header {
        flex-direction: column;
        align-items: flex-start;
    }

    .action-buttons {
        flex-direction: column;
        gap: 1rem;
    }

    .action-buttons > div {
        width: 100%;
    }

    .btn {
        width: 100%;
        justify-content: center;
    }

    .export-buttons {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }

    .export-buttons .btn {
        margin: 0;
    }

    .status-badge {
        width: 100%;
        justify-content: center;
    }
}
  </style>
  <div class="invoice-container">
    <div class="page-header">
<!--      <a href="${pageContext.request.contextPath}/customer/invoices" class="btn btn-outline-secondary mb-3">
        <i class="fas fa-arrow-left me-2"></i> Back to Invoices
      </a>-->
      
      <div class="invoice-header">
        <div class="invoice-id">Invoice - ${invoice.orderInfo}</div>
        <div class="invoice-date">
          <span class="me-3">Issued: <fmt:formatDate value="${invoice.createdDate}" pattern="dd MMM yyyy"/></span>-
          <span>Due: <fmt:formatDate value="${invoice.expireDate}" pattern="dd MMM yyyy"/></span>
        </div>
        <div>
          <span class="status-badge status-${invoice.status}">${invoice.status}</span>
        </div>
      </div>
    </div>

    <div class="invoice-summary">
      <div class="summary-item">
        <div class="label">Total Amount</div>
        <div class="value">$${invoice.amount}</div>
      </div>
      </div>

    </div>

    <div class="invoice-meta">
      <div class="meta-section">
        <h3>Related Visit</h3>
        <c:choose>
          <c:when test="${not empty invoice.appointmentId}">
            <p><strong>Appointment ID:</strong> ${invoice.appointmentId}</p>
          </c:when>
          <c:otherwise>
            <p>No related visit information</p>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

      
      <button class="pay" onclick="payInvoice(${invoice.id}, ${invoice.amount}, ${invoice.txnRef})">Pay Invoice</button>
    <div class="card">
      <div class="card-header">
        <i class="fas fa-list-ul me-2"></i> Invoice Items
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table class="table">
            <thead>
              <tr>
                <th>Description</th>
                <th class="text-end"></th>
                <th class="text-end">Status</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty transaction.bankCode}">
                    <tr>
                      <td class="text">Payment with ${transaction.bankCode}</td>
                      <td class="text"></td>
                      <td class="text-end">${transaction.status}</td>
                    </tr>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="4" class="text-center">No transaction found for this invoice</td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
           
          </table>
        </div>
      </div>
    </div>

    

    

    <div class="action-buttons">
      <div>
        <a href="${pageContext.request.contextPath}/customer/invoices" class="btn btn-secondary">
          <i class="fas fa-list me-2"></i> Back to Invoice List
        </a>
      </div>
      <div>
        <a href="${pageContext.request.contextPath}/invoices/${invoice.id}/export" class="btn btn-primary me-2">
          <i class="fas fa-print me-2"></i> Print Invoice
        </a>
        <a href="${pageContext.request.contextPath}/invoices/${invoice.id}/export" class="btn btn-primary">
          <i class="fas fa-file-pdf me-2"></i> Download PDF
        </a>
      </div>
    </div>

  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
  <script>
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
