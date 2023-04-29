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
        
        // Check if the bid amount is greater than or equal to the minimum price
        preparedStatement = connection.prepareStatement("SELECT min_price, min_inc FROM Listings WHERE vehicle_id=? AND license_plate=?");
        preparedStatement.setInt(1, vehicleId);
        preparedStatement.setString(2, license);
        resultSet = preparedStatement.executeQuery();
        
        if (resultSet.next()) {
            int minPrice = resultSet.getInt("min_price");
            int minInc = resultSet.getInt("min_inc");
            
            
            if (bidAmount >= minPrice) {
                // Get the current final_bid and seller_id from Listings
                preparedStatement = connection.prepareStatement("SELECT b.vehicle_id, MAX(b.bid_amount) as highest_bid_amount, l.seller_id FROM Bids as b, Listings as l WHERE b.vehicle_id=? AND b.dt=? AND b.license_plate=? AND b.vehicle_id=l.vehicle_id AND b.seller_id=l.seller_id AND b.license_plate = l.license_plate");
		        preparedStatement.setInt(1, vehicleId);
		        preparedStatement.setTimestamp(2, dtTimestamp);
		        preparedStatement.setString(3, license);
		        resultSet = preparedStatement.executeQuery();
		                
		        if (resultSet.next()) {
		            int currentBid = resultSet.getInt("highest_bid_amount");
                    
                    // Check if the new bid is greater than the current highest bid
                    if (bidAmount > currentBid) {
                    	String currentHighestBuyerId;
                    	int currentHighestUpperLimit;

                        // Fetch current highest bidder's upper limit
                        preparedStatement = connection.prepareStatement("SELECT buyer_id, upper_limit FROM Bids WHERE vehicle_id=? AND dt=? AND bid_amount=?");
                        preparedStatement.setInt(1, vehicleId);
                        preparedStatement.setTimestamp(2, dtTimestamp);
                        preparedStatement.setInt(3, currentBid);
                        resultSet = preparedStatement.executeQuery();

                        if (resultSet.next()) {
                            currentHighestBuyerId = resultSet.getString("buyer_id");
                            currentHighestUpperLimit = resultSet.getInt("upper_limit");
                        } else {
                        	preparedStatement = connection.prepareStatement("INSERT INTO Bids (vehicle_id, dt, seller_id, buyer_id, upper_limit, bid_amount, license_plate) VALUES (?, ?, ?, ?, ?, ?, ?)");
                            preparedStatement.setInt(1, vehicleId);
                            preparedStatement.setTimestamp(2, dtTimestamp);
                            preparedStatement.setString(3, sellerId);
                            preparedStatement.setString(4, buyerId);
                            preparedStatement.setInt(5, upperLimit);
                            preparedStatement.setInt(6, bidAmount);
                            preparedStatement.setString(7, license);
                            preparedStatement.executeUpdate();

                            // Update the final_bid in the Listings table
                            preparedStatement = connection.prepareStatement("UPDATE Listings SET final_bid=? WHERE vehicle_id=? AND dt=?");
                            preparedStatement.setInt(1, bidAmount);
                            preparedStatement.setInt(2, vehicleId);
                            preparedStatement.setTimestamp(3, dtTimestamp);
                            preparedStatement.executeUpdate();

                            response.sendRedirect("index.jsp?vehicle_id=" + vehicleId + "&bid=success");
                            return;
                        }

                        int newBidForCurrentHighest = currentBid;
                        int newBidForNewBidder = bidAmount;

                        while (newBidForCurrentHighest < currentHighestUpperLimit && newBidForNewBidder < upperLimit) {
                            newBidForCurrentHighest += minInc;
                            newBidForNewBidder += minInc;
                        }

                        String winningBidBuyerId;
                        int winningBidAmount;

                        if (newBidForCurrentHighest <= currentHighestUpperLimit && newBidForCurrentHighest >= newBidForNewBidder) {
                            winningBidBuyerId = currentHighestBuyerId;
                            winningBidAmount = newBidForCurrentHighest;
                        } else {
                            winningBidBuyerId = buyerId;
                            winningBidAmount = newBidForNewBidder;
                        }
                        
                        // Update current highest bidder's bid amount
                        preparedStatement = connection.prepareStatement("UPDATE Bids SET bid_amount=? WHERE vehicle_id=? AND dt=? AND buyer_id=?");
                        preparedStatement.setInt(1, newBidForCurrentHighest);
                        preparedStatement.setInt(2, vehicleId);
                        preparedStatement.setTimestamp(3, dtTimestamp);
                        preparedStatement.setString(4, currentHighestBuyerId);
                        preparedStatement.executeUpdate();

                        // Insert the new bid into the Bids table
                        preparedStatement = connection.prepareStatement("INSERT INTO Bids (vehicle_id, dt, seller_id, buyer_id, upper_limit, bid_amount) VALUES (?, ?, ?, ?, ?, ?)");
                        preparedStatement.setInt(1, vehicleId);
                        preparedStatement.setTimestamp(2, dtTimestamp);
                        preparedStatement.setString(3, sellerId);
                        preparedStatement.setString(4, buyerId);
                        preparedStatement.setInt(5, upperLimit);
                        preparedStatement.setInt(6, newBidForNewBidder);
                        preparedStatement.executeUpdate();
                        
                        // Update the final_bid in the Listings table
                        preparedStatement = connection.prepareStatement("UPDATE Listings SET final_bid=? WHERE vehicle_id=? AND dt=?");
                        preparedStatement.setInt(1, winningBidAmount);
                        preparedStatement.setInt(2, vehicleId);
                        preparedStatement.setTimestamp(3, dtTimestamp);
                        preparedStatement.executeUpdate();
                        
                        response.sendRedirect("index.jsp?vehicle_id=" + vehicleId + "&bid=success");
                    } else {
                    	request.setAttribute("errorMessage", "Your error message");
                    	RequestDispatcher dispatcher = request.getRequestDispatcher("bidform.jsp?vehicle_id=" + vehicleId);
                    	dispatcher.forward(request, response);
                    }
                } else {
                	request.setAttribute("errorMessage", "Your error message");
                	RequestDispatcher dispatcher = request.getRequestDispatcher("listings.jsp?vehicle_id=" + vehicleId);
                	dispatcher.forward(request, response);

                }
		        
            } else {
            	request.setAttribute("errorMessage", "Your error message");
            	RequestDispatcher dispatcher = request.getRequestDispatcher("bidform.jsp?vehicle_id=" + vehicleId);
            	dispatcher.forward(request, response);
            }
        }
        } catch (Exception e) {
        	 e.printStackTrace();
        	    String exceptionMessage = e.getMessage();
        	    response.sendRedirect("listings.jsp?vehicle_id=" + vehicleId + "&dt=" + dtTimestamp + "&bid_amount=" + bidAmount + "&bid=failure&exceptionMessage=" + exceptionMessage);
        } finally {
            if (resultSet != null) resultSet.close();
            if (preparedStatement != null) preparedStatement.close();
            if (connection != null) connection.close();
        }
    %>
    </body>
</html>

