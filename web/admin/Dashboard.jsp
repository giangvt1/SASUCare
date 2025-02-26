<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <%-- No need to include CSS/JS again here, it's in the header --%>
    
    <style>
        .chat-container {
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 300px;
            background: white;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            display: none;
          }
          .chat-header {
            background: #007bff;
            color: white;
            padding: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
          }
          .chat-body {
            max-height: 300px;
            overflow-y: auto;
            padding: 10px;
            display: block;
          }
          .chat-footer {
            padding: 10px;
            display: flex;
            gap: 5px;
          }
          .message {
            display: flex;
            align-items: center;
            margin: 5px 0;
          }
          .received img {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            margin-right: 10px;
          }
          .received p, .sent p {
            background: #f1f1f1;
            padding: 5px 10px;
            border-radius: 10px;
          }
          .sent p {
            background: #007bff;
            color: white;
            align-self: flex-end;
          }
          .chat-icon {
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 50px;
            height: 50px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
          }
          .message.sent {
              justify-content: flex-end;
          }
      </style>
</head>
<body class="skin-black"> <%-- You can keep this class if you want, but ensure styles are in CSS --%>
    <jsp:include page="AdminHeader.jsp"></jsp:include>
    <jsp:include page="AdminLeftSideBar.jsp"></jsp:include>

    <div class="right-side"> 
        <div class="dashboard-content">
            <h2 class="text-center mb-4">Admin Dashboard</h2>

            <div class="row">
                <div class="col-lg-3 col-md-6">
                    <div class="card bg-primary text-white p-3">
                        <h4><i class="fas fa-users"></i> Total Users</h4>
                        <p><strong>1,250</strong></p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="card bg-success text-white p-3">
                        <h4><i class="fas fa-shopping-cart"></i> Orders</h4>
                        <p><strong>320</strong></p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="card bg-warning text-white p-3">
                        <h4><i class="fas fa-dollar-sign"></i> Revenue</h4> <%-- Corrected Font Awesome icon --%>
                        <p><strong>$15,200</strong></p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="card bg-danger text-white p-3">
                        <h4><i class="fas fa-exclamation-triangle"></i> Pending Issues</h4>
                        <p><strong>8</strong></p>
                    </div>
                </div>
            </div>


            <div class="row mt-4">
                <div class="col-md-6 chart-container">
                    <canvas id="userChart"></canvas>
                </div>
                <div class="col-md-6 chart-container">
                    <canvas id="orderChart"></canvas>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col-md-12">
                    <h4>Recent Users</h4>
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>101</td>
                                    <td>john_doe</td>
                                    <td>john@example.com</td>
                                    <td>Manager</td>
                                    <td><span class="badge bg-success">Active</span></td>
                                </tr>
                                <tr>
                                    <td>102</td>
                                    <td>jane_smith</td>
                                    <td>jane@example.com</td>
                                    <td>Customer</td>
                                    <td><span class="badge bg-warning">Pending</span></td>
                                </tr>
                                <tr>
                                    <td>103</td>
                                    <td>admin_user</td>
                                    <td>admin@example.com</td>
                                    <td>Admin</td>
                                    <td><span class="badge bg-danger">Banned</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
                        
    <section>
            <div id="chat-box" class="chat-container">
              <div class="chat-header" id="chat-toggle">
                <h5 class="mb-0">Chat</h5>
                <button id="toggle-chat" class="btn btn-primary btn-sm">&#x25B2;</button>
              </div>
              <div class="chat-body">
                <div class="chat-messages">
                  <div class="message received">
                    <img src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-chat/ava3-bg.webp" alt="avatar">
                    <p>Hi, How are you?</p>
                  </div>
                  <div class="message sent">
                    <p>I'm good. How about you?</p>
                  </div>
                </div>
              </div>
              <div class="chat-footer">
                <input type="text" class="form-control" placeholder="Type a message">
                <button class="btn btn-primary">Send</button>
              </div>
            </div>
            <button id="chat-icon" class="chat-icon">
              <i class="fas fa-comment"></i>
            </button>
          </section>
    <script src="${pageContext.request.contextPath}/js/Director/dashboard.js"></script>
    <script>
        document.getElementById("toggle-chat").addEventListener("click", function() {
            document.getElementById("chat-box").style.display = "none";
            document.getElementById("chat-icon").style.display = "flex";
        });
        document.getElementById("chat-icon").addEventListener("click", function() {
            document.getElementById("chat-box").style.display = "block";
            document.getElementById("chat-icon").style.display = "none";
        });
            
            var socket = new WebSocket("ws://localhost:9999/SWP391_GR6/chat");
            socket.onmessage = function(event) {
                
                console.log("Received message:", event.data);
                let chatBody = document.querySelector(".chat-messages");
                let receivedMessage = document.createElement("div");
                receivedMessage.classList.add("message", "received");
                receivedMessage.innerHTML = `
                    <img src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-chat/ava3-bg.webp" alt="avatar">
                    <p>`+ event.data + `</p>
                `;
                chatBody.appendChild(receivedMessage);
                chatBody.scrollTop = chatBody.scrollHeight;
            };
            
            socket.onopen = function() {
                console.log("✅ WebSocket Connected");
            };
            
            


            socket.onerror = function(error) {
                console.log("WebSocket Error: " + error);
            };

            function sendMessage() {
                let inputField = document.querySelector(".chat-footer input");
                let message = inputField.value.trim();
                if (message !== "") {
                    let chatBody = document.querySelector(".chat-messages");
                    let sentMessage = document.createElement("div");
                    sentMessage.classList.add("message", "sent");
                    sentMessage.innerHTML = `<p>`+ message + `</p>`;
                    chatBody.appendChild(sentMessage);
                    chatBody.scrollTop = chatBody.scrollHeight;

                    socket.send(message); // Gửi tin nhắn qua WebSocket
                    inputField.value = "";
                }
            }

            document.querySelector(".chat-footer button").addEventListener("click", sendMessage);
            document.querySelector(".chat-footer input").addEventListener("keypress", function(event) {
                if (event.key === "Enter") {
                    sendMessage();
                }
            });
        
          const userChart = new Chart(document.getElementById("userChart"), {
            type: "doughnut",
            data: {
                labels: ["Active Users", "Inactive Users"],
                datasets: [{
                        data: [1000, 250],
                        backgroundColor: ["#4CAF50", "#FFC107"]
                    }]
            }
        });

        const orderChart = new Chart(document.getElementById("orderChart"), {
            type: "bar",
            data: {
                labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
                datasets: [{
                        label: "Orders",
                        data: [30, 50, 40, 70, 60, 90],
                        backgroundColor: "#007BFF"
                    }]
            }
        });
    </script>
     <script src="${pageContext.request.contextPath}/js/Director/dashboard.js"></script>
</body>
</html>