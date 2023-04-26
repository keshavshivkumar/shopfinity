<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<html> 
<head>
	<title>Index</title>
	<link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
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
		<header class="bg-light py-3">
			<div class="container">
				<div class="d-flex justify-content-between align-items-center">
					<a href="index.jsp" class="text-decoration-none">
						<h1 class="text-dark">ShopFinity</h1>
					</a>
					<nav class="nav">
						<% if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn")) { %>
						<a href="sell.jsp" class="nav-link">Sell</a>
						<a href="logout.jsp" class="nav-link">Sign Out</a>
						<% } else { %>
						<a href="login.jsp" class="nav-link">Log In</a>
						<% } %>
					</nav>
				</div>
			</div>
		</header>
	<%
		String loginMessage = "";
	    loginMessage = (String) session1.getAttribute("loginMessage");
	    if (loginMessage != null) {
	        out.println("<div class='alert alert-info mt-3'>" + loginMessage + "</div>");
	        session1.setAttribute("loginMessage", null);
	    }
	%>
	<% if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn")) { %>
	  <div class="container">
	  	<div class="input-group my-3">
	      <input type="text" id="search-input" class="form-control" placeholder="Search..." onkeyup="searchFunction()">
	      <button class="btn btn-primary" type="button">Search</button>
	    </div>
	    <ul id="search-results" class="list-unstyled"></ul>
	  </div>
	<% } %>
<script src="${contextPath}/resources/searchbar.js"></script>
</body> 
</html>
