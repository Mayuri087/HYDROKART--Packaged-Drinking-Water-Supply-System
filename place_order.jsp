<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String orderStatus = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String quantity = request.getParameter("quantity");
        String paymentMethod = request.getParameter("payment");
        String transactionId = request.getParameter("transactionId");
        String waterType = request.getParameter("waterType");
        String username = (String) session.getAttribute("username");

        if (username != null) {

            Connection con = null;
            PreparedStatement ps = null;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/hydrokart", "root", "root123"
                );

                String sql = "INSERT INTO orders(username, quantity, payment_method, transaction_id, water_type) VALUES (?,?,?,?,?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, quantity);
                ps.setString(3, paymentMethod);
                ps.setString(4, transactionId);
                ps.setString(5, waterType);

                int row = ps.executeUpdate();
                if (row > 0)
                    orderStatus = "success";
                else
                    orderStatus = "error";

            } catch (Exception e) {
                orderStatus = "error";
            } finally {
                if (ps != null) ps.close();
                if (con != null) con.close();
            }

        } else {
            response.sendRedirect("login.jsp");
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Place Your Order - Hydrokart</title>
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
        .form-container {
            display: flex;
            justify-content: center;
            margin: 50px auto;
        }
        .form-box {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px #999;
            width: 350px;
        }
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
                    <a class="nav-link ml-2 active" style="font-size:22px; color:white;" href="index.jsp">Home</a>
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

<!-- ORDER FORM -->
<div class="form-container">
    <div class="form-box">
        <h3 class="text-center">Place Your Order</h3>

        <form method="post">
            <label>Quantity (Litre)</label>
            <input type="number" name="quantity" class="form-control mb-3" required>

            <label>Payment Method</label><br>
            <input type="radio" name="payment" value="Cash on Delivery" checked> Cash on Delivery
            <input type="radio" name="payment" value="Online Pay"> Online Pay

            <input type="text" name="transactionId" class="form-control mt-2 mb-3"
                   placeholder="Transaction ID (Only for Online Pay)">

            <label>Type of Water</label><br>
            <input type="radio" name="waterType" value="Normal Water" checked> Normal Water
            <input type="radio" name="waterType" value="Drinking Water"> Drinking Water

            <button type="submit" class="btn btn-primary btn-block mt-3">Submit</button>
            <button type="button" class="btn btn-secondary btn-block mt-3" 
        onclick="window.location.href='user_dashboard.jsp';">Back</button>

        </form>
    </div>
</div>

<!-- SUCCESS POPUP MODAL -->
<div class="modal fade" id="successModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content text-center p-4" style="border-radius:15px;">

            <div style="
                width:70px;
                height:70px;
                border-radius:50%;
                border:3px solid #4CAF50;
                display:flex;
                align-items:center;
                justify-content:center;
                margin:0 auto 15px auto;">
                <span style="font-size:36px; color:#4CAF50;">✔</span>
            </div>

            <h4><b>Order Placed!</b></h4>
            <p>Your order has been submitted successfully.</p>

            <button class="btn btn-primary mt-2"
                    onclick="window.location.href='order_history.jsp'">
                OK
            </button>

        </div>
    </div>
</div>

<!-- FOOTER -->
<footer>
    <div>© 2025 HYDROKART All Rights Reserved</div>
</footer>

<!-- SCRIPT TO SHOW POPUP -->
<script>
<% if ("success".equals(orderStatus)) { %>
    $(document).ready(function(){
        $('#successModal').modal({
            backdrop: 'static',
            keyboard: false
        });
    });
<% } else if ("error".equals(orderStatus)) { %>
    $(document).ready(function(){
        alert("Error placing order. Please try again.");
    });
<% } %>
</script>
<script>
    $(document).ready(function() {
        // Function to enable/disable transaction ID based on payment method
        $('input[name="payment"]').change(function() {
            if ($(this).val() === 'Cash on Delivery') {
                $('input[name="transactionId"]').prop('disabled', true).val('');
            } else {
                $('input[name="transactionId"]').prop('disabled', false);
            }
        });

        // Initialize field state on page load
        if ($('input[name="payment"]:checked').val() === 'Cash on Delivery') {
            $('input[name="transactionId"]').prop('disabled', true);
        }
    });
</script>
</body>
</html>