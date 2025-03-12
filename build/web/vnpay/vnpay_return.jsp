<%@page import="java.net.URLEncoder"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="com.vnpay.common.Config"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="dao.TransactionDBContext"%>
<%@page import="model.Transaction"%>
<%@page import="model.Invoice"%>
<%@page import="java.time.LocalDateTime"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>KẾT QUẢ THANH TOÁN</title>
    <link href="/vnpay_jsp/assets/bootstrap.min.css" rel="stylesheet"/>
    <script src="/vnpay_jsp/assets/jquery-1.11.3.min.js"></script>
</head>
<body>
<%
    // Bắt đầu xử lý phản hồi từ VNPAY
    Map<String, String> fields = new HashMap<>();
    for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
        String fieldName = params.nextElement();
        String fieldValue = request.getParameter(fieldName);
        if (fieldValue != null && !fieldValue.isEmpty()) {
            fields.put(fieldName, fieldValue);
        }
    }

    String vnp_SecureHash = request.getParameter("vnp_SecureHash");
    if (fields.containsKey("vnp_SecureHashType")) fields.remove("vnp_SecureHashType");
    if (fields.containsKey("vnp_SecureHash")) fields.remove("vnp_SecureHash");
    String signValue = Config.hashAllFields(fields);

    // Lấy thông tin từ request
    String vnp_TxnRef = request.getParameter("vnp_TxnRef");
    String vnp_TransactionNo = request.getParameter("vnp_TransactionNo");
    String vnp_BankCode = request.getParameter("vnp_BankCode");
    String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
    String vnp_PayDate = request.getParameter("vnp_PayDate");

    // Xác định trạng thái thanh toán
    String status = "00".equals(vnp_ResponseCode) ? "SUCCESS" : "FAILURE";

    // Lấy invoice ID từ bảng Invoice dựa vào vnp_TxnRef
    int invoiceId = 1; // Mặc định không tìm thấy
    try (Connection connection = DriverManager.getConnection(
            "jdbc:sqlserver://localhost\\SQLEXPRESS:1433;databaseName=test1;encrypt=true;trustServerCertificate=true;",
            "golden", "dx2134");
         PreparedStatement ps = connection.prepareStatement("SELECT id FROM Invoice WHERE vnp_TxnRef = ?")) {
        
        ps.setString(1, vnp_TxnRef);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                invoiceId = rs.getInt("id");
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    // Nếu tìm thấy invoice, lưu transaction vào database
    if (invoiceId != -1) {
        TransactionDBContext transactionDAO = new TransactionDBContext();
        Invoice invoice = new Invoice();
        invoice.setId(invoiceId); // Set ID của invoice cho transaction

        Transaction transaction = new Transaction();
        transaction.setInvoice(invoice);
        transaction.setVnpTxnRef(vnp_TxnRef); // Store VNPAY transaction reference
        transaction.setBankCode(vnp_BankCode);
        transaction.setPaymentMethod("VNPAYQR");
        transaction.setPaymentUrl("https://sandbox.vnpayment.vn/transaction");
        transaction.setStatus(status);
        transaction.setTransactionDate(Timestamp.valueOf(LocalDateTime.now()));

        transactionDAO.insert(transaction);
    }
%>

<div class="container">
    <div class="header clearfix">
        <h3 class="text-muted">KẾT QUẢ THANH TOÁN</h3>
    </div>
    <div class="table-responsive">
        <div class="form-group">
            <label>Mã giao dịch thanh toán:</label>
            <label><%=vnp_TxnRef%></label>
        </div>    
        <div class="form-group">
            <label>Số tiền:</label>
            <label><%=request.getParameter("vnp_Amount")%></label>
        </div>  
        <div class="form-group">
            <label>Mô tả giao dịch:</label>
            <label><%=request.getParameter("vnp_OrderInfo")%></label>
        </div> 
        <div class="form-group">
            <label>Mã lỗi thanh toán:</label>
            <label><%=request.getParameter("vnp_ResponseCode")%></label>
        </div> 
        <div class="form-group">
            <label>Mã giao dịch tại CTT VNPAY-QR:</label>
            <label><%=request.getParameter("vnp_TransactionNo")%></label>
        </div> 
        <div class="form-group">
            <label>Mã ngân hàng thanh toán:</label>
            <label><%=request.getParameter("vnp_BankCode")%></label>
        </div> 
        <div class="form-group">
            <label>Thời gian thanh toán:</label>
            <label><%=request.getParameter("vnp_PayDate")%></label>
        </div> 
        <div class="form-group">
            <label>Tình trạng giao dịch:</label>
            <label>
                <%
                    if (signValue.equals(vnp_SecureHash)) {
                        if ("00".equals(request.getParameter("vnp_TransactionStatus"))) {
                            out.print("Thành công");
                        } else {
                            out.print("Không thành công");
                        }
                    } else {
                        out.print("Invalid signature");
                    }
                %>
            </label>
        </div> 
    </div>
    <p>&nbsp;</p>
    <footer class="footer">
        <p>&copy; VNPAY 2020</p>
    </footer>
</div>  
</body>
</html>
