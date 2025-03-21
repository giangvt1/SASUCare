<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Kết Quả Thanh Toán</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
        <link href="/vnpay_jsp/assets/bootstrap.min.css" rel="stylesheet"/>
        <style>
            :root {
                --primary-blue: #2563EB;
                --light-blue: #EFF6FF;
                --success-color: #10B981;
                --error-color: #EF4444;
            }

            body {
                background-color: var(--light-blue);
                font-family: 'Segoe UI', system-ui, sans-serif;
                color: #1F2937;
                line-height: 1.6;
            }

            .vnpay-container {
                max-width: 1000px;
                margin: 2rem auto;
                padding: 2rem;
                background: white;
                border-radius: 16px;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            }

            .header {
                text-align: center;
                margin-bottom: 2rem;
                padding-bottom: 1rem;
                border-bottom: 2px solid var(--light-blue);
            }

            .status-badge {
                display: inline-block;
                padding: 0.5rem 1rem;
                border-radius: 9999px;
                font-weight: 600;
                margin: 1rem 0;
            }

            .status-badge.success {
                background-color: #DCFCE7;
                color: var(--success-color);
            }

            .status-badge.error {
                background-color: #FEE2E2;
                color: var(--error-color);
            }

            .transaction-details {
                background-color: var(--light-blue);
                padding: 1.5rem;
                border-radius: 12px;
                margin: 1.5rem 0;
            }

            .detail-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 0.75rem 0;
                border-bottom: 1px solid rgba(37, 99, 235, 0.1);
            }

            .detail-row:last-child {
                border-bottom: none;
            }

            .detail-label {
                font-weight: 600;
                color: #4B5563;
            }

            .detail-value {
                color: var(--primary-blue);
                font-weight: 500;
            }

            .buttons-container {
                display: flex;
                gap: 1rem;
                justify-content: center;
                margin-top: 2rem;
                flex-wrap: wrap;
            }

            .btn {
                padding: 0.75rem 1.5rem;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .btn-primary {
                background-color: var(--primary-blue);
                color: white;
                border: none;
            }

            .btn-outline {
                background-color: transparent;
                border: 2px solid var(--primary-blue);
                color: var(--primary-blue);
            }

            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.2);
            }

            .btn-primary:hover {
                background-color: #1D4ED8;
            }

            .btn-outline:hover {
                background-color: var(--light-blue);
            }

            .footer {
                text-align: center;
                margin-top: 2rem;
                padding-top: 1rem;
                color: #6B7280;
                border-top: 2px solid var(--light-blue);
            }

            @media (max-width: 640px) {
                .container {
                    margin: 1rem;
                    padding: 1rem;
                }

                .detail-row {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 0.5rem;
                }

                .buttons-container {
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                    justify-content: center;
                }
            }
        </style>

        <%
        String vnp_PayDate = (String) request.getAttribute("vnp_PayDate");  
        if (vnp_PayDate != null) {
        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyyMMddHHmmss");
        Date parsedDate = inputFormat.parse(vnp_PayDate);

        // Đặt parsedDate vào request scope để sử dụng trong JSP
        request.setAttribute("parsedDate", parsedDate);
    }
        %>
    </head>
    <body>
 <jsp:include page="../Header.jsp"/>
 
        <div class="vnpay-container">
            <div class="header">
                <h2 style="color: var(--primary-blue); font-size: 1.875rem; font-weight: 600;">
                    Kết Quả Thanh Toán
                </h2>
                <!-- Status Badge -->
                <div class="status-badge ${vnp_ResponseCode == '00' ? 'success' : 'error'}">
                    <i class="fas ${vnp_ResponseCode == '00' ? 'fa-check-circle' : 'fa-times-circle'}"></i>
                    ${vnp_ResponseCode == '00' ? 'Thanh Toán Thành Công' : 'Thanh Toán Thất Bại'}
                </div>
            </div>

            <div class="transaction-details">
                <div class="detail-row">
                    <span class="detail-label">Mã giao dịch thanh toán:</span>
                    <span class="detail-value">${vnp_TxnRef}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Số tiền:</span>
                    <span class="detail-value">
                        <fmt:formatNumber value="${vnp_Amount / 100}" pattern="#,###" /> VNĐ
                    </span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Mô tả giao dịch:</span>
                    <span class="detail-value">${vnp_OrderInfo}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Mã giao dịch tại VNPAY:</span>
                    <span class="detail-value">${vnp_TransactionNo}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Ngân hàng:</span>
                    <span class="detail-value">${vnp_BankCode}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Thời gian thanh toán:</span>
                    <span class="detail-value"> <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm:ss"/></span>
                </div>
            </div>

            <div class="buttons-container">
                <button onclick="window.location.href = '${pageContext.request.contextPath}/home" class="btn btn-outline">
                    <i class="fas fa-arrow-left"></i> Quay Lại
                </button>
                <button onclick="window.location.href = '${pageContext.request.contextPath}/customer/invoice-details/${invoiceId}'" class="btn btn-primary">
                    <i class="fas fa-file-invoice"></i> Chi Tiết Hóa Đơn
                </button>
                <button onclick="exportToFile()" class="btn btn-outline">
                    <i class="fas fa-download"></i> Xuất File
                </button>
            </div>

            <footer class="footer">
                <p>&copy; VNPAY ${java.time.Year.now().getValue()}</p>
            </footer>
        </div>
 <jsp:include page="../Footer.jsp"/>
        <script src="/vnpay_jsp/assets/jquery-1.11.3.min.js"></script>
        <script>
                    const vnp_Amount = ${vnp_Amount}
                    function exportToFile() {
                        // Create the content for the file
                        const content = `
Kết Quả Thanh Toán
------------------
Mã giao dịch: ${vnp_TxnRef}
Số tiền: ` + vnp_Amount / 100`+ VNĐ
Mô tả: ${vnp_OrderInfo}
Mã giao dịch VNPAY: ${vnp_TransactionNo}
Ngân hàng: ${vnp_BankCode}
Thời gian: ${vnp_PayDate}
Trạng thái: ${vnp_ResponseCode == '00' ? 'Thành công' : 'Thất bại'}
            `.trim();

                        // Create a Blob with the content
                        const blob = new Blob([content], {type: 'text/plain;charset=utf-8'});

                        // Create a link element and trigger the download
                        const link = document.createElement('a');
                        link.href = window.URL.createObjectURL(blob);
                        link.download = `payment_result_${vnp_TxnRef}.txt`;
                        link.click();
                    }

                    // If payment is successful, redirect to invoice after 3 seconds
            <c:if test="${status == '00'}">
                    setTimeout(function () {
                        window.location.href = "${pageContext.request.contextPath}/customer/invoice-details/${invoiceId}";
                    }, 3000);
            </c:if>
        </script>
        
    </body>
</html>
