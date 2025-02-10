<%-- 
    Document   : khoanhi
    Created on : Feb 6, 2025, 12:57:52 AM
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
            <h1>Khoa Nhi</h1>
        </section>

        <section class="overview">
            
            <p></p>
        </section>

        <div class="flex list_content_subcate">
            <div class="col-6 thumb_subcate" style="aspect-ratio:6000/4000">
                <picture>
                    
                    <img loading="lazy" src="https://alltop.vn/backend/media/images/posts/657/Khoa_Nhi__Don_nguyen_so_sinh_-_Benh_vien_Thanh_Nhan-80013.png" alt="" class="full uploaded img-in-body" style="aspect-ratio:234/156">
                </picture>
            </div>

            <div class="col-6 desc_subcate">
                <div class="tit_content_subcate">Hoạt động 24/7</div>
                <div class="f16 mb3"><p>Tất cả các ngày trong tuần, kể cả Thứ 7, Chủ nhật và ngày lễ trong năm&nbsp;</p></div>
                <div class="tit_content_subcate">Tổng Quan</div>
                <div class="f16 mb3">
                    <ul>
                       <p>Trung tâm Nhi cung cấp các chương trình khám và theo dõi sức khỏe toàn diện cho trẻ em, phù hợp với từng độ tuổi, 
                           cũng như chương trình tiêm chủng với vac-xin chất lượng cao, có nguồn gốc rõ ràng, đảm bảo được cấp phép và bảo 
                           quản lạnh đúng chuẩn GSP.</p> 
                    </ul>
                </div>
            </div>
            
        </div>
            
            <div class="flex list_content_subcate ck-reverse" style="flex-direction: row-reverse">
    <div class="col-6 thumb_subcate" style="aspect-ratio:612/408">
        <picture>
            
            <img loading="lazy" src="https://medlatec.vn/media/2793/content/20230116_goc-kham-pha-bac-si-khoa-nhi-co-nhiem-vu-gi-trong-benh-vien-.jpg" alt="" class="full uploaded img-in-body" style="aspect-ratio:234/156">
        </picture>
    </div>

    <div class="col-6 desc_subcate">
        <div class="tit_content_subcate">Thành tựu nổi bật</div>
        <div class="f16 mb3">
            <ul>
                <p>Trung tâm cũng quy tụ đội ngũ bác sĩ và chuyên gia y tế đầu ngành của Việt Nam trong lĩnh vực Sơ sinh, 
                    có trình độ chuyên môn cao, giàu kinh nghiệm, hướng đến mục tiêu trở thành một trong những trung tâm hàng đầu của Việt Nam và khu vực 
                    cả về chuyên môn và nghiên cứu khoa học, đồng thời, đạt tiêu chuẩn Quốc tế cao nhất về quản lý chất lượng và an toàn cho bệnh nhân.</p>
                <p>Trung tâm thường xuyên có kế hoạch hợp tác chuyển giao kỹ thuật, trao đổi 
                    chuyên môn với các trung tâm Nhi khoa trên thế giới: Anh, Mỹ, Thụy Điển, Nhật Bản, Pháp…. 
                    Nhằm nâng cao năng lực chuyên môn và trình độ kỹ thuật cho đội ngũ nhân viên y tế.</p>
            </ul>
        </div>
    </div>
                
</div>
            
            
    </main>
        <jsp:include page="Footer.jsp"></jsp:include>
    </body>
</html>
