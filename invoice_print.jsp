<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date" %>

<%
String admin = (String) session.getAttribute("admin");
if(admin == null){
    response.sendRedirect("admin.jsp");
    return;
}

int orderId = Integer.parseInt(request.getParameter("orderId"));

String username="", waterType="", status="", paymentStatus="";
int quantity=0;
double ratePerLitre = 20;   // FIXED RATE
double totalAmount = 0;

/* ECO CREDIT ADDITION */
int weeklyOrders = 0;
boolean ecoEligible = false;
double discount = 0;
double grandTotal = 0;
/* END ADDITION */

Date orderDate = new Date();

Connection con=null;
PreparedStatement ps=null;
PreparedStatement psCount=null;
ResultSet rs=null;
ResultSet rsCount=null;

try{
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/hydrokart","root","root123");

    ps = con.prepareStatement("SELECT * FROM orders WHERE order_id=?");
    ps.setInt(1, orderId);
    rs = ps.executeQuery();

    if(rs.next()){
        username  = rs.getString("username");
        waterType = rs.getString("water_type");
        quantity  = rs.getInt("quantity");
        status    = rs.getString("status");
        orderDate = rs.getDate("order_date");

        totalAmount = quantity * ratePerLitre;

        if("Delivered".equalsIgnoreCase(status)){
            paymentStatus = "PAID";
        }else if("Approved".equalsIgnoreCase(status)){
            paymentStatus = "PENDING";
        }
    }

    /* ECO CREDIT WEEKLY COUNT */
    psCount = con.prepareStatement(
        "SELECT COUNT(*) FROM orders WHERE username=? AND YEARWEEK(order_date,1)=YEARWEEK(NOW(),1)"
    );
    psCount.setString(1, username);
    rsCount = psCount.executeQuery();

    if(rsCount.next()){
        weeklyOrders = rsCount.getInt(1);
        if(weeklyOrders > 5){
            ecoEligible = true;
            discount = totalAmount * 0.10;
        }
    }

    grandTotal = totalAmount - discount;

}catch(Exception e){
    out.println(e);
}finally{
    try{ if(rs!=null)rs.close(); }catch(Exception e){}
    try{ if(ps!=null)ps.close(); }catch(Exception e){}
    try{ if(rsCount!=null)rsCount.close(); }catch(Exception e){}
    try{ if(psCount!=null)psCount.close(); }catch(Exception e){}
    try{ if(con!=null)con.close(); }catch(Exception e){}
}

SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
String amountWords = grandTotal + " Rupees Only";
%>

<!DOCTYPE html>
<html>
<head>
<title>Hydrokart Invoice</title>

<style>
body{
    font-family:Arial;
    background:#f5f5f5;
}
.invoice-box{
    width:820px;
    margin:20px auto;
    background:white;
    padding:25px;
    border:1px solid #ccc;
    position:relative;
}
.header{
    display:flex;
    align-items:center;
    border-bottom:2px solid #1159B7;
    padding-bottom:10px;
}
.header img{
    height:80px;
    width:120px;
    border-radius:15px;
}
.header h2{
    margin-left:20px;
    color:#1159B7;
}
.details td{
    padding:6px;
}
table{
    width:100%;
    border-collapse:collapse;
    margin-top:20px;
}
table th, table td{
    border:1px solid #999;
    padding:10px;
    text-align:center;
}
table th{
    background:#eaeaea;
}
.total{
    text-align:right;
    margin-top:15px;
    font-size:18px;
}
.status{
    margin-top:10px;
    font-weight:bold;
}
.pending{ color:#d9534f; }

.paid-stamp{
    position:absolute;
    top:130px;
    right:40px;
    font-size:42px;
    color:green;
    border:4px solid green;
    padding:10px 20px;
    transform:rotate(-15deg);
    opacity:0.75;
}

.signature{
    margin-top:40px;
    display:flex;
    justify-content:space-between;
}
.signature div{
    text-align:center;
    width:40%;
}
.terms{
    margin-top:30px;
    font-size:14px;
}
.print-btn{
    text-align:center;
    margin-top:20px;
}
@media print{
    .print-btn{ display:none; }
}
</style>
</head>

<body>

<div class="invoice-box">

<% if("PAID".equals(paymentStatus)){ %>
    <div class="paid-stamp">PAID</div>
<% } %>

<div class="header">
    <img src="hydro.jpeg">
    <h2>Hydrokart – Packaged Drinking Water Supply System</h2>
</div>

<table class="details">
<tr>
    <td><b>Invoice No:</b> HK-INV-<%=orderId%></td>
    <td><b>Invoice Date:</b> <%=sdf.format(new Date())%></td>
</tr>
<tr>
    <td><b>Customer Name:</b> <%=username%></td>
    <td><b>Order Date:</b> <%=sdf.format(orderDate)%></td>
</tr>
<tr>
    <td><b>Water Type:</b> <%=waterType%></td>
    <td><b>Order Status:</b> <%=status%></td>
</tr>
</table>

<table>
<tr>
    <th>Sr No</th>
    <th>Description</th>
    <th>Quantity (Litres)</th>
    <th>Rate / Litre (₹)</th>
    <th>Amount (₹)</th>
</tr>
<tr>
    <td>1</td>
    <td>Water Supply</td>
    <td><%=quantity%></td>
    <td><%=ratePerLitre%></td>
    <td><%=totalAmount%></td>
</tr>

<tr>
    <td colspan="4">🌱 Eco Credit (Weekly Orders: <%=weeklyOrders%>)</td>
    <td><%= ecoEligible ? "Eligible" : "Not Eligible" %></td>
</tr>

<% if(ecoEligible){ %>
<tr>
    <td colspan="4">🌿 Eco Credit Discount (10%)</td>
    <td>- ₹ <%=discount%></td>
</tr>
<% } %>

<tr>
    <th colspan="4" style="text-align:right;">Grand Total</th>
    <th>₹ <%=grandTotal%></th>
</tr>
</table>

<div class="total">
    <b>Amount in Words:</b> <%=amountWords%>
</div>

<% if(!"PAID".equals(paymentStatus)){ %>
<div class="status pending">
    Payment Status: PENDING
</div>
<% } %>

<div class="signature">
    <div>
        _______________________<br>
        Customer Signature
    </div>
    <div>
        _______________________<br>
        Authorized Signatory
    </div>
</div>

<div class="terms">
    <b>Terms & Conditions:</b>
    <ul>
        <li>This is a system-generated invoice.</li>
        <li>Payment once made is non-refundable.</li>
        <li>All disputes are subject to local jurisdiction.</li>
    </ul>
</div>

<div class="print-btn">
    <button onclick="window.print()">Print / Save PDF</button>
</div>

</div>
</body>
</html>