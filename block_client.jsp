<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
String id = request.getParameter("id");
String action = request.getParameter("action");

Connection con = null;
PreparedStatement ps = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/hydrokart","root","root123");

    String sql = "UPDATE logreg SET blocked=? WHERE id=?";
    ps = con.prepareStatement(sql);
    ps.setInt(1, action.equals("block") ? 1 : 0);
    ps.setInt(2, Integer.parseInt(id));
    ps.executeUpdate();
} catch(Exception e){ e.printStackTrace(); }
finally{ try{if(ps!=null) ps.close();}catch(Exception e){} try{if(con!=null) con.close();}catch(Exception e){} }

response.sendRedirect("admin_login.jsp#clients");
%>