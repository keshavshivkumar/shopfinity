<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.Properties" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Submit Bid Debug</title>
    <script type="text/javascript">
        function showAlert(message) {
            alert(message);
        }
    </script>
</head>
<body>
<%
	int vehicleId = Integer.parseInt(request.getParameter("vehicle_id"));
	String license = request.getParameter("license_plate");
	String sellerId = request.getParameter("seller_id");
	
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
	java.util.Date currentDate = new java.util.Date();
	java.sql.Timestamp dtTimestamp = new java.sql.Timestamp(currentDate.getTime());
	
    int bidAmount = Integer.parseInt(request.getParameter("bid_amount"));
    int upperLimit = Integer.parseInt(request.getParameter("upper_limit"));
    
    HttpSession session1 = request.getSession();
    String buyerId = session.getAttribute("user").toString();
    
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;
    
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
        
    	preparedStatement = connection.prepareStatement("SELECT min_price, min_inc FROM Listings WHERE vehicle_id=? AND license_plate=?");
        preparedStatement.setInt(1, vehicleId);
        preparedStatement.setString(2, license);
        resultSet = preparedStatement.executeQuery();
        
        if (resultSet.next()) {
            int minPrice = resultSet.getInt("min_price");
            int minInc = resultSet.getInt("min_inc");
            
            if (bidAmount >= minPrice) {
                preparedStatement = connection.prepareStatement("SELECT b.vehicle_id, MAX(b.bid_amount) as highest_bid_amount, l.seller_id FROM Bids as b, Listings as l WHERE b.vehicle_id=? AND b.dt=? AND b.license_plate=? AND b.vehicle_id=l.vehicle_id AND b.seller_id=l.seller_id AND b.license_plate = l.license_plate");
                preparedStatement.setInt(1, vehicleId);
                preparedStatement.setTimestamp(2, dtTimestamp);
                preparedStatement.setString(3, license);
                resultSet = preparedStatement.executeQuery();

                if (resultSet.next()) {
                    int currentBid = resultSet.getInt("highest_bid_amount");

                    if (bidAmount > currentBid) {
                        String currentHighestBuyerId;
                        int currentHighestUpperLimit;

                        preparedStatement = connection.prepareStatement("SELECT buyer_id, upper_limit FROM Bids WHERE vehicle_id=? AND dt=? AND bid_amount=?");
                        preparedStatement.setInt(1, vehicleId);
                        preparedStatement.setTimestamp(2, dtTimestamp);
                        preparedStatement.setInt(3, currentBid);
                        resultSet = preparedStatement.executeQuery();

                        if (resultSet.next()) {
                            currentHighestBuyerId = resultSet.getString("buyer_id");
                            currentHighestUpperLimit = resultSet.getInt("upper_limit");

                            int newBidForCurrentHighest = currentBid;
                            int newBidForNewBidder = bidAmount;
                            while (newBidForCurrentHighest < currentHighestUpperLimit && newBidForNewBidder < upperLimit) {
                                newBidForCurrentHighest += minInc;
                                newBidForNewBidder += minInc;
                            }

                            // Check which bidder's incremented bid is higher and update the Bids table
                            if (newBidForCurrentHighest > newBidForNewBidder) {
                                preparedStatement = connection.prepareStatement("UPDATE Bids SET bid_amount=? WHERE vehicle_id=? AND dt=? AND buyer_id=?");
                                preparedStatement.setInt(1, newBidForCurrentHighest);
                                preparedStatement.setInt(2, vehicleId);
                                preparedStatement.setTimestamp(3, dtTimestamp);
                                preparedStatement.setString(4, currentHighestBuyerId);
                                preparedStatement.executeUpdate();

                                // Delete the losing bid
                                preparedStatement = connection.prepareStatement("DELETE FROM Bids WHERE vehicle_id=? AND dt=? AND buyer_id=?");
                                preparedStatement.setInt(1, vehicleId);
                                preparedStatement.setTimestamp(2, dtTimestamp);
                                preparedStatement.setString(3, buyerId);
                                preparedStatement.executeUpdate();
                            } else {
                                preparedStatement = connection.prepareStatement("UPDATE Bids SET bid_amount=? WHERE vehicle_id=? AND dt=? AND buyer_id=?");
                                preparedStatement.setInt(1, newBidForNewBidder);
                                preparedStatement.setInt(2, vehicleId);
                                preparedStatement.setTimestamp(3, dtTimestamp);
                                preparedStatement.setString(4, buyerId);
                                preparedStatement.executeUpdate();

                                // Delete the losing bid
                                preparedStatement = connection.prepareStatement("DELETE FROM Bids WHERE vehicle_id=? AND dt=? AND buyer_id=?");
                                preparedStatement.setInt(1, vehicleId);
                                preparedStatement.setTimestamp(2, dtTimestamp);
                                preparedStatement.setString(3, currentHighestBuyerId);
                                preparedStatement.executeUpdate();
                            }
                        }
                    }
                }
            } else {
                response.sendRedirect("bidform.jsp?vehicle_id=" + vehicleId + "&dt=" + dateFormat.format(dtTimestamp) + "&bid_amount=" + bidAmount + "&bid=failure&exceptionMessage=Bid%20amount%20is%20less%20than%20the%20minimum%20price.");
            }
        }
    } catch (Exception e) {
        response.sendRedirect("listings.jsp?vehicle_id=" + vehicleId + "&dt=" + dateFormat.format(dtTimestamp) + "&bid_amount=" + bidAmount + "&bid=failure&exceptionMessage=" + e.getMessage());
    } finally {
        if (resultSet != null) try { resultSet.close(); } catch (SQLException e) { /* ignored */ }
        if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException e) { /* ignored */ }
        if (connection != null) try { connection.close(); } catch (SQLException e) { /* ignored */ }
    }
%>
</body>
</html>


