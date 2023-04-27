<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<html>
<head>
    <title>Customer Representatives</title>
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
    <style>
        .table-container {
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="my-3">Customer Representatives</h1>

        <div class="table-container">
            <h3>Customer Representatives</h3>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Email</th>
                        <th>Name</th>
                        <th>Phone Number</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String connectionURL = "jdbc:mysql://localhost:3306/shopfinity";
                        Connection connection = null;
                        ResultSet rs = null;
                        Statement statement = null;
                        Class.forName("com.mysql.jdbc.Driver");
                        connection = DriverManager.getConnection(connectionURL, "root", "mutexlock");
                        statement = connection.createStatement();
                        String query = "SELECT * FROM EndUsers WHERE role_id=2";
                        rs = statement.executeQuery(query);

                        while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getString("email_id") %></td>
                        <td><%= rs.getString("full_name") %></td>
                        <td><%= rs.getString("ph_no") %></td>
                        <td><button class="btn btn-danger" onclick="changeRole('<%= rs.getString("email_id") %>', 3)">Remove Customer Representative Role</button></td>
                    </tr>
                    <%
                        }
                        statement.close();
                    %>
                </tbody>
            </table>
        </div>

        <div class="table-container">
            <h3>Regular Users</h3>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Email</th>
                        <th>Name</th>
                        <th>Phone Number</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        statement = connection.createStatement();
                        query = "SELECT * FROM EndUsers WHERE role_id=3";
                        rs = statement.executeQuery(query);

                        while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getString("email_id") %></td>
                        <td><%= rs.getString("full_name") %></td>
                        <td><%= rs.getString("ph_no") %></td>
                        <td><button class="btn btn-success" onclick="changeRole('<%= rs.getString("email_id") %>', 2)">Give Customer Representative Role</button></td>
                    </tr>
                    <%
                        }
                        statement.close();
                        connection.close();
                    %>
                </tbody>
            </table>
        </div>

    </div>
    <script src="${contextPath}/resources/rolechange.js"></script>
</body>
</html>