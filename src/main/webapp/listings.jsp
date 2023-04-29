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
        <nav class="navbar-nav ms-auto">
            <% if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn")) { %>
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
        </nav>
    </div>
</header>
<div class="container">
    <% if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn")) { %>
        <h2 class="mt-4 mb-3">Listings</h2>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Vehicle Name</th>
                    <th>Vehicle Model</th>
                    <th>Vehicle Type</th>
                    <th>Name</th>
                    <th>Listing Price</th>
                    <th>Time Left</th>
                    <th>Bid</th>
                    <% if (Integer.parseInt(session1.getAttribute("role_id").toString()) < 3) { %>
                    <th>Action</th>
                    <% } %>
                </tr>
            </thead>
            <tbody>
            <%
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
                    preparedStatement = connection.prepareStatement("SELECT v.vehicle_id, v.vehicle_name, v.vehicle_model, v.vehicle_type, l.seller_id, e.full_name, l.listing_price, l.dt, l.license_plate, CONCAT(TIMESTAMPDIFF(HOUR, NOW(), l.expiration_datetime), 'h ', TIMESTAMPDIFF(MINUTE, NOW(), l.expiration_datetime) % 60, 'm ', TIMESTAMPDIFF(SECOND, NOW(), l.expiration_datetime) % 60, 's') AS time_left FROM Vehicles AS v, Listings AS l, EndUsers as e WHERE v.vehicle_id=l.vehicle_id AND l.seller_id = e.email_id AND v.vehicle_id=l.vehicle_id");

                    resultSet = preparedStatement.executeQuery();

                    while (resultSet.next()) {
            %>
                <tr>
                    <td><%= resultSet.getString("vehicle_name") %></td>
                    <td><%= resultSet.getString("vehicle_model") %></td>
					<td><%= resultSet.getString("vehicle_type") %></td>
                    <td><%= resultSet.getString("full_name") %></td>
                    <td><%= resultSet.getDouble("listing_price") %></td>
                    <td><%= resultSet.getString("time_left") %></td>
                    <td>
					    <% if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn")) { %>
					        <form action="bidform.jsp" method="POST">
					            <input type="hidden" name="vehicle_id" value="<%= resultSet.getInt("vehicle_id") %>">
					            <input type="hidden" name="dt" value="<%= resultSet.getTimestamp("dt") %>">
					            <input type="hidden" name="license_plate" value="<%= resultSet.getString("license_plate") %>">
					            <input type="hidden" name="seller_id" value="<%= resultSet.getString("seller_id") %>">
					            <input type="hidden" name="redirectpage" value="listings.jsp">
					            <button type="submit" class="btn-primary">Bid</button>
					  		</form>
					    <% } %>
					</td>
					<% if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn") && Integer.parseInt(session1.getAttribute("role_id").toString()) < 3) { %>
					    <td>
					        <form action="deletelisting.jsp" method="POST">
					            <input type="hidden" name="vehicle_id" value="<%= resultSet.getInt("vehicle_id") %>">
					            <input type="hidden" name="dt" value="<%= resultSet.getTimestamp("dt") %>">
					            <input type="hidden" name="redirectpage" value="listings.jsp">
					            <button type="submit" class="btn btn-danger">Delete</button>
					        </form>
					    </td>
					<% } %>
					
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
                <div class="alert alert-warning">You first need to log in to view the listings!</div>
            </div>
        </div>
    <% } %>
</div>
<script src="${contextPath}/resources/searchbar.js"></script>
</body>
</html>
                    
