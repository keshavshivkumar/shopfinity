<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<%
    String email = request.getParameter("email");
    int role_id = Integer.parseInt(request.getParameter("role_id"));

    String connectionURL = "jdbc:mysql://localhost:3306/shopfinity";
    Connection connection = null;
    PreparedStatement pstmt = null;
    Class.forName("com.mysql.jdbc.Driver");
    connection = DriverManager.getConnection(connectionURL, "root", "");
    String query = "UPDATE EndUsers SET role_id=? WHERE email_id=?";
    pstmt = connection.prepareStatement(query);
    pstmt.setInt(1, role_id);
    pstmt.setString(2, email);
    int rowsAffected = pstmt.executeUpdate();

    if (rowsAffected > 0) {
        response.getWriter().write("Role changed successfully.");
    } else {
        response.getWriter().write("Error changing role.");
    }

    pstmt.close();
    connection.close();
%>