<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chat box</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .message { display: flex; align-items: center; margin-bottom: 10px; }
        .message.received { justify-content: flex-start; }
        .message.sent { justify-content: flex-end; }
        .chat-messages { max-height: 400px; overflow-y: auto; }
        .user-item { cursor: pointer; }
        .user-item:hover { background-color: #f8f9fa; }
        .user-item.selected {
            background-color: #e9f5ff;
            border-left: 4px solid #007bff;
            font-weight: bold;
            color: #004085;
        }
        .user-item.selected img {
            border: 2px solid #007bff;
        }
    </style>
</head>
<body>
    <jsp:include page="../admin/AdminHeader.jsp" />
    <jsp:include page="../admin/AdminLeftSideBar.jsp" />
    <section>
        <div class="right-side">
            <div class="main-content">
                <div class="container py-5">
                    <div class="row">
                        <div class="col-md-6 col-lg-5 col-xl-4 mb-4 mb-md-0">
                            <h5 class="font-weight-bold mb-3 text-center text-lg-start" id="memberTitle"></h5>
                            <div class="card">
                                <div class="card-body">
                                    <ul class="list-unstyled mb-0" id="memberList">
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6 col-lg-7 col-xl-8">
                            <div class="chat-messages" id="chatBody">
                                <!-- Messages will be added dynamically via JavaScript -->
                            </div>
                            <div class="bg-white mb-3">
                                <div data-mdb-input-init class="form-outline">
                                    <textarea class="form-control bg-body-tertiary" id="textAreaExample2" rows="4"></textarea>
                                    <label class="form-label" for="textAreaExample2">Message</label>
                                </div>
                            </div>
                            <button type="button" id="sendButton" class="btn btn-info btn-rounded float-end">Send</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Assign Doctor Modal (chỉ hiển thị cho HR) -->
    <c:if test="${sessionScope.userRoles == 'HR'}">
        <div class="modal fade" id="assignDoctorModal" tabindex="-1" aria-labelledby="assignDoctorModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="assignDoctorModalLabel">Assign Doctor</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Chọn bác sĩ cần phân công.</p>
                        <form id="assignDoctorForm">
                            <div class="mb-3">
                                <label for="doctorSelect" class="form-label">Chọn bác sĩ:</label>
                                <select class="form-select" id="doctorSelect">
                                </select>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" id="assignDoctorBtn" class="btn btn-primary">Assign</button>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        var socket = new WebSocket("ws://localhost:9999/SWP391_GR6/chat");
        var chatBody = document.getElementById("chatBody");
        var selectedUserEmail = localStorage.getItem("selectedUserEmail") || null;
        var adminEmail = "${sessionScope.account.gmail}" || "admin";
        var role = "${sessionScope.userRoles}";
        var fullName = "${sessionScope.account.displayname}";
        var chatHistory = {};
        var memberTitle = document.getElementById("memberTitle");

        // Đặt tiêu đề danh sách dựa trên vai trò
        if (role === "HR") {
            memberTitle.textContent = "Online Users";
        } else if (role === "Doctor") {
            memberTitle.textContent = "Assigned Users";
        }

        // Kiểm tra xem đây có phải là phiên mới (trình duyệt vừa mở lại) hay không
        if (!sessionStorage.getItem('sessionActive')) {
            // Nếu không có flag, tức là trình duyệt vừa được mở lại, xóa tin nhắn trong localStorage
            localStorage.removeItem('chatHistory');
            chatHistory = {};
        }

        // Đặt flag trong sessionStorage để đánh dấu phiên làm việc hiện tại
        sessionStorage.setItem('sessionActive', 'true');

        // Khôi phục lịch sử chat từ localStorage (nếu có)
        restoreChatHistory();

        // Hiển thị lịch sử chat nếu có người dùng được chọn
        if (selectedUserEmail && chatHistory[selectedUserEmail]) {
            displayChatHistory(selectedUserEmail);
        }

        socket.onopen = function() {
            console.log("✅ WebSocket Connected");
            socket.send(JSON.stringify({
                action: "userInfo",
                email: adminEmail,
                fullName: fullName,
                role: role
            }));
        };

        socket.onmessage = function(event) {
            let data = JSON.parse(event.data);
            if (data.action === "updateOnlineUsers" && role === "HR") {
                chatBody.innerHTML = "";
                updateOnlineUsers(data.onlineUsers);
            } else if (data.action === "clearChat" && role === "HR") {
                let userEmail = data.userEmail;
                if (chatHistory[userEmail]) {
                    delete chatHistory[userEmail];
                    saveChatHistory();
                    if (selectedUserEmail === userEmail) {
                        chatBody.innerHTML = "";
                    }
                }
                // Xóa người dùng khỏi danh sách giao diện
                const userElement = document.querySelector(`.user-item[data-email="${userEmail}"]`);
                if (userElement) {
                    userElement.remove();
                }
            } else if (data.action === "updateAssignedUsers" && role === "Doctor") {
                chatBody.innerHTML = "";
                updateAssignedUsers(data.assignedUsers);
            } else if (data.action === "updateOnlineDoctors" && role === "HR") {
                updateOnlineDoctors(data.onlineDoctors);
            } else if (data.action === "sendMessage") {
                let senderEmail = data.senderEmail || data.email;
                let message = data.message;

                if (!chatHistory[senderEmail]) {
                    chatHistory[senderEmail] = [];
                }
                chatHistory[senderEmail].push({ message: message, type: "received" });

                if (selectedUserEmail === senderEmail) {
                    displayMessage(message, 'received');
                }

                saveChatHistory();
            } else if (data.action === "assignSuccess" && role === "HR") {
                console.log(`User ${data.userEmail} assigned to doctor ${data.doctorEmail}`);
                const userElement = document.querySelector(`.user-item[data-email="${data.userEmail}"]`);
                if (userElement) {
                    userElement.remove();
                }
                if (selectedUserEmail === data.userEmail) {
                    chatBody.innerHTML = "";
                    selectedUserEmail = null;
                    localStorage.removeItem("selectedUserEmail");
                }
            } else if (data.action === "assignError" && role === "HR") {
                console.log("Assign failed: " + data.message);
                alert("Lỗi: " + data.message);
            }
        };

        socket.onclose = function() {
            console.log("WebSocket Disconnected.");
        };

        socket.onerror = function(error) {
            console.log("WebSocket Error: " + error);
        };

        function updateOnlineUsers(users) {
            const memberList = document.getElementById("memberList");
            memberList.innerHTML = "";
            users.forEach(user => {
                const li = document.createElement("li");
                li.classList.add("p-2", "border-bottom", "bg-body-tertiary", "user-item");
                li.setAttribute("data-email", user.email);
                li.innerHTML = `
                    <div class="d-flex justify-content-between">
                        <div class="d-flex flex-row">
                            <img src="https://mdbcdn.b-cdn.net/img/Photos/Avatars/avatar-8.webp" alt="avatar"
                                 class="rounded-circle d-flex align-self-center me-3 shadow-1-strong" width="60">
                            <div class="pt-1">
                                <p class="fw-bold mb-0">${user.fullName}</p>
                                <p class="small text-muted">${user.email}</p>
                            </div>
                        </div>
                        <div class="pt-1">
                            <p class="small text-muted mb-1">Online</p>
                            <div class="btn-group" role="group" aria-label="User actions">
                                <button type="button" class="btn btn-sm btn-danger">Delete</button>
                                <button type="button" class="btn btn-sm btn-success">Export</button>
                                <button type="button" class="btn btn-sm btn-primary assign-to-doctor">Assign</button>
                            </div>
                        </div>
                    </div>
                `;
                memberList.appendChild(li);
            });
            attachUserItemEvents();
        }

        function updateAssignedUsers(users) {
            const memberList = document.getElementById("memberList");
            memberList.innerHTML = "";
            users.forEach(user => {
                const li = document.createElement("li");
                li.classList.add("p-2", "border-bottom", "bg-body-tertiary", "user-item");
                li.setAttribute("data-email", user.email);
                li.innerHTML = `
                    <div class="d-flex justify-content-between">
                        <div class="d-flex flex-row">
                            <img src="https://mdbcdn.b-cdn.net/img/Photos/Avatars/avatar-8.webp" alt="avatar"
                                 class="rounded-circle d-flex align-self-center me-3 shadow-1-strong" width="60">
                            <div class="pt-1">
                                <p class="fw-bold mb-0">${user.fullName}</p>
                                <p class="small text-muted">${user.email}</p>
                            </div>
                        </div>
                        <div class="pt-1">
                            <p class="small text-muted mb-1">Assigned</p>
                            <div class="btn-group" role="group" aria-label="User actions">
                                <button type="button" class="btn btn-sm btn-danger">Delete</button>
                                <button type="button" class="btn btn-sm btn-success">Export</button>
                            </div>
                        </div>
                    </div>
                `;
                memberList.appendChild(li);
            });
            attachUserItemEvents();
        }

        function attachUserItemEvents() {
            document.querySelectorAll(".user-item").forEach(item => {
                item.addEventListener("click", function() {
                    document.querySelectorAll(".user-item").forEach(el => el.classList.remove("selected"));
                    this.classList.add("selected");
                    selectedUserEmail = this.getAttribute("data-email");
                    localStorage.setItem("selectedUserEmail", selectedUserEmail);
                    displayChatHistory(selectedUserEmail);
                });
            });
        }

        function updateOnlineDoctors(onlineDoctors) {
            const doctorSelect = document.getElementById("doctorSelect");
            doctorSelect.innerHTML = `<option selected>Chọn bác sĩ...</option>`;
            onlineDoctors.forEach(doctor => {
                const option = document.createElement("option");
                option.value = doctor.email;
                option.textContent = doctor.fullName;
                doctorSelect.appendChild(option);
            });
        }

        function displayChatHistory(email) {
            chatBody.innerHTML = "";
            if (chatHistory[email]) {
                chatHistory[email].forEach(msgObj => {
                    displayMessage(msgObj.message, msgObj.type);
                });
            }
        }

        function displayMessage(message, type) {
            let messageElement = document.createElement("div");
            messageElement.classList.add("message");
            if (type === 'sent') {
                messageElement.classList.add("sent");
                messageElement.innerHTML = `
                    <div class="d-flex justify-content-end mb-2">
                        <div class="card-body p-2 px-3 bg-primary text-white" style="border-radius: 20px;">
                            <p class="mb-0">${message}</p>
                        </div>
                    </div>
                `;
            } else {
                messageElement.classList.add("received");
                messageElement.innerHTML = `
                    <img src="https://mdbcdn.b-cdn.net/img/Photos/Avatars/avatar-8.webp" alt="avatar" class="me-3 rounded-circle d-flex align-self-center shadow-1-strong" width="60">
                    <div class="d-flex justify-content-start mb-2">
                        <div class="card-body p-2 px-3 bg-light text-dark" style="border-radius: 20px;">
                            <p class="mb-0">${message}</p>
                        </div>
                    </div>
                `;
            }
            chatBody.appendChild(messageElement);
            chatBody.scrollTop = chatBody.scrollHeight;
        }

        document.getElementById("sendButton").addEventListener("click", function() {
            let messageInput = document.getElementById("textAreaExample2");
            let message = messageInput.value.trim();
            if (message && selectedUserEmail) {
                displayMessage(message, 'sent');
                if (!chatHistory[selectedUserEmail]) {
                    chatHistory[selectedUserEmail] = [];
                }
                chatHistory[selectedUserEmail].push({ message: message, type: "sent" });
                const messageData = {
                    action: "sendMessage",
                    message: message,
                    email: adminEmail,
                    fullName: fullName,
                    receiverEmail: selectedUserEmail
                };
                socket.send(JSON.stringify(messageData));
                messageInput.value = "";
                saveChatHistory();
            } else {
                alert("Please select a user and enter a message.");
            }
        });

        document.getElementById("memberList").addEventListener("click", function(event) {
            if (event.target.classList.contains("btn-danger")) {
                const userItem = event.target.closest(".user-item");
                const email = userItem.getAttribute("data-email");
                deleteChatHistory(email);
            } else if (event.target.classList.contains("btn-success")) {
                const userItem = event.target.closest(".user-item");
                const email = userItem.getAttribute("data-email");
                const fullNameElement = userItem.querySelector(".fw-bold");
                const fullName = fullNameElement ? fullNameElement.textContent : "Unknown";
                exportChatHistory(email, fullName);
            } else if (event.target.classList.contains("assign-to-doctor")) {
                var assignDoctorModal = new bootstrap.Modal(document.getElementById("assignDoctorModal"));
                assignDoctorModal.show();
            }
        });

        function deleteChatHistory(email) {
            if (chatHistory[email]) {
                delete chatHistory[email];
                saveChatHistory();
                if (selectedUserEmail === email) {
                    chatBody.innerHTML = "";
                    selectedUserEmail = null;
                    localStorage.removeItem("selectedUserEmail");
                }
                const userItem = document.querySelector(`.user-item[data-email="${email}"]`);
                if (userItem) {
                    userItem.remove();
                }
                socket.send(JSON.stringify({
                    action: "deleteMessage",
                    email: email
                }));
            }
        }

        function exportChatHistory(email, fullName) {
            if (chatHistory[email]) {
                const messages = chatHistory[email];
                let textContent = `Chat history with ${fullName} (${email})\n\n`;
                messages.forEach(msgObj => {
                    const prefix = msgObj.type === "sent" ? "[Sent]" : "[Received]";
                    textContent += `${prefix} ${msgObj.message}\n`;
                });
                socket.send(JSON.stringify({
                    action: "exportChat",
                    email: email,
                    fullName: fullName,
                    chatContent: textContent
                }));
                alert("Export chat history successful!");
            } else {
                alert("Không tìm thấy lịch sử chat cho người dùng này.");
            }
        }

        function saveChatHistory() {
            localStorage.setItem("chatHistory", JSON.stringify(chatHistory));
        }

        function restoreChatHistory() {
            const storedHistory = localStorage.getItem("chatHistory");
            if (storedHistory) {
                chatHistory = JSON.parse(storedHistory);
            }
        }

        if (role === "HR") {
            document.getElementById("assignDoctorBtn").addEventListener("click", function() {
                const selectedDoctor = document.getElementById("doctorSelect").value;
                if (selectedDoctor && selectedDoctor !== "Chọn bác sĩ...") {
                    socket.send(JSON.stringify({
                        action: "assignDoctor",
                        doctor: selectedDoctor,
                        userEmail: selectedUserEmail
                    }));
                    var assignDoctorModal = bootstrap.Modal.getInstance(document.getElementById("assignDoctorModal"));
                    assignDoctorModal.hide();
                    alert("Bác sĩ " + selectedDoctor + " đã được phân công.");
                } else {
                    alert("Vui lòng chọn bác sĩ.");
                }
            });
        }
    </script>
</body>
</html>