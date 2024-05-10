<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Bill Receipt</title>
    <link rel="stylesheet" href="css/BillReceipt.css">
</head>
<body>
    <div class="main">
        <div class="header">
            <div class="container">
                <h1>Bill Receipt</h1>
                

            </div>
        </div>
        <div class="content">
            <div class="container">
                <table class="bill-table">
                    <tr>
                        <th>Order ID</th>
                        <th>Product ID</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Total</th>
                    </tr>
                    <%@ page import="java.sql.*" %>
                    <%
                        HttpSession httpSession = request.getSession();
                        String gid = (String) httpSession.getAttribute("currentuser");

                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "vamsi@1234");

                            String query = "SELECT * FROM orders WHERE uid = ?";
                            ps = conn.prepareStatement(query);
                            ps.setString(1, gid);
                            rs = ps.executeQuery();

                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("oid") %></td>
                        <td><%= rs.getString("pid") %></td>
                        <td><%= rs.getInt("price") %></td>
                        <td><%= rs.getInt("quantity") %></td>
                        <td><%= rs.getInt("price") * rs.getInt("quantity") %></td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("Error: " + e);
                        } finally {
                            try { if (rs != null) rs.close(); } catch (Exception e) {}
                            try { if (ps != null) ps.close(); } catch (Exception e) {}
                            try { if (conn != null) conn.close(); } catch (Exception e) {}
                        }
                    %>
                </table>
                <hr>
                <div class="total-amount">
                    <h3>Total Amount: <%= calculateTotalAmount(gid) %></h3>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

<%! 
    private double calculateTotalAmount(String userId) {
        double totalAmount = 0.0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql", "root", "vamsi@1234");

            String query = "SELECT SUM(price * quantity) as totalAmount FROM order_details WHERE user_id = ?";
            ps = conn.prepareStatement(query);
            ps.setString(1, userId);
            rs = ps.executeQuery();

            if (rs.next()) {
                totalAmount = rs.getDouble("totalAmount");
            }
        } catch (Exception e) {
            out.println("Error calculating total amount: " + e);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        return totalAmount;
    }
%>
