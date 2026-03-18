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
<title>Invoices - Hydrokart</title>

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

table th{ background:#f2f2f2; }

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

<div class="admin-container">

    <!-- SIDEBAR -->
    <div class="sidebar">
        <a href="admin_login.jsp">Dashboard</a>
        <a href="admin_orders.jsp">Orders</a>
        <a href="admin_clients.jsp">Registered Clients</a>
        <a href="admin_add_client.jsp">Add Clients</a>
        <a href="admin_sales.jsp">Sales Graph</a>
        <a href="admin_invoice.jsp"><b>Invoices</b></a>
        <a href="admin_ecocredit.jsp">Ecocredit</a>
        <a href="admin_feedback.jsp">Feedback</a>        
  
    </div>

    <!-- CONTENT -->
    <div class="main-content">
        <h3>Invoices (Approved & Delivered Orders)</h3>
        <hr>

        <div class="card-box">
            <table class="table table-bordered table-striped">
                <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Username</th>
                    <th>Quantity</th>
                    <th>Water Type</th>
                    <th>Payment Status</th>
                    <th>Order Status</th>
                    <th>Invoice</th>
                </tr>
                </thead>
                <tbody>

                <%
                Connection con=null;
                PreparedStatement ps=null;
                ResultSet rs=null;
                boolean found=false;

                try{
                    Class.forName("com.mysql.jdbc.Driver");
                    con=DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/hydrokart",
                        "root","root123");

                    ps=con.prepareStatement(
                        "SELECT * FROM orders WHERE status IN ('Approved','Delivered') ORDER BY order_id DESC");
                    rs=ps.executeQuery();

                    while(rs.next()){
                        found=true;
                %>

                <tr>
                    <td><%=rs.getInt("order_id")%></td>
                    <td><%=rs.getString("username")%></td>
                    <td><%=rs.getInt("quantity")%></td>
                    <td><%=rs.getString("water_type")%></td>

                    <!-- PAYMENT STATUS -->
                    <td>
                        <% if("Delivered".equalsIgnoreCase(rs.getString("status"))){ %>
                            <span class="text-success"><b>Paid</b></span>
                        <% } else { %>
                            <span class="text-warning"><b>Pending</b></span>
                        <% } %>
                    </td>

                    <!-- ORDER STATUS -->
                    <td>
                        <% if("Delivered".equalsIgnoreCase(rs.getString("status"))){ %>
                            <span class="text-success"><b>Delivered</b></span>
                        <% } else { %>
                            <span class="text-primary"><b>Approved</b></span>
                        <% } %>
                    </td>

                    <!-- INVOICE -->
                    <td>
                        <a href="invoice_print.jsp?orderId=<%=rs.getInt("order_id")%>"
                           target="_blank"
                           class="btn btn-primary btn-sm">
                           Download
                        </a>
                    </td>
                </tr>

                <%
                    }

                    if(!found){
                %>
                <tr>
                    <td colspan="7" class="text-center text-danger">
                        No approved or delivered orders found
                    </td>
                </tr>
                <%
                    }

                }catch(Exception e){
                    out.println("<tr><td colspan='7' class='text-danger'>"+e+"</td></tr>");
                }finally{
                    try{if(rs!=null)rs.close();}catch(Exception e){}
                    try{if(ps!=null)ps.close();}catch(Exception e){}
                    try{if(con!=null)con.close();}catch(Exception e){}
                }
                %>

                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- FOOTER (UNCHANGED) -->
<footer>
    © 2025 HYDROKART | All Rights Reserved
</footer>

</body>
</html>