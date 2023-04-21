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
        out.println(session1.getAttribute("loggedIn"));
		String listed = request.getParameter("listed");
		%>
        <script>
            let listed = "<%= listed %>";
        
            if (listed === "failure") {
                alert("Vehicle ID already exists, please enter a different ID");
            } else if (listed === "success") {
                alert("Vehicle listed successfully");
            }
        </script>
		<header>
			<a href="index.jsp">
				<h1>ShopFinity</h1>
			</a>
			<div class="nav-container">
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
			</div>
		</header>
	
    <% if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn")) { %>
        <h1>Create Vehicle Listing</h1>
        <form action="createlisting.jsp" method="POST">
            <label for="vehicle_id">Vehicle ID:</label>
            <input type="number" id="vehicle_id" name="vehicle_id" required><br><br>
        
            <label for="vehicle_name">Vehicle Name:</label>
            <input type="text" id="vehicle_name" name="vehicle_name" maxlength="25" required><br><br>
        
            <label for="vehicle_type">Vehicle Type:</label>
            <input type="text" id="vehicle_type" name="vehicle_type" maxlength="10"><br><br>
            
            <label for="listing_price">Listing Price:</label>
            <input type="number" id="listing_price" name="listing_price" required><br><br>
            
            <label for="min_price">Minimum Price:</label>
            <input type="number" id="min_price" name="min_price" required><br><br>
            
            <label for="min_inc">Minimum Increment:</label>
            <input type="number" id="min_inc" name="min_inc" required><br><br>
        
            <input type="submit" value="Submit">
        </form> 
    <% }
    else {%>
        <div class="message">You first need to login before you can sell cars!</div>
    <%} %>


</body> 
</html>
