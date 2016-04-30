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
					
					PreparedStatement categories_stmt = conn.prepareStatement("SELECT * FROM categories");
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
					<a href="products.jsp?category_search=
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
					<a href="products.jsp?category_search=all">
					All
					</a>
					</td>
				</tr>
				<tr>
					<form action="products.jsp" method="get">
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
				<tr>
					<%
					//get categories
					categories_rs = categories_stmt.executeQuery();
					String ret_url = request.getRequestURL() + "?" + request.getQueryString();
					%>
				
					<form action="insert_product.jsp" method="POST">
						<input type="hidden" name="ret_url" value="<%out.print(ret_url);%>" />
						<th><input value="" id="name" name="name" size="15" /></th>
						<th><input value="" id="sku" name="sku" size="15" /></th>
						<th>
						<select class="form-control" id="category" name="category">
						<%
						while (categories_rs.next()) {
							out.println("<option value='" + categories_rs.getString("name") + "'>" + 
										categories_rs.getString("name") + "</option>");
						}
						
						categories_stmt.close();
						categories_rs.close();
						%>
						</select>
						</th>
						<th><input value="" id="price" name="price" size="15" /></th>
						<th><input type="submit" value="Insert" /></th>
					</form>
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
						PreparedStatement pstmt = conn.prepareStatement(products_sql);
						ResultSet rs = pstmt.executeQuery();
					
	
				%>

				<%-- Iterate over the ResultSet / Presentation code --%>
				<%
						while (rs.next()) {
				%>
				<tr>
					<td><%=rs.getString("name")%></td>
					<td><%=rs.getString("sku")%></td>
					<td><%=rs.getString("category")%></td>
					<td><%=rs.getString("price")%></td>
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

<div style="margin:0 auto; width:45%;">
<%
ArrayList<String> error = (ArrayList<String>)session.getAttribute("product_error");
if (error == null)
	error = new ArrayList<String>();
	
if (!(error.isEmpty())) {
	out.println("<li>Failure to insert product</li>");
	for (String s : error) {
		out.println("<li>" + s + "</li>");
	}
} else {
	ArrayList<String> success_msg = (ArrayList<String>)session.getAttribute("success_msg");
	if (success_msg == null)
		success_msg = new ArrayList<String>();
		
	for (String s : success_msg) {
		out.println(s);
	}
}

session.setAttribute("product_error", new ArrayList<String>());
session.setAttribute("success_msg", new ArrayList<String>());
%>
</div>

</body>
</html>



