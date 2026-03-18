<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconfig.jsp" %>

<%
    String adminUser = (String) session.getAttribute("adminUser");
    if(adminUser == null){
        response.sendRedirect("admin_login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin Dashboard - HydroKart</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">

<style>
body{
    background:#f5f5f5;
}
.sidebar{
    height:100vh;
    background:#111;
    color:white;
    padding-top:20px;
}
.sidebar a{
    display:block;
    padding:10px;
    color:white;
    text-decoration:none;
}
.sidebar a:hover{
    background:#444;
}
</style>
</head>

<body>

<!-- TOP NAVBAR -->
<nav class="navbar navbar-dark bg-primary">
    <span class="navbar-brand">Water Supply</span>
    <span style="color:white;">
        👤 <%= adminUser %>
        <a href="admin_logout.jsp" class="btn btn-danger btn-sm ml-3">Logout</a>
    </span>
</nav>

<div class="container-fluid">
<div class="row">

<!-- LEFT SIDEBAR -->
<div class="col-md-2 sidebar">
    <h5 class="text-center">Dashboard</h5>
    <a href="admin_dashboard.jsp">Orders</a>
    <a href="#">Registered Client</a>
    <a href="#">Add Client</a>
    <a href="#">About Us</a>
    <a href="#">Contact</a>
</div>

<!-- MAIN CONTENT -->
<div class="col-md-10 mt-4">
    <h3 class="text-center">Admin Panel</h3>

    <h5 class="mt-4">Order Details</h5>

    <table class="table table-bordered table-striped">
        <thead class="thead-dark">
            <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Address</th>
                <th>Quantity</th>
                <th>Payment</th>
                <th>Water Type</th>
                <th>Transaction ID</th>
                <th>Status</th>
            </tr>
        </thead>

        <tbody>
        <%
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM orders");

            while(rs.next()){
        %>
            <tr>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getString("email") %></td>
                <td><%= rs.getString("phone") %></td>
                <td><%= rs.getString("address") %></td>
                <td><%= rs.getInt("quantity") %></td>
                <td><%= rs.getString("payment_method") %></td>
                <td><%= rs.getString("water_type") %></td>
                <td><%= rs.getString("transaction_id") %></td>
                <td>
                    <span class="badge badge-success">Delivered</span>
                </td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>

</div>
</div>
</div>

</body>
</html>