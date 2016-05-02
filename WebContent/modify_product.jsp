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
String action = request.getParameter("action");
String sku = request.getParameter("sku_id");
String ret_url = request.getParameter("ret_url");

ArrayList<String> error = new ArrayList<String>();

if ("Insert".equals(action))
	error = CustomerDAO.insertProduct(obj);
else if ("Update".equals(action))
	error = CustomerDAO.updateProduct(obj, sku);
else if ("Delete".equals(action))
	error = CustomerDAO.deleteProduct(sku, request.getParameter("category"));

if (!error.isEmpty()) {
	if ("Insert".equals(action))
		error.add(0, "Failure to insert product...");
	else if ("Update".equals(action))
		error.add(0, "Failure to update product...");
	else if ("Delete".equals(action))
		error.add(0, "Failure to delete product...");
	
	session.setAttribute("product_error", error);
	session.setAttribute("success_msg", new ArrayList<String>());
} else {
	ArrayList<String> success_msg = new ArrayList<String>();
	if ("Insert".equals(action))
		success_msg.add("Successfully added product!");
	else if ("Update".equals(action))
		success_msg.add("Successfully updated product!");
	else if ("Delete".equals(action))
		success_msg.add("Successfully deleted product!");
	
	success_msg.add("<li>" + "Name: " + request.getParameter("name") + "</li>");
	success_msg.add("<li>" + "Sku: " + request.getParameter("sku") + "</li>");
	success_msg.add("<li>" + "Category: " + request.getParameter("category") + "</li>");
	success_msg.add("<li>" + "Price: " + request.getParameter("price") + "</li>");
	
	session.setAttribute("product_error", new ArrayList<String>());
	session.setAttribute("success_msg", success_msg);
}

response.sendRedirect(ret_url);
%>
</body>
</html>