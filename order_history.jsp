<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/hydrokart", "root", "root123"
        );

        String sql = "SELECT * FROM orders WHERE username=? ORDER BY order_id DESC";
        ps = con.prepareStatement(sql);
        ps.setString(1, username);
        rs = ps.executeQuery();
    } catch (Exception e) {
        out.println("Database Error: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Order History - Hydrokart</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

    <style>
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
        a { cursor: pointer; }
        .container-box {
            margin: 50px auto;
            padding: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0px 0px 10px #999;
        }
        table th, table td { text-align: center; }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-light" style="background-color:#1159B7;">
    <img src="hydro.jpeg" height="80px" width="120px" style="border-radius:20px; margin-left:20px;">
    <div class="container">

        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarTogglerDemo01">
            <span class="navbar-toggler-icon"></span>
        </button>

        <h1 style="text-align:center; margin-top:20px; margin-bottom:20px; font-style:italic;">
            <b>Hydrokart - Packaged <br> Drinking Water Supply System</b>
        </h1>

        <div class="collapse navbar-collapse" id="navbarTogglerDemo01">
            <ul class="navbar-nav mr-auto mt-2 mt-lg-0 ml-5">
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

<!-- ORDER HISTORY TABLE -->
<div class="container container-box">
    <h3 class="text-center mb-4">Your Order History</h3>

    <table class="table table-bordered table-striped">
        <thead class="thead-dark">
            <tr>
                <th>Order ID</th>
                <th>Quantity (Litre)</th>
                <th>Water Type</th>
                <th>Payment</th>
                <th>Transaction ID</th> <!-- Added column -->
                <th>Date</th>
                <th>Status</th>
                <th>Invoice / Cancel</th>
            </tr>
        </thead>
        <tbody>
            <%
                try {
                    while (rs != null && rs.next()) {
                        String orderId = rs.getString("order_id");
                        String quantity = rs.getString("quantity");
                        String waterType = rs.getString("water_type");
                        String payment = rs.getString("payment_method");
                        String transactionId = rs.getString("transaction_id"); // fetch transaction id
                        String date = rs.getString("order_date");
                        String status = rs.getString("status");
            %>
            <tr>
                <td><%= orderId %></td>
                <td><%= quantity %></td>
                <td><%= waterType %></td>
                <td><%= payment %></td>
                <td>
                    <%= "Online Pay".equals(payment) ? transactionId : "-" %> <!-- Show only for Online Pay -->
                </td>
                <td><%= date %></td>
                <td><%= status %></td>
                <td>
                    <a href="invoice.jsp?orderId=<%=orderId%>" class="btn btn-sm btn-info">View</a>
                    <a href="cancel_order.jsp?orderId=<%=orderId%>" class="btn btn-sm btn-danger ml-1"
                       onclick="return confirm('Are you sure you want to cancel this order?');">
                       Cancel
                    </a>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='8'>Error fetching orders.</td></tr>");
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                }
            %>
        </tbody>
    </table>

    <!-- Back Button -->
    <button type="button" class="btn btn-secondary mt-3" onclick="window.location.href='user_dashboard.jsp';">
        Back
    </button>
</div>

<!-- FOOTER -->
<footer>
    <div>© 2025 HYDROKART All Rights Reserved</div>
</footer>

</body>
</html>