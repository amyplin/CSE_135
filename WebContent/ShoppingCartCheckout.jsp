<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII" import="com.mit.*,java.util.*,java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>Insert title here</title>
</head>
<body>

<jsp:useBean id="obj" class="com.mit.ProductBean"/>
<jsp:setProperty property="*" name="obj"/>

<%
	String username = request.getParameter("username");
	String creditcard = request.getParameter("creditcard").trim();
	if(creditcard == "")
	{
		response.sendRedirect("ShoppingCart.jsp?error=please%20enter%20a%20creditcard");
	} else {
		String checkouterror = CustomerDAO.checkout(username, creditcard);
		if( checkouterror != "" )
		{
			response.sendRedirect("ShoppingCart.jsp?error=" + checkouterror);
		} else {
			response.sendRedirect("OrderConfirmation.jsp?username=" + username);
		} 
	}


%>
</body>
</html>