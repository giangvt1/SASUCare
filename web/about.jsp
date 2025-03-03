<%-- 
    Document   : about.jsp
    Created on : Jan 30, 2025, 11:37:13 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.0/css/all.min.css"
            rel="stylesheet"
            />
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css"
            rel="stylesheet"
            />

        <!-- Libraries Stylesheet -->
        <link href="../lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet" />
        <link
            href="../lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css"
            rel="stylesheet"
            />
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <link href="css/login_style.css" rel="stylesheet" type="text/css"/>
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                color: #333;
            }
            header {
                background-color: #0073e6;
                color: white;
                padding: 15px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .logo {
                font-size: 24px;
                font-weight: bold;
            }
            nav ul {
                list-style: none;
                padding: 0;
                margin: 0;
                display: flex;
            }
            nav ul li {
                margin-left: 20px;
            }
            nav ul li a {
                color: white;
                text-decoration: none;
            }

            .banner {
                background:
                    linear-gradient(to right, rgba(0, 123, 255, 0.7), rgba(0, 198, 255, 0.7)),
                    url('banner.jpg') no-repeat center center/cover;
                height: 300px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 36px;
                font-weight: bold;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
            }

            .content {
                padding: 40px;
                text-align: center;
            }
            .container {
                max-width: 800px;
                margin: auto;
            }
            footer {
                background-color: #f4f4f4;
                text-align: center;
                padding: 20px;
                margin-top: 20px;
            }
        </style>
    </head>
    <body>
        <jsp:include page="Header.jsp"></jsp:include>


            <section class="banner">
                <h1>About</h1>

            </section>
            <section class="flex align-items-center mt30 mb60 top_vision" style="display: flex; flex-wrap: wrap; justify-content: space-between;">
                <div class="col-6" style="flex: 1; padding: 10px; max-width: 50%;">
                    <img src="https://tamanhhospital.vn/wp-content/uploads/2021/02/dich-vu-dac-biet.jpg" alt="alt" style="width: 100%; height: auto;"/>
                </div>
                <div class="col-6 content_vision" style="flex: 1; padding: 10px; max-width: 50%;">
                    <div class="tittle_cate_news">Giới Thiệu</div>
                    <div class="mb30">
                        MEDINOVA là hệ thống y tế không vì lợi nhuận do Tập đoàn Grop6 đầu tư phát triển, 
                        với tầm nhìn trở thành một hệ thống y tế vươn tầm quốc tế thông qua những nghiên cứu đột phá, 
                        nhằm mang lại chất lượng điều trị xuất sắc và dịch vụ chăm sóc hoàn hảo.
                    </div>
                </div>
            </section>

            <section class="content">
                <div class="container">
                    <h2>Đội ngũ bác sĩ</h2>
                    <div class="intro-cat">
                        <div style="text-align: justify;">
                            <p style="line-height:1.9199999491373696; margin-bottom:19px">
                                MEDINOVA khẳng định sự chú trọng đầu tư 
                                năng lực y khoa khi là nơi hội tụ 30 vị Bác Sĩ, Tiến Sĩ, Thạc Sĩ điều trị chuyên sâu. MEDINOVA là 
                                hệ thống y tế tiên phong thành lập hội đồng chuyên môn, do TS.BS DR.Stone và các giám đốc chuyên môn giám sát, 
                                quản lý, đào tạo. Cùng với sứ mệnh mang đến hàng triệu nụ cười, MEDINOVA luôn nỗ lực nâng cao năng lực chuyên môn 
                                của đội ngũ y – bác sỹ, tiêu chuẩn dịch vụ khám chữa bệnh của MEDINOVA tương đương với các trung tâm điều trị y tế 
                                danh tiếng thuộc các quốc gia lớn trên thế giới.</p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-3 col-md-6 col-sm-12">
                            <div class="item-nhansu item-nhansu-page item-numo">
                                <div class="img-hvr img-item-nhansu">
                                    <img src="https://genk.mediacdn.vn/2018/6/12/jreobxc-15287884336212141623062.jpg" alt="TS BS " width="100%"/>
                                </div>
                                <div class="content-item-nhansu">
                                    <div class="chucvu">Chủ tịch HĐCM</div> 
                                    <h3 class="name-item-nhansu"><a href="">TS BS </a></h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 col-sm-12">
                            <div class="item-nhansu item-nhansu-page item-numo">
                                <div class="img-hvr img-item-nhansu">
                                    <img src="https://genk.mediacdn.vn/k:2016/img20160301180216250/top-5-bac-si-noi-tieng-trong-the-gioi-manga.jpg" alt="ThS-BS " width="100%"/>
                                </div>
                                <div class="content-item-nhansu">
                                    <div class="chucvu">Giám đốc chuyên môn </div> 
                                    <h3 class="name-item-nhansu"><a href="">ThS-BS </a></h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 col-sm-12">
                            <div class="item-nhansu item-nhansu-page item-numo">
                                <div class="img-hvr img-item-nhansu">
                                    <img src="https://phunuso.mediacdn.vn/603486343963435008/2024/10/2/dr-stone-senku-17278396646577493402.jpeg" alt="BS. " width="100%"/>
                                </div>
                                <div class="content-item-nhansu">
                                    <div class="chucvu">Giám đốc chuyên môn</div> 
                                    <h3 class="name-item-nhansu"><a href="">BS. </a></h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 col-sm-12">
                            <div class="item-nhansu item-nhansu-page item-numo">
                                <div class="img-hvr img-item-nhansu">
                                    <img src="https://i.pinimg.com/736x/3c/d9/04/3cd904e8e7ec9ad946a963af50cbd46e.jpg" alt="ThS - BS Trần Đức Anh " width="100%"/>
                                </div>
                                <div class="content-item-nhansu">
                                    <div class="chucvu">Giám đốc chuyên môn </div> 
                                    <h3 class="name-item-nhansu"><a href="">ThS - BS  </a></h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 col-sm-12">
                            <div class="item-nhansu item-nhansu-page item-numo">
                                <div class="img-hvr img-item-nhansu">
                                    <img src="/temp/-uploaded-bacsi_bac si hoa_cr_440x708.jpg" alt="ThS - BS " width="100%"></a>
                                </div>
                                <div class="content-item-nhansu">
                                    <div class="chucvu">Bác sĩ chuyên môn</div> 
                                    <h3 class="name-item-nhansu"><a href="">ThS - BS </a></h3>
                                </div>
                            </div>
                        </div>
                    </div>
                    <p>Trở thành hệ thống y tế hàng đầu Châu Á...</p>

                    <h2>Chứng chỉ, Chứng Nhận </h2>
                    <p>MEDINOVA tự hào sở hữu các chứng chỉ y tế uy tín, 
                        khẳng định chất lượng dịch vụ và tiêu chuẩn an toàn hàng đầu 
                        trong lĩnh vực chăm sóc sức khỏe. Hệ thống y tế này đã đạt được chứng nhận từ các tổ chức y tế 
                        quốc tế và trong nước như ISO 9001:2015 về quản lý chất lượng, JCI (Joint Commission International) – 
                        tiêu chuẩn vàng trong lĩnh vực y tế toàn cầu, cùng nhiều chứng nhận chuyên môn khác trong điều trị và 
                        chăm sóc bệnh nhân. Các chứng chỉ này không chỉ là minh chứng cho sự cam kết của MEDINOVA trong việc cung 
                        cấp dịch vụ y tế an toàn, hiệu quả mà còn thể hiện nỗ lực không ngừng nhằm nâng cao chất lượng điều trị, 
                        mang lại sự an tâm tuyệt đối cho bệnh nhân.</p>
                    <img style="display:block" src="https://cdn.thuvienphapluat.vn/phap-luat/2022-2/THN/Y-TE-LAO-DONG.jpg" alt="Giấy phép hoạt động cơ sở " width="100%"/>
                </div>
            </section>

        <jsp:include page="Footer.jsp"></jsp:include>
        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/waypoints/waypoints.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>
        <script src="lib/tempusdominus/js/moment.min.js"></script>
        <script src="lib/tempusdominus/js/moment-timezone.min.js"></script>
        <script src="lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>
    </body>
</html>
