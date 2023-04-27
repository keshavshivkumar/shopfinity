<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    try {
        String query = request.getParameter("query");
        if (query == null || query.isEmpty()) {
            return;
        }

        String connectionURL = "jdbc:mysql://localhost:3306/shopfinity";
        String username = "root";
        String password = "qwertyuiop1@@1";

        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(connectionURL, username, password);

        PreparedStatement stmt = con.prepareStatement("SELECT v.vehicle_id, v.vehicle_name, l.seller_id, e.full_name, l.listing_price FROM Vehicles AS v,Listings AS l, EndUsers as e WHERE v.vehicle_id=l.vehicle_id AND l.seller_id = e.email_id AND v.vehicle_name LIKE ?");
        stmt.setString(1, "%" + query + "%");

        ResultSet rs = stmt.executeQuery();

        out.println("<table class=\"results-table\" style=\"width: 80%; text-align: center; margin-left: auto; margin-right: auto;\">");
        out.println("<thead>");
        out.println("<tr><th>Vehicle Name</th><th>Seller</th><th>Listing Price</th><th></th></tr>");
        out.println("</thead>");
        out.println("<tbody>");

        int counter = 0;
        while (rs.next()) {
            counter++;
            String vehicleId = rs.getString("vehicle_id");
            String sellerId = rs.getString("seller_id");
            out.println("<tr><td>" + rs.getString("vehicle_name") + "</td><td>" + rs.getString("full_name")+ "</td><td>" + rs.getString("listing_price") + "</td><td><button id='bid-button-" + counter + "' data-vehicle-id='" + vehicleId + "' data-seller-id='" + sellerId + "'>Bid</button></td></tr>");
        }

        out.println("</tbody>");
        out.println("</table>");

        con.close();

        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>