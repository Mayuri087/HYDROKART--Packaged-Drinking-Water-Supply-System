<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String orderId = request.getParameter("orderId");

    if (orderId != null && !orderId.isEmpty()) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hydrokart", "root", "root123"
            );

            // Delete order from database
            String sql = "DELETE FROM orders WHERE order_id=? AND username=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, orderId);
            ps.setString(2, username);

            int row = ps.executeUpdate();
            if (row > 0) {
                out.println("<script>alert('Order canceled successfully'); window.location.href='order_history.jsp';</script>");
            } else {
                out.println("<script>alert('Order not found or cannot be canceled'); window.location.href='order_history.jsp';</script>");
            }
        } catch (Exception e) {
            out.println("<script>alert('Error: " + e.getMessage() + "'); window.location.href='order_history.jsp';</script>");
        } finally {
            if (ps != null) ps.close();
            if (con != null) con.close();
        }
    } else {
        response.sendRedirect("order_history.jsp");
    }
%>