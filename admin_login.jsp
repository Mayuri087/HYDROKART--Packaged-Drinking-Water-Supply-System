<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
String admin = (String) session.getAttribute("admin");
if(admin == null){
    response.sendRedirect("admin.jsp");
    return;
}

int totalUsers=0, totalOrders=0, pendingOrders=0,
    approvedOrders=0, deliveredOrders=0, cancelledOrders=0;

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/hydrokart","root","root123");

    ps = con.prepareStatement("SELECT COUNT(*) FROM logreg");
    rs = ps.executeQuery(); if(rs.next()) totalUsers = rs.getInt(1);

    ps = con.prepareStatement("SELECT COUNT(*) FROM orders");
    rs = ps.executeQuery(); if(rs.next()) totalOrders = rs.getInt(1);

    ps = con.prepareStatement("SELECT COUNT(*) FROM orders WHERE status='Pending'");
    rs = ps.executeQuery(); if(rs.next()) pendingOrders = rs.getInt(1);

    ps = con.prepareStatement("SELECT COUNT(*) FROM orders WHERE status='Approved'");
    rs = ps.executeQuery(); if(rs.next()) approvedOrders = rs.getInt(1);

    ps = con.prepareStatement("SELECT COUNT(*) FROM orders WHERE status='Delivered'");
    rs = ps.executeQuery(); if(rs.next()) deliveredOrders = rs.getInt(1);

    ps = con.prepareStatement("SELECT COUNT(*) FROM orders WHERE status='Cancelled'");
    rs = ps.executeQuery(); if(rs.next()) cancelledOrders = rs.getInt(1);

}catch(Exception e){
    e.printStackTrace();
}finally{
    try{ if(rs!=null)rs.close(); }catch(Exception e){}
    try{ if(ps!=null)ps.close(); }catch(Exception e){}
    try{ if(con!=null)con.close(); }catch(Exception e){}
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin Dashboard - Hydrokart</title>
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
    text-align:center;
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

<script>
window.onload = function(){
    if(!sessionStorage.getItem("adminPopup")){
        alert("Welcome Admin 👋\nHydrokart Admin Dashboard");
        sessionStorage.setItem("adminPopup","shown");
    }
}
</script>

</head>

<body>

<!-- HEADER (UNCHANGED) -->
<nav class="navbar navbar-expand-lg navbar-light" style="background-color:#1159B7;">
    <img src="hydro.jpeg" height="80px" width="120px"
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

    <!-- SIDEBAR (ONLY LINKS UPDATED) -->
    <div class="sidebar">
        <a href="admin_login.jsp"><b>Dashboard</b></a>
        <a href="admin_orders.jsp">Orders</a>
        <a href="admin_clients.jsp">Registered Clients</a>
        <a href="admin_add_client.jsp">Add Clients</a>
        <a href="admin_sales.jsp">Sales Graph</a>
        <a href="admin_invoice.jsp">Invoices</a>
        <a href="admin_ecocredit.jsp">Ecocredit</a>
        <a href="admin_feedback.jsp">Feedback</a>
       
    </div>

    <!-- CONTENT -->
    <div class="main-content">
        <h3>Welcome, <%= admin %></h3>
        <hr>

        <div class="row">

            <div class="col-md-4 mb-3">
                <div class="card-box">
                    <h5>Total Users</h5>
                    <h3><%= totalUsers %></h3>
                </div>
            </div>

            <div class="col-md-4 mb-3">
                <div class="card-box">
                    <h5>Total Orders</h5>
                    <h3><%= totalOrders %></h3>
                </div>
            </div>

            <div class="col-md-4 mb-3">
                <div class="card-box">
                    <h5>Pending Orders</h5>
                    <h3><%= pendingOrders %></h3>
                </div>
            </div>

            <div class="col-md-4 mb-3">
                <div class="card-box">
                    <h5>Approved Orders</h5>
                    <h3><%= approvedOrders %></h3>
                </div>
            </div>

            <div class="col-md-4 mb-3">
                <div class="card-box">
                    <h5>Delivered Orders</h5>
                    <h3><%= deliveredOrders %></h3>
                </div>
            </div>

            <div class="col-md-4 mb-3">
                <div class="card-box">
                    <h5>Cancelled Orders</h5>
                    <h3><%= cancelledOrders %></h3>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- FOOTER (UNCHANGED) -->
<footer>
    © 2025 HYDROKART | All Rights Reserved
</footer>

</body>
</html>