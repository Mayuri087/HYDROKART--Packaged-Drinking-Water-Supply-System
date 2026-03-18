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
<title>Admin Sales - Hydrokart</title>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body{ background:#ADD8E6; min-height:100vh; }
.sidebar{ width:240px; background:#1c3b70; color:white; padding-top:20px; position:fixed; height:100%; }
.sidebar a{ display:block; padding:14px 20px; color:white; text-decoration:none; font-size:16px; }
.sidebar a:hover{ background:#1159B7; }
.main-content{ margin-left:260px; padding:30px; }
footer{ background:#1c3b70; color:white; text-align:center; padding:15px 0; position:fixed; bottom:0; width:100%; }
#waterChart{
    max-width: 400px;
    max-height: 400px;
    margin: 0 auto;
}
.main-content{
    padding-bottom: 100px;
}

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
<h3>Sales Report (Normal Orders)</h3>
<hr>

<div class="row">
<div class="col-md-6">
<h5 class="text-center">Weekly Orders</h5>
<canvas id="weeklyChart"></canvas>
</div>

<div class="col-md-6">
<h5 class="text-center">Monthly Orders</h5>
<canvas id="monthlyChart"></canvas>
</div>
</div>

<br>

<div class="row">
<div class="col-md-12">
<h5 class="text-center">Water Type Wise Orders</h5>
<canvas id="waterChart"></canvas>
</div>
</div>

<%
int[] weekly = new int[7];
int[] monthly = new int[12];
String waterLabels = "";
String waterData = "";

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{
Class.forName("com.mysql.jdbc.Driver");
con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/hydrokart","root","root123");

/* WEEKLY SALES (ORDER COUNT) */
ps = con.prepareStatement(
"SELECT DAYOFWEEK(order_date) d, COUNT(*) c " +
"FROM orders WHERE status='Delivered' " +
"AND YEARWEEK(order_date)=YEARWEEK(CURDATE()) GROUP BY d");
rs = ps.executeQuery();
while(rs.next()){
weekly[rs.getInt("d")-1] = rs.getInt("c");
}
rs.close(); ps.close();

/* MONTHLY SALES (ORDER COUNT) */
ps = con.prepareStatement(
"SELECT MONTH(order_date) m, COUNT(*) c " +
"FROM orders WHERE status='Delivered' " +
"AND YEAR(order_date)=YEAR(CURDATE()) GROUP BY m");
rs = ps.executeQuery();
while(rs.next()){
monthly[rs.getInt("m")-1] = rs.getInt("c");
}
rs.close(); ps.close();

/* WATER TYPE SALES */
ps = con.prepareStatement(
"SELECT water_type, COUNT(*) c FROM orders " +
"WHERE status='Delivered' GROUP BY water_type");
rs = ps.executeQuery();
while(rs.next()){
waterLabels += "'" + rs.getString("water_type") + "',";
waterData += rs.getInt("c") + ",";
}

}catch(Exception e){
e.printStackTrace();
}finally{
try{if(rs!=null)rs.close();}catch(Exception e){}
try{if(ps!=null)ps.close();}catch(Exception e){}
try{if(con!=null)con.close();}catch(Exception e){}
}
%>

<script>
new Chart(document.getElementById("weeklyChart"), {
    type: 'bar',
    data: {
        labels: ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],
        datasets: [{
            label: "Orders",
            data: <%=java.util.Arrays.toString(weekly)%>,
            backgroundColor: "#1159B7"
        }]
    },
    options: {
        scales: {
            y: {
                beginAtZero: true,
                max: 15,
                ticks: {
                    stepSize: 3
                }
            }
        }
    }
});

new Chart(document.getElementById("monthlyChart"),{
    type:'line',
    data:{
        labels:["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],
        datasets:[{
            label:"Orders",
            data:<%=java.util.Arrays.toString(monthly)%>,
            borderColor:"#1c3b70",
            fill:false
        }]
    },
    options:{
        scales:{
            y:{
                min:1,
                max:60,
                ticks:{
                    stepSize:6
                }
            }
        }
    }
});

new Chart(document.getElementById("waterChart"),{
type:'pie',
data:{
labels:[<%=waterLabels%>],
datasets:[{data:[<%=waterData%>]}]
}
});
</script>

</div>

<footer>
© 2025 HYDROKART | All Rights Reserved
</footer>

</body>
</html>