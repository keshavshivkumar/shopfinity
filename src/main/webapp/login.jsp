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
		<div class="container">
    <header class="navbar navbar-expand-lg navbar-dark bg-primary py-3">
    <div class="container">
        <a href="index.jsp" class="navbar-brand text-decoration-none">
            <h1 class="text-white">ShopFinity</h1>
        </a>
        <% if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn")) { %>
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a href="logout.jsp" class="nav-link">Sign Out</a>
                </li>
            </ul>
        <% } %>
    </div>
</header>



    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card mt-4">
                <div class="card-body">
                    <h1 class="card-title text-center">Login</h1>
                    <hr>
                    <%
                        String signUpMessage = (String) session1.getAttribute("signUpMessage");
                        if (signUpMessage != null) {
                    %>
                        <div class="alert alert-info" role="alert">
                            <%= signUpMessage %>
                        </div>
                    <% }
                    %>
                    <%
                        String error = request.getParameter("error");
                        if (error != null && error.equals("invalid")) {
                    %>
                        <div class="alert alert-danger" role="alert">
                            Invalid email or password
                        </div>
                    <% }
                    %>
                    <% if (session1.getAttribute("loggedIn") == null || (Boolean) session1.getAttribute("loggedIn") == false) { %>
                        <form action="loginvalidate.jsp" method="post">
                            <div class="form-group">
                                <label for="email">Email address:</label>
                                <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
                            </div>
                            <div class="form-group">
                                <label for="password">Password:</label>
                                <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                            </div>

                            <div class="text-center">
                                <a href="signup.jsp">Don't have an account? Create One.</a>
                                <br>
                                <br>
                                <button type="submit" class="btn btn-primary">Login</button>
                            </div>
                        </form>
                    <% } else { %>
                        <div class="alert alert-info" role="alert">
                            You are already signed in!
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>
		
	</body> 
</html>
