<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate session to logout the user
    if (session != null) {
        session.invalidate();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Logout</title>
    <!-- SweetAlert2 CSS and JS -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
    <script type="text/javascript">
        // Show professional popup using SweetAlert2
        Swal.fire({
            icon: 'success',
            title: 'Successfully Logged Out',
            showConfirmButton: false,
            timer: 2000, // auto close after 2 seconds
            timerProgressBar: true,
            didClose: () => {
                // Redirect to home page after popup closes
                window.location.href = "index.jsp";
            }
        });
    </script>
</body>
</html>