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

    <!-- Toast Container: Hiển thị thông báo cho Doctor khi có user được assign -->
    <div id="toastContainer" class="position-fixed top-0 end-0 p-3" style="z-index: 1050;">
      <div id="userToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-header">
          <img src="https://mdbcdn.b-cdn.net/img/Photos/Avatars/avatar-8.webp" class="rounded me-2" alt="Avatar" width="20">
          <strong class="me-auto">Thông báo</strong>
          <small></small>
          <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body" id="toastMessage">
          <!-- Nội dung thông báo sẽ được cập nhật động -->
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
        // Use || operators carefully, ensure values are actually present or provide valid defaults
        var adminEmail = "${sessionScope.account.gmail}";
        var role = "${sessionScope.userRoles}";
        var adminFullName = "${sessionScope.account.displayname}"; // Changed variable name for clarity
        var selectedUserEmail = null; // No initial selection, fetch history on click

        // --- State ---
        // Removed chatHistory localStorage logic. Server is the source of truth.

        // --- WebSocket Connection ---
        function connectWebSocket() {
            // Ensure adminEmail is available before connecting
             if (!adminEmail) {
                 console.error("Admin email not found in session. Cannot connect WebSocket.");
                  // Display an error message to the user on the page
                  chatBody.innerHTML = '<div class="alert alert-danger">Could not establish connection. User information missing. Please log in again.</div>';
                 return;
             }

            // Construct WebSocket URL dynamically (adjust if needed)
            const wsUrl = `ws://localhost:9999/SWP391_GR6/chat`;
             console.log("Connecting WebSocket to:", wsUrl);


            socket = new WebSocket(wsUrl);

            socket.onopen = function() {
                console.log("✅ WebSocket Connected");
                // Send admin info to server
                socket.send(JSON.stringify({
                    action: "userInfo",
                    email: adminEmail,
                    fullName: adminFullName,
                    role: role
                }));
                console.log("Sent userInfo:", { email: adminEmail, fullName: adminFullName, role: role });
                 // Optional: Clear chat body on reconnect
                 // chatBody.innerHTML = "Select a user to start chatting.";
            };

            socket.onmessage = function(event) {
                try {
                    let data = JSON.parse(event.data);
                    console.log("Message received:", event);

                    switch (data.action) {
                        case "updateOnlineUsers": // For HR
                            if (role === "HR") {
                                // Don't clear chat body here, only update list
                                updateUsersList(data.onlineUsers || [], "Online");
                            }
                            break;
                         case "clearChat": // Received when a user disconnects (after delay) or force deleted by HR
                              handleClearChat(data.userEmail, data.fullName);
                              break;
                        case "updateAssignedUsers": // For Doctor
                            if (role === "Doctor") {
                                updateUsersList(data.assignedUsers || [], "Assigned");
                            }
                            break;
                         case "newAssignment": // Notification for Doctor (Toast)
                              if (role === "Doctor" && data.userFullName) {
                                   showAssignToast(data); // Show toast for the newly assigned user
                                   // Note: updateAssignedUsers will follow to update the list
                              }
                              break;
                        case "updateOnlineDoctors": // For HR
                            if (role === "HR") {
                                updateOnlineDoctors(data.onlineDoctors || []);
                            }
                            break;
                        // --- NEW: Handle fetched chat history ---
                        case "chatHistoryResponse":
                             if (data.userEmail === selectedUserEmail) {
                                displayChatHistoryFromServer(data.history || []);
                             } else {
                                console.log("Received history for non-selected user:", data.userEmail);
                             }
                             break;
                         // --- Handle incoming messages ---
                        case "sendMessage":
                            console.log("adu");
                             handleIncomingMessage(data);
                             break;
                        case "assignSuccess": // Confirmation for HR after assigning
                            if (role === "HR") {
                                handleAssignSuccess(data);
                            }
                            break;
                         case "removeAssignedUser": // Notification for Doctor when user disconnects/is removed
                              if(role === "Doctor"){
                                   console.log(`User `+ data.userFullName +` (`+ data.userEmail +`) was removed or disconnected.`);
                                   // The list will be updated by updateAssignedUsers sent subsequently by server
                                   // Optionally show a less prominent notification/log
                                   // Remove selection if the removed user was selected
                                   if (selectedUserEmail === data.userEmail) {
                                        selectedUserEmail = null;
                                        chatBody.innerHTML = '<div class="p-3">User session ended. Select another user.</div>';
                                         // Deselect in the list
                                         deselectUserItem();
                                   }
                              }
                              break;
                         // --- Handle Errors from Server ---
                         case "assignError":
                         case "exportError":
                         case "sendError":
                         case "authError":
                         case "processingError":
                         case "sessionCloseError":
                         case "noHR": // Error for client when admin not available
                         case "deliveryError": // Error for client when doctor offline
                              console.error("Server Error (" + data.action + "):", data.message);
                              // Display a more user-friendly error if needed, e.g., using alerts or a dedicated error area
                              alert("Server Error: " + data.message);
                              break;
                         // --- Handle Success Confirmations (Optional UI feedback) ---
                         case "exportSuccess":
                              alert("Success: " + data.message); // Simple alert confirmation
                              break;
                         case "sessionCloseSuccess":
                              alert("Success: " + data.message);
                              break;
                         // --- Handle Notifications from Server (e.g., forced closure) ---
                         case "forceClose": // Notification to user client when kicked by admin
                              console.warn("Server initiated disconnect: " + data.reason);
                              alert("Your session was closed by an administrator.");
                              // Optionally disable input, close socket gracefully from client side?
                              socket.close();
                              break;
                         case "userReconnected":
                              console.log(`User `+ data.userEmail +` reconnected.`);
                              // Update the user's status indicator in the list if needed
                               const userItem = memberList.querySelector(`.user-item[data-email="`+ data.userEmail +`"]`);
                               if (userItem) {
                                   const statusElement = userItem.querySelector('.user-status'); // Add a class for status
                                   if (statusElement) {
                                       statusElement.textContent = (role === 'HR' ? 'Online' : 'Assigned');
                                       statusElement.classList.remove('text-muted'); // Make it look active
                                       statusElement.classList.add('text-success');
                                   }
                               }
                              break;
                         default:
                             console.log("Unhandled action: ", data.action);
                    }
                } catch (error) {
                    console.error("Error processing WebSocket message:", error);
                     console.error("Original message data:", event.data);
                }
            };

            socket.onclose = function(event) {
                console.log("WebSocket Disconnected.", event.reason, event.code);
                // Optionally try to reconnect after a delay, or notify user
                 chatBody.innerHTML = '<div class="alert alert-warning">Connection lost. Attempting to reconnect...</div>';
                 // Simple immediate reconnect attempt (consider backoff strategy)
                 setTimeout(connectWebSocket, 5000); // Reconnect after 5 seconds
            };

            socket.onerror = function(error) {
                console.error("WebSocket Error:", error);
                // Display error to user
                 chatBody.innerHTML = '<div class="alert alert-danger">WebSocket connection error. Please check the console and refresh the page.</div>';
            };
        }

        // --- User List Update Functions ---

        function updateUsersList(users, statusText) {
            memberList.innerHTML = ""; // Clear current list
            memberTitle.textContent = (role === "HR" ? "Online Users" : "Assigned Users") + ` (`+ users.length +`)`; // Update title with count

            if (users.length === 0) {
                 memberList.innerHTML = '<li class="p-2 text-muted">No users found.</li>';
                 // If the previously selected user is no longer in the list, clear the chat
                 if(selectedUserEmail && !users.some(u => u.email === selectedUserEmail)){
                     selectedUserEmail = null;
                     chatBody.innerHTML = '<div class="p-3">Select a user to chat.</div>';
                 }
                 return;
            }

            users.forEach(user => {
                 // Determine if the user is marked as online (relevant for doctors mostly)
                 const isOnline = user.isOnline !== undefined ? user.isOnline : true; // Default to true if not specified
                 const statusClass = isOnline ? 'text-success' : 'text-muted';
                 const currentStatusText = isOnline ? statusText : 'Offline';

                const li = document.createElement("li");
                li.classList.add("p-2", "border-bottom", "user-item"); // Removed bg-body-tertiary for better selection visibility
                li.setAttribute("data-email", user.email);
                li.setAttribute("data-fullname", user.fullName); // Store full name

                // Add selected class if this user was previously selected
                 if (user.email === selectedUserEmail) {
                     li.classList.add("selected");
                 }
                 const role1 = role == 'HR' ? '<button type="button" class="btn btn-primary action-assign-doctor" title="Assign to Doctor">Assign</button>' : '';

                // Basic structure (customize as needed)
                li.innerHTML = `
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="d-flex flex-row align-items-center">
                            <img src="https://mdbcdn.b-cdn.net/img/Photos/Avatars/avatar-8.webp" alt="avatar"
                                 class="rounded-circle d-flex align-self-center me-3 shadow-1-strong" width="50">
                            <div class="pt-1">
                                <p class="fw-bold mb-0">`+ user.fullName +`</p>
                                <p class="small text-muted mb-0">`+ user.email +`</p>
                            </div>
                        </div>
                        <div class="text-end">
                             <p class="small mb-1 user-status `+ statusClass +`">`+ currentStatusText +`</p>
                            <div class="btn-group btn-group-sm" role="group" aria-label="User actions">
                                <button type="button" class="btn btn-danger action-delete-user" title="End Chat & Remove User">End Chat</button>
                                <button type="button" class="btn btn-success action-export-chat" title="Export Chat History">Export</button>
                                `+ role1 +`
                            </div>
                        </div>
                    </div>
                `;
                memberList.appendChild(li);
            });

            attachUserItemEvents(); // Re-attach events to new list items
        }


        // --- Event Handlers ---

        function attachUserItemEvents() {
            memberList.querySelectorAll(".user-item").forEach(item => {
                // Click on the main item to select chat
                item.addEventListener("click", function(event) {
                    // Prevent selection if a button inside the item was clicked
                     if (event.target.closest('button')) {
                         return;
                     }

                    // Remove selection from others
                    deselectUserItem();

                    // Select this item
                    this.classList.add("selected");
                    selectedUserEmail = this.getAttribute("data-email");
                    console.log("Selected user:", selectedUserEmail);

                    // Clear chat display and request history from server
                    chatBody.innerHTML = '<div class="p-3 text-center">Loading chat history...</div>'; // Loading indicator
                    if (socket && socket.readyState === WebSocket.OPEN) {
                        socket.send(JSON.stringify({
                            action: "getChatHistory",
                            userEmail: selectedUserEmail
                        }));
                    } else {
                         chatBody.innerHTML = '<div class="alert alert-warning">Cannot load history: WebSocket not connected.</div>';
                    }
                });

                // Add event listeners for action buttons within the user item
                 const deleteBtn = item.querySelector('.action-delete-user');
                 const exportBtn = item.querySelector('.action-export-chat');
                 const assignBtn = item.querySelector('.action-assign-doctor'); // Only exists for HR

                 if (deleteBtn) {
                      deleteBtn.addEventListener('click', function(e) {
                           e.stopPropagation(); // Prevent item click event
                           const userEmail = item.getAttribute('data-email');
                           const userName = item.getAttribute('data-fullname');
                            if (confirm(`Are you sure you want to end the chat session with `+ userName +` (`+ userEmail +`) and remove them from the list?`)) {
                                deleteChatSession(userEmail);
                            }
                      });
                 }

                 if (exportBtn) {
                     exportBtn.addEventListener('click', function(e) {
                         e.stopPropagation(); // Prevent item click event
                         const userEmail = item.getAttribute('data-email');
                         const userName = item.getAttribute('data-fullname');
                         exportChatHistory(userEmail, userName);
                     });
                 }

                 if (assignBtn) {
                     assignBtn.addEventListener('click', function(e) {
                         e.stopPropagation(); // Prevent item click event
                          // Ensure this user is selected visually before showing modal
                           if (!item.classList.contains('selected')) {
                               deselectUserItem();
                               item.classList.add('selected');
                               selectedUserEmail = item.getAttribute('data-email');
                                // No need to fetch history here, just select for assignment
                                chatBody.innerHTML = `<div class="p-3">Assigning `+ item.getAttribute('data-fullname') +`...</div>`;
                           }
                         // Now show the modal
                         var assignDoctorModal = new bootstrap.Modal(document.getElementById('assignDoctorModal'));
                         assignDoctorModal.show();
                     });
                 }
            });
        }

        sendButton.addEventListener("click", sendMessage);
        messageInput.addEventListener("keypress", function(event) {
             // Send message on Enter key press (optional: Shift+Enter for newline)
             if (event.key === 'Enter' && !event.shiftKey) {
                 event.preventDefault(); // Prevent default newline behavior
                 sendMessage();
             }
         });

        // --- Chat Display Functions ---

         function displayChatHistoryFromServer(history) {
             chatBody.innerHTML = ""; // Clear loading message or previous chat
             if (history.length === 0) {
                 chatBody.innerHTML = '<div class="p-3 text-center text-muted">No messages in this conversation yet.</div>';
                 return;
             }
             history.forEach(msgObj => {
                 // Determine if message was sent by the current admin or received from the user
                 const type = msgObj.senderEmail === adminEmail ? 'sent' : 'received';
                 displayMessage(msgObj.message, type, msgObj.senderFullName || msgObj.senderEmail, msgObj.timestamp);
             });
             scrollToBottom();
         }

        function displayMessage(message, type, senderName, timestamp) {
             const messageElement = document.createElement("div");
             // messageElement.classList.add("message", type); // 'message' class might not be needed with new structure

             const formattedTime = timestamp ? formatTimestamp(timestamp) : ''; // Format timestamp

             if (type === 'sent') {
                 messageElement.innerHTML = `
                     <div class="d-flex justify-content-end mb-3">
                          <div>
                             <div class="bg-primary p-2 px-3 text-white mb-1" style="border-radius: 15px; max-width: 75%;">
                                 <p class="small mb-0">`+ message +`</p>
                             </div>
                              <p class="small text-muted text-end">`+ formattedTime +`</p>
                          </div>
                     </div>
                 `;
             } else { // received
                 messageElement.innerHTML = `
                     <div class="d-flex justify-content-start mb-3">
                          <img src="https://mdbcdn.b-cdn.net/img/Photos/Avatars/avatar-8.webp" alt="`+ senderName +`" class="rounded-circle align-self-start me-2 shadow-1-strong" width="40">
                          <div>
                              <p class="small text-muted mb-1">`+ senderName +`</p>
                              <div class="bg-light p-2 px-3 mb-1" style="border-radius: 15px; max-width: 75%;">
                                  <p class="small mb-0">`+ message +`</p>
                              </div>
                              <p class="small text-muted">`+ formattedTime +`</p>
                          </div>
                     </div>
                 `;
             }
             chatBody.appendChild(messageElement);
             // Don't scroll here, scroll after processing a batch (history) or a single new message
         }


        // --- WebSocket Message Handlers ---
         function handleIncomingMessage(data) {
              // Check if the message belongs to the currently selected conversation
              // Message is relevant if the admin is the receiver OR the sender is the selected user
             const isRelevant = (data.receiverEmail === adminEmail && data.senderEmail === selectedUserEmail) ||
                                (data.senderEmail === adminEmail && data.receiverEmail === selectedUserEmail); // Relevant if admin sent to selected user too (though already displayed locally)

             if (selectedUserEmail && isRelevant) {
                 // Display message only if it's from the user (admin's own messages are displayed on send)
                  if (data.senderEmail !== adminEmail) {
                      displayMessage(data.message, 'received', data.senderFullName || data.senderEmail, data.timestamp);
                      scrollToBottom();
                  }
             } else if (data.senderEmail !== adminEmail) {
                  // Optional: Indicate new message from a non-selected user
                  console.log(`New message from `+ data.senderFullName || data.senderEmail +` (not currently selected).`);
                  const userItem = memberList.querySelector(`.user-item[data-email="`+ data.senderEmail +`"]`);
                  if (userItem && !userItem.classList.contains('selected')) {
                      // Add a visual indicator (e.g., bold text, notification dot)
                      userItem.classList.add('has-unread'); // Add a class for styling unread state
                       const nameElement = userItem.querySelector('.fw-bold');
                       if(nameElement) nameElement.style.fontWeight = 'bold'; // Make name bold
                  }
             }
         }

         function handleAssignSuccess(data) {
            console.log(`User `+ data.userFullName +` (`+ data.userEmail +`) assigned to doctor `+ data.doctorFullName +` (`+ data.doctorEmail +`)`);

            // Remove the user item from the HR's list
            const userElement = memberList.querySelector(`.user-item[data-email="`+ data.userEmail +`"]`);
            if (userElement) {
                userElement.remove();
                 updateListTitle(); // Update count in title
            }

            // If the assigned user was selected, clear the chat area and selection
            if (selectedUserEmail === data.userEmail) {
                chatBody.innerHTML = `<div class="p-3">User `+ data.userFullName +` has been assigned to Dr. `+ data.doctorFullName +`.</div>`;
                selectedUserEmail = null;
                 // Optionally remove the selection highlight if it wasn't removed above
                 deselectUserItem();
            }
             // Optional: Show a success alert/toast
             alert(data.message); // Simple confirmation
         }

         function handleClearChat(userEmail, userName) {
             console.log(`Received clearChat for user: `+ userName +` (`+ userEmail +`)`);
             // Remove user from the list
             const userElement = memberList.querySelector(`.user-item[data-email="`+ userEmail +`"]`);
             if (userElement) {
                 userElement.remove();
                 updateListTitle(); // Update count in title
             }
             // If the removed user was selected, clear the chat panel
             if (selectedUserEmail === userEmail) {
                 selectedUserEmail = null;
                 chatBody.innerHTML = `<div class="p-3">User `+ userName +` has disconnected or the session ended.</div>`;
                  deselectUserItem();
             }
             // Note: Server might handle actual message history deletion separately or not at all based on policy
         }

         // --- Actions ---

        function sendMessage() {
            let message = messageInput.value.trim();
            if (!selectedUserEmail) {
                alert("Please select a user to send a message to.");
                return;
            }
            if (message === "") {
                alert("Please enter a message.");
                return;
            }

            if (socket && socket.readyState === WebSocket.OPEN) {
                // Display the sent message immediately for better UX
                const timestamp = formatTimestamp(new Date()); // Get current formatted time
                displayMessage(message, 'sent', adminFullName, timestamp); // Display locally
                scrollToBottom();

                // Prepare data for the server
                const messageData = {
                    action: "sendMessage",
                    message: message,
                    email: adminEmail, // Admin's email
                    fullName: adminFullName, // Admin's name
                    receiverEmail: selectedUserEmail // The user admin is sending to
                };

                // Send to server
                socket.send(JSON.stringify(messageData));
                console.log("Message sent: ", messageData);

                // Clear input field
                messageInput.value = "";
            } else {
                alert("WebSocket is not connected. Cannot send message.");
                 // Optionally try to reconnect or show a more persistent error
            }
        }


        function deleteChatSession(email) {
             console.log("Requesting delete/close session for user:", email);
             if (socket && socket.readyState === WebSocket.OPEN) {
                 socket.send(JSON.stringify({
                     action: "deleteMessage", // Action name as defined on server for closing session
                     email: email
                 }));
                  // UI update (removal from list, clearing chat) will be handled
                  // by the server's response/broadcast (e.g., clearChat or updateOnlineUsers)
             } else {
                 alert("WebSocket is not connected. Cannot perform action.");
             }
         }

        function exportChatHistory(email, fullName) {
             console.log("Requesting export chat history for:", fullName, email);
             if (socket && socket.readyState === WebSocket.OPEN) {
                 // Server now retrieves history, client just sends request
                 socket.send(JSON.stringify({
                     action: "exportChat",
                     email: email,
                     fullName: fullName
                     // No need to send chatContent from client anymore
                 }));
                 // Server will respond with success or error message (handled in onmessage)
             } else {
                 alert("WebSocket is not connected. Cannot perform action.");
             }
         }


        // --- Doctor Assignment Modal (HR only) ---
        if (role === "HR") {
             const assignDoctorBtn = document.getElementById("assignDoctorBtn");
             const doctorSelect = document.getElementById("doctorSelect");

             if (assignDoctorBtn && doctorSelect) {
                 assignDoctorBtn.addEventListener("click", function() {
                     const selectedDoctorEmail = doctorSelect.value;
                     if (!selectedDoctorEmail || selectedDoctorEmail === "Chọn bác sĩ...") {
                         alert("Please select a doctor from the list.");
                         return;
                     }
                     if (!selectedUserEmail) {
                          alert("No user selected for assignment. Click the user in the list first.");
                          return;
                     }

                     console.log(`Assigning user `+ selectedUserEmail +` to doctor `+ selectedDoctorEmail +``);

                     if (socket && socket.readyState === WebSocket.OPEN) {
                         socket.send(JSON.stringify({
                             action: "assignDoctor",
                             doctor: selectedDoctorEmail, // Doctor's email
                             userEmail: selectedUserEmail // User's email
                         }));

                         // Close the modal
                         var assignDoctorModal = bootstrap.Modal.getInstance(document.getElementById("assignDoctorModal"));
                         if (assignDoctorModal) {
                              assignDoctorModal.hide();
                         }
                         // UI update (user removal from list, etc.) will be handled by assignSuccess message from server
                     } else {
                         alert("WebSocket is not connected. Cannot perform action.");
                     }
                 });
             } else {
                  console.error("Assign Doctor button or select element not found.");
             }
        }


        // --- Utility Functions ---

         function updateOnlineDoctors(onlineDoctors) {
             const doctorSelect = document.getElementById("doctorSelect");
             if (!doctorSelect) return; // Only HR has this

             const currentSelection = doctorSelect.value; // Preserve selection if possible
             doctorSelect.innerHTML = `<option selected value="Chọn bác sĩ...">Choose a doctor...</option>`; // Default option

             if (onlineDoctors.length === 0) {
                  doctorSelect.innerHTML += `<option disabled>No doctors online</option>`;
             } else {
                  onlineDoctors.forEach(doctor => {
                      const option = document.createElement("option");
                      option.value = doctor.email;
                      option.textContent = ``+ doctor.fullName +` (`+ doctor.email +`)`;
                      // Reselect if it was selected before update
                       if (doctor.email === currentSelection) {
                           option.selected = true;
                       }
                      doctorSelect.appendChild(option);
                  });
             }
         }


        function scrollToBottom() {
            // Use setTimeout to allow the DOM to update before scrolling
             setTimeout(() => {
                chatBody.scrollTop = chatBody.scrollHeight;
             }, 0);
        }

        function formatTimestamp(timestamp) {
             // Handles both ISO string format from server history and Date object for local messages
             try {
                  const date = new Date(timestamp);
                  // Options for formatting: customize as needed
                  const options = { hour: 'numeric', minute: 'numeric' }; // time only
                  // const options = { year: 'numeric', month: 'short', day: 'numeric', hour: 'numeric', minute: 'numeric' }; // full date time
                  return date.toLocaleTimeString(undefined, options); // Use locale-specific time format
             } catch (e) {
                  console.error("Error formatting timestamp:", timestamp, e);
                  return timestamp; // Return original if formatting fails
             }
         }

         function deselectUserItem() {
             memberList.querySelectorAll(".user-item.selected").forEach(el => {
                  el.classList.remove("selected");
                  // Optional: Reset unread indicator if needed when deselecting
                  el.classList.remove('has-unread');
                   const nameElement = el.querySelector('.fw-bold');
                   if(nameElement) nameElement.style.fontWeight = 'normal'; // Reset bold
             });
         }

         function updateListTitle() {
              const count = memberList.querySelectorAll('.user-item').length;
              memberTitle.textContent = (role === "HR" ? "Online Users" : "Assigned Users") + ` (`+ count +`)`;
         }


        // --- Toast Notification for Doctor ---
        function showAssignToast(user) {
            // user: object containing userFullName and userEmail
             const toastElement = document.getElementById('userToast');
             const toastMessage = document.getElementById('toastMessage');

             if (!toastElement || !toastMessage) {
                  console.error("Toast elements not found.");
                  return;
             }

             toastMessage.textContent = `User `+ user.userFullName +` (`+ user.userEmail +`) has been assigned to you.`;

             // Ensure toast is properly initialized (might need to recreate instance if reused)
             // Use 'getOrCreateInstance' for safety
             const toast = bootstrap.Toast.getOrCreateInstance(toastElement, { delay: 5000 }); // 5 second delay
             toast.show();
             console.log("Showing assignment toast for:", user.userFullName);
        }

        // --- Initialization ---
        document.addEventListener("DOMContentLoaded", function() {
             // Set initial title based on role
             if (role === "HR") {
                 memberTitle.textContent = "Online Users";
             } else if (role === "Doctor") {
                 memberTitle.textContent = "Assigned Users";
             } else {
                  memberTitle.textContent = "Chat"; // Fallback
             }

             // Connect WebSocket
             connectWebSocket();

             // Initial setup for chat body
             chatBody.innerHTML = '<div class="p-3 text-center">Please select a user from the list to start chatting.</div>';

             // Add listener to clear unread status when an item is clicked
             memberList.addEventListener('click', (event) => {
                  const item = event.target.closest('.user-item');
                  if (item && item.classList.contains('has-unread')) {
                       item.classList.remove('has-unread');
                        const nameElement = item.querySelector('.fw-bold');
                        if(nameElement) nameElement.style.fontWeight = 'normal'; // Reset bold
                  }
             });
        });

    </script>
</body>
</html>
