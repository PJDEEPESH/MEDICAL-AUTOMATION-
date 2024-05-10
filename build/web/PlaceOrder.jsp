<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Orders JSP</title>
</head>
<body>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.util.*" %>
<%
String pid=request.getParameter("pid");
int qr=Integer.parseInt(request.getParameter("orderquantity"));
HttpSession httpSession = request.getSession();
String guid=(String)httpSession.getAttribute("currentuser");
Connection conn=null;
ResultSet rs=null;
PreparedStatement ps=null;
PreparedStatement ps2=null;
PreparedStatement updateStatement = null; // Declare updateStatement here

String a,b;
int c;
//
//Date currentDate = new Date();

%>
<%
 %><%
String query1="select p.pid,o.sid,p.price from inventory o,product p where p.pid=? and p.pid=o.pid";
String query2="insert into orders(pid,sid,uid,quantity,price) values(?,?,?,?,?)";
String updateQuery = "UPDATE inventory SET quantity = quantity - ? WHERE pid = ?";
try{
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql","root","vamsi@1234");
	ps=conn.prepareStatement(query1);
	ps.setString(1,pid);
	rs=ps.executeQuery();
	if(rs.next())
	{
		a=rs.getString("pid");
		b=rs.getString("sid");
		c=rs.getInt("price");
                
        updateStatement = conn.prepareStatement(updateQuery);
        updateStatement.setInt(1, qr);
        updateStatement.setString(2, a);
        updateStatement.executeUpdate();
        
		ps2=conn.prepareStatement(query2);
		ps2.setString(1,a);
		ps2.setString(2,b);
		ps2.setString(3,guid);
		ps2.setInt(4,qr);
		ps2.setInt(5,qr*c);
		int i=ps2.executeUpdate();
		response.sendRedirect("Orders.jsp");
	}
}
catch(Exception E)
{
	out.println(E);
}
finally {
	  	try { if (rs != null) rs.close(); } catch (Exception e) {};
	  	try { if (ps != null) ps.close(); } catch (Exception e) {};
	  	try { if (ps2 != null) ps2.close(); } catch (Exception e) {};
	  	try { if (updateStatement != null) updateStatement.close(); } catch (Exception e) {}; // Close updateStatement
		try { if (conn != null) conn.close(); } catch (Exception e) {};
}
%>
</body>
</html>
