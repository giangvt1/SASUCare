<%-- 
    Document   : khoaxuongkhop
    Created on : Feb 5, 2025, 11:23:27 PM
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
                    <h1>Khoa Xương Khớp</h1>
                </section>

                <section class="overview">
                    <h2>Tổng Quan Dịch Vụ</h2>
                    <p>Khoa Xương Khớp là một chuyên khoa y tế chuyên sâu, tập trung vào việc chẩn đoán, điều trị và phục hồi các bệnh lý 
                        liên quan đến xương, khớp, cơ và mô mềm. Đội ngũ bác sĩ tại khoa thường bao gồm các chuyên gia có trình độ cao, 
                        được đào tạo bài bản trong lĩnh vực cơ xương khớp.</p>
                </section>

                <div class="flex list_content_subcate">
                    <div class="col-6 thumb_subcate" style="aspect-ratio:6000/4000">
                        <picture>

                            <img loading="lazy" src="https://images2.thanhnien.vn/528068263637045248/2024/8/30/2-17250136576371460808528.jpg" alt="" class="full uploaded img-in-body" style="aspect-ratio:234/156">
                        </picture>
                    </div>

                    <div class="col-6 desc_subcate">
                        <div class="tit_content_subcate">Hoạt động 24/7</div>
                        <div class="f16 mb3"><p>Tất cả các ngày trong tuần, kể cả Thứ 7, Chủ nhật và ngày lễ trong năm&nbsp;</p></div>
                        <div class="tit_content_subcate">Công Nghệ Hiện Đại Trong Điều Trị Chấn Thương</div>
                        <div class="f16 mb3">
                            <ul>
                                <p>Y học thể thao Vinmec còn sở hữu các trang thiết bị và công nghệ hiện đại lần đầu tiên có mặt tại Việt Nam:
                                    Phòng Phân tích Vận động (Motion Analysis Lab): Sử dụng hệ thống công nghệ cao để ghi nhận và phân tích động học, động lực học, sức cơ, điện thần kinh cơ, và thành phần cơ thể, giúp lập kế 
                                    hoạch điều trị hoặc luyện tập cá thể hóa, giảm nguy cơ chấn thương và nâng cao thành tích thể thao.  
                                    Phương pháp "Ánh xạ giải phẫu": Sử dụng công nghệ hình ảnh 3D để phân tích các thông số dây chằng ở bên 
                                    lành nhằm tạo ra thiết kế “bản sao soi gương” cho bên bị đứt dây chằng,  giúp phẫu thuật viên có thể tái tạo các dây chằng “cá thể hóa” với 
                                    độ chính xác cao.</p> 
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="flex list_content_subcate ck-reverse" style="flex-direction: row-reverse">
                    <div class="col-6 thumb_subcate" style="aspect-ratio:612/408">
                        <picture>

                            <img loading="lazy" src="https://benhvienk.vn/data/media//images/2022/280654147_1671423533219018_3489173214382772023_n.jpg" alt="" class="full uploaded img-in-body" style="aspect-ratio:234/156">
                        </picture>
                    </div>

                    <div class="col-6 desc_subcate">
                        <div class="tit_content_subcate">Định Hướng Phát Triển Bền Vững</div>
                        <div class="f16 mb3">
                            <ul>
                                <p>Để đáp ứng nhu cầu ngày càng tăng của bệnh nhân, trung tâm không ngừng cải tiến và mở rộng các dịch vụ chăm 
                                    sóc sức khỏe. Chúng tôi cam kết sẽ tiếp tục đầu tư vào công nghệ mới và nâng cao năng lực đội ngũ y bác sĩ, 
                                    nhằm mang đến trải nghiệm chăm sóc sức khỏe tốt nhất. Đặc biệt, chúng tôi sẽ tập trung vào việc phát triển 
                                    các chương trình phục hồi chức năng sau phẫu thuật, giúp bệnh nhân sớm trở lại cuộc sống bình thường và nâng 
                                    cao chất lượng cuộc sống.</p>
                            </ul>
                        </div>
                    </div>
                </div>


            </main>
        <jsp:include page="Footer.jsp"></jsp:include>
    </body>
</html>
