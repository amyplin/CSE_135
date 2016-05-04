<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII" import="com.mit.*,java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<link rel="stylesheet" media="screen" href="css/categories.css">
<link rel="stylesheet" href="css/bootstrap.min.css">

<title>Order Confirmation</title>
</head>
<body>

<jsp:useBean id="obj" class="com.mit.CustomerBean"/>
<jsp:setProperty property="*" name="obj"/>
<%@ page import="java.sql.*"%>
<% if (session.getAttribute("loggedIn") == null) { %>
<div class="title">
	<h1>No user logged in</h1>
</div>
<% } else { %>
<%
	try{
		//create connections to the database
		Connection conn = ConnectionProvider.getCon();
%>



 <div class="title">
  <h1>Hello <%= session.getAttribute("username") %>, Order Confirmation Page</h1>
</div>


	<div class="container">
		<table class="table table-bordered">
			<thead>
				<tr>
					<th>Item</th>
					<th>Category</th>
					<th>Quantity</th>
					<th>Price</th>
					<th>Date Ordered</th>
					<th>Credit Card</th>
					
				</tr>
				
			</thead>
			
			<tbody>
				<%
				// Create the statement
				PreparedStatement cartSQL = conn.prepareStatement("select * from orders where order_id = (SELECT MAX(order_id) from orders where username=?)");
				cartSQL.setString(1, session.getAttribute("username").toString());
				ResultSet rs = cartSQL.executeQuery();
				%>
				
				<%-- Iterate over the ResultSet / Presentation code --%>
				<%		
						int ordertotal = 0;
						while (rs.next()) {
				%>
					<tr>
						<td><%=rs.getString("productname")%></td>
						<td><%=rs.getString("productcategory")%></td>
						<td><%=rs.getString("productquantity")%></td>
						<td><%=rs.getString("productprice") %>$</td>
						<td><%=rs.getString("dateordered") %></td>
						<td><%=rs.getString("creditcard") %></td>
					</tr>


				<%
							// calculate the total price
							int quantity = Integer.parseInt(rs.getString("productquantity"));
							int price = Integer.parseInt(rs.getString("productprice"));
							ordertotal += (quantity*price);
							
						}
						// Close the ResultSet
						rs.close();
						// Close the Statement
						cartSQL.close();
						// Close the Connection
						conn.close();
						
						

					
				%>
			</tbody>
		</table>
	</div>
	<div align="center">
		<p> Order Total: <% out.print(ordertotal); %>$</p>
	</div>
	
	<br>
	<br>
	<br>

<ul>
    <li><a href="Home.jsp">Home Page</a></li>

</ul>

	
	<%					} catch  (Exception ex) {
							System.out.println(ex);
						} 
					}%>
						
						

</body>
</html>
