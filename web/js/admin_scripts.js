// admin_scripts.js
document.addEventListener('DOMContentLoaded', function () {
    const sidebarToggle = document.querySelector('.sidebar-toggle');
    const leftSide = document.querySelector('.left-side');
    const rightSide = document.querySelector('.right-side');

    let sidebarCollapsed = localStorage.getItem('sidebarOffcanvas') === 'true'; // Correct initial state

    function updateSidebar(collapsed) {
        if (collapsed) {
            leftSide.classList.remove('active');
            if (rightSide) {
                rightSide.classList.remove('strech');
            }

        } else {
            leftSide.classList.add('active');
            if (rightSide) {
                rightSide.classList.add('strech');
            }
        }
        localStorage.setItem('sidebarOffcanvas', collapsed);
    }


    if (window.innerWidth <= 768) {
        updateSidebar(sidebarCollapsed);
    }

    // Toggle button click event
    if (sidebarToggle && leftSide) {
        sidebarToggle.addEventListener('click', function (event) {
            event.preventDefault();

            sidebarCollapsed = !sidebarCollapsed;
            sidebarToggle.classList.toggle('active'); // Toggle the arrow
            updateSidebar(sidebarCollapsed); // Update sidebar state and local storage
        });
    }

      // Resize handle
    window.addEventListener('resize', () => {

        if (window.innerWidth > 768 && rightSide) {
            rightSide.classList.remove('strech'); // Remove margin
            localStorage.setItem('sidebarOffcanvas', false); // Store state

            if (leftSide.classList.contains('active')) { //Remove active class if present
                 leftSide.classList.remove('active');
            }
             if (sidebarToggle.classList.contains('active')) { //Change the toggle arrow
                 sidebarToggle.classList.remove('active');
            }



        }
    });

      // Small screen behavior: Toggle sidebar on link click (if right-side exists)
    if (rightSide) {
        const sidebarLinks = document.querySelectorAll('.sidebar-menu a');
        sidebarLinks.forEach(link => {
            link.addEventListener('click', function (event) {
                if (window.innerWidth <= 768) { // Only on small screens

                    //Close dropdown after clicking menu
                    const isDropdown = link.closest('.dropdown');
                    if (isDropdown) {
                        const dropdownToggle = isDropdown.querySelector('.dropdown-toggle');
                        if (dropdownToggle) {
                            bootstrap.Dropdown.getInstance(dropdownToggle).hide();
                        }
                    }
                    // Set state BEFORE calling updateSidebar
                    sidebarCollapsed = !leftSide.classList.contains('sidebar-offcanvas');

                    updateSidebar(sidebarCollapsed); //Correctly store state
                    event.preventDefault(); // Prevent link behavior after toggling
                }

            });

        });
    }


});