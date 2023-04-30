<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Properties" %>

<%
Connection connection = null;
PreparedStatement preparedStatement1 = null;
PreparedStatement preparedStatement2 = null;

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

    preparedStatement1 = connection.prepareStatement(
    	    "UPDATE Listings L " +
    	    "SET L.sold = 1, " +
    	    "    L.buyer_id = (SELECT B.buyer_id " +
    	    "                 FROM Bids B " +
    	    "                 WHERE B.license_plate = L.license_plate " +
    	    "                 ORDER BY B.bid_amount DESC, B.dt DESC " +
    	    "                 LIMIT 1), " +
    	    "    L.final_bid = (SELECT B.bid_amount " +
    	    "                 FROM Bids B " +
    	    "                 WHERE B.license_plate = L.license_plate " +
    	    "                 ORDER BY B.bid_amount DESC, B.dt DESC " +
    	    "                 LIMIT 1) " +
    	    "WHERE L.expiration_datetime < NOW() AND " +
    	    "      L.license_plate IN (SELECT license_plate FROM Bids) AND " +
    	    "      L.sold = 0"
    	);

    int rowsUpdated = preparedStatement1.executeUpdate();
    out.println("Updated rows: " + rowsUpdated);

    preparedStatement2 = connection.prepareStatement(
            "DELETE B " +
            "FROM Bids B " +
            "WHERE B.license_plate IN (SELECT L.license_plate " +
            "                          FROM Listings L " +
            "                          WHERE L.sold = 1)"
        );

    int bidsDeleted = preparedStatement2.executeUpdate();
    out.println("Deleted bids: " + bidsDeleted);

} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (preparedStatement1 != null) preparedStatement1.close();
    if (preparedStatement2 != null) preparedStatement2.close();
    if (connection != null) connection.close();
}
%>
