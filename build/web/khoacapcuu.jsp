<%-- 
    Document   : khoacapcuu
    Created on : Feb 5, 2025, 9:24:34 PM
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
            <h1>Cấp Cứu - Hồi Sức Tích Cực</h1>
        </section>

        <section class="overview">
            <h2>Tổng Quan Dịch Vụ</h2>
            <p>Medinova cung cấp dịch vụ cấp cứu chuyên nghiệp với đội ngũ bác sĩ có chứng chỉ quốc tế và trang thiết bị hiện đại.</p>
        </section>

        <div class="flex list_content_subcate">
            <div class="col-6 thumb_subcate" style="aspect-ratio:6000/4000">
                <picture>
                    
                    <img loading="lazy" src="https://storage-vnportal.vnpt.vn/hni-bvdkbd/1/Thuvienanh/KhoaHoiSucCapCuu/1.jpg" alt="" class="full uploaded img-in-body" style="aspect-ratio:234/156">
                </picture>
            </div>

            <div class="col-6 desc_subcate">
                <div class="tit_content_subcate">Hoạt động 24/7</div>
                <div class="f16 mb3"><p>Tất cả các ngày trong tuần, kể cả Thứ 7, Chủ nhật và ngày lễ trong năm&nbsp;</p></div>
                <div class="tit_content_subcate">Uy tín &amp; Phản ứng nhanh</div>
                <div class="f16 mb3">
                    <ul>
                        <li>Đội ngũ bác sĩ, nhân viên y tế được đào tạo bài bản, chuyên sâu về nhiều lĩnh vực hồi sức cấp cứu với chứng chỉ quốc tế như ACLS (Hồi sinh tim phổi nâng cao người lớn), PALS (Hồi sinh tim phổi nâng cao trẻ nhi), FCCS, luôn cập nhật những phác đồ, kỹ thuật cấp cứu hiện đại (như E-PCR…) đáp ứng trong mọi tình huống xảy ra. </li>
                        <li>Hỗ trợ đắc lực cho khoa Cấp cứu là đội ngũ thư ký chuyên môn phiên dịch viên đa ngôn ngữ Anh, Pháp, Hàn Quốc, Nhật Bản, Nga, Trung …</li>
                        <li>Tất cả các xe cấp cứu chuyên dụng được trang bị hiện đại với hệ thống máy thở chuyên nghiệp, máy monitor theo dõi liên tục các chỉ số sinh tồn, máy sốc điện tự động, băng ca chuyên dụng cấp cứu thông thường và đa chấn thương… Phản ứng xuất xe ngay khi có yêu cầu. </li>
                    </ul>
                </div>
            </div>
        </div>
            
            <div class="flex list_content_subcate ck-reverse" style="flex-direction: row-reverse">
    <div class="col-6 thumb_subcate" style="aspect-ratio:612/408">
        <picture>
            
            <img loading="lazy" src="https://tnh.com.vn/wp-content/uploads/2020/05/1-600x600-5.jpg" alt="" class="full uploaded img-in-body" style="aspect-ratio:234/156">
        </picture>
    </div>

    <div class="col-6 desc_subcate">
        <div class="tit_content_subcate">Quy trình cấp cứu chuyên nghiệp</div>
        <div class="f16 mb3">
            <ul>
                <li>Người bệnh được đánh giá chính xác và phân loại tình trạng bệnh theo thang điểm phân loại bệnh nhân của Úc tại khoa Cấp cứu – chống độc. (ATS), áp dụng các biện pháp cấp cứu thích hợp theo mức độ ưu tiên.</li>
                <li>Người bệnh được chăm sóc chuyên sâu, với sự phối hợp của nhiều chuyên khoa chuyên (chăm sóc theo nhóm chuyên khoa - Team Based Care) ngay từ lúc nhập viện, đảm bảo sự chính xác, nhanh chóng với mức độ tin cậy cao, để có thể nhanh chóng qua khỏi giai đoạn nguy kịch và ổn định.</li>
                <li>Khoa có đầy đủ chức năng cấp cứu và điều trị tình trạng cấp cứu, khẩn cấp cho bệnh nhân thuộc các chuyên ngành khác nhau: Nội, Ngoại, Sản, Nhi.</li>
                <li>Khoa Hồi sức cấp cứu Medinova cũng đảm nhiệm công tác hồi sức sau phẫu thuật, các ca bệnh diễn biến nặng cần chăm sóc đặc biệt (sau đột quỵ, sau chấn thương nặng, người cao tuổi bệnh nặng…).</li>
            </ul>
        </div>
    </div>
</div>
            
            
    </main>
        <jsp:include page="Footer.jsp"></jsp:include>
    </body>
</html>
