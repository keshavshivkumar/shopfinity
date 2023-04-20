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
        String password = "mutexlock";

        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(connectionURL, username, password);

        PreparedStatement stmt = con.prepareStatement("SELECT v.vehicle_name, l.seller_id, l.listing_price FROM Vehicles AS v,Listings AS l WHERE v.vehicle_id=l.vehicle_id AND v.vehicle_name LIKE ?");
        stmt.setString(1, "%" + query + "%");

        ResultSet rs = stmt.executeQuery();

        out.println("<table class=\"results-table\">");
        out.println("<thead>");
        out.println("<tr><th>Vehicle Name</th><th>Seller ID</th><th>Listing Price</th></tr>");
        out.println("</thead>");
        out.println("<tbody>");

        while (rs.next()) {
            out.println("<tr><td>" + rs.getString("vehicle_name") + "</td><td>" + rs.getString("seller_id") + "</td><td>" + rs.getString("listing_price") + "</td></tr>");
        }

        out.println("</tbody>");
        out.println("</table>");

        con.close();

        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>