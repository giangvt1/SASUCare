document.addEventListener("DOMContentLoaded", function () {
  const infoForm = document.getElementById("info-form");
  const chatBox = document.getElementById("chat-box");
  const chatIcon = document.getElementById("chat-icon");

  // Initialize WebSocket
  const socket = new WebSocket("ws://localhost:9999/SWP391_GR6/chat");
  let userEmail = localStorage.getItem("userEmail") || "";
  let userRole = localStorage.getItem("userRole") || "guest";
  let broadcastChannel;

  // Get Session ID from Servlet
  fetch('/SWP391_GR6/getSessionId')
    .then(response => response.text())
    .then(sessionId => {
        console.log(sessionId);
      // Save sessionId in localStorage
      localStorage.setItem("sessionId", sessionId);
      // Check and restore chat if session matches
      console.log("checkSessionAndRestoreChat");
      checkSessionAndRestoreChat();
    })
    .catch(error => console.error('Error fetching Session ID:', error));

  function checkSessionAndRestoreChat() {

    const currentSessionId = localStorage.getItem("sessionId");
    const storedSessionId = localStorage.getItem("currentSessionId");
console.log("currentSessionId: " + currentSessionId);
      console.log("storedSessionId: " + storedSessionId);
    if (storedSessionId && storedSessionId === currentSessionId) {
        console.log("recover: ");
      // Session IDs match: show previous chat if user info was submitted
      if (localStorage.getItem("userInfoSubmitted") === "true") {
        infoForm.style.display = "none";
        chatBox.style.display = "block";
        chatIcon.style.display = "none";
        restoreMessages(userEmail);
        // Initialize Broadcast Channel
        broadcastChannel = new BroadcastChannel(`chat_${userEmail}`);
        broadcastChannel.onmessage = function (event) {
          const { message, senderEmail } = event.data;
          displayMessage(message, senderEmail);
        };
      }
    } else {
      // Session ID mismatch or not present, clear old data
      console.log("action delete user");
      console.log("email local storage: " + localStorage.getItem("userEmail"));
      console.log("userInfoSubmitted: " + localStorage.getItem()("userInfoSubmitted"));
      localStorage.removeItem("userInfoSubmitted");
    socket.send(JSON.stringify({
        action: "deleteUser",
        email: localStorage.getItem("userEmail")
    }));
    
      
      localStorage.removeItem("chatMessages");
      
      localStorage.removeItem("userFullName");
      localStorage.removeItem("userEmail");
      localStorage.removeItem("userRole");
      localStorage.setItem("currentSessionId", currentSessionId);
      // Show info form only
      infoForm.style.display = "none";
      chatBox.style.display = "none";
      chatIcon.style.display = "flex";

    }
  }

  socket.onopen = function () {
    console.log("WebSocket Connected.");
    if (localStorage.getItem("userInfoSubmitted") === "true") {
      const userInfo = {
        action: "userInfo",
        fullName: localStorage.getItem("userFullName"),
        email: localStorage.getItem("userEmail"),
        role: "guest"
      };
      socket.send(JSON.stringify(userInfo));
      console.log("Re-sent user info after refresh:", userInfo);
    }
  };

  socket.onmessage = function (event) {
    const data = JSON.parse(event.data);
    if (data.action === "sendMessage") {
      const message = data.message;
      const senderEmail = data.senderEmail;
      console.log("Received message from: " + senderEmail + ", Message: " + message);
      displayMessage(message, senderEmail);
      saveMessageToStorage(message, senderEmail);
    }
  };

  socket.onclose = function () {
    console.log("WebSocket Disconnected.");
  };

  socket.onerror = function (error) {
    console.log("WebSocket Error: " + error);
  };

  chatIcon.addEventListener("click", function () {
    console.log("Chat icon clicked!");
    if (localStorage.getItem("userInfoSubmitted") === "true") {
      chatBox.style.display = "block";
    } else {
      infoForm.style.display = "block";
    }
    chatIcon.style.display = "none";
  });

  document.getElementById("close-btn")?.addEventListener("click", function () {
    infoForm.style.display = "none";
    chatIcon.style.display = "flex";
  });

  document.getElementById("submit-info")?.addEventListener("click", function () {
    const fullName = document.getElementById("fullName").value.trim();
    const email = document.getElementById("email-1").value.trim();

    if (fullName === "" || email === "") {
      alert("Vui lòng nhập đầy đủ thông tin!");
      return;
    }

    const userInfo = { action: "userInfo", fullName: fullName, email: email, role: "guest" };
    socket.send(JSON.stringify(userInfo));
    console.log("Sent user info:", userInfo);

    // Save current Session ID when submitting form
    localStorage.setItem("currentSessionId", localStorage.getItem("sessionId"));
    localStorage.setItem("userInfoSubmitted", "true");
    localStorage.setItem("userFullName", fullName);
    localStorage.setItem("userEmail", email);
    localStorage.setItem("userRole", "guest");
    userEmail = email;

    // Create Broadcast Channel
    broadcastChannel = new BroadcastChannel(`chat_${email}`);
    broadcastChannel.onmessage = function (event) {
      const { message, senderEmail } = event.data;
      displayMessage(message, senderEmail);
    };

    infoForm.style.display = "none";
    chatBox.style.display = "block";
  });

  document.getElementById("toggle-chat").addEventListener("click", function () {
    chatBox.style.display = "none";
    chatIcon.style.display = "flex";
  });

  function sendMessage() {
    const inputField = document.querySelector(".chat-footer input");
    const message = inputField.value.trim();
    const email = localStorage.getItem("userEmail") || document.getElementById("email-1")?.value.trim();
    const fullName = localStorage.getItem("userFullName") || document.getElementById("fullName")?.value.trim();

    if (message !== "") {
      const messageData = {
        action: "sendMessage",
        message: message,
        email: email,
        fullName: fullName,
        receiverEmail: ""
      };
      socket.send(JSON.stringify(messageData));
      console.log("Message sent: " + JSON.stringify(messageData));

      if (broadcastChannel) {
        broadcastChannel.postMessage({ message, senderEmail: email });
      }

      displayMessage(message, email);
      saveMessageToStorage(message, email);
      inputField.value = "";
    }
  }

  document.querySelector(".chat-footer button").addEventListener("click", sendMessage);
  document.querySelector(".chat-footer input").addEventListener("keypress", function (event) {
    if (event.key === "Enter") {
      sendMessage();
    }
  });

  function displayMessage(message, senderEmail) {
    const chatBody = document.querySelector(".chat-messages");
    const messageElement = document.createElement("div");
    messageElement.classList.add("message");

    if (senderEmail === userEmail) {
      messageElement.classList.add("sent");
      messageElement.innerHTML = `<p>` + message + `</p>`;
    } else {
      messageElement.classList.add("received");
      messageElement.innerHTML = `
        <img src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-chat/ava3-bg.webp" 
             alt="avatar" class="me-3 rounded-circle d-flex align-self-center shadow-1-strong" width="40">
        <p>` + message + `</p>
      `;
    }

    chatBody.appendChild(messageElement);
    chatBody.scrollTop = chatBody.scrollHeight;
  }

  function saveMessageToStorage(message, senderEmail) {
    let messages = JSON.parse(localStorage.getItem("chatMessages")) || [];
    messages.push({ message, senderEmail });
    localStorage.setItem("chatMessages", JSON.stringify(messages));
  }

  function restoreMessages(userEmail) {
    const chatBody = document.querySelector(".chat-messages");
    let messages = JSON.parse(localStorage.getItem("chatMessages")) || [];
    messages.forEach((msg) => {
      const messageElement = document.createElement("div");
      messageElement.classList.add("message");

      if (msg.senderEmail === userEmail) {
        messageElement.classList.add("sent");
        messageElement.innerHTML = `<p>` + msg.message + `</p>`;
      } else {
        messageElement.classList.add("received");
        messageElement.innerHTML = `
          <img src="https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-chat/ava3-bg.webp" 
               alt="avatar" class="me-3 rounded-circle d-flex align-self-center shadow-1-strong" width="40">
          <p>` + msg.message + `</p>
        `;
      }
      chatBody.appendChild(messageElement);
    });
    chatBody.scrollTop = chatBody.scrollHeight;
  }
});
