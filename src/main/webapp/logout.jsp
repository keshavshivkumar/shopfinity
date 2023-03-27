<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<html> 
<head>
	<title>Login Page</title>
	<link rel="stylesheet" href="${contextPath}/resources/style.css" type = "text/css"> 
</head>
<body>
		<%
		HttpSession session1 = request.getSession();
		%>
		<header>
			<a href="index.jsp">
				<h1>ShopFinity</h1>
			</a>
		</header>
		<div class = "signup">Successfully logged out!</div>
		<%
		    session1.setAttribute("loggedIn", false);
		response.sendRedirect("login.jsp");
		%>
</body> 
</html>
