<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Properties" %>

<%
    int vehicleId = Integer.parseInt(request.getParameter("vehicle_id"));
    String licensePlate = request.getParameter("license_plate");

    HttpSession session1 = request.getSession();
    String userId = session1.getAttribute("user").toString();
    int roleId = Integer.parseInt(session1.getAttribute("role_id").toString());
    String redirect = "";
    if (roleId < 3) {
        redirect = "bids.jsp";
    } else {
        redirect = "mybids.jsp";
    }

    Connection connection = null;
    PreparedStatement preparedStatementBid = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Properties props = new Properties();
        FileInputStream in = new FileInputStream(getServletContext().getRealPath("/resources/database.properties"));
        props.load(in);
        in.close();
        String url = props.getProperty("db.url");
        String username = props.getProperty("db.username");
        String pswd = props.getProperty("db.password");
        connection = DriverManager.getConnection(url, username, pswd);
        
        // Delete the specific bid placed by the user
        if (roleId==3){
	        preparedStatementBid = connection.prepareStatement("DELETE FROM Bids WHERE vehicle_id=? AND license_plate=? AND buyer_id=?");
	        preparedStatementBid.setInt(1, vehicleId);
	        preparedStatementBid.setString(2, licensePlate);
	        preparedStatementBid.setString(3, userId);
	        preparedStatementBid.executeUpdate();
        } else {
        	preparedStatementBid = connection.prepareStatement("DELETE FROM Bids WHERE vehicle_id=? AND license_plate=?");
	        preparedStatementBid.setInt(1, vehicleId);
	        preparedStatementBid.setString(2, licensePlate);
	        preparedStatementBid.executeUpdate();
        }
		
        response.sendRedirect(redirect+"?deleted=success");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect(redirect+"?deleted=failure");
    } finally {
        if (preparedStatementBid != null) preparedStatementBid.close();
        if (connection != null) connection.close();
    }
%>
