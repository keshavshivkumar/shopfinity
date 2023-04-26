<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    try {
        HttpSession session1 = request.getSession();
        String connectionURL = "jdbc:mysql://localhost:3306/shopfinity";
        String username = "root";
        String password = "";

        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(connectionURL, username, password);

        int vehicleId = Integer.parseInt(request.getParameter("vehicle_id"));
        String vehicleName = request.getParameter("vehicle_name");
        String vehicleType = request.getParameter("vehicle_type");
        int listingPrice = Integer.parseInt(request.getParameter("listing_price"));
        int minPrice = Integer.parseInt(request.getParameter("min_price"));
        int minInc = Integer.parseInt(request.getParameter("min_inc"));

        String checkQuery = "SELECT vehicle_id FROM Vehicles WHERE vehicle_id = ?";
        PreparedStatement checkStatement = con.prepareStatement(checkQuery);
        checkStatement.setInt(1, vehicleId);
        ResultSet rs = checkStatement.executeQuery();
        if (rs.next())
            {
                response.sendRedirect("sell.jsp?listed=failure");
            }
        else
            {
                String insertQuery = "INSERT INTO Vehicles (vehicle_id, vehicle_name, vehicle_type) VALUES (?, ?, ?)";
                PreparedStatement insertStatement = con.prepareStatement(insertQuery);
                insertStatement.setInt(1, vehicleId);
                insertStatement.setString(2, vehicleName);
                insertStatement.setString(3, vehicleType);
                insertStatement.executeUpdate();
                
                String seller_id = (String) session1.getAttribute("user");
                String insertListingQuery = "INSERT INTO Listings (vehicle_id, dt, seller_id, buyer_id, final_bid, listing_price, min_price, min_inc, sold) VALUES (?, NOW(), ?, NULL, NULL, ?, ?, ?, false)";
                PreparedStatement insertListingStatement = con.prepareStatement(insertListingQuery);
                insertListingStatement.setInt(1, vehicleId);
                insertListingStatement.setString(2, seller_id);
                insertListingStatement.setInt(3, listingPrice);
                insertListingStatement.setInt(4, minPrice);
                insertListingStatement.setInt(5, minInc);
                insertListingStatement.executeUpdate();

                response.sendRedirect("sell.jsp?listed=success");

            }
        con.close();
    }
    catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

