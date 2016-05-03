<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII" import="com.mit.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>Home</title>
</head>
<body>

<jsp:useBean id="obj" class="com.mit.CustomerBean"/>
<jsp:setProperty property="*" name="obj"/>

<% if (session.getAttribute("loggedIn") == null) { %>
<div class="title">
	<h1>No user logged in</h1>
</div>
<% } else { %>
 <div class="title">
  <h1>Hello <%= session.getAttribute("username") %></h1>
</div>
<% } %>

<%--  <% 
	if (session.getAttribute("role").equals("Owner")) {
%> --%>

<ul>
    <li><a href="Categories.jsp">Categories</a></li>
    <li><a href="products.jsp">Products</a></li>
    <li><a href="ShoppingCart.jsp">Shopping Cart</a></li>
    
</ul>

<%-- <% } else { %>

<ul>
    <li><a href="#">Product Browsing</a></li>
</ul>

<% } %> --%>

</body>
</html>