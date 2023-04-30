<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Properties" %>
<% System.out.println("update_listings.jsp called"); %>

<%
Connection connection = null;
PreparedStatement preparedStatement = null;

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

    preparedStatement = connection.prepareStatement(
        "UPDATE Listings L " +
        "SET L.sold = 1, " +
        "    L.buyer_id = (SELECT B.buyer_id " +
        "                 FROM Bids B " +
        "                 WHERE B.license_plate = L.license_plate " +
        "                 ORDER BY B.bid_amount DESC, B.dt DESC " +
        "                 LIMIT 1) " +
        "WHERE L.expiration_datetime < NOW() AND " +
        "      L.license_plate IN (SELECT license_plate FROM Bids) AND " +
        "      L.sold = 0"
    );

    int rowsUpdated = preparedStatement.executeUpdate();
    out.println("Updated rows: " + rowsUpdated);

} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (preparedStatement != null) preparedStatement.close();
    if (connection != null) connection.close();
}
%>
