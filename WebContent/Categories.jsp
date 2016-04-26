<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<!DOCTYPE html>
<html>
<head>
<title>Hello</title>
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
			Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5433/postgres", "postgres",
					"alin");
	%>

	<h1>Categories</h1>

	<div class="container">
		<table class="table table-bordered">
			<thead>
				<tr>
					<th>Name</th>
					<th>Description</th>
					<th>Buttons</th>
				</tr>
				<tr>
					<form action="Categories.jsp" method=”POST">
						<input type="hidden" name="action" value="insert" />
						<th><input value="" name="name" size="15" /></th>
						<th><input value="" name="description" size="15" /></th>
						<th><input type="submit" value="Insert" /></th>
					</form>
				</tr>

				<%
					String action = request.getParameter("action");
						if (action != null && action.equals("insert")) {

							PreparedStatement pstmt = conn
									.prepareStatement("INSERT INTO categories (name, description) VALUES (?, ?)");
							pstmt.setString(1, request.getParameter("name"));
							pstmt.setString(2, request.getParameter("description"));
							int rowCount = pstmt.executeUpdate();
						}
				%>

			</thead>
			<tbody>

				<%
					// Create the statement
					
					PreparedStatement pstmt = conn
									.prepareStatement("select * from categories");
					ResultSet rs = pstmt.executeQuery();
/* 					Statement theStatement = conn.createStatement();
					ResultSet rs = theStatement.executeQuery("select * from categories"); */
	
				%>

				<%-- Iterate over the ResultSet / Presentation code --%>
				<%
					while (rs.next()) {
				%>
				<tr>

					<td><%=rs.getString("name")%></td>
					<td><%=rs.getString("description")%></td>
				</tr>


				<%
					}
					// Close the ResultSet
						rs.close();
						// Close the Statement
						/* theStatement.close(); */
						pstmt.close();
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



