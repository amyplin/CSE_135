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
    String quantity = request.getParameter("quantity");
	if(quantity != null)
		quantity.replaceAll("\\s","");
    String sku = request.getParameter("sku");
    if("".equals(quantity) )
    {
        response.sendRedirect("ProductsOrder.jsp?sku="+ sku + "&error=please%20enter%20a%20quantity");
    } else {
    try { 
        int quantity_int = Integer.parseInt(quantity);
        if( quantity_int < 1 )
        {
            response.sendRedirect("ProductsOrder.jsp?sku="+ sku + "&error=please%20enter%20a%20quantity%20of%201%20or%20more");
        } else {
        
            String inserterror = CustomerDAO.addToCart(session.getAttribute("username").toString(), quantity_int, sku);
            if( inserterror != "" )
                response.sendRedirect("ProductsOrder.jsp?sku="+ sku + "&error=" + inserterror);
            else
                response.sendRedirect("products_browse.jsp");
        }
        
    } catch(NumberFormatException e) { 
        response.sendRedirect("ProductsOrder.jsp?sku="+ sku + "&error=please%20enter%20a%20valid%20number");
    } catch(Exception ex) {
        System.out.println(ex);
    } 
    }
%>
</body>
</html>