<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
String admin = (String) session.getAttribute("admin");
if(admin == null){
    response.sendRedirect("admin.jsp");
    return;
}

String message = "";
boolean success = false;

if(request.getMethod().equalsIgnoreCase("POST")){
    String name = request.getParameter("name");
    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String contact = request.getParameter("contact");
    String address = request.getParameter("address");
    String password = request.getParameter("password");

    try{
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/hydrokart","root","root123");

        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO logreg(name, username, email, contact, address, password, blocked) VALUES(?,?,?,?,?,?,0)");

        ps.setString(1,name);
        ps.setString(2,username);
        ps.setString(3,email);
        ps.setString(4,contact);
        ps.setString(5,address);
        ps.setString(6,password);

        int i = ps.executeUpdate();
        if(i>0){
            message="Client added successfully!";
            success=true;
        }else{
            message="Failed to add client!";
        }

        ps.close();
        con.close();

    }catch(Exception e){
        message="Error: "+e.getMessage();
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Add Client - Hydrokart</title>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">

<style>
body{
    background:#ADD8E6;
    min-height:100vh;
    display:flex;
    flex-direction:column;
}

.admin-container{ display:flex; flex:1; }

.sidebar{
    width:240px;
    background:#1c3b70;
    color:white;
    padding-top:20px;
}

.sidebar a{
    display:block;
    padding:14px 20px;
    color:white;
    text-decoration:none;
    font-size:16px;
}

.sidebar a:hover{ background:#1159B7; }

.main-content{ flex:1; padding:30px; }

.card-box{
    background:white;
    padding:25px;
    border-radius:12px;
    box-shadow:0 0 10px #999;
}

.logout-btn{
    background:white;
    color:#1159B7 !important;
    padding:8px 18px;
    border-radius:20px;
    font-weight:bold;
}

.logout-btn:hover{
    background:#ff4d4d;
    color:white !important;
}

footer{
    background:#1c3b70;
    color:white;
    text-align:center;
    padding:15px 0;
}
</style>

</head>

<body>

<!-- HEADER (UNCHANGED) -->
<nav class="navbar navbar-expand-lg navbar-light" style="background-color:#1159B7;">
    <img src="hydro.jpeg" height="80" width="120"
         style="border-radius:20px; margin-left:20px;">

    <div class="container">
        <h1 style="text-align:center; margin-top:20px; margin-bottom:20px; font-style:italic;">
            <b>Hydrokart - Packaged <br> Drinking Water Supply System</b>
        </h1>

        <a href="logout.jsp" class="logout-btn ml-auto">Logout</a>
    </div>
</nav>

<!-- DASHBOARD -->
<div class="admin-container">

    <!-- SIDEBAR -->
    <div class="sidebar">
        <a href="admin_login.jsp">Dashboard</a>
        <a href="admin_orders.jsp">Orders</a>
        <a href="admin_clients.jsp">Registered Clients</a>
        <a href="admin_add_client.jsp"><b>Add Clients</b></a>
        <a href="admin_sales.jsp">Sales Graph</a>
        <a href="admin_invoice.jsp">Invoices</a>
        <a href="admin_ecocredit.jsp">Ecocredit</a>
        <a href="admin_feedback.jsp">Feedback</a>
       
    </div>

    <!-- CONTENT -->
    <div class="main-content">
        <h3>Add New Client</h3>
        <hr>

        <% if(!message.isEmpty()){ %>
            <div class="alert <%= success ? "alert-success" : "alert-danger" %>">
                <%= message %>
            </div>
        <% } %>

        <div class="card-box">

            <form method="post">

                <div class="form-group">
                    <label>Name</label>
                    <input type="text" name="name" class="form-control" required>
                </div>

                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" class="form-control" required>
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control" required>
                </div>

                <div class="form-group">
                    <label>Contact</label>
                    <input type="text" name="contact" class="form-control" required>
                </div>

                <div class="form-group">
                    <label>Address</label>
                    <textarea name="address" class="form-control" rows="3" required></textarea>
                </div>

                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" required>
                </div>

                <button type="submit" class="btn btn-primary">Add Client</button>
                <a href="admin_clients.jsp" class="btn btn-secondary">Back</a>

            </form>

        </div>
    </div>
</div>

<!-- FOOTER (UNCHANGED) -->
<footer>
    © 2025 HYDROKART | All Rights Reserved
</footer>

</body>
</html>