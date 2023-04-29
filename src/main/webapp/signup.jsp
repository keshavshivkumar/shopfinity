<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
	<title>Signup Page</title>
	<link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
	<link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700&display=swap" rel="stylesheet">
</head>

<body>
    <header class="navbar navbar-expand-lg navbar-dark bg-primary py-3">
    <div class="container">
        <div class="d-flex justify-content-center">
            <a href="index.jsp" class="navbar-brand text-decoration-none">
                <h1 class="text-white">ShopFinity</h1>
            </a>
            
        </div>
    </div>
</header>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card mt-4">
                    <div class="card-body">
                        <h1 class="card-title text-center">Sign up</h1>
                        <hr>
                        <%
                            String error = request.getParameter("error");

                            if (error != null && error.equals("invalid")) {
                                out.println("<div class=\"alert alert-danger\">Invalid email or password!</div>");
                            }
                        %>
                        <form action="validate.jsp" method="post">
                            <div class="form-group">
                                <input class="form-control" type="text" id="fullname" name="full_name" placeholder="Full Name" required>
                            </div>
                            <div class="form-group">
                                <input class="form-control" type="email" id="email" name="email_id" placeholder="Email" required>
                            </div>
                            <div class="form-group">
                                <input class="form-control" type="tel" id="mobile" name="ph_no" placeholder="Mobile Number" required>
                            </div>
                            <div class="form-group">
                                <input class="form-control" type="password" id="password" name="passwd" placeholder="Password" required>
                            </div>

                            <span id="password-requirements"></span>

                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="show-password">
                                <label class="form-check-label" for="show-password">
                                    Show Password
                                </label>
                            </div>

                            <div class="mt-3">
                                <a href="login.jsp">Already have an account? Login.</a>
                            </div>

                            <div class="text-center mt-3">
                                <input type="submit" value="Sign up" class="btn btn-primary">
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="${contextPath}/resources/functionality.js"></script>
</body>

</html>