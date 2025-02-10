<%-- 
    Document   : service.jsp
    Created on : Jan 31, 2025, 9:34:20 AM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
<!--        <style>
  /* Căn giữa toàn bộ carousel */
  .styles_serviceHeader__rJZ7Q .ant-carousel {
    display: flex;
    justify-content: center;
    align-items: center;
  }

  /* Căn giữa các item và đảm bảo khoảng cách đều */
  .slick-list {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
  }

  .slick-track {
    display: flex;
    justify-content: space-evenly; /* Đảm bảo các item cách đều */
    align-items: center;
    width: 100%;
  }

  /* Các item trong carousel */
  .slick-slide {
    display: flex;
    justify-content: center;
    align-items: center;
    width: auto;
    padding: 10px; /* Khoảng cách giữa các item */
  }

  /* Căn giữa và làm cho biểu tượng lớn hơn */
  .styles_card__706JX {
    text-align: center;
  }

  /* Điều chỉnh kích thước biểu tượng */
  .styles_card__706JX i {
    font-size: 60px; /* Điều chỉnh kích thước biểu tượng */
    color: #003553; /* Màu sắc của biểu tượng */
    margin-bottom: 10px; /* Khoảng cách giữa biểu tượng và tiêu đề */
  }

  /* Đảm bảo tiêu đề nằm dưới biểu tượng */
  .styles_title__IzDio {
    margin-top: 5px;
    font-size: 16px; /* Kích thước chữ tiêu đề */
    text-align: center;
  }
</style>-->

<style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 1200px;
            margin: auto;
            padding: 20px;
        }
        .heading {
            text-align: center;
            margin-bottom: 40px;
        }
        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin: 20px;
            overflow: hidden;
            transition: transform 0.3s;
            flex: 1 1 calc(33% - 40px);
            max-width: calc(33% - 40px);
        }
        .card:hover {
            transform: scale(1.05);
        }
        .card img {
            width: 100%;
            height: auto;
        }
        .card-content {
            padding: 20px;
            text-align: center;
        }
        .card-content h3 {
            margin: 0 0 10px;
        }
        .more {
            color: #007bff;
            text-decoration: none;
        }
        .grid {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }
    </style>

    </head>
    
    
    
    <body>
        <jsp:include page="Header.jsp"></jsp:include>
        



