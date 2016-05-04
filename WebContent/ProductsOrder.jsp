<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII" import="com.mit.*,java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<link rel="stylesheet" media="screen" href="css/categories.css">
<link rel="stylesheet" href="css/bootstrap.min.css">

<title>Add To Cart</title>
</head>
<body>

<jsp:useBean id="obj" class="com.mit.ProductBean"/>
<jsp:setProperty property="*" name="obj"/>


<%@ page import="java.sql.*"%>
<%

	try{
		//create connections to the database
		Connection conn = ConnectionProvider.getCon();
		
		String sku = request.getParameter("sku");
		String valid = request.getParameter("url");
		
		PreparedStatement newProduct = conn.prepareStatement("select * from products where sku=?");
		newProduct.setString(1, sku);
		ResultSet productinfo = newProduct.executeQuery();
		
		if(!productinfo.next())
		{

			if (valid == null) {
				%>
				 <div class="title">
				  <h1>Please Select A Product From The Product Browsing Page</h1>
				 </div>
			<%
			} else {
				%>
				 <div class="title">
				  <h1>Sorry, this item is no longer available!</h1>
				 </div>
				 
	<%
			}
		}else
		{
%>
			 <div class="title">
			  <h1>Select Quantity To Add To Cart</h1>
			 </div>






	<div class="container">
		<table class="table table-bordered">
			<thead>
				<tr>
					<th>Item</th>
					<th>Category</th>
					<th>Price</th>
					<th>Quantity</th>
				</tr>
			</thead>
			
			<tbody>
				<tr>
					<td><%=productinfo.getString("name")%></td>
					<td><%=productinfo.getString("category")%></td>
					<td><%=productinfo.getString("price")%></td>
					<td>
						<form action="ProductsOrderInsert.jsp" method="POST" id="form1">
							<input type="quantity" class="form-control" id="quantity" name="quantity" value="1">
							<input type="hidden" name="sku" value="<%out.print(sku);%>" />
						</form>
					
					</td>
				</tr>
			
			</tbody>
		
		</table>
	</div>
	<div align="center">
	
	<% 
	String error = request.getParameter("error");
	if( error == null)
		error = "";
	%>
		<p> <%= error %> </p>
	</div>
	<div align="center">
		<button type="submit" class="btn btn-default" form="form1">Add To Cart</button>

		<form action="products_browse.jsp" method="POST">
			<button type="submit" class="btn btn-default">Cancel Item</button>
		</form>
	</div>
	

<% 			
		}//end of else statement 
%>

<br>
<br>
<br>
 <div class="title">
  <h1>Current Cart for <%=session.getAttribute("username") %></h1>
</div>
	<div class="container">
		<table class="table table-bordered">
			<thead>
				<tr>
					<th>Item</th>
					<th>Category</th>
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
						<td><%=rs.getString("category")%></td>
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
	

	
	<%



	
	} catch  (Exception ex) {
		System.out.println(ex);
	} %>

</body>
</html>
