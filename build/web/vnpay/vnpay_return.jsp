<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
<div class="container">
    <h3 class="text-muted">KẾT QUẢ THANH TOÁN</h3>
    
    <div class="table-responsive">
        <div class="form-group"><label>Mã giao dịch thanh toán:</label> <label>${vnp_TxnRef}</label></div>
        <div class="form-group"><label>Số tiền:</label> <label>${vnp_Amount}</label></div>
        <div class="form-group"><label>Mô tả giao dịch:</label> <label>${vnp_OrderInfo}</label></div>
        <div class="form-group"><label>Mã lỗi thanh toán:</label> <label>${vnp_ResponseCode}</label></div>
        <div class="form-group"><label>Mã giao dịch tại VNPAY:</label> <label>${vnp_TransactionNo}</label></div>
        <div class="form-group"><label>Mã ngân hàng:</label> <label>${vnp_BankCode}</label></div>
        <div class="form-group"><label>Thời gian thanh toán:</label> <label>${vnp_PayDate}</label></div>
        <div class="form-group"><label>Tình trạng giao dịch:</label> <label>${status}</label></div>
    </div>

    <footer class="footer">
        <p>&copy; VNPAY 2025</p>
    </footer>
</div>
</body>
</html>
