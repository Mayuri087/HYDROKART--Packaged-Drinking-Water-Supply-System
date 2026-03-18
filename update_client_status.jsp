<%@ page import="java.sql.*" %>

<%
    // Admin session check
    String admin = (String) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("admin.jsp");
        return;
    }

    int userId = Integer.parseInt(request.getParameter("id"));
    String action = request.getParameter("action");

    Connection con = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/hydrokart",
            "root",
            "root123"
        );

        if ("block".equals(action)) {

            ps = con.prepareStatement(
                "UPDATE logreg SET blocked = 1 WHERE user_id = ?"
            );
            ps.setInt(1, userId);
            ps.executeUpdate();

        } else if ("unblock".equals(action)) {

            ps = con.prepareStatement(
                "UPDATE logreg SET blocked = 0 WHERE user_id = ?"
            );
            ps.setInt(1, userId);
            ps.executeUpdate();

        } else if ("delete".equals(action)) {

            ps = con.prepareStatement(
                "DELETE FROM logreg WHERE user_id = ?"
            );
            ps.setInt(1, userId);
            ps.executeUpdate();
        }

        // Redirect back to clients page
        response.sendRedirect("admin_clients.jsp");

    } catch (Exception e) {
        out.println("<h3 style='color:red'>" + e.getMessage() + "</h3>");
    } finally {
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }
%>