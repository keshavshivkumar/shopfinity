<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
	<title>Signup Page</title>
	<link rel="stylesheet" href="${contextPath}/resources/style2.css" type = "text/css">
	<link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700&display=swap" rel="stylesheet">
</head>

<body>
	<a href="index.jsp">
			<header>
					<h1>ShopFinity</h1>
			</header>
		</a>
	<div class="container_s">
		
			<h1>Sign up</h1>
			<%
				String error = request.getParameter("error");
				
				if (error != null && error.equals("invalid")) {
				    out.println("<div class=\"message\">Invalid email or password! </div>");
				}
			%>
			
			<form action = "validate.jsp" method = "post">
				<input class="input-field" type="text" id="fullname" name="full_name" placeholder="Full Name" required>
				<input class="input-field" type="email" id="email" name="email_id" placeholder="Email" required>
				<input class="input-field" type="tel" id="mobile" name="ph_no" placeholder="Mobile Number" required>
				<input class="input-field" type="password" id="password" name="passwd" placeholder="Password" required>
 
	
	      		<span id="password-requirements"></span>  
	
				<label for="show-password">
					<input type="checkbox" id="show-password">
					Show Password
				</label>
	
	      		<a href="login.jsp">Already have an account? Login.</a>
		
				<input type="submit" value="Sign up">
			</form>
	</div>
  <script src="${contextPath}/resources/functionality.js"></script>
</body>
</html>