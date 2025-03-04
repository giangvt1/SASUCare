// admin_scripts.js
document.addEventListener('DOMContentLoaded', function () {
    const sidebarToggle = document.querySelector('.sidebar-toggle');
    const leftSide = document.querySelector('.left-side');
    const rightSide = document.querySelector('.right-side');

    // Nếu chưa có giá trị lưu trong localStorage, mặc định sidebar ẩn (collapsed = true)
    let storedState = localStorage.getItem('sidebarOffcanvas');
    let sidebarCollapsed = (storedState === null) ? true : (storedState === 'true');

    function updateSidebar(collapsed) {
        if (collapsed) {
            // Sidebar ẩn: loại bỏ class hiển thị và xóa đẩy nội dung
            leftSide.classList.remove('sidebar-offcanvas');
            rightSide.classList.remove('strech');
        } else {
            // Sidebar hiện: thêm class hiển thị và đẩy nội dung sang phải
            leftSide.classList.add('sidebar-offcanvas');
            rightSide.classList.add('strech');
        }
        localStorage.setItem('sidebarOffcanvas', collapsed);
    }

    // Cập nhật trạng thái ngay khi load trang
    updateSidebar(sidebarCollapsed);

    // Sự kiện click cho nút toggle
    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', function (event) {
            event.preventDefault();
            // Khi bấm, đảo ngược trạng thái
            sidebarCollapsed = !sidebarCollapsed;
            // Toggle class active cho nút (để đổi icon nếu cần)
            sidebarToggle.classList.toggle('active');
            updateSidebar(sidebarCollapsed);
        });
    }

    // Khi resize: nếu màn hình lớn hơn 768px, bạn có thể muốn hiển thị sidebar (tùy chọn)
    window.addEventListener('resize', function () {
        if (window.innerWidth > 768) {
            // Có thể muốn mặc định hiển thị sidebar hoặc giữ trạng thái trước đó
            // Ví dụ: hiển thị sidebar:
            updateSidebar(false);
            if (sidebarToggle.classList.contains('active')) {
                sidebarToggle.classList.remove('active');
            }
        }
    });

    // Trên thiết bị nhỏ, khi click vào link trong sidebar, tự ẩn sidebar
    const sidebarLinks = document.querySelectorAll('.sidebar-menu a');
    sidebarLinks.forEach(link => {
        link.addEventListener('click', function (event) {
            if (window.innerWidth <= 768) {
                updateSidebar(true);
                event.preventDefault();
            }
        });
    });
});
