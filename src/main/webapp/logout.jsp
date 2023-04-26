<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<html> 
<head>
	<title>Login Page</title>
	<link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
	<link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700&display=swap" rel="stylesheet">
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
			session1.setAttribute("user", null);
		response.sendRedirect("login.jsp");
		%>
</body> 
</html>
