<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.Properties" %>

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
		%>
		<header class="navbar navbar-expand-lg navbar-dark bg-primary py-3">
        <div class="container">
            <a href="index.jsp" class="navbar-brand text-decoration-none">
                <h1 class="text-white">ShopFinity</h1>
            </a>
            <div class="navbar-text text-white">
            <% if (session1.getAttribute("user") != null) { %>
                <small>Hello <%= session1.getAttribute("user") %>!</small>
            <% } else { %>
                <small>Hello Guest!</small>
            <% } %>
        	</div>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <% if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn")) { 
                    	if (session1.getAttribute("role_id").equals(1)){%>
                    	<li class="nav-item">
                            <a href="reps.jsp" class="nav-link">Representatives</a>
                        </li>
                        <% } 
                        if (session1.getAttribute("role_id").equals(2)){%>
                        <li class="nav-item">
                            <a href="answerquestions.jsp" class="nav-link">Answer Questions</a>
                        </li>
                        <% } 
                        if (session1.getAttribute("role_id").equals(3)){%>
                        <li class="nav-item">
                            <a href="askquestions.jsp" class="nav-link">Ask Questions</a>
                        </li>
                        <% } %>
                        <li class="nav-item">
                            <a href="mylistings.jsp" class="nav-link">My Listings</a>
                        </li>
                        <li class="nav-item">
                            <a href="sell.jsp" class="nav-link">Sell</a>
                        </li>
                        <li class="nav-item">
                            <a href="logout.jsp" class="nav-link">Sign Out</a>
                        </li>
                    <% } else { %>
                        <li class="nav-item">
                            <a href="login.jsp" class="nav-link">Log In</a>
                        </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </header>
    <div class="container">
    <div class="row">
        <div class="col-md-12">
            <h2 class="text-center mt-4 mb-3">Your Questions</h2>

            <table class="table table-bordered table-hover">
                <thead>
                    <tr>
                        <th>Question</th>
                        <th>Answer</th>
                        <th>Representative ID</th>
                        <th>Asked Datetime</th>
                        <th>Answered Datetime</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String user_id = (String) session1.getAttribute("user");

                        // Load the MySQL driver
                        Class.forName("com.mysql.jdbc.Driver");

                        // Connect to the database
                        Properties props = new Properties();
                        FileInputStream in = new FileInputStream(getServletContext().getRealPath("/resources/database.properties"));
                        props.load(in);
                        in.close();
                        String url = props.getProperty("db.url");
                        String username = props.getProperty("db.username");
                        String pswd = props.getProperty("db.password");
                        Connection conn = DriverManager.getConnection(url, username, pswd);

                        // Prepare the SQL query
                        String query = "SELECT * FROM Questions WHERE customer_id = ?";
                        PreparedStatement ps = conn.prepareStatement(query);
                        ps.setString(1, user_id);

                        // Execute the query
                        ResultSet rs = ps.executeQuery();

                        // Iterate through the result set and display the questions and answers
                        while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getString("question") %></td>
                        <td><%= rs.getString("answer") != null ? rs.getString("answer") : "Not Answered" %></td>
                        <td><%= rs.getString("representative_id") != null ? rs.getString("representative_id") : "Not Answered" %></td>
                        <td><%= rs.getTimestamp("asked_datetime") %></td>
                        <td><%= rs.getTimestamp("answered_datetime") %></td>
                    </tr>
                    <%
                        }
                        // Close the database connection
                        conn.close();
                    %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>