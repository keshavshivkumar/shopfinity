<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.Properties" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<%
    int vehicleId = Integer.parseInt(request.getParameter("vehicle_id"));
    String license = request.getParameter("license_plate");
    String sellerId = request.getParameter("seller_id");

    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
    java.util.Date currentDate = new java.util.Date();
    java.sql.Timestamp dtTimestamp = new java.sql.Timestamp(currentDate.getTime());

    //int bidAmount = Integer.parseInt(request.getParameter("bid_amount"));
    //int upperLimit = Integer.parseInt(request.getParameter("upper_limit"));

    String upperLimitStr = request.getParameter("upper_limit");
    int bidAmount = Integer.parseInt(request.getParameter("bid_amount"));
    int upperLimit;

    if (upperLimitStr != null && !upperLimitStr.isEmpty()) {
        upperLimit = Integer.parseInt(upperLimitStr);
    } else {
        upperLimit = bidAmount;
    }
    HttpSession session1 = request.getSession();
    String buyerId = session.getAttribute("user").toString();
    String redirectUrl = "";

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
            	preparedStatement = connection.prepareStatement("SELECT b.vehicle_id, COALESCE(MAX(b.bid_amount), 0) as highest_bid_amount, l.seller_id FROM Bids as b, Listings as l WHERE b.vehicle_id=? AND b.license_plate=? AND b.vehicle_id=l.vehicle_id AND b.seller_id=l.seller_id AND b.license_plate = l.license_plate GROUP BY b.vehicle_id, l.seller_id");
                preparedStatement.setInt(1, vehicleId);
                preparedStatement.setString(2, license);
                resultSet = preparedStatement.executeQuery();


                if (resultSet.next() && resultSet.getInt("highest_bid_amount") != 0) {
                    int currentBid = resultSet.getInt("highest_bid_amount");
                    
                    if (bidAmount > currentBid + minInc) {
                        String currentHighestBuyerId;
                        int currentHighestUpperLimit;

                        preparedStatement = connection.prepareStatement("SELECT buyer_id, upper_limit FROM Bids WHERE vehicle_id=? AND bid_amount=? AND license_plate=?");
                        preparedStatement.setInt(1, vehicleId);
                        preparedStatement.setInt(2, currentBid);
                        preparedStatement.setString(3, license);
                        
                        resultSet = preparedStatement.executeQuery();

                        if (resultSet.next()) {
                        	
                            currentHighestBuyerId = resultSet.getString("buyer_id");
                            currentHighestUpperLimit = resultSet.getInt("upper_limit");
                            int newBidForCurrentHighest = currentBid;
                            int newBidForNewBidder = bidAmount;
                            boolean currentHighestReachedLimit = false;
                            boolean newBidderReachedLimit = false;

                            while (true) {
                                if (!currentHighestReachedLimit && newBidForCurrentHighest + minInc <= currentHighestUpperLimit && newBidForCurrentHighest <= newBidForNewBidder) {
                                    newBidForCurrentHighest += minInc;
                                } else {
                                    currentHighestReachedLimit = true;
                                }

                                if (!newBidderReachedLimit && newBidForNewBidder + minInc <= upperLimit && newBidForNewBidder <= newBidForCurrentHighest) {
                                    newBidForNewBidder += minInc;
                                } else {
                                    newBidderReachedLimit = true;
                                }

                                if (currentHighestReachedLimit && newBidderReachedLimit) {
                                    break;
                                }
                            }
                            // Check which bidder's incremented bid is higher and update the Bids table
                            if (newBidForCurrentHighest > newBidForNewBidder || (newBidForCurrentHighest == newBidForNewBidder && currentHighestUpperLimit>upperLimit)) {
                                preparedStatement = connection.prepareStatement("UPDATE Bids SET bid_amount=?, dt=? WHERE vehicle_id=? AND buyer_id=? AND license_plate=?");
                                preparedStatement.setInt(1, newBidForCurrentHighest);
                                preparedStatement.setTimestamp(2, dtTimestamp);
                                preparedStatement.setInt(3, vehicleId);
                                preparedStatement.setString(4, currentHighestBuyerId);
                                preparedStatement.setString(5, license);
                                preparedStatement.executeUpdate();
                                // Delete the losing bid
                                
                                preparedStatement = connection.prepareStatement("DELETE FROM Bids WHERE vehicle_id=? AND buyer_id=? AND license_plate=?");
                                preparedStatement.setInt(1, vehicleId);
                                preparedStatement.setString(2, buyerId);
                                preparedStatement.setString(3, license);
                                preparedStatement.executeUpdate();
                                
                                String vehicleName;
                                preparedStatement = connection.prepareStatement("SELECT vehicle_name, vehicle_model FROM Vehicles WHERE vehicle_id = ?");
                                preparedStatement.setInt(1, vehicleId);
                                ResultSet vehicleResultSet = preparedStatement.executeQuery();
                                if (vehicleResultSet.next()) {
                                	vehicleName = vehicleResultSet.getString("vehicle_name") + " " + vehicleResultSet.getString("vehicle_model");
                                } else {
                                    vehicleName = "Unknown Vehicle";
                                }

                                // Insert notification for the losing bidder
                                preparedStatement = connection.prepareStatement("INSERT INTO Notifications (email_id, notification_text) VALUES (?, ?)");
                                preparedStatement.setString(1, buyerId);
                                preparedStatement.setString(2, "Your bid on vehicle " + vehicleName + " with license plate " + license + " was beaten by " + currentHighestBuyerId + " with amount " + newBidForCurrentHighest);
                                preparedStatement.executeUpdate();
                               
                                redirectUrl="index.jsp?bid=success";
                            } else if (newBidForCurrentHighest == newBidForNewBidder && currentHighestUpperLimit==upperLimit){
                            	redirectUrl="index.jsp?bid=repeat";
                            } else {
                            	
                            	// Get the vehicle name
                                String vehicleName;
                                preparedStatement = connection.prepareStatement("SELECT vehicle_name, vehicle_model FROM Vehicles WHERE vehicle_id = ?");
                                preparedStatement.setInt(1, vehicleId);
                                ResultSet vehicleResultSet = preparedStatement.executeQuery();
                                if (vehicleResultSet.next()) {
                                    vehicleName = vehicleResultSet.getString("vehicle_name") + " " + vehicleResultSet.getString("vehicle_model");
                                } else {
                                    vehicleName = "Unknown Vehicle";
                                }

                                // Insert notification for the current highest bidder before deleting their bid
                                preparedStatement = connection.prepareStatement("INSERT INTO Notifications (email_id, notification_text) VALUES (?, ?)");
                                preparedStatement.setString(1, currentHighestBuyerId);
                                preparedStatement.setString(2, "Your bid on vehicle " + vehicleName + " with license plate " + license + " was beaten by " + buyerId + " with amount " + newBidForNewBidder);
                                preparedStatement.executeUpdate();
                            	
                            	preparedStatement = connection.prepareStatement("DELETE FROM Bids WHERE vehicle_id=? AND buyer_id=? AND license_plate=?");
                                preparedStatement.setInt(1, vehicleId);
                                preparedStatement.setString(2, currentHighestBuyerId);
                                preparedStatement.setString(3, license);
                                preparedStatement.executeUpdate();
                            	
                            	preparedStatement = connection.prepareStatement("INSERT INTO Bids (vehicle_id, dt, seller_id, buyer_id, upper_limit, bid_amount, license_plate) VALUES (?, ?, ?, ?, ?, ?, ?)");
                                preparedStatement.setInt(1, vehicleId);
                                preparedStatement.setTimestamp(2, dtTimestamp);
                                preparedStatement.setString(3, sellerId);
                                preparedStatement.setString(4, buyerId);
                                preparedStatement.setInt(5, upperLimit);
                                preparedStatement.setInt(6, newBidForNewBidder);
                                preparedStatement.setString(7, license);
                                preparedStatement.executeUpdate();
                                // Delete the losing bid
                                
                                
                                 
                                redirectUrl="index.jsp?bid=success";
                            }
                        }
                    }
                    else{
                    	redirectUrl="index.jsp?bid=failure";
                    }
                }

                else {
                    // Insert the bid into the Bids table when there is no existing highest bid
                    
                    preparedStatement = connection.prepareStatement("INSERT INTO Bids (vehicle_id, dt, seller_id, buyer_id, upper_limit, bid_amount, license_plate) VALUES (?, ?, ?, ?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
                    preparedStatement.setInt(1, vehicleId);
                    preparedStatement.setTimestamp(2, dtTimestamp);
                    preparedStatement.setString(3, sellerId);
                    preparedStatement.setString(4, buyerId);
                    preparedStatement.setInt(5, upperLimit);
                    preparedStatement.setInt(6, bidAmount);
                    preparedStatement.setString(7, license);
                    preparedStatement.executeUpdate();
                    redirectUrl="index.jsp?bid=success";
                }
                
            } else {
            	redirectUrl="index.jsp?bid=failure";
            }
            response.sendRedirect(redirectUrl);
        }

        
    } catch (Exception e) {
        response.sendRedirect("listings.jsp?bid=failure");
    } finally {
        if (resultSet != null) try { resultSet.close(); } catch (SQLException e) { /* ignored */ }
        if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException e) { /* ignored */ }
        if (connection != null) try { connection.close(); } catch (SQLException e) { /* ignored */ }
    }
%>