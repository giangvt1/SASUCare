<%-- 
    Document   : postDetail
    Created on : Mar 17, 2025, 8:19:02 PM
    Author     : admin
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f8f9fa;
                margin: 0;
                padding: 0;
            }

            .right-side {
                display: flex;
                justify-content: center;
                padding: 20px;
            }

            .main-content {
                width: 80%;
                background-color: #ffffff;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            }

            h3 {
                font-size: 24px;
                margin-bottom: 20px;
                color: #333;
                text-align: center;
            }

            .post-detail {
                margin-bottom: 20px;
            }

            p {
                font-size: 16px;
                line-height: 1.5;
                color: #555;
            }

            strong {
                color: #333;
            }

            .post-detail img {
                max-width: 100%;
                margin-top: 20px;
                border-radius: 8px;
                box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            }

            .btn {
                display: inline-block;
                padding: 10px 20px;
                margin-top: 20px;
                background-color: #007bff;
                color: #fff;
                text-decoration: none;
                border-radius: 4px;
                font-size: 16px;
                transition: background-color 0.3s;
            }

            .btn:hover {
                background-color: #0056b3;
            }

            .btn-primary {
                text-align: center;
                display: inline-block;
                margin: 0 auto;
            }
        </style>
    </head>
    <body>
        
        <div class="right-side">
            <div class="main-content">

                <c:if test="${not empty post}">
                    <div class="post-detail">
                        <h3>${post.title}</h3>
                        <p><strong>Author:</strong> ${post.staffName}</p>
                        
                        <p><strong>Created At:</strong> <fmt:formatDate value="${post.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
                        
                        <p><strong>Content:</strong></p>
                        <p>${post.content}</p>

                        <c:if test="${not empty post.image}">
                            <img src="${pageContext.request.contextPath}/${post.image}" alt="Post Image" />
                        </c:if>
                    </div>
                </c:if>

                <a href="${pageContext.request.contextPath}/posts" class="btn btn-primary">Back to Post List</a>
            </div> <!-- Close .main-content -->
        </div> <!-- Close .right-side -->
    </body>
</html>

