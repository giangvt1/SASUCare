<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chat box</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* General Body & Layout */
        body {
            background-color: #f8f9fa; /* Light background for the page */
        }
        .right-side {
             /* Adjust based on your AdminLeftSideBar width */
            padding-left: 260px; /* Example: If sidebar is 250px wide */
            transition: all 0.3s; /* Smooth transition if sidebar collapses */
        }
        .main-content {
            padding: 20px;
        }
        .chat-container {
             background-color: #ffffff;
             border-radius: 8px;
             box-shadow: 0 2px 10px rgba(0,0,0,0.1);
             overflow: hidden; /* Contain children */
        }

        /* User List Panel */
        .user-list-panel {
            border-right: 1px solid #dee2e6;
            height: calc(600px + 4rem); /* Match chat panel height roughly */
            display: flex;
            flex-direction: column;
        }
        .user-list-panel .card {
            flex-grow: 1;
            border: none;
            border-radius: 0;
        }
        .user-list-panel h5 {
            padding: 1rem 1.25rem;
            margin-bottom: 0;
            background-color: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
        }
        #memberList {
            max-height: calc(600px + 4rem - 60px); /* Adjust based on title height */
            overflow-y: auto;
            padding: 0; /* Remove default ul padding */
        }
        .user-item {
            cursor: pointer;
            padding: 1rem 1.25rem;
            border-bottom: 1px solid #eee;
            transition: background-color 0.2s ease-in-out;
        }
        .user-item:last-child {
            border-bottom: none;
        }
        .user-item:hover {
            background-color: #f1f1f1;
        }
        .user-item.selected {
            background-color: #e7f1ff;
            border-left: 4px solid #0d6efd;
            padding-left: calc(1.25rem - 4px); /* Adjust padding for border */
        }
        .user-item.selected .fw-bold {
            color: #0a58ca;
        }
        .user-item img {
            width: 50px;
            height: 50px;
            object-fit: cover; /* Ensure image covers the area */
        }
        .user-item .user-info {
            flex-grow: 1; /* Allow text to take space */
            margin-left: 10px;
            overflow: hidden; /* Prevent long names/emails from breaking layout */
        }
        .user-item .user-info p {
            margin-bottom: 0.2rem;
            white-space: nowrap; /* Prevent wrapping */
            overflow: hidden;
            text-overflow: ellipsis; /* Add ... for overflow */
        }
        .user-item .user-actions .btn-group {
             margin-top: 5px;
        }
         /* Style for unread message indicator */
        .user-item.has-unread .fw-bold {
            font-weight: 900 !important; /* Make name very bold */
            color: #000; /* Black color for emphasis */
        }
         .user-item.has-unread::before { /* Optional: add a dot indicator */
             content: '●';
             color: #0d6efd; /* Blue dot */
             font-size: 1.2em;
             margin-right: 8px;
             vertical-align: middle;
         }

        /* Chat Panel */
        .chat-panel {
            display: flex;
            flex-direction: column;
            height: calc(600px + 4rem); /* Define a fixed height for the chat area + input */
             position: relative; /* Needed for absolute positioning of input */
        }
        .chat-messages {
            flex-grow: 1; /* Take available space */
            overflow-y: auto;
            padding: 1.5rem;
            background-color: #f9f9f9; /* Light gray background for chat */
        }

        /* Individual Messages */
        .message {
            display: flex;
            align-items: flex-end; /* Align items to bottom (avatar and bubble) */
            margin-bottom: 1rem;
        }
        .message.sent {
            justify-content: flex-end;
        }
        .message.received {
            justify-content: flex-start;
        }
        .message .avatar {
             width: 40px;
             height: 40px;
             object-fit: cover;
             border-radius: 50%;
             align-self: flex-start; /* Align avatar to the top of the message block */
        }
        .message.received .avatar {
            margin-right: 10px;
        }
         /* No avatar needed for sent messages in this design */
        /* .message.sent .avatar {
            margin-left: 10px;
        } */

        .message-content {
            max-width: 75%;
            display: flex;
            flex-direction: column; /* Stack bubble and timestamp */
        }
        .message-bubble {
            padding: 0.75rem 1rem;
            border-radius: 18px;
            word-wrap: break-word; /* Break long words */
            margin-bottom: 0.25rem; /* Space between bubble and timestamp */
        }
        .message.sent .message-bubble {
            background-color: #0d6efd; /* Bootstrap primary blue */
            color: white;
            border-bottom-right-radius: 5px; /* Slightly flatten corner */
        }
        .message.received .message-bubble {
            background-color: #e9ecef; /* Bootstrap light gray */
            color: #212529;
            border-bottom-left-radius: 5px; /* Slightly flatten corner */
        }
        .message .sender-name {
            font-size: 0.8em;
            color: #6c757d; /* Muted text */
            margin-bottom: 0.3rem;
            font-weight: 500;
        }
        .message .timestamp {
            font-size: 0.75em;
            color: #adb5bd; /* Lighter muted text */
        }
        .message.sent .timestamp {
            text-align: right; /* Align time to the right for sent messages */
        }
        .message.received .timestamp {
             margin-left: 0; /* Align to left under received bubble */
        }


        /* Message Input Area */
        .chat-input-area {
            padding: 1rem;
            border-top: 1px solid #dee2e6;
            background-color: #f8f9fa;
            display: flex; /* Use flexbox for alignment */
            align-items: center; /* Vertically center items */
             /* Removed position: absolute and related properties */
        }
        .chat-input-area .form-outline {
            flex-grow: 1; /* Textarea takes available space */
            margin-right: 0.5rem; /* Space between textarea and button */
        }
        .chat-input-area #textAreaExample2 {
            resize: none; /* Disable textarea resizing */
        }
        .chat-input-area #sendButton {
            flex-shrink: 0; /* Prevent button from shrinking */
        }
        /* Hide default label provided by MDB/Bootstrap if you don't need it */
        .chat-input-area .form-label {
             /* display: none; */ /* Uncomment if you don't want the floating label */
        }

        /* Toast Notification */
         #toastContainer {
            z-index: 1100; /* Ensure toast is above other elements */
         }

         /* Scrollbar (Optional - Webkit Browsers) */
         .chat-messages::-webkit-scrollbar {
             width: 8px;
         }
         .chat-messages::-webkit-scrollbar-track {
             background: #f1f1f1;
             border-radius: 10px;
         }
         .chat-messages::-webkit-scrollbar-thumb {
             background: #ccc;
             border-radius: 10px;
         }
         .chat-messages::-webkit-scrollbar-thumb:hover {
             background: #aaa;
         }
          #memberList::-webkit-scrollbar { width: 6px; }
          #memberList::-webkit-scrollbar-track { background: #f8f9fa; }
          #memberList::-webkit-scrollbar-thumb { background: #ddd; border-radius: 5px; }
          #memberList::-webkit-scrollbar-thumb:hover { background: #bbb; }

    </style>
