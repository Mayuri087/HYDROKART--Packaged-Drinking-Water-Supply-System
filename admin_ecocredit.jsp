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
    <title>Admin Eco Credit - Hydrokart</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
    <style>
        body{ background:#ADD8E6; min-height:100vh; }
        .sidebar{ width:240px; background:#1c3b70; color:white; padding-top:20px; position:fixed; height:100%; }
        .sidebar a{ display:block; padding:14px 20px; color:white; text-decoration:none; font-size:16px; }
        .sidebar a:hover{ background:#1159B7; }
        .main-content{ margin-left:260px; padding:30px; }
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
    <a href="admin_ecocredit.jsp"><b>Ecocredit</b></a>
    <a href="admin_feedback.jsp">Feedback</a>
</div>

<!-- MAIN CONTENT -->
<div class="main-content">
    <h3>Registered Users Eco Credit</h3>
    <hr>

    <table class="table table-bordered table-striped">
        <thead>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Week-Year</th>
                <th>Orders This Week</th>
                <th>Total Eco Credit (₹)</th>
                <th>Last Updated</th>
            </tr>
        </thead>
        <tbody>
            <%
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try{
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/hydrokart","root","root123");

                ps = con.prepareStatement(
                    "SELECT * FROM admin_ecocredit ORDER BY created_at DESC"
                );

                rs = ps.executeQuery();
                while(rs.next()){
            %>
            <tr>
                <td><%= rs.getInt("eco_id") %></td>
                <td><%= rs.getString("username") %></td>
                <td><%= rs.getString("week_year") %></td>
                <td><%= rs.getInt("weekly_orders") %></td>
                <td>&#8377; <%= String.format("%.2f", rs.getDouble("total_ecocredit")) %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
            </tr>
            <%
                }
            }catch(Exception e){
                e.printStackTrace();
            }finally{
                try{ if(rs!=null) rs.close(); }catch(Exception e){}
                try{ if(ps!=null) ps.close(); }catch(Exception e){}
                try{ if(con!=null) con.close(); }catch(Exception e){}
            }
            %>
        </tbody>
    </table>
</div>

<footer>
    © 2025 HYDROKART | All Rights Reserved
</footer>

</body>
</html>