<div class="container">
    <div class="heading">
        <h1>Chuyên khoa điều trị</h1>
    </div>
    <div class="grid">
        <div class="card">
            <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSvWLUFmU1UcUxxpMBtfKhfEIS89U5eR2GSPw&s" alt="Cấp cứu">
            <div class="card-content">
                <h3>Cấp cứu</h3>
                <a class="more" href="khoacapcuu.jsp">More →</a>
            </div>
        </div>
        <div class="card">
            <img src="https://datafiles.nghean.gov.vn/nan-ubnd/2882/quantritintuc20242/m2638436058638817220.jpg" alt="Tim mạch">
            <div class="card-content">
                <h3>Tim mạch</h3>
                <a class="more" href="khoatimmach.jsp">More →</a>
            </div>
        </div>
        <div class="card">
            <img src="https://cdn.benhvienthucuc.vn/wp-content/uploads/2021/06/kinh-nghiem-tim-dia-chi-kham-chuyen-khoa-co-xuong-khop-o-dau-tot-1.jpg" alt="Xương Khớp">
            <div class="card-content">
                <h3>Xương Khớp</h3>
                <a class="more" href="khoaxuongkhop.jsp">More →</a>
            </div>
        </div>
        <div class="card">
            <img src="https://cms-prod.s3-sgn09.fptcloud.com/cau_tao_chuc_nang_cua_he_ho_hap_va_mot_so_benh_thuong_gap_2_15facfc931.jfif" alt="Hô Hấp">
            <div class="card-content">
                <h3>Hô Hấp</h3>
                <a class="more" href="#">More →</a>
            </div>
        </div>
        <div class="card">
            <img src="https://www.vinmec.com/static/uploads/20190524_042142_717615_NBI_tieu_hoa_max_1800x1800_jpg_f8625d797f.jpg" alt="Tiêu hóa">
            <div class="card-content">
                <h3>Tiêu hóa</h3>
                <a class="more" href="#">More →</a>
            </div>
        </div>
        <div class="card">
            <img src="https://benhvien22-12.com/wp-content/uploads/2021/08/khoa-nhi.jpg" alt="Khoa Nhi">
            <div class="card-content">
                <h3>Khoa Nhi</h3>
                <a class="more" href="#">More →</a>
            </div>
        </div>
        <div class="card">
            <img src="https://phongkhamdinhcu.vn/wp-content/uploads/khoa-noi-than-kinh.jpg" alt="Thần kinh">
            <div class="card-content">
                <h3>Thần kinh</h3>
                <a class="more" href="#">More →</a>
            </div>
        </div>
        <div class="card">
            <img src="https://nhakhoakim.com/wp-content/uploads/2022/03/rang-ham-mat-tieng-anh-la-gi-1.png" alt="Răng Hàm Mặt">
            <div class="card-content">
                <h3>Răng Hàm Mặt</h3>
                <a class="more" href="#">More →</a>
            </div>
        </div>
        <div class="card">
            <img src="https://benhviendongnai.com.vn/wp-content/uploads/2023/09/poster-2-scaled.jpg" alt="Mắt">
            <div class="card-content">
                <h3>Mắt</h3>
                <a class="more" href="#">More →</a>
            </div>
        </div>
        <div class="card">
            <img src="https://thanhnien.mediacdn.vn/Uploaded/linhnt-qc/2022_01_10/mh-1-4707.jpg" alt="Thẩm Mỹ">
            <div class="card-content">
                <h3>Thẩm Mỹ</h3>
                <a class="more" href="#">More →</a>
            </div>
        </div>
        <div class="card">
            <img src="https://bizweb.dktcdn.net/thumb/1024x1024/100/413/259/files/cong-nghe-te-bao-goc-2.jpg?v=1673515663024" alt="Viện nghiên cứu tế bào gốc và công nghệ Gen">
            <div class="card-content">
                <h3>Viện nghiên cứu tế bào gốc và công nghệ Gen</h3>
                <a class="more" href="#">More →</a>
            </div>
        </div>
        <div class="card">
            <img src="https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2021/10/12/photo-1634049650013-1634049663521446262357.png" alt="Trung tâm Vacxin">
            <div class="card-content">
                <h3>Trung tâm Vacxin</h3>
                <a class="more" href="#">More →</a>
            </div>
        </div>
        <div class="card">
            <img src="https://lienhiepkhktnghean.org.vn/uploads/thong-tin-khoa-hoc/2024_04/image-20240416104018-1.jpeg" alt="Trung tâm Y học cổ truyền">
            <div class="card-content">
                <h3>Trung tâm Y học cổ truyền </h3>
                <a class="more" href="#">More →</a>
            </div>
        </div>
        <div class="card">
            <img src="https://acc.vn/wp-content/uploads/2021/06/59-cac-phuong-phap-vat-ly-tri-lieu.jpg" alt="Vật lí trị liệu">
            <div class="card-content">
                <h3>Vật lí trị liệu</h3>
                <a class="more" href="#">More →</a>
            </div>
        </div>
        <div class="card">
            <img src="https://hoanhap.vn/files/images/article16548.jpg" alt="Khoa tâm lý">
            <div class="card-content">
                <h3>Khoa tâm lý </h3>
                <a class="more" href="#">More →</a>
            </div>
        </div>
        <div class="card">
            <img src="https://ykhoahopnhan.vn/wp-content/uploads/2019/05/ent-1.jpg" alt="Tai mũi họng">
            <div class="card-content">
                <h3>Tai mũi họng</h3>
                <a class="more" href="#">More →</a>
            </div>
        </div>
    </div>
</div>

        
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
