<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII" import="com.mit.*,java.util.*"%>
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
ArrayList<String> error = CustomerDAO.insertProduct(obj);
if (!error.isEmpty()) {
	session.setAttribute("product_error", error);
	session.setAttribute("success_msg", new ArrayList<String>());
	
	response.sendRedirect(request.getParameter("ret_url"));
}
else {
	ArrayList<String> success_msg = new ArrayList<String>();
	success_msg.add("Successfully added product!");
	success_msg.add("<li>" + "Name: " + request.getParameter("name") + "</li>");
	success_msg.add("<li>" + "Sku: " + request.getParameter("sku") + "</li>");
	success_msg.add("<li>" + "Category: " + request.getParameter("category") + "</li>");
	success_msg.add("<li>" + "Price: " + request.getParameter("price") + "</li>");
	
	session.setAttribute("product_error", new ArrayList<String>());
	session.setAttribute("success_msg", success_msg);
	
	response.sendRedirect(request.getParameter("ret_url"));
}
%>
</body>
</html>