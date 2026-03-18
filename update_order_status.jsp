<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
String admin = (String) session.getAttribute("admin");
if(admin == null){
    response.sendRedirect("admin.jsp");
    return;
}

int orderId = Integer.parseInt(request.getParameter("id"));
String status = request.getParameter("s");

Connection con = null;
PreparedStatement ps = null;

try{
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/hydrokart","root","root123");

    if("Delete".equalsIgnoreCase(status)){
        // DELETE ORDER
        ps = con.prepareStatement("DELETE FROM orders WHERE order_id=?");
        ps.setInt(1, orderId);
        ps.executeUpdate();
    }else{
        // UPDATE STATUS (Approved, Delivered, Cancelled)
        ps = con.prepareStatement("UPDATE orders SET status=? WHERE order_id=?");
        ps.setString(1, status);
        ps.setInt(2, orderId);
        ps.executeUpdate();
    }

}catch(Exception e){
    e.printStackTrace();
}finally{
    try{ if(ps!=null) ps.close(); }catch(Exception e){}
    try{ if(con!=null) con.close(); }catch(Exception e){}
}

// Redirect back to orders page
response.sendRedirect("admin_orders.jsp");
%>