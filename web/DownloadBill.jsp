<%--<%@ page import="org.apache.pdfbox.pdmodel.PDDocument"%>
<%@ page import="org.apache.pdfbox.pdmodel.PDPage"%>
<%@ page import="org.apache.pdfbox.pdmodel.PDPageContentStream"%>
<%@ page import="org.apache.pdfbox.pdmodel.font.PDType1Font"%>
<%@ page import="java.io.OutputStream"%>
<%@ page import="java.io.ByteArrayOutputStream"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page contentType="application/pdf" pageEncoding="ISO-8859-1"%>

<%
    // Retrieve necessary data for the bill receipt
    String orderId = request.getParameter("oid");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sql", "root", "vamsi@1234");

        // Assuming bill_receipts is the name of your table
        String query = "SELECT * FROM bill_receipts WHERE oid = ?";
        ps = conn.prepareStatement(query);
        ps.setString(1, orderId);
        rs = ps.executeQuery();

        if (rs.next()) {
            // Retrieve data from the result set
            double totalAmount = rs.getDouble("total_amount");
            Timestamp paymentDate = rs.getTimestamp("payment_date");
            String userId = rs.getString("uid");

            // Generate the bill receipt content
            String billContent = "Order ID: " + orderId + "\n" +
                                 "Total Amount: $" + totalAmount + "\n" +
                                 "Payment Date: " + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(paymentDate) + "\n" +
                                 "User ID: " + userId;

            // Generate the PDF document
            PDDocument document = new PDDocument();
            PDPage page = new PDPage();
            document.addPage(page);

            PDPageContentStream contentStream = new PDPageContentStream(document, page);
            contentStream.setFont(PDType1Font.HELVETICA_BOLD, 12);
            contentStream.beginText();
            contentStream.newLineAtOffset(50, 700);
            contentStream.showText(billContent);
            contentStream.endText();
            contentStream.close();

            // Convert the PDF document to a byte array
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            document.save(byteArrayOutputStream);
            document.close();

            // Set response headers for PDF download
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=bill_receipt.pdf");

            // Send the generated PDF to the response output stream
            OutputStream outputStream = response.getOutputStream();
            outputStream.write(byteArrayOutputStream.toByteArray());
            outputStream.flush();
            outputStream.close();
        } else {
            out.println("No data found for order ID: " + orderId);
        }
    } catch (Exception e) {
        out.println("Error: " + e);
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>--%>
