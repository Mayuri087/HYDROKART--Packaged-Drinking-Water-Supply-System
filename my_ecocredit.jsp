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

    int weeklyOrders = 0;
    boolean discountEligible = false;
    double totalEcoCredit = 0.0;

    try{
        /* COUNT ORDERS IN CURRENT WEEK */
        PreparedStatement psCount = conn.prepareStatement(
            "SELECT COUNT(*) FROM orders WHERE username=? " +
            "AND YEARWEEK(order_date,1)=YEARWEEK(NOW(),1)"
        );
        psCount.setString(1, username);

        ResultSet rsCount = psCount.executeQuery();
        if(rsCount.next()){
            weeklyOrders = rsCount.getInt(1);
        }

        if(weeklyOrders >= 5){
            discountEligible = true;
        }

        rsCount.close();
        psCount.close();

        /* CALCULATE ECO CREDIT AFTER 5 ORDERS (JAVA LOGIC – SAFE) */
        PreparedStatement psAll = conn.prepareStatement(
            "SELECT quantity FROM orders WHERE username=? " +
            "AND YEARWEEK(order_date,1)=YEARWEEK(NOW(),1) " +
            "ORDER BY order_date"
        );
        psAll.setString(1, username);

        ResultSet rsAll = psAll.executeQuery();

        int count = 0;
        while(rsAll.next()){
            count++;
            if(count > 5){   // AFTER 5 ORDERS
                int qty = rsAll.getInt("quantity");
                totalEcoCredit += qty * 20 * 0.10; // 10% discount
            }
        }

        rsAll.close();
        psAll.close();

        // -----------------------------
        // INSERT OR UPDATE admin_ecocredit
        // -----------------------------
        java.text.SimpleDateFormat sdfWeek = new java.text.SimpleDateFormat("YYYY-ww");
        String weekYear = sdfWeek.format(new java.util.Date());

        PreparedStatement psInsert = conn.prepareStatement(
            "INSERT INTO admin_ecocredit(username, week_year, weekly_orders, total_ecocredit, created_at) " +
            "VALUES (?, ?, ?, ?, NOW()) " +
            "ON DUPLICATE KEY UPDATE weekly_orders=?, total_ecocredit=?, created_at=NOW()"
        );
        psInsert.setString(1, username);
        psInsert.setString(2, weekYear);
        psInsert.setInt(3, weeklyOrders);
        psInsert.setDouble(4, totalEcoCredit);
        psInsert.setInt(5, weeklyOrders);
        psInsert.setDouble(6, totalEcoCredit);

        psInsert.executeUpdate();
        psInsert.close();

    }catch(Exception e){
        out.println("<p style='color:red;text-align:center;'>Database Error: "+e.getMessage()+"</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Eco Credit - Hydrokart</title>
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

<!-- ECO CREDIT CARD -->
<div class="profile-box">
    <h3 class="text-center mb-4">🌱 My Eco Credit</h3>

    <div class="profile-item">
        <span class="profile-label">Username:</span> <%= username %>
    </div>

    <div class="profile-item">
        <span class="profile-label">Orders This Week:</span> <%= weeklyOrders %>
    </div>

    <div class="profile-item">
        <span class="profile-label">Eco Credit Status:</span>
        <%= discountEligible ? "Eligible 🎉" : "Not Eligible" %>
    </div>

    <div class="profile-item">
        <span class="profile-label">Eco Credit Benefit:</span>
        <%= discountEligible 
            ? "10% OFF on all remaining orders this week" 
            : "Complete 5 orders in a week to unlock Eco Credit" %>
    </div>

    <div class="profile-item">
        <span class="profile-label">Total Eco Credit Earned:</span>
        &#8377; <%= String.format("%.2f", totalEcoCredit) %>
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