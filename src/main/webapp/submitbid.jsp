<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<%
    int vehicleId = Integer.parseInt(request.getParameter("vehicle_id"));
    String dt = request.getParameter("dt");
    String license = request.getParameter("license_plate");
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
    java.util.Date parsedDate = dateFormat.parse(dt);
    java.sql.Timestamp dtTimestamp = new java.sql.Timestamp(parsedDate.getTime());
    
    int bidAmount = Integer.parseInt(request.getParameter("bid_amount"));
    int upperLimit = Integer.parseInt(request.getParameter("upper_limit"));
    
    HttpSession session1 = request.getSession();
    String buyerId = session.getAttribute("user").toString();
    
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/shopfinity", "root", "");
        
        // Check if the bid amount is greater than or equal to the minimum price
        preparedStatement = connection.prepareStatement("SELECT min_price, min_inc FROM Listings WHERE vehicle_id=? AND dt=?");
        preparedStatement.setInt(1, vehicleId);
        preparedStatement.setTimestamp(2, dtTimestamp);
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
		            String sellerId = resultSet.getString("seller_id");
                    
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
                            throw new Exception("Failed to fetch current highest bidder information");
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
                        
                        response.sendRedirect("index.jsp?vehicle_id=" + vehicleId + "&dt=" + dt + "&bid=success");
                    } else {
                        response.sendRedirect("listings.jsp?vehicle_id=" + vehicleId + "&dt=" + dt + "&bid=failure");
                    }
                } else {
                    response.sendRedirect("bidform.jsp?vehicle_id=" + vehicleId + "&dt=" + dt + "&bid=below_min_price");
                }
            } else {
                response.sendRedirect("listings.jsp?vehicle_id=" + vehicleId + "&dt=" + dt + "&bid=failure");
            }
        }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("listings.jsp?vehicle_id=" + vehicleId + "&dt=" + dt + "&bid=failure");
        } finally {
            if (resultSet != null) resultSet.close();
            if (preparedStatement != null) preparedStatement.close();
            if (connection != null) connection.close();
        }
    %>

