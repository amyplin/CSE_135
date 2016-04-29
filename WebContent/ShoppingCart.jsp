<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII" import="com.mit.*,java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<link rel="stylesheet" media="screen" href="css/categories.css">
<link rel="stylesheet" href="css/bootstrap.min.css">

<title>Shopping Cart</title>
</head>
<body>

<jsp:useBean id="obj" class="com.mit.CustomerBean"/>
<jsp:setProperty property="*" name="obj"/>
<%@ page import="java.sql.*"%>
<%
	try{
		//create connections to the database
		Connection conn = ConnectionProvider.getCon();
%>



 <div class="title">
  <h1><%= session.getAttribute("username") %>'s Shopping Cart</h1>
</div>


	<div class="container">
		<table class="table table-bordered">
			<thead>
				<tr>
					<th>Item</th>
					<th>Description</th>
					<th>Price</th>
					<th>Quantity</th>
					
				</tr>
				
			</thead>
			
			<tbody>
				<%
				// Create the statement
				PreparedStatement cartSQL = conn.prepareStatement("select * from shoppingcart where username=?");
				cartSQL.setString(1, session.getAttribute("username").toString());
				ResultSet rs = cartSQL.executeQuery();
				%>
				
				<%-- Iterate over the ResultSet / Presentation code --%>
				<%
						while (rs.next()) {
				%>
				<tr>
					<td><%=rs.getString("username")%></td>
					<td><%=rs.getString("sku")%></td>
					<td><%=rs.getString("quantity")%></td>
					<td>N/A</td>
				</tr>


				<%
						}
						// Close the ResultSet
						rs.close();
						// Close the Statement
						cartSQL.close();
						// Close the Connection
						conn.close();
						
						
					} catch  (Exception ex) {
						System.out.println(ex);
					}
					
				%>
			</tbody>
		</table>
	</div>

</body>
</html>
