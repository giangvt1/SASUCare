<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Hóa đơn</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
            }
            h1 {
                color: #333;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 16px;
            }
            th, td {
                padding: 8px 12px;
                border: 1px solid #ccc;
                vertical-align: middle;
            }
            th {
                background-color: #f2f2f2;
            }
            .no-data {
                text-align: center;
                font-style: italic;
            }
        </style>
    </head>
    <body>

        <jsp:include page="../admin/AdminHeader.jsp" />
        <jsp:include page="../admin/AdminLeftSideBar.jsp" />
        <div class="right-side">
        <h1>Quản lý Hóa đơn</h1>

        <table>
            <thead>
                <tr>
                    <th>Order Info</th>
                    <th>Ngày Tạo (created_date)</th>
                    <th>Ngày Hết Hạn (expire_date)</th>
                    <th>Khách Hàng (customer_id)</th>
                    <th>Dịch Vụ (service_id)</th>
                    <th>vnp_TxnRef</th>
                    <th>Trạng Thái (status)</th>
                    <th>Appointment ID</th>
                </tr>
            </thead>
        </table>
        </div>
    </body>
</html>
