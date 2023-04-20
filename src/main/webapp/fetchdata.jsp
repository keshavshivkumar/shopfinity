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

        while (rs.next()) {
            out.println(rs.getString("vehicle_name")+ " - " + rs.getString("seller_id") + " - " + rs.getString("listing_price"));
            out.println("<br>");
        }

        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>