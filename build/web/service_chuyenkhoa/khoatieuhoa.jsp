<%-- 
    Document   : khoatieuhoa
    Created on : Feb 6, 2025, 12:45:26 AM
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
            <h1>Khoa Tiêu Hóa</h1>
        </section>

        <section class="overview">
            <h2>Tổng Quan Dịch Vụ</h2>
            <p>Trung tâm Tiêu hóa tại Việt Nam tập trung phát triển các phương pháp và 
                kỹ thuật chẩn đoán, điều trị hiện đại, chuyên sâu. Với ưu tiên các kỹ thuật ít xâm lấn, trung tâm mong muốn mang lại 
                hiệu quả điều trị cao, giảm đau, rút ngắn thời gian phục hồi, đồng thời đảm bảo tính thẩm mỹ, nâng cao chất lượng cuộc 
                sống cho bệnh nhân.</p>
        </section>

        <div class="flex list_content_subcate">
            <div class="col-6 thumb_subcate" style="aspect-ratio:6000/4000">
                <picture>
                    
                    <img loading="lazy" src="https://vcdn1-suckhoe.vnecdn.net/2016/09/26/Doi-ngu-BS-500x300-6536-1474860812.jpg?w=460&h=0&q=100&dpr=2&fit=crop&s=WzpEhhbluBOa6W-AR8QVvQ" alt="" class="full uploaded img-in-body" style="aspect-ratio:234/156">
                </picture>
            </div>

            <div class="col-6 desc_subcate">
                <div class="tit_content_subcate">Hoạt động 24/7</div>
                <div class="f16 mb3"><p>Tất cả các ngày trong tuần, kể cả Thứ 7, Chủ nhật và ngày lễ trong năm&nbsp;</p></div>
                <div class="tit_content_subcate">Đội ngũ chuyên gia</div>
                <div class="f16 mb3">
                    <ul>
                       <p>Với đội ngũ chuyên gia hàng đầu tại Việt Nam trong các lĩnh vực nội tiêu hóa, ngoại tiêu hóa và tiết niệu, cùng 
                           với các trang thiết bị hiện đại từ các nhà sản xuất nổi tiếng thế giới, Trung tâm Tiêu hóa 
                           Medinova đã thành công trong việc thực hiện các kỹ thuật phức tạp một cách thường xuyên. Đồng thời, 
                           trung tâm cũng đã tiên phong tiếp cận và làm chủ các kỹ thuật điều trị đột phá, mang lại hiệu quả điều trị vượt trội.</p> 
                    </ul>
                </div>
            </div>
        </div>
            
            <div class="flex list_content_subcate ck-reverse" style="flex-direction: row-reverse">
    <div class="col-6 thumb_subcate" style="aspect-ratio:612/408">
        <picture>
            
            <img loading="lazy" src="https://www.vinmec.com/static/uploads/large_20200307_062228_136520_Noi_soi_tieu_hoa_Vi_max_1800x1800_jpg_2b2c8906bf.jpg" alt="" class="full uploaded img-in-body" style="aspect-ratio:234/156">
        </picture>
    </div>

    <div class="col-6 desc_subcate">
        <div class="tit_content_subcate">Thành tựu nổi bật</div>
        <div class="f16 mb3">
            <ul>
                <p>Hiện nay, Medinova đã thực hiện được trên 90% loại phẫu thuật tiêu hóa bằng phẫu thuật nội soi, 
                    kể cả các phẫu thuật rất lớn, đòi hỏi trình độ chuyên môn cao như: Phẫu thuật nội soi điều trị ung thư thực quản, 
                    phẫu thuật nội soi cắt toàn bộ và phần lớn dạ dày điều trị ung thư dạ dày, phẫu thuật nội soi cắt toàn bộ đại tràng, 
                    trực tràng...</p>
                <p>Đối với can thiệp chẩn đoán hình ảnh: Các kỹ thuật nút mạch hóa chất động mạch gan, tán sỏi đường mật 
                    cứng trong và ngoài gan bằng laser tạo ra bước đột phá 
                    trong điều trị sỏi mật hiện nay ở Việt Nam.</p>
            </ul>
        </div>
    </div>
</div>
            
            
    </main>
        <jsp:include page="Footer.jsp"></jsp:include>
    </body>
</html>
