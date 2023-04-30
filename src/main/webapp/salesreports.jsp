<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Properties" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
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
    String userEmail = session.getAttribute("user").toString();

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
<%
    try {
        // Load database properties and establish connection
        Class.forName("com.mysql.jdbc.Driver");
        Properties props = new Properties();
        FileInputStream in = new FileInputStream(getServletContext().getRealPath("/resources/database.properties"));
        props.load(in);
        in.close();
        String url = props.getProperty("db.url");
        String username = props.getProperty("db.username");
        String pswd = props.getProperty("db.password");
        connection = DriverManager.getConnection(url, username, pswd);

        // Check user permissions
        preparedStatement = connection.prepareStatement("SELECT u.role_id, u.can_generate_reports FROM EndUsers e INNER JOIN UserRoles u ON e.role_id = u.role_id WHERE e.email_id=?");
        preparedStatement.setString(1, userEmail);
        resultSet = preparedStatement.executeQuery();

        if (resultSet.next()) {
            int roleId = resultSet.getInt("role_id");
            boolean canGenerateReports = resultSet.getBoolean("can_generate_reports");

            if (roleId == 1 && canGenerateReports) {
            	// Total Earnings Report
            	preparedStatement = connection.prepareStatement("SELECT SUM(final_bid) as total_earnings FROM Listings WHERE sold = 1");
            	resultSet = preparedStatement.executeQuery();

            	if (resultSet.next()) {
            	    int totalEarnings = resultSet.getInt("total_earnings");
            	    out.println("<h2>Total Earnings</h2>");
            	    out.println("<p>" + totalEarnings + "</p>");
            	} else {
            	    out.println("Error generating the Total Earnings report.");
            	}
            	
                PreparedStatement earningsPerItemStatement = connection.prepareStatement("SELECT v.vehicle_id, v.vehicle_name, v.vehicle_model, SUM(l.final_bid) as total_earnings FROM Listings l INNER JOIN Vehicles v ON l.vehicle_id = v.vehicle_id WHERE l.sold = 1 GROUP BY v.vehicle_id, v.vehicle_name, v.vehicle_model;");
                ResultSet earningsPerItemResultSet = earningsPerItemStatement.executeQuery();
	            %>
	
	            <h2>Earnings Per Item</h2>
	            <table border="1">
	                <tr>
	                    <th>Vehicle ID</th>
	                    <th>Vehicle Name</th>
	                    <th>Vehicle Model</th>
	                    <th>Total Earnings</th>
	                </tr>
	                <% while (earningsPerItemResultSet.next()) { %>
	                    <tr>
	                        <td><%= earningsPerItemResultSet.getInt("vehicle_id") %></td>
	                        <td><%= earningsPerItemResultSet.getString("vehicle_name") %></td>
	                        <td><%= earningsPerItemResultSet.getString("vehicle_model") %></td>
	                        <td><%= earningsPerItemResultSet.getInt("total_earnings") %></td>
	                    </tr>
	                <% } %>
	            </table>
	            <%

            } else {
                out.println("You do not have permission to view this page.");
            }
        } else {
            out.println("User not found.");
        }

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (resultSet != null) try { resultSet.close(); } catch (SQLException e) { /* ignored */ }
        if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException e) { /* ignored */ }
        if (connection != null) try { connection.close(); } catch (SQLException e) { /* ignored */ }
    }
%>
</body>
</html>
