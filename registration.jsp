<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbconfig.jsp" %>

<%
    String successMsg = null;
    String errorMsg = null;

    if(request.getMethod().equalsIgnoreCase("POST")){

        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String contact = request.getParameter("contact");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        if(name!=null && username!=null && password!=null &&
           contact!=null && email!=null && address!=null){

            try{
                // CHECK USER EXISTS
                PreparedStatement check = conn.prepareStatement(
                    "SELECT * FROM logreg WHERE username=? OR email=?"
                );
                check.setString(1, username);
                check.setString(2, email);
                ResultSet rs = check.executeQuery();

                if(rs.next()){
                    errorMsg = "Username or Email already exists!";
                }else{
                    // INSERT USER = conn.prepareStatement(
                    PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO logreg(name, username, password, contact, email, address) VALUES (?,?,?,?,?,?)"
                    );
                    ps.setString(1, name);
                    ps.setString(2, username);
                    ps.setString(3, password);
                    ps.setString(4, contact);
                    ps.setString(5, email);
                    ps.setString(6, address);

                    int i = ps.executeUpdate();

                    if(i > 0){
                        successMsg = "Registration Successful! Redirecting to login...";
                        response.setHeader("Refresh", "2;URL=login.jsp");
                    }else{
                        errorMsg = "Registration Failed. Try again!";
                    }
                }
            }catch(Exception e){
                errorMsg = "Error: " + e.getMessage();
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>User Registration - Hydrokart</title>
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
        background: #f2f2f2; color: black; display: none; padding: 0; position: absolute; z-index: 999;
    }
    ul li:hover ul.dropdown { display: block; }
    ul li ul.dropdown li { display: block; }
    a { cursor: pointer; }
    .form-container { display: flex; justify-content: center; flex-wrap: wrap; margin: 50px auto; }
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
</head>

<body>

<!-- NAVBAR -->
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
                        <li><a class="nav-link ml-2" style="font-size:22px; color:black;" href="user_login_register.jsp">As User</a></li>
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

<!-- USER REGISTRATION FORM -->
<div class="form-container">
    <div class="form-box">
        <h3 style="text-align:center;">New User Registration</h3>

        <form method="post">
            <input type="text" name="name" placeholder="Full Name" class="form-control mb-3" required>
            <input type="text" name="username" placeholder="Username" class="form-control mb-3" required>
            <input type="password" name="password" placeholder="Password" class="form-control mb-3" required>
            <input type="text" name="contact" placeholder="Contact No" class="form-control mb-3" required>
            <input type="email" name="email" placeholder="Email" class="form-control mb-3" required>
            <textarea name="address" placeholder="Address" class="form-control mb-3" rows="3" required></textarea>

            <button type="submit" class="btn btn-success btn-block">Register</button>

            <% if(errorMsg != null){ %>
                <p style="color:red;text-align:center;margin-top:10px;">
                    <%= errorMsg %>
                </p>
            <% } %>

            <% if(successMsg != null){ %>
                <p style="color:green;text-align:center;margin-top:10px;">
                    <%= successMsg %>
                </p>
            <% } %>
        </form>

        <p style="text-align:center; margin-top:10px;">
            Already registered?
            <a href="login.jsp" style="color:blue; font-weight:bold;">Login here</a>
        </p>
    </div>
</div>

<!-- FOOTER -->
<footer>
    <div style="text-align:center;">© 2025 HYDROKART All Rights Reserved</div>
</footer>

</body>
</html>