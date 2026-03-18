<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String message = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Load MySQL Driver
            Class.forName("com.mysql.jdbc.Driver");

            // Create Database Connection
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hydrokart",
                "root",
                "root123"
            );

            // SQL Query
            String sql = "SELECT * FROM admin WHERE username=? AND password=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);

            rs = ps.executeQuery();

            if (rs.next()) {
                session.setAttribute("admin", username);
                response.sendRedirect("admin_login.jsp");
                return;
            } else {
                message = "Invalid Username or Password";
            }

        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        } finally {
            try { if (rs != null) rs.close(); } catch(Exception e){}
            try { if (ps != null) ps.close(); } catch(Exception e){}
            try { if (conn != null) conn.close(); } catch(Exception e){}
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Login - Hydrokart</title>
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
    .use {
        font-size: 20px;
        color: white;
    }
    .navbar li:hover {
        background-color: silver;
    }
    ul li ul.dropdown {
        background: #f2f2f2;
        color: black;
        display: none;
        padding: 0px;
        position: absolute;
        z-index: 999;
    }
    ul li:hover ul.dropdown {
        display: block;
    }
    ul li ul.dropdown li {
        display: block;
    }
    a {
        cursor: pointer;
    }
</style>
</head>

<body>

<!-- NAVBAR (UNCHANGED) -->
<nav class="navbar navbar-expand-lg navbar-light" style="background-color:#1159B7;">
    <img src="hydro.jpeg" height="80px" width="120px" style="border-radius: 20px; margin-left: 20px;">
    <div class="container">

        <h1 style="text-align:center; margin-top:20px; margin-bottom:20px; font-style:italic;">
            <b>Hydrokart - Packaged <br> Drinking Water Supply System</b>
        </h1>

        <div class="collapse navbar-collapse">
            <ul class="navbar-nav mr-auto ml-5">
                <li class="nav-item">
                    <a class="nav-link ml-2 active" style="font-size:22px; color:white;" href="index.jsp">Home</a>
                </li>
                <li>
                    <a class="nav-link ml-2" style="font-size:22px; color:white;">Login</a>
                    <ul class="dropdown" style="list-style-type:none;">
                        <li><a class="nav-link ml-2" style="font-size:22px; color:black;" href="login.jsp">As User</a></li>
                        <li><a class="nav-link ml-2" style="font-size:22px; color:black;" href="admin.jsp">As Admin</a></li>
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

<!-- ADMIN LOGIN FORM -->
<div class="container">
    <form method="post" style="width:350px;margin:80px auto;">
        <h3 style="text-align:center;">Admin Login</h3>

        <input type="text" name="username" placeholder="Username" class="form-control mb-3" required>
        <input type="password" name="password" placeholder="Password" class="form-control mb-3" required>

        <button type="submit" class="btn btn-primary btn-block">Login</button>

        <% if (message != null) { %>
            <p style="color:red;text-align:center;margin-top:10px;">
                <%= message %>
            </p>
        <% } %>
    </form>
</div>

<!-- FOOTER (UNCHANGED) -->
<footer>
    <div style="text-align:center;">© 2025 HYDROKART All Rights Reserved</div>
</footer>

</body>
</html>