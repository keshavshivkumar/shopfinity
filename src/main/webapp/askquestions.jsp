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
  <div class="row">
    <div class="col-md-6 offset-md-3">
      <% if(request.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-danger">
          <%= request.getAttribute("errorMessage") %>
        </div>
      <% } %>
      <h2 class="text-center mt-4 mb-3">Ask a Question</h2>

      <% if (session.getAttribute("loggedIn") != null && (Boolean) session.getAttribute("loggedIn")) { %>
      <form action="submitquestion.jsp" method="POST">
        <input type="hidden" name="customer_id" value="${sessionScope.user}">

        <div class="form-group">
          <label for="question">Question:</label>
          <textarea name="question" id="question" class="form-control" required rows="5"></textarea>
        </div>

        <div class="form-group mt-3">
          <button type="submit" class="btn btn-primary">Submit Question</button>
        </div>
      </form>
      <% } else { %>
      <div class="alert alert-warning">You must be logged in to ask a question.</div>
      <% } %>
    </div>
  </div>
</div>

</body>