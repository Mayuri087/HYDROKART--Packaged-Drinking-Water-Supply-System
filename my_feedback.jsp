<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbconfig.jsp" %>

<%
    // SESSION CHECK
    String username = (String) session.getAttribute("username");
    if(username == null){
        response.sendRedirect("login.jsp");
        return;
    }

    String message = "";

    if(request.getMethod().equalsIgnoreCase("POST")){
        String feedback = request.getParameter("feedback");
        String ratingStr = request.getParameter("rating");

        if(feedback != null && ratingStr != null){
            try{
                int rating = Integer.parseInt(ratingStr);
                if(rating < 1 || rating > 5){
                    message = "Rating must be between 1 and 5.";
                } else {
                    PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO feedback(username, feedback, rating, feedback_date) VALUES(?,?,?,NOW())"
                    );
                    ps.setString(1, username);
                    ps.setString(2, feedback);
                    ps.setInt(3, rating);

                    int rows = ps.executeUpdate();
                    if(rows > 0){
                        message = "Thank you! Your feedback has been submitted.";
                    } else {
                        message = "Failed to submit feedback. Please try again.";
                    }

                    ps.close();
                }
            } catch(Exception e){
                message = "Error: " + e.getMessage();
            }
        } else {
            message = "Please provide both feedback and rating.";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Feedback - Hydrokart</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">

    <style>
        body {
            background-color: #ADD8E6;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        footer {
            border-top: 1px solid #0278BA;
            padding: 20px 0;
            width: 100%;
            text-align: center;
            background-color: #1c3b70;
            color: white;
            margin-top: auto;
        }
        .feedback-box {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px #999;
        }
        .feedback-item {
            margin-bottom: 15px;
            font-size: 17px;
        }
        .feedback-label {
            font-weight: bold;
        }
        .navbar li:hover { background-color: silver; }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-light" style="background-color:#1159B7;">
    <img src="hydro.jpeg" height="80px" width="120px"
         style="border-radius:20px; margin-left:20px;">

    <div class="container">
        <h1 style="text-align:center; margin-top:20px; margin-bottom:20px; font-style:italic;">
            <b>Hydrokart - Packaged <br> Drinking Water Supply System</b>
        </h1>

        <div class="collapse navbar-collapse">
            <ul class="navbar-nav mr-auto ml-5">
                <li class="nav-item">
                    <a class="nav-link ml-2" style="font-size:22px; color:white;" href="index.jsp">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ml-2" style="font-size:22px; color:white;" href="index.jsp#aboutus">About Us</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ml-2" style="font-size:22px; color:white;" href="index.jsp#contactus">Contact Us</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ml-2" style="font-size:22px; color:white;" href="logout.jsp">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- FEEDBACK FORM -->
<div class="feedback-box">
    <h3 class="text-center mb-4">📝 My Feedback</h3>

    <% if(!message.isEmpty()){ %>
        <div class="alert alert-info text-center"><%= message %></div>
    <% } %>

    <form method="post" action="my_feedback.jsp">
        <div class="feedback-item">
            <label class="feedback-label" for="feedback">Your Feedback:</label>
            <textarea class="form-control" id="feedback" name="feedback" rows="4" placeholder="Enter your feedback here..." required></textarea>
        </div>

        <div class="feedback-item">
            <label class="feedback-label" for="rating">Rate Our Service:</label>
            <select class="form-control" id="rating" name="rating" required>
                <option value="">Select Rating</option>
                <option value="1">1 - Very Poor</option>
                <option value="2">2 - Poor</option>
                <option value="3">3 - Good</option>
                <option value="4">4 - Very Good</option>
                <option value="5">5 - Excellent</option>
            </select>
        </div>

        <div class="text-center mt-4">
            <button type="submit" class="btn btn-primary">Submit Feedback</button>
            <button type="button" class="btn btn-secondary" onclick="window.location.href='user_dashboard.jsp'">Back to Dashboard</button>
        </div>
    </form>
</div>

<!-- FOOTER -->
<footer>
    © 2025 HYDROKART All Rights Reserved
</footer>

</body>
</html>