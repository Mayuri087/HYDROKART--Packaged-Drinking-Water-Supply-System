<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
String admin = (String) session.getAttribute("admin");
if(admin == null){
    response.sendRedirect("admin.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Orders - Hydrokart</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
    <style>
        body{ background:#ADD8E6; min-height:100vh; }
        .sidebar{ width:240px; background:#1c3b70; color:white; padding-top:20px; position:fixed; height:100%; }
        .sidebar a{ display:block; padding:14px 20px; color:white; text-decoration:none; font-size:16px; }
        .sidebar a:hover{ background:#1159B7; }
        .main-content{ margin-left:260px; padding:30px; }
        .btn{ margin:2px; }
        footer{ background:#1c3b70; color:white; text-align:center; padding:15px 0; position:fixed; bottom:0; width:100%; }
    </style>
</head>
<body>

<!-- HEADER -->
<nav class="navbar navbar-expand-lg navbar-light" style="background-color:#1159B7;">
    <img src="hydro.jpeg" height="80px" width="120px" style="border-radius:20px; margin-left:20px;">
    <div class="container">
        <h1 style="text-align:center; margin:20px 0; font-style:italic;">
            <b>Hydrokart - Packaged <br> Drinking Water Supply System</b>
        </h1>
        <a href="logout.jsp" class="btn btn-light ml-auto">Logout</a>
    </div>
</nav>

<!-- SIDEBAR -->
<div class="sidebar">
    <a href="admin_login.jsp"><b>Dashboard</b></a>
    <a href="admin_orders.jsp">Orders</a>
    <a href="admin_clients.jsp">Registered Clients</a>
    <a href="admin_add_client.jsp">Add Client</a>
    <a href="admin_sales.jsp">Sales Graph</a>
    <a href="admin_invoice.jsp">Invoices</a>
    <a href="admin_ecocredit.jsp">Ecocredit</a>
    <a href="admin_feedback.jsp">Feedback</a>    
   
</div>

<!-- MAIN CONTENT -->
<div class="main-content">
    <h3>Orders Management</h3>
    <hr>

    <table class="table table-bordered table-striped">
        <thead>
            <tr>
                <th>Order ID</th><th>Name</th><th>Email</th><th>Phone</th>
                <th>Address</th><th>Qty</th><th>Payment</th><th>Water</th>
                <th>Txn ID</th><th>Date</th><th>Status</th><th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
            Connection con=null; PreparedStatement ps=null; ResultSet rs=null;
            try{
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/hydrokart","root","root123");
                ps = con.prepareStatement(
                    "SELECT o.*, l.name, l.email, l.contact, l.address " +
                    "FROM orders o JOIN logreg l ON o.username=l.username " +
                    "ORDER BY o.order_date DESC"
                );
                rs = ps.executeQuery();
                while(rs.next()){
            %>
            <tr>
                <td><%=rs.getInt("order_id")%></td>
                <td><%=rs.getString("name")%></td>
                <td><%=rs.getString("email")%></td>
                <td><%=rs.getString("contact")%></td>
                <td><%=rs.getString("address")%></td>
                <td><%=rs.getInt("quantity")%></td>
                <td><%=rs.getString("payment_method")%></td>
                <td><%=rs.getString("water_type")%></td>
                <td><%=rs.getString("transaction_id")%></td>
                <td><%=rs.getTimestamp("order_date")%></td>
                <td><%=rs.getString("status")%></td>
                <td>
                    <a href="update_order_status.jsp?id=<%=rs.getInt("order_id")%>&s=Approved"
                       class="btn btn-success btn-sm">Approve</a>
                    <a href="update_order_status.jsp?id=<%=rs.getInt("order_id")%>&s=Delivered"
                       class="btn btn-primary btn-sm">Deliver</a>
                    <a href="update_order_status.jsp?id=<%=rs.getInt("order_id")%>&s=Cancelled"
                       class="btn btn-warning btn-sm">Cancel</a>
                    <a href="update_order_status.jsp?id=<%=rs.getInt("order_id")%>&s=Delete"
                       class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this order?');">Delete</a>
                </td>
            </tr>
            <% } } catch(Exception e){ e.printStackTrace(); } finally{ try{if(rs!=null)rs.close();}catch(Exception e){} try{if(ps!=null)ps.close();}catch(Exception e){} try{if(con!=null)con.close();}catch(Exception e){} } %>
        </tbody>
    </table>
</div>

<footer>
    © 2025 HYDROKART | All Rights Reserved
</footer>

</body>
</html>