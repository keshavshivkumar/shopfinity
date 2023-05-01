<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.Properties" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<html>
<head>
    <title>All Bids</title>
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700&display=swap" rel="stylesheet">
</head>

<body>
<%
    HttpSession session1 = request.getSession();
    if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn") && Integer.parseInt(session1.getAttribute("role_id").toString()) < 3) {
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
                        <li class="nav-item">
                            <a href="bids.jsp" class="nav-link">All Bids</a>
                        </li>
                        <% } 
                        if (session1.getAttribute("role_id").equals(2)){%>
                        <li class="nav-item">
                            <a href="bids.jsp" class="nav-link">All Bids</a>
                        </li>
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
        <h2 class="mt-4 mb-3">Bid History</h2>
        <table class="table table-bordered">
            <thead>
            <tr>
                <th>Vehicle ID</th>
                <th>Buyer ID</th>
                <th>Seller ID</th>
                <th>License Plate</th>
                <th>Upper Limit</th>
                <th>Bid Amount</th>
                <th>Timestamp</th>
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
                    preparedStatement = connection.prepareStatement("SELECT * FROM Bids");
                    resultSet = preparedStatement.executeQuery();

                    while (resultSet.next()) {
            %>
                <tr>
                    <td><%= resultSet.getInt("vehicle_id") %></td>
                    <td><%= resultSet.getString("buyer_id") %></td>
                    <td><%= resultSet.getString("seller_id") %></td>
                    <td><%= resultSet.getString("license_plate") %></td>
                    <td><%= resultSet.getInt("upper_limit") %></td>
                    <td><%= resultSet.getInt("bid_amount") %></td>
                    <td><%= resultSet.getTimestamp("dt") %></td>
                                        <% if (Integer.parseInt(session1.getAttribute("role_id").toString()) < 3) { %>
                        <td>
                            <form action="deletebid.jsp" method="POST">
                                <input type="hidden" name="vehicle_id" value="<%= resultSet.getInt("vehicle_id") %>">
                                <input type="hidden" name="dt" value="<%= resultSet.getTimestamp("dt") %>">
                                <input type="hidden" name="license_plate" value="<%= resultSet.getString("license_plate") %>">
                                <input type="hidden" name="redirectpage" value="bidhistory.jsp">
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
</div>

<% } else { %>
    <div class="row">
        <div class="col-md-12 text-center mt-4">
            <div class="alert alert-warning">You don't have permission to view this page!</div>
        </div>
    </div>
<% } %>

</body>
</html>

