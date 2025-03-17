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
  <link rel="stylesheet" href="/${pageContext.request.contextPath}/static/css/customer/invoices.css">
</head>
<body>
       <jsp:include page="../Header.jsp"/>
  <div class="container">
    <div class="page-header">
      <a href="${pageContext.request.contextPath}/customer/invoices" class="btn btn-outline-secondary mb-3">
        <i class="fas fa-arrow-left me-2"></i> Back to Invoices
      </a>
      
      <div class="invoice-header">
        <div class="invoice-id">Invoice #${invoice.id}</div>
        <div class="invoice-date">
          <span class="me-3">Issued: <fmt:formatDate value="${invoice.createdDate}" pattern="dd MMM yyyy"/></span>
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
      <div class="summary-item">
        <div class="label">Paid Amount</div>
        <div class="value value-success">$</div>
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
                <th class="text-end">Unit Price</th>
                <th class="text-end">Total</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty transactions}">
                  <c:forEach var="item" items="${transactions}">
                    <tr>
                      <td class="text-center">${item.id}</td>
                      <td class="text-end">$</td>
                      <td class="text-end">$</td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="4" class="text-center">No items found for this invoice</td>
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
  <script></script>
</body>
</html>
