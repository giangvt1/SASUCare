document.addEventListener('DOMContentLoaded', function () {
    const sidebarToggle = document.querySelector('.sidebar-toggle');
    const leftSide = document.querySelector('.left-side');
    const rightSide = document.querySelector('.right-side');

    // Initialize sidebar state
    let sidebarCollapsed = localStorage.getItem('sidebarOffcanvas') === 'true';

    function updateSidebar(collapsed) {
        if (collapsed) {
            leftSide.classList.add('sidebar-offcanvas');
            if (rightSide) {
                rightSide.classList.add('strech');
            }
        } else {
            leftSide.classList.remove('sidebar-offcanvas');
            if (rightSide) {
                rightSide.classList.remove('strech');
            }
        }
        localStorage.setItem('sidebarOffcanvas', collapsed);
    }


    // Apply initial state
    updateSidebar(sidebarCollapsed); // Use helper function

    if (sidebarToggle && leftSide) {
        sidebarToggle.addEventListener('click', function (event) {
            event.preventDefault();
            sidebarCollapsed = !sidebarCollapsed; // Toggle the state BEFORE updating
            updateSidebar(sidebarCollapsed); // Use helper function

        });
    }

    // Resize handle
    window.addEventListener('resize', () => {
        if (window.innerWidth > 768 && rightSide) {
            updateSidebar(false); // Reset state on larger screens
        }else if (window.innerWidth <= 768 && rightSide) {
            if (!rightSide.classList.contains('strech')){
                 rightSide.classList.add('strech');
            }
            if (!leftSide.classList.contains('sidebar-offcanvas')){ //Update sidebar status
                localStorage.setItem('sidebarOffcanvas', false);
            }

        }
    });

    // Small screen behavior: Toggle sidebar on link click (if right-side exists)
    if (rightSide) {
        const sidebarLinks = document.querySelectorAll('.sidebar-menu a');
        sidebarLinks.forEach(link => {
            link.addEventListener('click', function (event) {
                if (window.innerWidth <= 768) {
                    if (!sidebarCollapsed) { // Only collapse if not already collapsed
                        sidebarCollapsed = true; // Set state BEFORE calling updateSidebar
                        updateSidebar(sidebarCollapsed);
                        event.preventDefault(); // Prevent link behavior after toggling
                    }

                }
            });
        });
    }

});