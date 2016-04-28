<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII" import="com.mit.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>Login</title>
</head>
<body>

<jsp:useBean id="obj" class="com.mit.CustomerBean"/>
<jsp:setProperty property="*" name="obj"/>

	<%
		String username = null;
		String role = CustomerDAO.signinCustomer(obj);
		username = request.getParameter("username");
		session.setAttribute("username", username);
		session.setAttribute("role", role);
		
		if (!role.equals(null)) {
			session.setAttribute("error", "false");
			response.sendRedirect("Home.jsp");
		} else
			response.sendRedirect("LoginError.jsp");
	%>

</body>
</html>