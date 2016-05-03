<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII" import="com.mit.*,java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Hello</title>
<meta charset="UTF-8">
<link rel="stylesheet" media="screen" href="css/categories.css">
<link rel="stylesheet" href="css/bootstrap.min.css">

<jsp:useBean id="obj" class="com.mit.CategoryBean"/>
<jsp:setProperty property="*" name="obj"/>

</head>
<body>


<% if (session.getAttribute("loggedIn") == null) { %>
<div class="title">
	<h1>No user logged in</h1>
</div>
<% } else { %>
 <div class="title">
  <h1>Hello <%= session.getAttribute("username") %></h1>
</div>



	<%@ page import="java.sql.*, javax.sql.*, javax.naming.*"%>
	<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	
	try {
		 
		Class.forName("org.postgresql.Driver");
		// Open a connection to the database
		conn = ConnectionProvider.getCon();
		
	%>

	<h2>Categories</h2>
	<br>
	<ul>
		<li><a href="Categories.jsp">Categories</a></li>
		<li><a href="products.jsp">Products</a></li>
	</ul>
<% 

		if (session.getAttribute("error").equals("true")) {
			session.setAttribute("error", "false");
	%>
	<h3>Data Modification Failure*</h3><br>
	
	<% } %>
	
	

	<div class="container">
		<table class="table table-bordered">
			<thead>
				<tr>
					<th>Name</th>
					<th>Description</th>
					<th></th>
				</tr>
				<tr>
					<form action="Categories.jsp" method=”POST">
						<input type="hidden" name="action" value="insert"
							autocomplete="off" />
						<th><input value="" name="name" size="15" autocomplete="off" /></th>
						<th><input value="" name="description" size="15"
							autocomplete="off" /></th>
						<th><input type="submit" value="Insert" autocomplete="off" /></th>
					</form>
				</tr>

				<%
					String action = request.getParameter("action");
									PreparedStatement theStatement = null;

									if (action != null && action.equals("insert")) {

										String name = request.getParameter("name");
										String description = request.getParameter("description");

										if (!CustomerDAO.insertCategory(obj, name, description)) {
											session.setAttribute("error", "true");
											response.sendRedirect("Categories.jsp");
										}
									}

									// Check if a delete is requested
									if (action != null && action.equals("delete")) {

										String name = request.getParameter("name");

										if (!CustomerDAO.deleteCategory(obj, name)) {
											session.setAttribute("error", "true");
											response.sendRedirect("Categories.jsp");
										}
									}

							// Check if an update is requested
							if (action != null && action.equals("update")) {

								String name = request.getParameter("name");
								String description = request.getParameter("description");
								String origName = request.getParameter("origName");

								if (!CustomerDAO.updateCategory(obj, origName, name, description)) {
									session.setAttribute("error", "true");
									response.sendRedirect("Categories.jsp");
								}
							}
				%>

			</thead>
			<tbody>

				<%
					// Create the statement
							Statement statement = conn.createStatement();
							rs = statement.executeQuery("select * from categories");
				%>

				<%-- Iterate over the ResultSet / Presentation code --%>
				<%
					while (rs.next()) {
				%>

				<tr>
					<form action="Categories.jsp" method="POST">
						<input type="hidden" name="action" value="update" /> <input
							type="hidden" name="origName" value=<%=rs.getString("name")%> />

						<td><input value="<%=rs.getString("name")%>" name="name"
							size="15" /></td>
						<td><input value="<%=rs.getString("description")%>"
							name="description" size="15" /></td>

						<td><input type="submit" value="Update"></td>

					</form>

					<%
					if (rs.getInt("count") <= 0) {
				%>
					<form action="Categories.jsp" method="POST">
						<input type="hidden" name="action" value="delete" /> <input
							type="hidden" value="<%=rs.getString("name")%>" name="name" />
						<td><input type="submit" value="Delete" /></td>
					</form>
				</tr>

				<%
					}
					}
						// Close the ResultSet
						rs.close();
						statement.close();
						// Close the Connection
						conn.close();
					} catch (SQLException e) {

						// Wrap the SQL exception in a runtime exception to propagate
						// it upwards
						throw new RuntimeException(e);
					}
				%>

			</tbody>
		</table>
	</div>


<% } %>

</body>
</html>



