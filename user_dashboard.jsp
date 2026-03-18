<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>User Dashboard - Hydrokart</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">

    <style>
        body {
            background-color: #ADD8E6;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .dashboard-box {
            background-color: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0px 0px 12px #999;
            width: 420px;
            margin: 60px auto;
            text-align: center;
        }

        .dashboard-box a {
            margin: 10px 0;
        }

        footer {
            margin-top: auto;
            background-color: #1c3b70;
            color: white;
            text-align: center;
            padding: 15px 0;
        }
    </style>
</head>

<body>

<!-- NAVBAR (UNCHANGED) -->
<nav class="navbar navbar-expand-lg navbar-light" style="background-color:#1159B7;">
    <img src="hydro.jpeg" height="80px" width="120px"
         style="border-radius:20px; margin-left:20px;">

    <div class="container">

        <button class="navbar-toggler" type="button" data-toggle="collapse"
                data-target="#navbarTogglerDemo01">
            <span class="navbar-toggler-icon"></span>
        </button>

        <h1 style="text-align:center; margin-top:20px; margin-bottom:20px; font-style:italic;">
            <b>Hydrokart - Packaged <br> Drinking Water Supply System</b>
        </h1>

        <div class="collapse navbar-collapse" id="navbarTogglerDemo01">
            <ul class="navbar-nav mr-auto mt-2 mt-lg-0 ml-5">
                <li class="nav-item">
                    <a class="nav-link ml-2 active"
                       style="font-size:22px; color:white;"
                       href="index.jsp">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ml-2"
                       style="font-size:22px; color:white;"
                       href="index.jsp#aboutus">About Us</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ml-2"
                       style="font-size:22px; color:white;"
                       href="index.jsp#contactus">Contact Us</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ml-2"
                       style="font-size:22px; color:white;"
                       href="logout.jsp">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- USER DASHBOARD -->
<div class="dashboard-box">
    <h3>Welcome, <%= username %> 👋</h3>
    <hr>

    <a href="place_order.jsp" class="btn btn-primary btn-block">🛒 Place Order</a>
    <a href="order_history.jsp" class="btn btn-success btn-block">📦 Order History</a>
    <a href="my_profile.jsp" class="btn btn-info btn-block">👤 My Profile</a>
    <a href="my_ecocredit.jsp" class="btn btn-info btn-block">💧 Ecocredit </a>
    <a href="my_feedback.jsp" class="btn btn-info btn-block">💬 Feedback</a>
</div>

<!-- FOOTER -->
<footer>
    © 2025 HYDROKART | All Rights Reserved
</footer>

</body>
</html>