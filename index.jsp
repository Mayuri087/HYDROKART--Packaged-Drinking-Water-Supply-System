<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title></title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<link rel="stylesheet"
href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">

<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
rel="stylesheet">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

<style type="text/css">
footer {
border-top: 1px solid #0278BA;
padding: 10px 0;
width: 100%;
text-align: center;
margin: 30px 0 0;
background-color: #ddd;
}

.card {
margin-top: 40px;
align-items: center;
margin-right: 40px;
margin-left: 40px;
border: 2px solid black;
}

.use {
font-size: 20px;
color: white;
}

.navbar li:hover {
background-color: silver;
}

ul li ul.dropdown {
background: white;
border-radius: 8px;
box-shadow: 0px 4px 12px rgba(0,0,0,0.4);
display: none;
padding: 10px;
position: absolute;
z-index: 999;
min-width: 220px;
}
ul li ul.dropdown li a {
color: black !important;
font-size: 18px !important;
padding: 8px 12px;
border-radius: 6px;
display: block;
font-weight: 600;
}

ul li ul.dropdown li a:hover {
background-color: #1159B7;
color: white !important;
text-decoration: none;
}


ul li:hover ul.dropdown {
display: block;
}

ul li ul.dropdown li {
display: block;
}
</style>
</head>

<body id="home">

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-light" style="background-color:#1159B7;">
<img src="hydro.jpeg" height="80px" width="120px"
style="border-radius: 20px; margin-left: 20px;">

<div class="container">
<button class="navbar-toggler" type="button" data-toggle="collapse"
data-target="#navbarTogglerDemo01">
<span class="navbar-toggler-icon"></span>
</button>

<h1 style="text-align:center; margin-top:20px; margin-bottom:20px; font-style:italic;">
<b>Hydrokart - Packaged <br> Drinking Water Supply System</b>
</h1>

<div class="collapse navbar-collapse" id="navbarTogglerDemo01">
<ul class="navbar-nav mr-auto mt-2 mt-lg-0 ml-5">

<li class="nav-item">
<a class="nav-link ml-2 active" style="font-size:22px; color:white;" href="#home">
Home</a>
</li>

<ul class="nav" style="list-style-type:none; padding-left:0;">
  <li>
    <a class="nav-link ml-2" style="font-size:22px; color:white; font-weight:bold;">
      Login ▾
    </a>
    <ul class="dropdown" style="list-style-type:none; padding-left:0;">
      <li><a href="login.jsp">👤 Login as User</a></li>
      <li><a href="admin.jsp">🛠 Login as Admin</a></li>
    </ul>
  </li>

  <li class="nav-item">
    <a class="nav-link ml-2" style="font-size:22px; color:white;" href="#aboutus">
      About Us
    </a>
  </li>
</ul>


<li class="nav-item">
<a class="nav-link ml-2" style="font-size:22px; color:white;" href="#contactus">
Contact Us</a>
</li>

</ul>

<ul class="nav navbar-nav navbar-right" id="login-panel" style="color:white;">
<li>
<%
String loginUser = (String) session.getAttribute("login_user");
Boolean logged = (Boolean) session.getAttribute("logged");

if (loginUser != null && logged != null && logged) {
%>
<div class="use text-right p-3">
<div class="font-weight-bold" style="font-size:20px;">
👤 <%= loginUser %>
</div>
<a href="logout.jsp" class="btn btn-danger mt-2">🔓 Logout</a>
</div>
<%
}
%>
</li>
</ul>

</div>
</div>
</nav>

<!-- CAROUSEL -->
<div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
<div class="carousel-inner">
<div class="carousel-item active">
<img class="d-block w-100" src="bg.jpeg" height="400px">
</div>
<div class="carousel-item">
<img class="d-block w-100" src="backg.jpeg" height="400px">
</div>
</div>
</div>

<!-- OUR PRODUCTS -->
<h2 style="text-align:center;"><u><b>Our Products</b></u></h2>

<div class="row justify-content-center" style="margin:40px;">
<div class="col-lg-4 col-md-6 col-sm-12">
<div class="card text-center">
    <h5 class="card-title bg-info text-white p-2" style="border:2px solid black;"><br>
Drinking Water
</h5>
<div class="card-body">
<img src="bottle.png" class="img-fluid mb-3">
<p>Pure and safe packaged drinking water.<br><b>Rs.20/Litre</b></p>
</div>
</div>
</div>

<div class="col-lg-4 col-md-6 col-sm-12">
<div class="card text-center">
<h5 class="card-title bg-info text-white p-2" style="border:2px solid black;">
Normal Water
</h5>
<div class="card-body">
<img src="jar.jpeg" class="img-fluid mb-3">
<p><br>Normal water supply for daily household use.<br><b>Rs.20/Litre</b></p>
</div>
</div>
</div>
</div>

<!-- ABOUT US -->
<div id="aboutus" style="margin:40px; border:2px solid black; padding:20px; font-size:18px;">
    <h3 style="text-align:center; font-style:italic;"><u><b>About Us</b></u></h3>
<p>
Our company 
<b>Hydrokart packaged drinking Water Supply</b> get water from 
    a variety of locations after appropriate treatment, including groundwater 
(aquifers), surface water (lakes and 
    rivers), and the sea through desalination. The water treatment steps include, in 
most cases, purification, 
    disinfection through chlorination and sometimes fluoridation. Treated water 
then either flows by gravity or is 
    pumped to reservoirs, which can be elevated such as water towers or on the 
ground (for indicators related to the 
    efficiency of drinking water distribution see non-revenue water). Once water 
is used, wastewater is typically 
    discharged in a sewer system and treated in a sewage treatment plant before 
being discharged into a river, lake or 
the sea or reused for landscaping, irrigation or industrial use. Water supply 
service quality has many dimensions: 
continuity; water quality; pressure; and the degree of responsiveness of 
service providers to customer complaints. 
Many people in developing countries receive a poor or very poor quality of 
service.<br> 
<b>Drinking water quality </b>has a micro-biological and a physico-chemical 
dimension. There are thousands of 
parameters of water quality. In public water supply systems water should, at a 
minimum, be disinfected—most commonly 
through the use of chlorination or the use of ultra violet light—or it may need 
to undergo treatment, especially in 
the case of surface water. For more details, please see the separate entries on 
water quality, water treatment and 
drinking water.
</p>
</div>

<!-- FOOTER -->
<footer id="contactus" style="background: linear-gradient(to right, #1c3b70, #2f5ca8); color: white; padding: 60px 20px 20px 20px;">

<a href="#home" style="position: fixed; bottom: 20px; right: 20px; width: 45px; height: 45px; background: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; text-decoration: none;">
↑
</a>

    <h4><u>Contact Us</u></h4>
<p>+91-1234567890</p>
<p>info@hydrokart.in</p>

<h4><u>Address</u></h4>
<p>
HYDROKART - Package Drinking Water Suppliers<br>
shop no.08, Om Prasad CHS, Vikram Nagar, Kalwa, Thane - 400605.
</p>

<div style="text-align:center;">© 2025 HYDROKART All Rights Reserved</div>
</footer>

</body>
</html>