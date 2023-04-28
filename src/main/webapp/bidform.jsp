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
        String bidstatus = request.getParameter("bid");
    %>

    <header class="navbar navbar-expand-lg navbar-dark bg-primary py-3">
    <div class="container">
        <a href="index.jsp" class="navbar-brand text-decoration-none">
            <h1 class="text-white">ShopFinity</h1>
        </a>
        <nav class="navbar-nav ms-auto">
            <% if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn")) { %>
                <li class="nav-item">
                    <a href="sell.jsp" class="nav-link">Sell</a>
                </li>
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

    <body>
  <div class="container">
    <div class="row">
      <div class="col-md-6 offset-md-3">
        <h2 class="text-center mt-4 mb-3">Bid Form</h2>

        <% if (session.getAttribute("loggedIn") != null && (Boolean) session.getAttribute("loggedIn")) { %>
        <form action="submitbid.jsp" method="POST">
          <input type="hidden" name="vehicle_id" value="${param.vehicle_id}">
          <input type="hidden" name="license_plate" value="${param.license_plate}">
          <input type="hidden" name="seller_id" value="${param.seller_id}">
          <input type="hidden" name="buyer_id" value="${sessionScope.user}">

          <div class="form-group">
            <label for="bid_amount">Bid Amount:</label>
            <input type="number" name="bid_amount" id="bid_amount" class="form-control" required min="0">
          </div>

          <div class="form-group">
            <label for="upper_limit">Upper Limit:</label>
            <input type="number" name="upper_limit" id="upper_limit" class="form-control" required min="0">
          </div>

          <div class="form-group mt-3">
            <button type="submit" class="btn btn-primary">Submit Bid</button>
          </div>
        </form>
        <% } else { %>
        <div class="alert alert-warning">You must be logged in to place a bid.</div>
        <% } %>
      </div>
    </div>
  </div>
</body>
    

</body>
</html>
