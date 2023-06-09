<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<html> 
<head>
	<title>Index</title>
	<link rel="stylesheet" href="${contextPath}/resources/style2.css" type = "text/css"> 
	<link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700&display=swap" rel="stylesheet">
</head>
<body>
		<%
		HttpSession session1 = request.getSession();
		String login = request.getParameter("login");
		if (login != null && login.equals("success")) {
	        if ((Boolean) session1.getAttribute("loggedIn") == true){
	        	 session1.setAttribute("loginMessage", null);
	        }
	        else if ((Boolean) session1.getAttribute("loggedIn")==false) {
	        	session1.setAttribute("loggedIn", true);
	        	session1.setAttribute("loginMessage", "Successfully logged in!");
	        }
	    }
		%>
		<header>
			<a href="index.jsp">
				<h1>ShopFinity</h1>
			</a>
			<span style="float:right;">
				<% if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn")) { %>
			<a href = "logout.jsp">
				Sign Out
			</a>
			<% } 
				else {%>
				<a href = "login.jsp">
					Log In
				</a>
			<%} %>
			</span>
		</header>
	<%
		
		String loginMessage = "";
		loginMessage = (String) session1.getAttribute("loginMessage");
	    if (loginMessage != null) {
	        out.println("<div class=\"message\">" + loginMessage + "</div>");
	    }
	%>
</body> 
</html>
