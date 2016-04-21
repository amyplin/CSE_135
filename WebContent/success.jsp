<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII" import="com.mit.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>Insert title here</title>
</head>
<body>

<jsp:useBean id="obj" class="com.mit.CustomerBean"/>
<jsp:setProperty property="*" name="obj"/>

<%
int status = CustomerDAO.insertCustomer(obj);
if (status>0)
	out.println("You have successfully signed up!");
else
	out.println("Insertion fail");
%>


</body>
</html>