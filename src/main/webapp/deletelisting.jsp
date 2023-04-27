<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    int vehicleId = Integer.parseInt(request.getParameter("vehicle_id"));
    HttpSession session1 = request.getSession();
    String userId = session1.getAttribute("user").toString();

    Connection connection = null;
    PreparedStatement preparedStatement = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopfinity", "root", "");
        preparedStatement = connection.prepareStatement("DELETE FROM Listings WHERE vehicle_id=? AND seller_id=?");
        preparedStatement.setInt(1, vehicleId);
        preparedStatement.setString(2, userId);
        preparedStatement.executeUpdate();

        response.sendRedirect("mylistings.jsp?deleted=success");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("mylistings.jsp?deleted=failure");
    } finally {
        if (preparedStatement != null) preparedStatement.close();
        if (connection != null) connection.close();
    }
%>
