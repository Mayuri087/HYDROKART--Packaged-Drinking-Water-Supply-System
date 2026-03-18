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

    // SAFE LOGIN TIME FETCH
    Object loginTimeObj = session.getAttribute("loginTime");
    String loginTime = (loginTimeObj != null) ? loginTimeObj.toString() : "N/A";

    // USER DETAILS
    String name="", contact="", email="", address="";

    try{
        PreparedStatement ps = conn.prepareStatement(
            "SELECT name, contact, email, address FROM logreg WHERE username=?"
        );
        ps.setString(1, username);

        ResultSet rs = ps.executeQuery();

        if(rs.next()){
            name = rs.getString("name");
            contact = rs.getString("contact");
            email = rs.getString("email");
            address = rs.getString("address");
        }

        rs.close();
        ps.close();
    }catch(Exception e){
        out.println("<p style='color:red;text-align:center;'>Database Error: "+e.getMessage()+"</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Profile - Hydrokart</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

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
        .profile-box {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px #999;
        }
        .profile-item {
            margin-bottom: 15px;
            font-size: 17px;
        }
        .profile-label {
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

<!-- PROFILE -->
<div class="profile-box">
    <h3 class="text-center mb-4">My Profile</h3>

    <div class="profile-item">
        <span class="profile-label">Full Name:</span> <%= name %>
    </div>

    <div class="profile-item">
        <span class="profile-label">Username:</span> <%= username %>
    </div>

    <div class="profile-item">
        <span class="profile-label">Contact:</span> <%= contact %>
    </div>

    <div class="profile-item">
        <span class="profile-label">Email:</span> <%= email %>
    </div>

    <div class="profile-item">
        <span class="profile-label">Address:</span> <%= address %>
    </div>

    

    <div class="text-center mt-4">
        <button class="btn btn-secondary"
                onclick="window.location.href='user_dashboard.jsp'">
            Back to Dashboard
        </button>
    </div>
</div>

<!-- FOOTER -->
<footer>
    © 2025 HYDROKART All Rights Reserved
</footer>

</body>
</html>