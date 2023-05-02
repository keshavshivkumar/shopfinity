<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Properties" %>

<%
    try {
        HttpSession session1 = request.getSession();
        Properties props = new Properties();
        FileInputStream in = new FileInputStream(getServletContext().getRealPath("/resources/database.properties"));
        props.load(in);
        in.close();
        String url = props.getProperty("db.url");
        String username = props.getProperty("db.username");
        String pswd = props.getProperty("db.password");
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(url, username, pswd);

        String vehicleName = request.getParameter("vehicle_name");
        String vehicleModel = request.getParameter("vehicle_model");
        String vehicleType = request.getParameter("vehicle_type");
        int listingPrice = Integer.parseInt(request.getParameter("listing_price"));
        int minPrice = Integer.parseInt(request.getParameter("min_price"));
        int minInc = Integer.parseInt(request.getParameter("min_inc"));
        String expDateTime = request.getParameter("exp_datetime");
        String licensePlate = request.getParameter("license_plate");
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        java.util.Date parsedDate = dateFormat.parse(expDateTime);
        java.sql.Timestamp expirationTimestamp = new java.sql.Timestamp(parsedDate.getTime());


        // Check for unique license plate
        String checkLicensePlateQuery = "SELECT license_plate FROM Listings WHERE license_plate = ?";
        PreparedStatement checkLicensePlateStatement = con.prepareStatement(checkLicensePlateQuery);
        checkLicensePlateStatement.setString(1, licensePlate);
        ResultSet licensePlateResultSet = checkLicensePlateStatement.executeQuery();
        if (licensePlateResultSet.next()) {
            response.sendRedirect("sell.jsp?error=license_plate_not_unique");
            return;
        }

        // Check for existing vehicle
        String checkQuery = "SELECT vehicle_id FROM Vehicles WHERE vehicle_name = ? AND vehicle_model = ? AND vehicle_type = ?";
        PreparedStatement checkStatement = con.prepareStatement(checkQuery);
        checkStatement.setString(1, vehicleName.toUpperCase());
        checkStatement.setString(2, vehicleModel.toUpperCase());
        checkStatement.setString(3, vehicleType.toUpperCase());
        ResultSet rs = checkStatement.executeQuery();
        int vehicleId;

        if (rs.next()) {
            vehicleId = rs.getInt("vehicle_id");
        } else {
            String insertVehicleQuery = "INSERT INTO Vehicles (vehicle_name, vehicle_model, vehicle_type) VALUES (?, ?, ?)";
            PreparedStatement insertVehicleStatement = con.prepareStatement(insertVehicleQuery, Statement.RETURN_GENERATED_KEYS);
            String vehicleNameUpper = vehicleName.toUpperCase();
            String vehicleModelUpper = vehicleModel.toUpperCase();
            String vehicleTypeUpper = vehicleType.toUpperCase();
            insertVehicleStatement.setString(1, vehicleNameUpper);
            insertVehicleStatement.setString(2, vehicleModelUpper);
            insertVehicleStatement.setString(3, vehicleTypeUpper);
            insertVehicleStatement.executeUpdate();

            ResultSet generatedKeys = insertVehicleStatement.getGeneratedKeys();
            if (generatedKeys.next()) {
                vehicleId = generatedKeys.getInt(1);
            } else {
                throw new SQLException("Creating vehicle failed, no ID obtained.");
            }
        }
		
        String seller_id = (String) session1.getAttribute("user");
        String insertListingQuery = "INSERT INTO Listings (vehicle_id, dt, seller_id, buyer_id, final_bid, listing_price, min_price, min_inc, sold, expiration_datetime, license_plate) VALUES (?, NOW(), ?, NULL, NULL, ?, ?, ?, false, ?, ?)";
        PreparedStatement insertListingStatement = con.prepareStatement(insertListingQuery);
        insertListingStatement.setInt(1, vehicleId);
        insertListingStatement.setString(2, seller_id);
        insertListingStatement.setInt(3, listingPrice);
        insertListingStatement.setInt(4, minPrice);
        insertListingStatement.setInt(5, minInc);
        insertListingStatement.setTimestamp(6, expirationTimestamp);
        insertListingStatement.setString(7, licensePlate);
        insertListingStatement.executeUpdate();
        
        
        String buyersQuery = "SELECT email_id FROM Wishlists WHERE vehicle_id = ? AND email_id <> ?";
        PreparedStatement buyersStatement = con.prepareStatement(buyersQuery);
        buyersStatement.setInt(1, vehicleId);
        buyersStatement.setString(2, seller_id);
        ResultSet buyersResultSet = buyersStatement.executeQuery();

        String notificationText = "A vehicle you have in your wishlist is now available for bidding: " + vehicleName + " " + vehicleModel + " (" + vehicleType + ").";
        String insertNotificationQuery = "INSERT INTO Notifications (email_id, notification_text) VALUES (?, ?)";
        PreparedStatement insertNotificationStatement = con.prepareStatement(insertNotificationQuery);

        while (buyersResultSet.next()) {
            String buyerEmail = buyersResultSet.getString("email_id");
            insertNotificationStatement.setString(1, buyerEmail);
            insertNotificationStatement.setString(2, notificationText);
            insertNotificationStatement.executeUpdate();
        }

        response.sendRedirect("sell.jsp?listed=success");
        con.close();
    }
    catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

