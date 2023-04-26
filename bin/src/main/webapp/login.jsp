<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<html> 
<head>
	<title>Login Page</title>
	<link rel="stylesheet" href="${contextPath}/resources/style2.css" type = "text/css">
	<link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700&display=swap" rel="stylesheet">
</head>
<body>
		<%
			HttpSession session1 = request.getSession();
			String signup = request.getParameter("signup");
			if (signup != null && signup.equals("success")) {
		        if ((Boolean) session1.getAttribute("signedUp") == true){
		        	 session1.setAttribute("signUpMessage", null);
		        }
		        else if ((Boolean) session1.getAttribute("signedUp")==false) {
		        	session1.setAttribute("signedUp", true);
		        	session1.setAttribute("signUpMessage", "Successfully signed up!");
		        }
		    }
		%>
		<div class="main">
		<header>
			<a href="index.jsp">
				<h1>ShopFinity</h1>
			</a>
			<% if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn")) { %>
			<a href = "logout.jsp">
				<span style="float:right;">Sign Out</span>
			</a>
			<% } %>
		</header>
		<div class="container">

			<h1>Login</h1>
			
			<%
			
				String signUpMessage = (String) session1.getAttribute("signUpMessage");
			    if (signUpMessage != null) {
			        out.println("<div class=\"message\">" + signUpMessage + "</div>");
			    }
			%>
			<%
				String error = request.getParameter("error");
				
				if (error != null && error.equals("invalid")) {
				    out.println("<div class=\"message\">Invalid email or password</div>");
				}
			%>
			<% if (session1.getAttribute("loggedIn") == null || (Boolean) session1.getAttribute("loggedIn") == false) { %>
			<form action = "loginvalidate.jsp" method = "post">
				<input class="input-field" type="email" id="email" name="email" placeholder="Enter your email" required>
				<input class="input-field" type="password" id="password" name="password" placeholder="Enter your password" required>
	
				<a href="signup.jsp">Don't have an account? Create One.</a>
	
				<input type="submit" value="Login">
			</form>
			<% } else { %>
			<div class="message"> You are already signed in!</div>
			<% } %>
		</div>
		</div>
	</body> 
</html>
