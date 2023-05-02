<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Properties" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


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
	String userEmail = "";
	if (session1.getAttribute("user") != null) {
	    userEmail = session1.getAttribute("user").toString();
	}

    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;
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
                            <a href="salesreports.jsp" class="nav-link">Reports</a>
                        </li>
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
                        <li class="nav-item">
                            <a href="yourquestions.jsp" class="nav-link">Your Questions</a>
                        </li>
                        <% } %>
                        <li class="nav-item">
                            <a href="allquestions.jsp" class="nav-link">All Questions</a>
                        </li>
                        <li class="nav-item">
                            <a href="mylistings.jsp" class="nav-link">My Listings</a>
                        </li>
                        <li class="nav-item">
                            <a href="mybids.jsp" class="nav-link">My Bids</a>
                        </li>
                        <li class="nav-item">
                            <a href="sell.jsp" class="nav-link">Sell</a>
                        </li>
                        <li class="nav-item">
                            <a href="notifications.jsp" class="nav-link">Notifications</a>
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
    <% if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn")) { %>
    <div class="container mt-4">
    <h2>Browse Vehicles</h2>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Vehicle ID</th>
                <th>Vehicle Name</th>
                <th>Vehicle Model</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <%
                

                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    Properties props = new Properties();
                    FileInputStream in = new FileInputStream(getServletContext().getRealPath("/resources/database.properties"));
                    props.load(in);
                    in.close();
                    String url = props.getProperty("db.url");
                    String username = props.getProperty("db.username");
                    String pswd = props.getProperty("db.password");
                    connection = DriverManager.getConnection(url, username, pswd);
                    preparedStatement = connection.prepareStatement("SELECT V.vehicle_id, V.vehicle_name, V.vehicle_model FROM Vehicles AS V LEFT JOIN Listings AS L ON V.vehicle_id = L.vehicle_id WHERE L.vehicle_id IS NULL");
                    resultSet = preparedStatement.executeQuery();

                    while (resultSet.next()) {
            %>
            <tr>
                <td><%= resultSet.getInt("vehicle_id") %></td>
                <td><%= resultSet.getString("vehicle_name") %></td>
                <td><%= resultSet.getString("vehicle_model") %></td>
                <td>
                    <form action="addToWishlist.jsp" method="POST">
                        <input type="hidden" name="vehicle_id" value="<%= resultSet.getInt("vehicle_id") %>">
                        <button type="submit" class="btn btn-primary">Add to Wishlist</button>
                    </form>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (resultSet != null) resultSet.close();
                    if (preparedStatement != null) preparedStatement.close();
                    if (connection != null) connection.close();
                }
            %>
        </tbody>
    </table>
</div>
<% } else { %>
        <div class="row">
            <div class="col-md-12 text-center mt-4">
                <div class="alert alert-warning">You first need to log in to view all the questions!</div>
            </div>
        </div>
    <% } %>