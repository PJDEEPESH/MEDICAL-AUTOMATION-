<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Contact Us</title>
</head>
<body>
    <%
        // Retrieve form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "vamsi@1234");

            // Assuming you have a table named 'contact_entries'
            String query = "INSERT INTO contact_entries (name, email, message) VALUES (?, ?, ?)";
            ps = conn.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, message);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                // Successful insertion, you can redirect to a thank you page or display a success message
                response.sendRedirect("ContactUsSuccess.jsp");
            } else {
                // Handle the case where the insertion failed
                response.sendRedirect("ContactUsError.jsp");
            }
        } catch (Exception e) {
            // Handle exceptions, log them, or redirect to an error page
            out.println(e);
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {};
            try { if (conn != null) conn.close(); } catch (Exception e) {};
        }
    %>
</body>
</html>
