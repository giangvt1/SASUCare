<%-- 
    Document   : chatbox
    Created on : Mar 1, 2025, 5:11:38 PM
    Author     : ngoch
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chat box</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <style>
            .message {
                display: flex;
                align-items: center;
            }
        </style>
    </head>
    <body>
        <section>
            <div class="container py-5">

              <div class="row">

                <div class="col-md-6 col-lg-5 col-xl-4 mb-4 mb-md-0">

                  <h5 class="font-weight-bold mb-3 text-center text-lg-start">Member</h5>

                  <div class="card">
                    <div class="card-body">
                      <ul class="list-unstyled mb-0">
                        <li class="p-2 border-bottom bg-body-tertiary">
                          <a href="#!" class="d-flex justify-content-between">
                            <div class="d-flex flex-row chat-messages">
                            </div>
                            <div class="pt-1">
                              <p class="small text-muted mb-1">Just now</p>
                              <span class="badge bg-danger float-end">1</span>
                            </div>
                          </a>
                        </li>
                      </ul>
                    </div>
                  </div>
                </div>

                <div class="col-md-6 col-lg-7 col-xl-8">
                  <ul class="list-unstyled">
                    <li class="d-flex justify-content-between mb-4">
                      <img src="https://mdbcdn.b-cdn.net/img/Photos/Avatars/avatar-6.webp" alt="avatar"
                        class="rounded-circle d-flex align-self-start me-3 shadow-1-strong" width="60">
                      <div class="card">
                        <div class="card-header d-flex justify-content-between p-3">
                          <p class="fw-bold mb-0">Brad Pitt</p>
                          <p class="text-muted small mb-0"><i class="far fa-clock"></i> 12 mins ago</p>
                        </div>
                        <div class="card-body">
                          <p class="mb-0">
                            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut
                            labore et dolore magna aliqua.
                          </p>
                        </div>
                      </div>
                    </li>
                    <li class="d-flex justify-content-between mb-4">
                      <div class="card w-100">
                        <div class="card-header d-flex justify-content-between p-3">
                          <p class="fw-bold mb-0">Lara Croft</p>
                          <p class="text-muted small mb-0"><i class="far fa-clock"></i> 13 mins ago</p>
                        </div>
                        <div class="card-body">
                          <p class="mb-0">
                            Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque
                            laudantium.
                          </p>
                        </div>
                      </div>
                      <img src="https://mdbcdn.b-cdn.net/img/Photos/Avatars/avatar-5.webp" alt="avatar"
                        class="rounded-circle d-flex align-self-start ms-3 shadow-1-strong" width="60">
                    </li>
                    
                    <li class="bg-white mb-3">
                      <div data-mdb-input-init class="form-outline">
                        <textarea class="form-control bg-body-tertiary" id="textAreaExample2" rows="4"></textarea>
                        <label class="form-label" for="textAreaExample2">Message</label>
                      </div>
                    </li>
                    <button  type="button" data-mdb-button-init data-mdb-ripple-init class="btn btn-info btn-rounded float-end">Send</button>
                  </ul>

                </div>
              </div>
            </div>
          </section>
        <script>
            var socket = new WebSocket("ws://localhost:9999/SWP391_GR6/chat");
            
            let chatBody = document.querySelector(".chat-messages");
            
            let receivedMessage = document.createElement("div");
            receivedMessage.classList.add("message", "received");
            receivedMessage.innerHTML = `
                <img src="https://mdbcdn.b-cdn.net/img/Photos/Avatars/avatar-8.webp" alt="avatar"
                            class="rounded-circle d-flex align-self-left me-3 shadow-1-strong" width="60">
                <p> Name <\p>
            `;
    
    
            chatBody.appendChild(receivedMessage);
            chatBody.scrollTop = chatBody.scrollHeight;
            
            socket.onmessage = function(event) {
                
                console.log("Received message:", event.data);
                
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
        </script>
    </body>
</html>
