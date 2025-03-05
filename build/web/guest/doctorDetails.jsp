<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Chi Tiết Bác Sĩ</title>
        <style>
            body {
                font-family: 'Poppins', sans-serif;
                background-color: #f8f9fa;
                color: #333;
            }
            .container {
                max-width: 900px;
                margin: 40px auto;
                padding: 20px;
                background: white;
                border-radius: 10px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                text-align: center;
            }
            .doctor-img {
                width: 150px;
                height: 150px;
                border-radius: 50%;
                object-fit: cover;
                border: 4px solid #007bff;
            }
            .action-btn {
                display: inline-block;
                padding: 10px 16px;
                background: #00c0ef;
                color: white;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
            }
            .action-btn:hover {
                background: #0056b3;
            }
            .rating-container {
                margin-top: 30px;
                text-align: left;
            }
            .rating {
                background: #f4f4f4;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 10px;
            }
            .popup {
                display: none;
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2);
                width: 300px;
            }
            .popup input, .popup textarea {
                width: 100%;
                margin: 10px 0;
            }
            .stars {
                display: flex;
                flex-direction: row-reverse; /* Đảo ngược thứ tự sao */
                justify-content: center;
            }
            .stars input {
                display: none;
            }
            .stars label {
                font-size: 25px;
                color: gray;
                cursor: pointer;
                transition: color 0.3s;
            }
            .stars input:checked ~ label,
            .stars label:hover,
            .stars label:hover ~ label {
                color: gold;
            }

            .average-rating {
                font-size: 1.2em;
                margin-bottom: 15px;
            }
            
             .rating-filter {
            margin-bottom: 10px;
        }

        .rating-filter a {
            display: inline-block;
            padding: 5px 10px;
            margin-right: 5px;
            background-color: #ddd;
            color: #333;
            text-decoration: none;
            border-radius: 5px;
        }

        .rating-filter a.active {
            background-color: #007bff;
            color: white;
        }
        </style>
    </head>
    <body>
        <jsp:include page="../Header.jsp"/>
        <div class="container">
            <img src="img/doctors/${doctor.img}" alt="Bác sĩ ${doctor.name}" class="doctor-img">
            <h2>${doctor.name}</h2>
            <p><strong>Chuyên khoa:</strong> ${doctor.specialties}</p>
            <p><strong>Giá khám:</strong> ${doctor.price}</p>
            <p><strong>Lịch khám:</strong> Hẹn khám</p>
            <a href="bookAppointment.jsp?doctorId=${doctor.id}" class="action-btn">Đặt lịch hẹn</a>
            <c:if test="${not empty sessionScope.currentCustomer}">
                <c:choose>
                    <c:when test="${not empty userRating}">
                        <button class="action-btn" onclick="openPopup(true)">Sửa đánh giá</button>
                    </c:when>
                    <c:otherwise>
                        <button class="action-btn" onclick="openPopup(false)">Đánh giá Bác sĩ</button>
                    </c:otherwise>
                </c:choose>
            </c:if>
        </div>
        <div class="rating-container container">
            <h3>Thông tin bác sĩ</h3>
            ${doctor.info}
        </div>
        <div class="rating-container container">
            <h3>Đánh giá từ khách hàng</h3>
            <div class="average-rating">
                ⭐ Trung bình: <strong>${doctor.average_rating}</strong> / 5
            </div>

            <div class="rating-filter">
                <a href="?id=${doctor.id}" class="${param.ratingFilter == null ? 'active' : ''}">Tất cả</a>
                <c:forEach var="i" begin="1" end="5">
                    <a href="?id=${doctor.id}&ratingFilter=${i}" class="${param.ratingFilter == i ? 'active' : ''}">${i} Sao</a>
                </c:forEach>
            </div>

            <%-- Hiển thị danh sách đánh giá đã lọc --%>
            <c:forEach var="rating" items="${filteredRatings}">
                <div class="rating">
                    <strong>${rating.customerUsername}</strong> - ⭐ ${rating.rating}
                    <p>${rating.comment}</p>
                </div>
            </c:forEach>

        </div>
        <div id="ratingPopup" class="popup">

            <h3>Đánh giá Bác sĩ</h3>
            <form action="RatingServlet" method="post">
                <input type="hidden" name="doctorId" value="${doctor.id}">

                <div class="stars">
                    <c:forEach var="i" begin="1" end="5">
                        <input type="radio" id="star${i}" name="rate" value="${i}" ${userRating.rate == i ? 'checked' : ''}>
                        <label for="star${i}">★</label>
                    </c:forEach>
                </div>
                <textarea name="comment" placeholder="Nhập nhận xét...">${userRating.comment}</textarea>
                <button type="submit" class="action-btn">Lưu</button>
                <c:if test="${not empty userRating}">
                    <button type="button" class="action-btn" style="background: red;" onclick="deleteRating()">Xóa</button>
                </c:if>
                <button type="button" class="action-btn" onclick="closePopup()">Hủy</button>
            </form>
        </div>


        <script>
            function openPopup(isEdit) {
                document.getElementById('ratingPopup').style.display = 'block';
            }
            function closePopup() {
                document.getElementById('ratingPopup').style.display = 'none';
            }
            function deleteRating() {
                if (confirm('Bạn có chắc muốn xóa đánh giá này không?')) {
                    alert('Đánh giá đã được xóa!');
                    closePopup();
                }
            }
        </script>
        <jsp:include page="../Footer.jsp"/>
    </body>
</html>