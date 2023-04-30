<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.Properties" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<html> 
<head>
	<title>My Bids</title>
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
        <nav class="navbar-nav ms-auto">
            <% if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn")) { %>
                
             
                <li class="nav-item">
                    <a href="sell.jsp" class="nav-link">Sell</a>
                </li>
                <% if (session1.getAttribute("role_id").equals(3)){%>
                		<li class="nav-item">
                            <a href="mylistings.jsp" class="nav-link">My Listings</a>
                        </li>
                        <li class="nav-item">
                            <a href="askquestions.jsp" class="nav-link">Ask Questions</a>
                        </li>
                        <li class="nav-item">
                            <a href="yourquestions.jsp" class="nav-link">Your Questions</a>
                        </li>
                        <% } %>
                <li class="nav-item">
                    <a href="logout.jsp" class="nav-link">Sign Out</a>
                </li>
            <% } else { %>
                <li class="nav-item">
                    <a href="login.jsp" class="nav-link">Log In</a>
                </li>
            <% } %>
        </nav>
    </div>
</header>
<div class="container">
    <% if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn")) { %>
        <h2 class="mt-4 mb-3">My Listings</h2>
        <table class="table table-bordered">
            <thead>
                <tr>
                    
                    <th>Vehicle Name</th>
                    <th>Vehicle Model</th>
                    <th>License Plate</th>
                    <th>Bid Price</th>
                    <th>Upper Limit</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                String userId = session1.getAttribute("user").toString();
                Connection connection = null;
                PreparedStatement preparedStatement = null;
                ResultSet resultSet = null;

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
                    preparedStatement = connection.prepareStatement("SELECT V.vehicle_id, V.vehicle_name, V.vehicle_model, L.license_plate, B.dt, B.buyer_id, B.bid_amount, B.upper_limit FROM Listings as L, Vehicles as V, Bids as B WHERE v.vehicle_id = l.vehicle_id AND l.vehicle_id = b.vehicle_id AND l.seller_id = b.buyer_id AND l.license_plate = b.license_plate AND L.seller_id = ?");

                    preparedStatement.setString(1, userId);
                    resultSet = preparedStatement.executeQuery();

                    while (resultSet.next()) {
            %>
                    <tr>
                        
                        <td><%= resultSet.getString("vehicle_name") %></td>
                        <td><%= resultSet.getString("vehicle_model") %></td>
                        <td><%= resultSet.getString("license_plate") %></td>
                        <td><%= resultSet.getDouble("listing_price") %></td>
                        <td><%= resultSet.getDouble("min_price") %></td>
                        <td><%= resultSet.getDouble("min_inc") %></td>
                        <td>
                            <form action="deletelisting.jsp" method="POST">
                                <input type="hidden" name="vehicle_id" value="<%= resultSet.getInt("vehicle_id") %>">
                                <input type="hidden" name="dt" value="<%= resultSet.getTimestamp("dt") %>">
                                <button type="submit" class="btn btn-danger">Delete</button>
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
    <% } else { %>
    <div class="row">
    <div class="col-md-12 text-center mt-4">
    <div class="alert alert-warning">You first need to log in to view your listings!</div>
    </div>
    </div>
    <% } %>

    </div>
</body>