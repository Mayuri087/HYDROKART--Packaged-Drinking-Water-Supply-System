<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
String loginStatus = "";

if ("POST".equalsIgnoreCase(request.getMethod())) {

    String username = request.getParameter("username").trim();
    String password = request.getParameter("password").trim();

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/hydrokart",
            "root",
            "root123"   // change if needed
        );

        String sql = "SELECT * FROM logreg WHERE BINARY username=? AND BINARY password=?";
        ps = con.prepareStatement(sql);
        ps.setString(1, username);
        ps.setString(2, password);

        rs = ps.executeQuery();

        if (rs.next()) {
            session.setAttribute("username", username);
            loginStatus = "success";
        } else {
            loginStatus = "error";
        }

    } catch (Exception e) {
        loginStatus = "error";
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>User Login / Registration - Hydrokart</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

<style type="text/css">
    body {
        background-color: #ADD8E6;
        color: black; 
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
    .navbar li:hover { background-color: silver; }
    ul li ul.dropdown {
        background: #f2f2f2;
        color: black;
        display: none;
        padding: 0px;
        position: absolute;
        z-index: 999;
    }
    ul li:hover ul.dropdown { display: block; }
    ul li ul.dropdown li { display: block; }
    a { cursor: pointer; }
    .form-container {
        display: flex;
        justify-content: space-around;
        flex-wrap: wrap;
        margin: 50px auto;
    }
    .form-box {
        background-color: white;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0px 0px 10px #999;
        margin: 20px;
        width: 350px;
        color: black;
    }
</style>

<script>
<% if ("success".equals(loginStatus)) { %>
    alert("Login Successful!");
    window.location = "user_dashboard.jsp";
<% } %>
</script>

</head>
<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-light" style="background-color:#1159B7;">
    <img src="hydro.jpeg" height="80px" width="120px" style="border-radius: 20px; margin-left: 20px;">
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
                    <a class="nav-link ml-2 active" style="font-size:22px; color:white;" href="index.jsp">Home</a>
                </li>
                <li>
                    <a class="nav-link ml-2" style="font-size:22px; color:white;" href="#">Login</a>
                    <ul class="dropdown" style="list-style-type:none;">
                        <li class="nav-item">
                            <a class="nav-link ml-2" style="font-size:22px; color:black;" href="login.jsp">As User</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ml-2" style="font-size:22px; color:black;" href="admin.jsp">As Admin</a>
                        </li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link ml-2" style="font-size:22px; color:white;" href="index.jsp#aboutus">About Us</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ml-2" style="font-size:22px; color:white;" href="index.jsp#contactus">Contact Us</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- LOGIN FORM -->
<div class="form-container">
    <div class="form-box">
        <h3 style="text-align:center;">User Login</h3>
        <form method="post">
            <input type="text" name="username" placeholder="Username" class="form-control mb-3" required>
            <input type="password" name="password" placeholder="Password" class="form-control mb-3" required>
            <button type="submit" class="btn btn-primary btn-block">Login</button>

            <% if ("error".equals(loginStatus)) { %>
                <p style="color:red;text-align:center;margin-top:10px;">
                    Invalid Username or Password
                </p>
            <% } %>
        </form>

        <p style="text-align:center; margin-top:10px;">
            Not registered?
            <a href="registration.jsp" style="color:blue; font-weight:bold;">Register from here</a>
        </p>
    </div>
</div>

<!-- FOOTER -->
<footer>
    <div style="text-align:center;">© 2025 HYDROKART All Rights Reserved</div>
</footer>

</body>
</html>