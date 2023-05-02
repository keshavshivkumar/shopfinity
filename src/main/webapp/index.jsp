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
		String login = request.getParameter("login");
		if (login != null && login.equals("success")) {
	        if ((Boolean) session1.getAttribute("loggedIn") == true){
	        	 session1.setAttribute("loginMessage", null);
	        }
	        else if ((Boolean) session1.getAttribute("loggedIn")==false) {
	        	session1.setAttribute("loggedIn", true);
	        	session1.setAttribute("loginMessage", "Successfully logged in!");
	        }
	    }
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
                            <a href="notifications.jsp" class="nav-link">Notifications</a>
                        </li>
                        <li class="nav-item">
                            <a href="wishlist.jsp" class="nav-link">Wishlist</a>
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
			String loginMessage = "";
		    loginMessage = (String) session1.getAttribute("loginMessage");
		    if (loginMessage != null) {
		        out.println("<div id='login-message' class='alert alert-info mt-3'>" + loginMessage + "</div>");
		        session1.setAttribute("loginMessage", null);
		    }
	    String userEmail = "";
	    if (session1.getAttribute("user") != null) {
	        userEmail = session1.getAttribute("user").toString();
	    }
	    if (userEmail != null && !userEmail.isEmpty()) {
	        // Initialize database connection and fetch the latest notification
	        Properties props = new Properties();
	        FileInputStream in = new FileInputStream(getServletContext().getRealPath("/resources/database.properties"));
	        props.load(in);
	        in.close();
	        String url = props.getProperty("db.url");
	        String username = props.getProperty("db.username");
	        String pswd = props.getProperty("db.password");
	        Class.forName("com.mysql.jdbc.Driver");
	        Connection connection = DriverManager.getConnection(url, username, pswd);

	        String query = "SELECT * FROM Notifications WHERE email_id = ? ORDER BY timestamp_pushed DESC LIMIT 1";
	        PreparedStatement preparedStatement = connection.prepareStatement(query);
	        preparedStatement.setString(1, userEmail);

	        ResultSet resultSet = preparedStatement.executeQuery();

	        if (resultSet.next()) {
	            String latestNotification = resultSet.getString("notification_text");
	            out.println("<div id='latest-notification' class='alert alert-info mt-3'>Latest Notification: " + latestNotification + "</div>");
	        }

	        // Close resources
	        if (resultSet != null) resultSet.close();
	        if (preparedStatement != null) preparedStatement.close();
	        if (connection != null) connection.close();
	    }

	%>
	
	<% if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn")) { %>
	<% if ("success".equals(request.getParameter("bid"))) { %>
	<p id="success-message" style="color: green;">Bid placed successfully.</p>
		<script>
			setTimeout(function() {
				document.getElementById("success-message").style.display = "none";
				history.replaceState({}, "", "index.jsp");
			}, 3000);
		</script>
	<% } %>
	<% if ("repeat".equals(request.getParameter("bid"))) { %>
			<p id="success-message" style="color: red;">Your bid amount/upper limit is already used!</p>
				<script>
					setTimeout(function() {
						document.getElementById("success-message").style.display = "none";
						history.replaceState({}, "", "bidform.jsp");
					}, 3000);
				</script>
			<% } else if ("failure".equals(request.getParameter("bid"))) {%>
			<p id="success-message" style="color: red;">Bid failed, your bid is too low</p>
				<script>
					setTimeout(function() {
						document.getElementById("success-message").style.display = "none";
						history.replaceState({}, "", "bidform.jsp");
					}, 3000);
				</script>
			<% } %>
	
	  <div class="container">
  <div class="d-flex justify-content-between my-3">
    <a href="listings.jsp" class="btn btn-primary">Browse All Listings</a>
    <select id="sort-select" class="form-select" onchange="searchFunction()">
      <option value="" selected>Sort by...</option>
      <option value="listing_price">Listing Price</option>
      <option value="bid_amount">Bid Amount</option>
      <option value="vehicle_name">Vehicle Name</option>
      <option value="vehicle_type">Vehicle Type</option>
      <option value="vehicle_model">Vehicle Model</option>
      <option value="time_left">Time left</option>
      <option value="seller_id">Seller Name</option>
      <!-- Add more options here for other fields -->
    </select>
  </div>
  <div class="input-group my-3">
    <input type="text" id="search-input" class="form-control" placeholder="Search..." onkeyup="searchFunction()">
    <button class="btn btn-primary" type="button">Search</button>
  </div>
  <ul id="search-results" class="list-unstyled"></ul>
</div>
<% } %>
<script src="${contextPath}/resources/searchbar.js"></script>

<script>

setTimeout(function() {
    const loginMessageElement = document.getElementById("login-message");
    const latestNotificationElement = document.getElementById("latest-notification");

    if (loginMessageElement) {
        loginMessageElement.style.display = "none";
    }

    if (latestNotificationElement) {
        latestNotificationElement.style.display = "none";
    }
}, 5000);
			function updateListings() {
				console.log("updateListings called");
			    fetch('update_listings.jsp')
			        .then(response => response.text())
			        .then(result => console.log(result))
			        .catch(error => console.error('Error:', error));
			}
			
			// Call the update function every 5 minutes (300000 milliseconds)
			document.addEventListener('DOMContentLoaded', updateListings);
			setInterval(updateListings, 300000);
			



</script>
</body> 
</html>
