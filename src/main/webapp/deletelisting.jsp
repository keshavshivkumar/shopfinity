<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    int vehicleId = Integer.parseInt(request.getParameter("vehicle_id"));
    String dt = request.getParameter("dt");
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
    java.util.Date parsedDate = dateFormat.parse(dt);
    java.sql.Timestamp dtTimestamp = new java.sql.Timestamp(parsedDate.getTime());

    HttpSession session1 = request.getSession();
    String userId = session1.getAttribute("user").toString();

    Connection connection = null;
    PreparedStatement preparedStatement = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopfinity", "root", "");
        preparedStatement = connection.prepareStatement("DELETE FROM Listings WHERE vehicle_id=? AND seller_id=? AND dt=?");
        preparedStatement.setInt(1, vehicleId);
        preparedStatement.setString(2, userId);
        preparedStatement.setTimestamp(3, dtTimestamp);
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
