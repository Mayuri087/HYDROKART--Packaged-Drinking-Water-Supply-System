<%@ page import="java.sql.*, java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
String orderId = request.getParameter("orderId");
String username = (String) session.getAttribute("username");

if(username == null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Invoice - Hydrokart</title>

<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">

<style>
body{
    background:#f2f2f2;
    font-family:Arial;
}
.invoice-card{
    background:#fff;
    padding:30px;
    border-radius:10px;
    max-width:800px;
    margin:30px auto;
    box-shadow:0 0 10px #999;
}
.invoice-header{
    display:flex;
    justify-content:space-between;
}
.invoice-header img{
    height:80px;
}
.total-row{
    font-weight:bold;
    font-size:18px;
}
</style>
</head>

<body>

<div class="invoice-card">

<%
Connection con=null;
PreparedStatement ps=null;
PreparedStatement psCount=null;
ResultSet rs=null;
ResultSet rsCount=null;

int weeklyOrders = 0;
boolean ecoEligible = false;

double ratePerLitre = 20;
double discount = 0;

try{
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/hydrokart","root","root123"
    );

    /* COUNT ORDERS IN SAME WEEK */
    psCount = con.prepareStatement(
        "SELECT COUNT(*) FROM orders WHERE username=? AND YEARWEEK(order_date,1)=YEARWEEK(NOW(),1)"
    );
    psCount.setString(1, username);
    rsCount = psCount.executeQuery();

    if(rsCount.next()){
        weeklyOrders = rsCount.getInt(1);
        if(weeklyOrders > 5){
            ecoEligible = true;
        }
    }

    /* FETCH CURRENT ORDER */
    ps = con.prepareStatement(
        "SELECT * FROM orders WHERE order_id=? AND username=?"
    );
    ps.setInt(1, Integer.parseInt(orderId));
    ps.setString(2, username);
    rs = ps.executeQuery();

    if(rs.next()){
        int qty = rs.getInt("quantity");
        double total = qty * ratePerLitre;

        if(ecoEligible){
            discount = total * 0.10;
        }

        double grandTotal = total - discount;
%>

<!-- HEADER -->
<div class="invoice-header">
    <div>
        <h3>Hydrokart</h3>
        <p>Packaged Drinking Water Supply System</p>
        <p><b>Customer:</b> <%=username%></p>
        <p><b>Order ID:</b> <%=orderId%></p>
        <p><b>Date:</b> <%=rs.getTimestamp("order_date")%></p>
    </div>
    <img src="hydro.jpeg">
</div>

<hr>

<table class="table table-bordered">
<thead>
<tr>
    <th>Item</th>
    <th>Quantity (Litres)</th>
    <th>Rate / Litre</th>
    <th>Amount</th>
</tr>
</thead>

<tbody>
<tr>
    <td><%=rs.getString("water_type")%></td>
    <td><%=qty%></td>
    <td>&#8377; <%=ratePerLitre%></td>
    <td>&#8377; <%=total%></td>
</tr>

<tr>
    <td colspan="3">
        🌱 Eco Credit (Weekly Orders: <%=weeklyOrders%>)
    </td>
    <td>
        <%= ecoEligible ? "Eligible" : "Not Eligible" %>
    </td>
</tr>

<% if(ecoEligible){ %>
<tr>
    <td colspan="3">🌿 Eco Credit Discount (10%)</td>
    <td>- &#8377; <%=discount%></td>
</tr>
<% } %>

<tr class="total-row">
    <td colspan="3" style="text-align:right;">Grand Total</td>
    <td>&#8377; <%=grandTotal%></td>
</tr>

</tbody>
</table>

<div class="text-center mt-4">
    <button onclick="window.print()" class="btn btn-success">Print Invoice</button>
    <a href="order_history.jsp" class="btn btn-secondary ml-2">Back</a>
</div>

<%
    } else {
        out.println("<p class='text-danger'>Order not found</p>");
    }
}catch(Exception e){
    out.println("Error: "+e);
}finally{
    if(rs!=null) rs.close();
    if(ps!=null) ps.close();
    if(rsCount!=null) rsCount.close();
    if(psCount!=null) psCount.close();
    if(con!=null) con.close();
}
%>

</div>
</body>
</html>