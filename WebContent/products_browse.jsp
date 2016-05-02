<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII" import="com.mit.*,java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Products Page</title>
<meta charset="UTF-8">
<link rel="stylesheet" media="screen" href="css/signup.css">
<link rel="stylesheet" href="css/bootstrap.min.css">

</head>
<body>

	<%@ page import="java.sql.*"%>
	<%
		try {
			// Registering Postgresql JDBC driver
			Class.forName("org.postgresql.Driver");

			// Open a connection to the database
			Connection conn = ConnectionProvider.getCon();		
	%>

	<h1>Products</h1>
	
	<div id="categories" class="table-responsive col-xs-3">
		<table class="table table-bordered">
		<thead>
				<tr>
					<th>Categories</th>
				</tr>
		</thead>
		</tbody>
				<%
					// Create the statement
					
					PreparedStatement categories_stmt = conn.prepareStatement("SELECT * FROM categories ORDER BY name");
					ResultSet categories_rs = categories_stmt.executeQuery();
				%>

				<%-- Iterate over the ResultSet / Presentation code --%>
				<%
					String name = "";
					while (categories_rs.next()) {
						name = categories_rs.getString("name");
						
				%>
				<tr>
					<td>
					<a href="products_browse.jsp?category_search=
					<%
					out.println(name);
					if (request.getParameter("filter") != null)
						out.print("&filter=" + request.getParameter("filter"));
					%>">
					<%out.println(name);%>
					</a>
					</td>
				</tr>
				<%
					}
				%>
				<tr>
					<td>
					<a href="products_browse.jsp?category_search=all
					<%
					if (request.getParameter("filter") != null)
						out.print("&filter=" + request.getParameter("filter"));
					%>
					">
					All
					</a>
					</td>
				</tr>
				<tr>
					<form action="products_browse.jsp" method="get">
						<%
						if (request.getParameter("category_search") != null)
							out.println("<input name='category_search' type='hidden' value='"+ request.getParameter("category_search") +"'/>");
						%>
						<th><input value="" name="filter" size="15" /></th>
						<th><input type="submit" value="Filter" /></th>
					</form>
				</tr>
		</tbody>
		</table>
	</div>

	<div id="display_products" class="table-responsive col-xs-9">
		<table class="table table-bordered">
			<thead>
				<tr>
					<th>Name</th>
					<th>Sku</th>
					<th>Category</th>
					<th>Price</th>
				</tr>
			</thead>
			<tbody>

				<%
					// Create the statement
					String category_param = request.getParameter("category_search");
					String filter_param = request.getParameter("filter");
					if (category_param != null || filter_param != null) {
						String products_sql = "SELECT * FROM products ";
						products_sql += (category_param != null && !"all".equals(category_param))
										?"WHERE category = '" + category_param + "' ":"";
						products_sql += (category_param != null && filter_param != null && !"all".equals(category_param))
										?" AND ":"";
						products_sql += ((category_param == null || "all".equals(category_param)) && filter_param != null)
										?" WHERE ":"";
						products_sql += (filter_param != null)?" name LIKE '%" + filter_param + "%' ":"";
						products_sql += " ORDER BY sku";
						PreparedStatement pstmt = conn.prepareStatement(products_sql);
						ResultSet rs = pstmt.executeQuery();
					
	
				%>

				<%-- Iterate over the ResultSet / Presentation code --%>
				<%
						while (rs.next()) {
				%>
				<tr>
					<th><%=rs.getString("name")%></th>
					<th><%=rs.getString("sku")%></th>
					<th><%=rs.getString("category")%></th>
					<th><%=rs.getString("price")%></th>
					<form action="product_order.jsp" method="POST">
					<input type="hidden" name="url" value="valid" />
					<input type="hidden" name="sku" value"<%=rs.getString("sku")%>"/>
					<th><input type="submit" name="action" value="order" /></th>
					</form>
				</tr>


				<%
						}
						// Close the ResultSet
						rs.close();
						// Close the Statement
						pstmt.close();
						// Close the Connection
						conn.close();
						
						}
					} catch  (Exception ex) {
						System.out.println(ex);
					}
					
				%>

			</tbody>
		</table>
	</div>

</body>
</html>



