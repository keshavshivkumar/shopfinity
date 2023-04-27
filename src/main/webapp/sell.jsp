<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card mt-4">
                        <div class="card-body">
                            <h1 class="card-title text-center">Create Vehicle Listing</h1>
                            <hr>
                            <form action="createlisting.jsp" method="POST">
                                <div class="form-group">
                                    <label for="vehicle_id">Vehicle ID:</label>
                                    <input type="number" id="vehicle_id" name="vehicle_id" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label for="vehicle_name">Vehicle Name:</label>
                                    <input type="text" id="vehicle_name" name="vehicle_name" maxlength="25" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label for="vehicle_type">Vehicle Type:</label>
                                    <input type="text" id="vehicle_type" name="vehicle_type" maxlength="10" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label for="listing_price">Listing Price:</label>
                                    <input type="number" id="listing_price" name="listing_price" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label for="min_price">Minimum Price:</label>
                                    <input type="number" id="min_price" name="min_price" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label for="min_inc">Minimum Increment:</label>
                                    <input type="number" id="min_inc" name="min_inc" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label for="exp_date">Expiration Date:</label>
                                    <input type="date" id="exp_date" name="exp_date" class="form-control" required>
                                </div>
                                <div class="text-center">
                                    <input type="submit" value="Submit" class="btn btn-primary">
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        <% } else { %>
            <div class="row">
                <div class="col-md-12 text-center mt-4">
                    <div class="alert alert-warning">You first need to login before you can sell cars!</div>
</div>
</div>
<% } %>
</div>

</body>

</html>
