<%-- 
    Document   : ring
    Created on : Mar 24, 2025, 10:52:24 PM
    Author     : Golden  Lightning
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        
        <button type="button" onclick="openDepartmentModal()">Select Departments</button>
        <script>
            var socket = new WebSocket("ws://localhost:9999/SWP391_GR6/notification");
            
            socket.onopen = function(){
                console.log('hello');
            }
            
            socket.onmessage = function(){
                console.log('client');
            }
            
            socket.onclose = function(){
                console.log('not close');
            }
            
            function openDepartmentModal(){
                socket.send(JSON.stringify({
                        action: "sendData",
                        doctor: "2hi",
                        userEmail: 'bu khu'
                    }));
                
                
                
                console.log('helllllllll');
            }
        </script>
    </body>
</html>
