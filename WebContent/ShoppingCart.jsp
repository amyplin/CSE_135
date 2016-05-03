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
  <h1>Hello <%= session.getAttribute("username") %>, This Is Your Shopping Cart</h1>
</div>


	<div class="container">
		<table class="table table-bordered">
			<thead>
				<tr>
					<th>Item</th>
					<th>Description</th>
					<th>Quantity</th>
					<th>Price</th>
					
				</tr>
				
			</thead>
			
			<tbody>
				<%
				// Create the statement
				PreparedStatement cartSQL = conn.prepareStatement("select * from shoppingcart join products on shoppingcart.sku = products.sku where username=?");
				cartSQL.setString(1, session.getAttribute("username").toString());
				ResultSet rs = cartSQL.executeQuery();
				%>
				
				<%-- Iterate over the ResultSet / Presentation code --%>
				<%		
						int shoppingcarttotal = 0;
						while (rs.next()) {
				%>
					<tr>
						<td><%=rs.getString("name")%></td>
						<td><%=rs.getString("sku")%></td>
						<td><%=rs.getString("quantity")%></td>
						<td><%=rs.getString("price") %>$</td>
					</tr>


				<%
							// calculate the total price
							int quantity = Integer.parseInt(rs.getString("quantity"));
							int price = Integer.parseInt(rs.getString("price"));
							shoppingcarttotal += (quantity*price);
							
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
		<p> Shopping Cart Total: <% out.print(shoppingcarttotal); %>$</p>
	</div>
	
	<br>
	<br>
	<br>
	<div align="center">
	
		<% 
		String error = request.getParameter("error");
		if( error == null)
			error = "";
		%>
		<p> <%= error %> </p>
	</div>
	
	<div style="width:200px;align:center;" align="center" >
		<form action="ShoppingCartCheckout.jsp" method="POST">
			<input class="form-control" id="creditcard" name="creditcard" placeholder="1234 5678 8888" >
			<input type="hidden" name="sku" value="<%out.print(session.getAttribute("username"));%>" />
			<button type="submit" class="btn btn-default">Purchase</button>
		</form>
	</div>
	
	<%					} catch  (Exception ex) {
							System.out.println(ex);
						} %>
						
						

</body>
</html>