</head>
<body>
    <jsp:include page="../admin/AdminHeader.jsp" />
    <jsp:include page="../admin/AdminLeftSideBar.jsp" />

    <section>
        <div class="right-side">
            <div class="main-content">
                <div class="container-fluid py-4"> <!-- Use container-fluid for full width -->
                    <div class="row chat-container"> <!-- Add chat-container class -->
                        <!-- User List Panel -->
                        <div class="col-md-5 col-lg-4 col-xl-3 user-list-panel p-0"> <!-- No padding on col -->
                            <h5 class="font-weight-bold mb-0 text-center text-lg-start" id="memberTitle">Members</h5>
                            <div class="card">
                                <div class="card-body p-0"> <!-- No padding on card body -->
                                    <ul class="list-unstyled mb-0" id="memberList">
                                        <!-- User items will be added dynamically -->
                                        <li class="p-2 text-muted text-center">Loading users...</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Chat Panel -->
                        <div class="col-md-7 col-lg-8 col-xl-9 chat-panel p-0"> <!-- No padding on col -->
                            <div class="chat-messages" id="chatBody">
                                <!-- Messages will be added dynamically via JavaScript -->
                                <div class="p-3 text-center text-muted">Please select a user to start chatting.</div>
                            </div>

                            <!-- Message Input Area -->
                            <div class="chat-input-area">
                                <div data-mdb-input-init class="form-outline">
                                    <!-- Removed bg-body-tertiary, using area background -->
                                    <textarea class="form-control" id="textAreaExample2" rows="3" placeholder="Type your message..."></textarea>
                                    <!-- Removed MDB label, using placeholder -->
                                    <!-- <label class="form-label" for="textAreaExample2">Message</label> -->
                                </div>
                                <button type="button" id="sendButton" class="btn btn-primary btn-rounded">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-send-fill" viewBox="0 0 16 16">
                                      <path d="M15.964.686a.5.5 0 0 0-.65-.65L.767 5.855H.766l-.452.18a.5.5 0 0 0-.082.887l.41.26.001.002 4.995 3.178 3.178 4.995.002.001.26.41a.5.5 0 0 0 .886-.083l6-15Zm-1.833 1.89L6.637 10.07l-.215-.338a.5.5 0 0 0-.154-.154l-.338-.215 7.494-7.494 1.178-.471-.47 1.178Z"/>
                                    </svg>
                                    Send
                                </button>
                            </div>
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
                        <p>Select the doctor to assign this user's chat to.</p>
                        <form id="assignDoctorForm">
                            <div class="mb-3">
                                <label for="doctorSelect" class="form-label">Available Doctors:</label>
                                <select class="form-select" id="doctorSelect">
                                    <!-- Options populated by JS -->
                                    <option>Loading doctors...</option>
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

    <!-- Toast Container: Hiển thị thông báo cho Doctor khi có user được assign -->
    <div id="toastContainer" class="position-fixed top-0 end-0 p-3" style="z-index: 1100;"> <!-- Increased z-index -->
      <div id="userToast" class="toast align-items-center text-white bg-primary border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body" id="toastMessage">
              <!-- Nội dung thông báo -->
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        var socket = null; // Initialize later
        var chatBody = document.getElementById("chatBody");
        var memberList = document.getElementById("memberList"); // Get member list element
        var memberTitle = document.getElementById("memberTitle");
        var sendButton = document.getElementById("sendButton");
        var messageInput = document.getElementById("textAreaExample2");

        // --- Admin/Session Info ---
        var adminEmail = "${sessionScope.account.gmail}";
        var role = "${sessionScope.userRoles}";
        var adminFullName = "${sessionScope.account.displayname}";
        var selectedUserEmail = null; // No initial selection

        // --- WebSocket Connection ---
        function connectWebSocket() {
             if (!adminEmail) {
                 console.error("Admin email not found in session. Cannot connect WebSocket.");
                  chatBody.innerHTML = '<div class="alert alert-danger m-3">Could not establish connection. User information missing. Please log in again.</div>';
                 return;
             }
            const wsProtocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
            // Dynamically get hostname and port if needed, or use hardcoded if running locally
             const wsUrl = `ws://localhost:9999/SWP391_GR6/chat`; // For local development
             console.log("Connecting WebSocket to:", wsUrl);

            socket = new WebSocket(wsUrl);

            socket.onopen = function() {
                console.log("✅ WebSocket Connected");
                socket.send(JSON.stringify({
                    action: "userInfo",
                    email: adminEmail,
                    fullName: adminFullName,
                    role: role
                }));
                console.log("Sent userInfo:", { email: adminEmail, fullName: adminFullName, role: role });
                 // Reset UI state on connect/reconnect
                 if (!selectedUserEmail) {
                     chatBody.innerHTML = '<div class="p-3 text-center text-muted">Please select a user to start chatting.</div>';
                 }
            };

            socket.onmessage = function(event) {
                try {
                    let data = JSON.parse(event.data);
                    console.log("Message received:", data); // Log parsed data

                    switch (data.action) {
                        case "updateOnlineUsers": // For HR
                            if (role === "HR") {
                                updateUsersList(data.onlineUsers || [], "Online");
                            }
                            break;
                         case "clearChat": // User disconnected or removed by admin
                              handleClearChat(data.userEmail, data.fullName);
                              break;
                        case "updateAssignedUsers": // For Doctor
                            if (role === "Doctor") {
                                // Server now includes online status for assigned users
                                updateUsersList(data.assignedUsers || [], "Assigned");
                            }
                            break;
                         case "newAssignment": // Notification for Doctor (Toast)
                              if (role === "Doctor" && data.userFullName) {
                                   showAssignToast(data);
                                   // List update will follow via updateAssignedUsers
                              }
                              break;
                        case "updateOnlineDoctors": // For HR (populates modal)
                            if (role === "HR") {
                                updateOnlineDoctors(data.onlineDoctors || []);
                            }
                            break;
                        case "chatHistoryResponse":
                             if (data.userEmail === selectedUserEmail) {
                                displayChatHistoryFromServer(data.history || []);
                             } else {
                                console.log("Received history for non-selected user:", data.userEmail);
                             }
                             break;
                        case "sendMessage": // Incoming message from user or confirmation of own sent message (handle incoming only)
                             handleIncomingMessage(data);
                             break;
                        case "assignSuccess": // Confirmation for HR after assigning
                            if (role === "HR") {
                                handleAssignSuccess(data);
                            }
                            break;
                         case "removeAssignedUser": // Notification for Doctor when user disconnects/is removed by HR
                              if(role === "Doctor"){
                                   console.log(`User ${data.userFullName} (${data.userEmail}) was removed or disconnected.`);
                                   // List is updated via updateAssignedUsers
                                   if (selectedUserEmail === data.userEmail) {
                                        selectedUserEmail = null;
                                        chatBody.innerHTML = `<div class="p-3 text-center text-muted">User ${data.fullName || data.userEmail} session ended. Select another user.</div>`;
                                         deselectUserItem();
                                   }
                              }
                              break;
                         // Error Handling
                         case "assignError":
                         case "exportError":
                         case "sendError":
                         case "authError":
                         case "processingError":
                         case "sessionCloseError":
                         case "noHR":
                         case "deliveryError":
                              console.error(`Server Error (${data.action}):`, data.message);
                              alert(`Server Error: ${data.message}`); // Simple alert for now
                              break;
                         // Success Confirmations
                         case "exportSuccess":
                              alert(`Success: ${data.message}`);
                              break;
                         case "sessionCloseSuccess":
                              alert(`Success: ${data.message}`);
                              break;
                         // Server Notifications
                         case "forceClose":
                              console.warn("Server initiated disconnect: " + data.reason);
                              alert("Your session was closed by an administrator: " + data.reason);
                              if (socket && socket.readyState === WebSocket.OPEN) {
                                 socket.close(1000, "Client acknowledging force close");
                              }
                              // Disable UI
                              messageInput.disabled = true;
                              sendButton.disabled = true;
                              chatBody.innerHTML = '<div class="alert alert-danger m-3">Your session has been closed by an administrator.</div>';
                              break;
                         case "userReconnected":
                              console.log(`User ${data.userEmail} reconnected.`);
                               const userItem = memberList.querySelector(`.user-item[data-email="${data.userEmail}"]`);
                               if (userItem) {
                                   const statusElement = userItem.querySelector('.user-status');
                                   if (statusElement) {
                                       const statusText = (role === 'HR' ? 'Online' : 'Assigned');
                                       statusElement.textContent = statusText;
                                       statusElement.classList.remove('text-muted', 'text-danger');
                                       statusElement.classList.add('text-success');
                                   }
                               }
                              break;
                         default:
                             console.warn("Unhandled action: ", data.action);
                    }
                } catch (error) {
                    console.error("Error processing WebSocket message:", error);
                    console.error("Original message data:", event.data);
                }
            };

            socket.onclose = function(event) {
                console.warn("WebSocket Disconnected.", `Code: ${event.code}`, `Reason: ${event.reason}`, `Clean: ${event.wasClean}`);
                 chatBody.innerHTML = '<div class="alert alert-warning m-3">Connection lost. Attempting to reconnect in 5 seconds...</div>';
                 memberList.innerHTML = '<li class="p-2 text-muted text-center">Connection lost.</li>'; // Clear user list
                 selectedUserEmail = null; // Reset selection
                 messageInput.disabled = true; // Disable input
                 sendButton.disabled = true;
                 setTimeout(connectWebSocket, 5000); // Attempt to reconnect
            };

            socket.onerror = function(error) {
                console.error("WebSocket Error:", error);
                 chatBody.innerHTML = '<div class="alert alert-danger m-3">WebSocket connection error. Please check the console and server status. Refresh the page to try again.</div>';
                 messageInput.disabled = true;
                 sendButton.disabled = true;
            };
        }

        // --- User List Update ---
        function updateUsersList(users, defaultStatusText) {
            memberList.innerHTML = ""; // Clear current list
            memberTitle.textContent = (role === "HR" ? "Online Users" : "Assigned Users") + ` (`+ users.length +`)`; // Update title

            if (users.length === 0) {
                 memberList.innerHTML = '<li class="p-3 text-muted text-center fst-italic">No users currently available.</li>';
                 if(selectedUserEmail){ // Clear chat if the selected user disappears
                     selectedUserEmail = null;
                     chatBody.innerHTML = '<div class="p-3 text-center text-muted">Select a user to chat.</div>';
                 }
                 return;
            }

            users.forEach(user => {
                 const isOnline = user.isOnline !== undefined ? user.isOnline : (role === 'HR'); // Assume online for HR list, use status for Doctor
                 const statusClass = isOnline ? 'text-success' : (role === 'Doctor' ? 'text-danger' : 'text-muted'); // Use red for offline assigned doctors
                 const currentStatusText = isOnline ? defaultStatusText : (role === 'Doctor' ? 'Offline' : 'Status N/A');

                const li = document.createElement("li");
                li.className = "user-item"; // Use class for easier selection
                li.setAttribute("data-email", user.email);
                li.setAttribute("data-fullname", user.fullName);

                 if (user.email === selectedUserEmail) {
                     li.classList.add("selected");
                 }

                 // Define buttons based on role
                 let buttonsHtml = `
                    <button type="button" class="btn btn-sm btn-outline-danger action-delete-user" title="End Chat & Remove User">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x-circle" viewBox="0 0 16 16"><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/><path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/></svg>
                    </button>
                    <button type="button" class="btn btn-sm btn-outline-secondary action-export-chat" title="Export Chat History">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-download" viewBox="0 0 16 16"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/><path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z"/></svg>
                    </button>
                 `;
                 if (role === 'HR') {
                     buttonsHtml += `
                        <button type="button" class="btn btn-sm btn-outline-primary action-assign-doctor" title="Assign to Doctor">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-plus" viewBox="0 0 16 16"><path d="M6 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H1s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C9.516 10.68 8.289 10 6 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/><path fill-rule="evenodd" d="M13.5 5a.5.5 0 0 1 .5.5V7h1.5a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0V8h-1.5a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5z"/></svg>
                        </button>
                     `;
                 }

                // Structure with flexbox for better alignment
                li.innerHTML = `
                    <div class="d-flex align-items-center">
                         <img src="https://mdbcdn.b-cdn.net/img/Photos/Avatars/avatar-8.webp" alt="avatar"
                             class="rounded-circle shadow-1-strong me-3" width="50" height="50">
                        <div class="user-info flex-grow-1">
                            <p class="fw-bold mb-1">`+ user.fullName +`</p>
                            <p class="small text-muted mb-0">`+ user.email +`</p>
                        </div>
                         <div class="text-end user-actions">
                              <p class="small mb-1 user-status `+ statusClass +`">`+ currentStatusText +`</p>
                             <div class="btn-group btn-group-sm" role="group" aria-label="User actions">
                                 `+ buttonsHtml +`
                             </div>
                         </div>
                    </div>
                `;
                memberList.appendChild(li);
            });

            attachUserItemEvents(); // Re-attach events
             // Ensure selected user still exists, otherwise clear selection
             if (selectedUserEmail && !memberList.querySelector(`.user-item[data-email="`+ selectedUserEmail +`"]`)) {
                 selectedUserEmail = null;
                 chatBody.innerHTML = '<div class="p-3 text-center text-muted">Select a user to chat.</div>';
             }
        }

        // --- Event Handlers ---
        function attachUserItemEvents() {
            memberList.querySelectorAll(".user-item").forEach(item => {
                // Click on the main item (excluding buttons) to select chat
                item.addEventListener("click", function(event) {
                     if (event.target.closest('button, .btn-group')) {
                         return; // Ignore clicks on buttons or their container
                     }
                    const clickedEmail = this.getAttribute("data-email");
                     if (clickedEmail === selectedUserEmail) return; // Don't reload if already selected

                    deselectUserItem(); // Remove selection from others
                    this.classList.add("selected");
                    selectedUserEmail = clickedEmail;
                    console.log("Selected user:", selectedUserEmail);

                     // Clear unread status visually if present
                     this.classList.remove('has-unread');
                     const nameElement = this.querySelector('.fw-bold');
                     if(nameElement) nameElement.style.fontWeight = 'bold'; // Keep selected bold, but maybe reset extra boldness

                    chatBody.innerHTML = '<div class="p-3 text-center text-muted">Loading chat history...</div>';
                    if (socket && socket.readyState === WebSocket.OPEN) {
                        socket.send(JSON.stringify({
                            action: "getChatHistory",
                            userEmail: selectedUserEmail
                        }));
                         messageInput.disabled = false; // Enable input for selected user
                         sendButton.disabled = false;
                    } else {
                         chatBody.innerHTML = '<div class="alert alert-warning m-3">Cannot load history: WebSocket not connected.</div>';
                         messageInput.disabled = true;
                         sendButton.disabled = true;
                    }
                });

                // Action Button Listeners
                 const deleteBtn = item.querySelector('.action-delete-user');
                 const exportBtn = item.querySelector('.action-export-chat');
                 const assignBtn = item.querySelector('.action-assign-doctor'); // HR only

                 if (deleteBtn) {
                      deleteBtn.addEventListener('click', function(e) {
                           e.stopPropagation(); // Prevent item click
                           const userEmail = item.getAttribute('data-email');
                           const userName = item.getAttribute('data-fullname');
                            if (confirm(`Are you sure you want to end the chat session with ${userName} (${userEmail}) and remove them? This may disconnect the user.`)) {
                                deleteChatSession(userEmail);
                            }
                      });
                 }
                 if (exportBtn) {
                     exportBtn.addEventListener('click', function(e) {
                         e.stopPropagation();
                         const userEmail = item.getAttribute('data-email');
                         const userName = item.getAttribute('data-fullname');
                         exportChatHistory(userEmail, userName);
                     });
                 }
                 if (assignBtn) {
                     assignBtn.addEventListener('click', function(e) {
                         e.stopPropagation();
                         const userEmailToAssign = item.getAttribute('data-email');
                         // Select the user visually if not already selected, *without* triggering full chat load
                          if (!item.classList.contains('selected')) {
                              deselectUserItem();
                              item.classList.add('selected');
                              selectedUserEmail = userEmailToAssign;
                               chatBody.innerHTML = `<div class="p-3 text-center text-muted">Preparing to assign ${item.getAttribute('data-fullname')}...</div>`;
                               messageInput.disabled = true; // Disable input during assignment prep
                               sendButton.disabled = true;
                          }
                         // Show modal (needs Bootstrap JS)
                         var assignModal = new bootstrap.Modal(document.getElementById('assignDoctorModal'));
                         assignModal.show();
                         // Note: The actual assignment happens when the modal's "Assign" button is clicked
                     });
                 }
            });
        }

        sendButton.addEventListener("click", sendMessage);
        messageInput.addEventListener("keypress", function(event) {
             if (event.key === 'Enter' && !event.shiftKey) {
                 event.preventDefault();
                 sendMessage();
             }
         });

        // --- Chat Display Functions ---
        function displayChatHistoryFromServer(history) {
             chatBody.innerHTML = ""; // Clear loading message
             if (history.length === 0) {
                 chatBody.innerHTML = '<div class="p-3 text-center text-muted">No chat history found for this user.</div>';
                 scrollToBottom(); // Scroll even if empty
                 return;
             }
             history.forEach(msgObj => {
                 const type = msgObj.senderEmail === adminEmail ? 'sent' : 'received';
                 // Use senderFullName from history if available, fallback to email
                 const sender = msgObj.senderFullName || msgObj.senderEmail || 'Unknown Sender';
                 displayMessage(msgObj.message, type, sender, msgObj.timestamp);
             });
             scrollToBottom();
         }

        // MODIFIED displayMessage to match new CSS structure
        function displayMessage(message, type, senderName, timestamp) {
            const messageWrapper = document.createElement("div");
            messageWrapper.classList.add("message", type);

            const formattedTime = timestamp ? formatTimestamp(timestamp) : '';

            // Default avatar URL (replace if you have user-specific avatars)
            const avatarUrl = "https://mdbcdn.b-cdn.net/img/Photos/Avatars/avatar-8.webp"; // Example placeholder

            if (type === 'sent') {
                messageWrapper.innerHTML = `
                    <div class="message-content">
                        <!-- Sender Name (Optional for sent messages)
                        <div class="sender-name">You</div> -->
                        <div class="message-bubble">
                            `+ message +` <!-- Use innerHTML if message contains HTML, else textContent -->
                        </div>
                        <div class="timestamp">`+ formattedTime +`</div>
                    </div>
                    <!-- Optional: Add admin avatar on the right
                    <img src="ADMIN_AVATAR_URL" alt="Admin" class="avatar"> -->
                `;
            } else { // received
                messageWrapper.innerHTML = `
                    <img src="`+ avatarUrl +`" alt="`+ senderName +`" class="avatar">
                    <div class="message-content">
                        <div class="sender-name">`+ senderName +`</div>
                        <div class="message-bubble">
                            `+ message +` <!-- Use innerHTML if message contains HTML, else textContent -->
                        </div>
                        <div class="timestamp">`+ formattedTime +`</div>
                    </div>
                `;
            }
            chatBody.appendChild(messageWrapper);
            // Scroll is handled after adding message or history batch
        }


        // --- WebSocket Message Handlers ---
         function handleIncomingMessage(data) {
             // Check if the message is relevant to the current view
             const isRelevantToCurrentChat = selectedUserEmail &&
                ((data.receiverEmail === adminEmail && data.senderEmail === selectedUserEmail) || // Received from selected user
                 (data.senderEmail === adminEmail && data.receiverEmail === selectedUserEmail));   // Sent by admin TO selected user (already displayed locally, but confirms delivery/persists)

             if (isRelevantToCurrentChat) {
                  // Display only if it's a message received FROM the user
                  // (Admin's own messages are displayed immediately on send)
                  if (data.senderEmail !== adminEmail) {
                      displayMessage(data.message, 'received', data.senderFullName || data.senderEmail, data.timestamp);
                      scrollToBottom();
                  } else {
                       // Optional: Could add a 'delivered' tick or similar for admin's sent messages here
                       console.log("Confirmation of sent message received/processed by server.");
                  }
             } else if (data.senderEmail !== adminEmail) {
                  // Message from a user not currently selected
                  console.log(`New message from ${data.senderFullName || data.senderEmail} (not selected).`);
                  const userItem = memberList.querySelector(`.user-item[data-email="${data.senderEmail}"]`);
                  if (userItem && !userItem.classList.contains('selected')) {
                      userItem.classList.add('has-unread'); // Add visual indicator
                      // Optional: Play a notification sound
                  }
             }
         }

         function handleAssignSuccess(data) {
            console.log(`User ${data.userFullName} (${data.userEmail}) assigned to doctor ${data.doctorFullName} (${data.doctorEmail})`);
            alert(data.message); // Confirmation for HR

            // Remove the user from HR's list
            const userElement = memberList.querySelector(`.user-item[data-email="${data.userEmail}"]`);
            if (userElement) {
                userElement.remove();
                 updateListTitle();
            }

            // If the assigned user was selected, clear the chat area
            if (selectedUserEmail === data.userEmail) {
                chatBody.innerHTML = `<div class="p-3 text-center text-muted">User ${data.userFullName} has been assigned to Dr. ${data.doctorFullName}.</div>`;
                selectedUserEmail = null;
                deselectUserItem(); // Ensure visual deselection
                messageInput.disabled = true; // Disable input as no user is selected
                sendButton.disabled = true;
            }
         }

         function handleClearChat(userEmail, userName) {
             console.log(`Received clearChat for user: ${userName} (${userEmail})`);
             const userElement = memberList.querySelector(`.user-item[data-email="${userEmail}"]`);
             if (userElement) {
                 userElement.remove();
                 updateListTitle();
             }
             if (selectedUserEmail === userEmail) {
                 selectedUserEmail = null;
                 chatBody.innerHTML = `<div class="p-3 text-center text-muted">User ${userName || userEmail} has disconnected or the session ended.</div>`;
                 deselectUserItem();
                 messageInput.disabled = true;
                 sendButton.disabled = true;
             }
         }

        // --- Actions ---
        function sendMessage() {
            let message = messageInput.value.trim();
            if (!selectedUserEmail) {
                alert("Please select a user to chat with.");
                return;
            }
            if (message === "") {
                // Optional: Maybe don't alert, just do nothing or disable button when empty
                return;
            }

            if (socket && socket.readyState === WebSocket.OPEN) {
                // Display locally first for instant feedback
                const timestamp = new Date(); // Use Date object, format when displaying
                displayMessage(message, 'sent', adminFullName, timestamp);
                scrollToBottom();

                const messageData = {
                    action: "sendMessage",
                    message: message,
                    email: adminEmail,          // Sender (admin)
                    fullName: adminFullName,    // Sender's name
                    receiverEmail: selectedUserEmail // Recipient (user)
                };

                socket.send(JSON.stringify(messageData));
                console.log("Message sent: ", messageData);
                messageInput.value = ""; // Clear input
            } else {
                alert("WebSocket is not connected. Cannot send message.");
            }
        }

        function deleteChatSession(email) {
             console.log("Requesting delete/close session for user:", email);
             if (socket && socket.readyState === WebSocket.OPEN) {
                 socket.send(JSON.stringify({
                     action: "deleteMessage", // Server action to close session
                     email: email           // User whose session to close
                 }));
                 // UI updates (removal, chat clear) are handled by server broadcasts (clearChat)
             } else {
                 alert("WebSocket is not connected. Cannot perform action.");
             }
         }

        function exportChatHistory(email, fullName) {
             console.log("Requesting export chat history for:", fullName, email);
             if (socket && socket.readyState === WebSocket.OPEN) {
                 socket.send(JSON.stringify({
                     action: "exportChat",
                     email: email,
                     fullName: fullName
                     // Server fetches history based on email
                 }));
                 // User gets feedback via 'exportSuccess' or 'exportError' message
             } else {
                 alert("WebSocket is not connected. Cannot perform action.");
             }
         }

        // --- Doctor Assignment Modal (HR only) ---
        if (role === "HR") {
             const assignDoctorBtn = document.getElementById("assignDoctorBtn");
             const doctorSelect = document.getElementById("doctorSelect");
             const assignModalElement = document.getElementById('assignDoctorModal');
             let assignModalInstance = null;
              if(assignModalElement) {
                   assignModalInstance = bootstrap.Modal.getOrCreateInstance(assignModalElement);
              }


             if (assignDoctorBtn && doctorSelect && assignModalInstance) {
                 assignDoctorBtn.addEventListener("click", function() {
                     const selectedDoctorEmail = doctorSelect.value;
                     const selectedDoctorName = doctorSelect.options[doctorSelect.selectedIndex]?.text || selectedDoctorEmail; // Get name for logging

                     if (!selectedDoctorEmail || selectedDoctorEmail === "Choose a doctor...") {
                         alert("Please select a doctor from the list.");
                         return;
                     }
                     if (!selectedUserEmail) {
                          // This case should ideally be prevented by disabling assign button or selecting user first
                          alert("Error: No user is selected for assignment.");
                          return;
                     }

                     console.log(`Attempting to assign user ${selectedUserEmail} to doctor ${selectedDoctorName} (${selectedDoctorEmail})`);

                     if (socket && socket.readyState === WebSocket.OPEN) {
                         socket.send(JSON.stringify({
                             action: "assignDoctor",
                             doctor: selectedDoctorEmail, // Doctor's email
                             userEmail: selectedUserEmail  // User's email
                         }));
                         assignModalInstance.hide(); // Close the modal
                         // UI updates handled via 'assignSuccess' message
                     } else {
                         alert("WebSocket is not connected. Cannot assign doctor.");
                     }
                 });
             } else {
                  console.error("Assign Doctor button, select element, or modal instance not found/initialized correctly.");
             }
        }

        // --- Utility Functions ---
        function updateOnlineDoctors(onlineDoctors) { // For HR's assignment modal
             const doctorSelect = document.getElementById("doctorSelect");
             if (!doctorSelect) return;

             const currentSelection = doctorSelect.value;
             doctorSelect.innerHTML = `<option selected disabled value="Choose a doctor...">Choose a doctor...</option>`; // Default disabled option

             if (onlineDoctors.length === 0) {
                  doctorSelect.innerHTML += `<option disabled>No doctors currently online</option>`;
             } else {
                  onlineDoctors.forEach(doctor => {
                      const option = document.createElement("option");
                      option.value = doctor.email;
                      option.textContent = `${doctor.fullName} (${doctor.email})`;
                       if (doctor.email === currentSelection) {
                           option.selected = true; // Re-select if possible
                       }
                      doctorSelect.appendChild(option);
                  });
             }
         }

        function scrollToBottom() {
            // Use requestAnimationFrame for smoother scrolling after DOM updates
             requestAnimationFrame(() => {
                 // Small delay can sometimes help ensure layout is fully computed
                setTimeout(() => {
                   chatBody.scrollTop = chatBody.scrollHeight;
                }, 50);
             });
        }

        function formatTimestamp(timestamp) {
             try {
                  const date = new Date(timestamp);
                  if (isNaN(date)) { // Check if the date is valid
                       return 'Invalid date';
                  }
                  const options = { hour: 'numeric', minute: 'numeric', hour12: true }; // e.g., 10:30 AM
                  return date.toLocaleTimeString(navigator.language, options); // Use browser's locale
             } catch (e) {
                  console.error("Error formatting timestamp:", timestamp, e);
                  // Attempt to return the original string if it looks like a time already
                   if (typeof timestamp === 'string' && timestamp.includes(':')) return timestamp;
                   return 'Time N/A';
             }
         }

        function deselectUserItem() {
             memberList.querySelectorAll(".user-item.selected").forEach(el => {
                  el.classList.remove("selected");
                  // Reset font weight if needed, but keep regular bold for non-selected items
                   const nameElement = el.querySelector('.fw-bold');
                   if(nameElement) nameElement.style.fontWeight = ''; // Reset specific style overrides
             });
             // Disable input when no user is selected
             // selectedUserEmail = null; // This should be set explicitly when deselecting
              messageInput.disabled = true;
              sendButton.disabled = true;
         }

         function updateListTitle() { // Recalculates count and updates title
              const count = memberList.querySelectorAll('.user-item').length;
              memberTitle.textContent = (role === "HR" ? "Online Users" : "Assigned Users") + ` (${count})`;
         }

        // --- Toast Notification for Doctor ---
        function showAssignToast(user) { // user = { userFullName, userEmail }
            const toastElement = document.getElementById('userToast');
            const toastMessage = document.getElementById('toastMessage');
            if (!toastElement || !toastMessage) {
                console.error("Toast elements not found."); return;
            }
            toastMessage.textContent = `User ${user.userFullName} (${user.userEmail}) has been assigned to you.`;
            const toast = bootstrap.Toast.getOrCreateInstance(toastElement, { delay: 6000 }); // Show for 6 seconds
            toast.show();
            console.log("Showing assignment toast for:", user.userFullName);
            // Optional: Play a notification sound
            // var audio = new Audio('path/to/notification.mp3'); audio.play();
        }

        // --- Initialization ---
        document.addEventListener("DOMContentLoaded", function() {
             // Set initial title
             updateListTitle(); // Call initially to set title with 0 count

             // Connect WebSocket
             connectWebSocket();

              // Initial state for input
              messageInput.disabled = true;
              sendButton.disabled = true;

             // Add listener to clear unread status when an item is explicitly clicked (handled in attachUserItemEvents now)
        });

    </script>
</body>
</html>