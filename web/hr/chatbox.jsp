<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chat box</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
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
                            <h5 class="font-weight-bold mb-3 text-center text-lg-start">Member</h5>
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
    <script>
        var socket = new WebSocket("ws://localhost:9999/SWP391_GR6/chat");
        var chatBody = document.getElementById("chatBody");
        var selectedUserEmail = localStorage.getItem("selectedUserEmail") || null;
        var adminEmail = "${sessionScope.email}" || "admin";
        var role = "${sessionScope.userRoles}";
        var fullName = "${sessionScope.fullName}";
        var adminRole = "HR";
        var chatHistory = {};

        // Restore chat history when the page loads
        restoreChatHistory();

        // Display chat history if a user is selected
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
            if (data.action === "updateOnlineUsers") {
                updateOnlineUsers(data.onlineUsers);
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
            const onlineEmails = users.map(user => user.email);

            // Clear the old list and populate with updated online users
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
                                <p class="fw-bold mb-0">` + user.fullName + `</p>
                                <p class="small text-muted">` + user.email + `</p>
                            </div>
                        </div>
                        <div class="pt-1">
                            <p class="small text-muted mb-1">Online</p>
                            <div class="btn-group" role="group" aria-label="User actions">
                                <button type="button" class="btn btn-sm btn-danger">Delete</button>
                                <button type="button" class="btn btn-sm btn-success">Export</button>
                                <button type="button" class="btn btn-sm btn-primary assign-to-doctor">Assign to Doctor</button>
                            </div>
                        </div>
                    </div>
                `;
                memberList.appendChild(li);
            });

            // Add click event listeners to user items
            document.querySelectorAll(".user-item").forEach(item => {
                item.addEventListener("click", function() {
                    document.querySelectorAll(".user-item").forEach(el => el.classList.remove("selected"));
                    this.classList.add("selected");
                    selectedUserEmail = this.getAttribute("data-email");
                    localStorage.setItem("selectedUserEmail", selectedUserEmail);
                    displayChatHistory(selectedUserEmail);
                    console.log("Email selected: " + selectedUserEmail);
                    socket.send(JSON.stringify({
                        action: "selectUser",
                        email: selectedUserEmail
                    }));
                });
            });

            // If the selected user is online, display their chat; otherwise, clear the chat
            if (selectedUserEmail && onlineEmails.includes(selectedUserEmail)) {
                displayChatHistory(selectedUserEmail);
                const selectedItem = document.querySelector(`.user-item[data-email="${selectedUserEmail}"]`);
                if (selectedItem) {
                    selectedItem.classList.add("selected");
                }
            } else if (selectedUserEmail && !onlineEmails.includes(selectedUserEmail)) {
                chatBody.innerHTML = "";
                console.log(`Cleared chat content because user ${selectedUserEmail} is offline`);
            }
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
                            <p class="mb-0">` + message + `</p>
                        </div>
                    </div>
                `;
            } else {
                messageElement.classList.add("received");
                messageElement.innerHTML = `
                    <img src="https://mdbcdn.b-cdn.net/img/Photos/Avatars/avatar-8.webp" alt="avatar" class="me-3 rounded-circle d-flex align-self-center shadow-1-strong" width="60">
                    <div class="d-flex justify-content-start mb-2">
                        <div class="card-body p-2 px-3 bg-light text-dark" style="border-radius: 20px;">
                            <p class="mb-0">` + message + `</p>
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
                console.log("email: " + email);
                console.log("fullName: " + fullName);
                exportChatHistory(email, fullName);
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
                console.log("messages: " + messages);
                let textContent = `Chat history with `+ fullName +` (`+ email +`)\n\n`;
                messages.forEach(msgObj => {
                    const prefix = msgObj.type === "sent" ? "[Sent]" : "[Received]";
                    textContent += ``+ prefix +` `+ msgObj.message +`\n`;
                });
                // Gửi dữ liệu đến server qua WebSocket
                socket.send(JSON.stringify({
                    action: "exportChat",
                    email: email,
                    fullName: fullName,
                    chatContent: textContent
                }));
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
    </script>
</body>
</html>