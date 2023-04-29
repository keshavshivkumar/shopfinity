<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Properties" %>

<%
    int vehicleId = Integer.parseInt(request.getParameter("vehicle_id"));
    String licensePlate = request.getParameter("license_plate");
    String dt = request.getParameter("dt");
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
    java.util.Date parsedDate = dateFormat.parse(dt);
    java.sql.Timestamp dtTimestamp = new java.sql.Timestamp(parsedDate.getTime());
    String redirect = null;

    HttpSession session1 = request.getSession();
    String userId = session1.getAttribute("user").toString();
    int roleId = Integer.parseInt(session1.getAttribute("role_id").toString());

    Connection connection = null;
    PreparedStatement preparedStatementListing = null;
    PreparedStatement preparedStatementBids = null;

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
        
        // Delete bids related to the vehicle_id and license_plate
        preparedStatementBids = connection.prepareStatement("DELETE FROM Bids WHERE vehicle_id=? AND license_plate=?");
        preparedStatementBids.setInt(1, vehicleId);
        preparedStatementBids.setString(2, licensePlate);
        preparedStatementBids.executeUpdate();

        if (roleId < 3) {
            preparedStatementListing = connection.prepareStatement("DELETE FROM Listings WHERE vehicle_id=? AND dt=?");
            preparedStatementListing.setInt(1, vehicleId);
            preparedStatementListing.setTimestamp(2, dtTimestamp);
            redirect = request.getParameter("redirectpage");
            if (redirect == null){
            	redirect = "index.jsp";
            }
        } else {
            preparedStatementListing = connection.prepareStatement("DELETE FROM Listings WHERE vehicle_id=? AND seller_id=? AND dt=?");
            preparedStatementListing.setInt(1, vehicleId);
            preparedStatementListing.setString(2, userId);
            preparedStatementListing.setTimestamp(3, dtTimestamp);
            redirect = "mylistings.jsp";
        }
        
        preparedStatementListing.executeUpdate();

        response.sendRedirect(redirect+"?deleted=success");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect(redirect+"?deleted=failure");
    } finally {
        if (preparedStatementListing != null) preparedStatementListing.close();
        if (preparedStatementBids != null) preparedStatementBids.close();
        if (connection != null) connection.close();
    }
%>
