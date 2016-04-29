<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<!DOCTYPE html>
<html>
<head>
<title>Hello</title>
<meta charset="UTF-8">
<link rel="stylesheet" media="screen" href="css/categories.css">
<link rel="stylesheet" href="css/bootstrap.min.css">

</head>
<body>
 <div class="title">
  <h1>Hello <%= session.getAttribute("username") %></h1>
</div>

	<%@ page import="java.sql.*"%>
	<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
		try {
			// Registering Postgresql JDBC driver
			Class.forName("org.postgresql.Driver");

			// Open a connection to the database
			conn = DriverManager.getConnection("jdbc:postgresql://localhost:5433/postgres", "postgres",
					"alin");
			
	%>

	<h2>Categories</h2>
	<br>
	<ul>
		<li><a href="Categories.jsp">Categories</a></li>
		<li><a href="#">Products</a></li>
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
										
						if (action != null && action.equals("insert")) {
							PreparedStatement pstmtCheck = null;
							pstmtCheck = conn.prepareStatement("select * from username2 where username=?");
							pstmtCheck.setString(1, request.getParameter("name"));
							ResultSet theResult = pstmtCheck.executeQuery();
System.out.println("hello");
							if (theResult.next()) {
								System.out.println("duplicate");
								session.setAttribute("error", "true");
								response.sendRedirect("Categories.jsp");
							} else if (request.getParameter("name").equals("")
									|| request.getParameter("description").equals("")) {
								session.setAttribute("error", "true");
								response.sendRedirect("Categories.jsp");
							} else {
								conn.setAutoCommit(false);
								pstmt = conn
										.prepareStatement("INSERT INTO categories (name, description,count) VALUES (?, ?,?)");

								pstmt.setString(1, request.getParameter("name"));
								pstmt.setString(2, request.getParameter("description"));
								pstmt.setInt(3, 0);

								int rowCount = pstmt.executeUpdate();
								conn.commit();
								conn.setAutoCommit(true);

							}
						}

						// Check if a delete is requested
						if (action != null && action.equals("delete")) {
							conn.setAutoCommit(false);
							pstmt = conn.prepareStatement("DELETE FROM categories WHERE name = ?");
							pstmt.setString(1, request.getParameter("name"));
							int rowCount = pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);
						}

						// Check if an update is requested
						if (action != null && action.equals("update")) {

							conn.setAutoCommit(false);
							pstmt = conn.prepareStatement("UPDATE categories SET name=?, description = ? WHERE name = ?");
							pstmt.setString(1, request.getParameter("name"));
							pstmt.setString(2, request.getParameter("description"));
							pstmt.setString(3, request.getParameter("origName"));
							int rowCount = pstmt.executeUpdate();

							conn.commit();
							conn.setAutoCommit(true);
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




</body>
</html>



