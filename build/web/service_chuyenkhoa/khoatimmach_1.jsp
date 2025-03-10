<%-- 
    Document   : khoatimmach
    Created on : Feb 5, 2025, 10:55:13 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    <style>
        body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
}

header {
    background-color: #0073e6;
    padding: 20px;
}

nav ul {
    list-style: none;
    padding: 0;
}

nav ul li {
    display: inline;
    margin-right: 20px;
}

nav ul li a {
    color: white;
    text-decoration: none;
}

.hero {
    background: url('hero-image.jpg') no-repeat center center;
    height: 300px;
    text-align: center;
    color: white;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 3rem;
}

main {
    padding: 20px;
}

h1, h2 {
    color: #333;
}

.flex {
    display: flex;
    justify-content: space-between;
    gap: 20px;
}

.col-6 {
    flex: 1;
}

.thumb_subcate {
    position: relative;
    width: 100%;
}

.thumb_subcate picture img {
    width: 100%;
    object-fit: cover;
}

.desc_subcate {
    padding: 10px;
    background-color: #f7f7f7;
}

.tit_content_subcate {
    font-size: 1.25rem;
    font-weight: bold;
    margin-bottom: 10px;
}

.f16 {
    font-size: 16px;
}

.mb3 {
    margin-bottom: 15px;
}

ul {
    padding-left: 20px;
}

ul li {
    margin-bottom: 10px;
}
</style>
    </head>
    <body>
        <jsp:include page="Header.jsp"></jsp:include>
        <main>
        <section class="hero">
            <h1>Khoa Tim Mạch</h1>
        </section>

        <section class="overview">
            <h2>Tổng Quan Dịch Vụ</h2>
            <p>Trung tâm Tim mạch Medinova hiện là một trong số ít các Trung tâm tim mạch có quy mô lớn và uy tín ở Việt Nam, 
                được trang bị các phương tiện hiện đại, tuân thủ các quy trình thăm khám bệnh chuyên nghiệp, 
                được cấp chứng chỉ quản lý, chăm sóc bệnh mạch vành và suy tim theo tiêu chuẩn của trường môn tim mạch Hoa Kỳ (ACC). 
                Chuyên khoa Tim mạch của Medinova cung cấp dịch vụ điều trị, chăm sóc bệnh lý tim mạch cho bệnh nhân trong nước và quốc tế 
                theo các tiêu chuẩn quốc tế. Tùy theo tình trạng bệnh lý, người bệnh sẽ được thăm khám và điều trị tại tại các đơn vị tim mạch 
                chuyên sâu: Nội tim mạch, can thiệp tim mạch và ngoại tim mạch. Nhằm đạt kết quả tối ưu cho từng người bệnh Các bác sĩ Medinova 
                điều trị bệnh lý tim mạch theo phương thức cá thể hóa bằng các phương pháp nội khoa, phẫu thuật, thông tim can thiệp và nhiều 
                kỹ thuật cao cấp khác. Đội ngũ chuyên gia của Trung tâm Tim mạch Medinova là các Giáo sư, Tiến sĩ, Bác sĩ Chuyên khoa 2, 
                Thạc sĩ - Bác sĩ giàu kinh nghiệm trong chẩn đoán và điều trị các bệnh lý mạch máu, van tim, cơ tim, rối loạn nhịp tim, 
                tim bẩm sinh, tim nhiễm khuẩn, suy tim, bệnh mạch vành ...</p>
        </section>

        <div class="flex list_content_subcate">
            <div class="col-6 thumb_subcate" style="aspect-ratio:6000/4000">
                <picture>
                    
                    <img loading="lazy" src="https://phongkhamykhoasaigon.com/wp-content/uploads/2024/01/kham-tim-mach-lam-sang.jpg" alt="" class="full uploaded img-in-body" style="aspect-ratio:234/156">
                </picture>
            </div>

            <div class="col-6 desc_subcate">
                <div class="tit_content_subcate">Hoạt động 24/7</div>
                <div class="f16 mb3"><p>Tất cả các ngày trong tuần, kể cả Thứ 7, Chủ nhật và ngày lễ trong năm&nbsp;</p></div>
                <div class="tit_content_subcate">Khám và điều trị theo tiêu chuẩn Mỹ</div>
                <div class="f16 mb3">
                    <ul>
                       <p>Là thành viên của Cleveland Clinic Connected – Hệ thống Y tế số 1 Hoa Kỳ, Trung tâm Tim mạch Medinova tiếp cận, 
                           chuyển giao các kinh nghiệm, quy trình áp dụng tại các cơ sở của Cleveland Clinic trên toàn thế giới, 
                           không ngừng nâng cao chất lượng điều trị. Đặc biệt, các trường hợp bệnh nhân khó có thể tham vấn trực tiếp ý kiến thứ 2 
                           với các chuyên gia Cleveland Clinic để lựa chọn phương án tốt trong quá trình điều trị.</p><p>&nbsp;</p><p>Từ năm 2022, 
                           các Trung tâm Tim mạch tại Bệnh viện Medinova Times City (Hà Nội) và Medinova Central Park (TP.HCM) là những Trung tâm 
                           xuất sắc (COE) đầu tiên tại Châu Á được Trường môn Tim mạch Hoa Kỳ (ACC) công nhận đạt chuẩn về quản lý bệnh mạch vành 
                           và suy tim. Theo đó, người bệnh suy tim và mạch vành được chăm sóc sức khỏe người bệnh toàn diện từ chẩn đoán tới theo 
                           dõi sau xuất viện tại nhà. Việc áp dụng mô hình chuẩn quốc tế trong quản lý bệnh tim mạch tại Medinova thực sự giúp cải 
                           thiện chất lượng cuộc sống, tăng tuổi thọ và tối ưu chi phí cho người bệnh. Tỷ lệ tái nhập viện do suy tim trung bình 
                           từ 18% xuống chỉ còn xấp xỉ 0%, thời gian nằm viện từ 8 ngày giảm xuống 4 ngày, đồng thời hạ thấp các nguy cơ biến chứng và khả năng tái nhập viện trong vòng 30 ngày.</p> 
                    </ul>
                </div>
            </div>
        </div>
            
            <div class="flex list_content_subcate ck-reverse" style="flex-direction: row-reverse">
    <div class="col-6 thumb_subcate" style="aspect-ratio:612/408">
        <picture>
            
            <img loading="lazy" src="https://www.vinmec.com/static/uploads/medium_VMTC_202413342_copy_e95f603cf0.jpg" alt="" class="full uploaded img-in-body" style="aspect-ratio:234/156">
        </picture>
    </div>

    <div class="col-6 desc_subcate">
        <div class="tit_content_subcate">Làm chủ các kỹ thuật điều trị</div>
        <div class="f16 mb3">
            <ul>
                <p>Với tầm nhìn trở thành tổ chức y tế hàn lâm mang lại giá trị cao và trải nghiệm xuất sắc cho người bệnh, 
                    Trung tâm Tim mạch Medinova tuân thủ các quy trình điều trị, chăm sóc theo tiêu chuẩn Mỹ. Đội ngũ bác sĩ tại 
                    Trung tâm đã làm chủ và áp dụng thường quy các kỹ thuật khó về tim mạch hiện nay, đồng thời xử trí tối ưu các tình huống 
                    cấp cứu phát sinh, giúp người bệnh phục hồi tốt.</p>
            </ul>
        </div>
    </div>
</div>
            
            
    </main>
        <jsp:include page="Footer.jsp"></jsp:include>
    </body>
</html>
