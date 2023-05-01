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
    <% if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn")) { %>
    <main class="container my-4">
    <h2 class="mb-3">All Notifications</h2>
    <div class="table-responsive">
        <table class="table table-striped" id="notifications-table">
            <thead>
                <tr>
                    <th scope="col" onclick="loadSortedNotifications('notification_id', 'asc')">Notification ID</th>
                    <th scope="col" onclick="loadSortedNotifications('email_id', 'asc')">User Email</th>
                    <th scope="col" onclick="loadSortedNotifications('notification_text', 'asc')">Notification Text</th>
                    <th scope="col" onclick="loadSortedNotifications('timestamp_pushed', 'asc')">Timestamp</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Properties props = new Properties();
                    FileInputStream in = new FileInputStream(getServletContext().getRealPath("/resources/database.properties"));
                    props.load(in);
                    in.close();
                    String url = props.getProperty("db.url");
                    String username = props.getProperty("db.username");
                    String pswd = props.getProperty("db.password");
                    Class.forName("com.mysql.jdbc.Driver");
                    connection = DriverManager.getConnection(url, username, pswd);

                    String sortField = request.getParameter("sortField") != null ? request.getParameter("sortField") : "notification_id";
                    String sortDirection = request.getParameter("sortDirection") != null ? request.getParameter("sortDirection") : "asc";

                    String query = "SELECT * FROM Notifications WHERE email_id = ? ORDER BY " + sortField + " " + sortDirection;
                    preparedStatement = connection.prepareStatement(query);
                    preparedStatement.setString(1, userEmail);
                    resultSet = preparedStatement.executeQuery();

                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

                    while (resultSet.next()) {
                %>
                <tr>
                    <th scope="row"><%= resultSet.getInt("notification_id") %></th>
                    <td><%= resultSet.getString("email_id") %></td>
                    <td><%= resultSet.getString("notification_text") %></td>
                    <td><%= sdf.format(resultSet.getTimestamp("timestamp_pushed")) %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <form id="sortForm" method="get" style="display:none;">
            <input type="hidden" id="sortField" name="sortField" value="">
            <input type="hidden" id="sortDirection" name="sortDirection" value="">
        </form>
        <% } else { %>
        <div class="row">
            <div class="col-md-12 text-center mt-4">
                <div class="alert alert-warning">You first need to log in to view your notifications!</div>
            </div>
        </div>
    <% } %>
    </div>
</main>
<script>
    function loadSortedNotifications(sortField, sortDirection) {
        document.getElementById("sortField").value = sortField;
        document.getElementById("sortDirection").value = sortDirection;
        document.getElementById("sortForm").submit();
    }
</script>
</body>
</html>