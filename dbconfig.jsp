<%@ page import="java.sql.*" %>
<%
    String dbURL = "jdbc:mysql://localhost:3306/hydrokart"; // replace with your DB name
    String dbUser = "root"; // replace with your DB username
    String dbPass = "root123"; // replace with your DB password

    Connection conn = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
    } catch(Exception e) {
        out.println("Database connection failed: " + e.getMessage());
    }
%>