<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.Properties" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<%
    HttpSession session1 = request.getSession();
    int roleId = Integer.parseInt(session1.getAttribute("role_id").toString());

    try {
        String query = request.getParameter("query");
        if (query == null || query.isEmpty()) {
            return;
        }

        Properties props = new Properties();
        FileInputStream in = new FileInputStream(getServletContext().getRealPath("/resources/database.properties"));
        props.load(in);
        in.close();
        String url = props.getProperty("db.url");
        String username = props.getProperty("db.username");
        String pswd = props.getProperty("db.password");
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(url, username, pswd);

        PreparedStatement stmt = con.prepareStatement("SELECT v.vehicle_id, v.vehicle_name, v.vehicle_model, v.vehicle_type, l.seller_id, l.license_plate, l.dt, e.full_name, l.listing_price, l.dt, CONCAT(TIMESTAMPDIFF(HOUR, NOW(), l.expiration_datetime), 'h ', TIMESTAMPDIFF(MINUTE, NOW(), l.expiration_datetime) % 60, 'm ', TIMESTAMPDIFF(SECOND, NOW(), l.expiration_datetime) % 60, 's') AS time_left, COALESCE(b.bid_amount, NULL) as bid_amount FROM Vehicles AS v JOIN Listings AS l ON v.vehicle_id=l.vehicle_id JOIN EndUsers as e ON l.seller_id = e.email_id LEFT JOIN Bids as b ON l.vehicle_id = b.vehicle_id AND l.license_plate = b.license_plate WHERE v.vehicle_name LIKE ? AND l.expiration_datetime > NOW()");
        stmt.setString(1, "%" + query + "%");

        ResultSet rs = stmt.executeQuery();

        out.println("<table class=\"results-table\" style=\"width: 100%; text-align: center; margin-left: auto; margin-right: auto;\">");
        out.println("<thead>");
        out.println("<tr><th>Vehicle Name</th><th>Vehicle Model</th><th>Vehicle Type</th><th>License Plate</th><th>Seller</th><th>Listing Price</th><th>Time Left (minutes)</th><th>Current Bid</th><th>Bid</th>");
        if (roleId < 3) {
            out.println("<th>Action</th>");
        }
        out.println("</tr>");
        out.println("</thead>");
        out.println("<tbody>");

        int counter = 0;
        while (rs.next()) {
            counter++;
            String vehicleId = rs.getString("vehicle_id");
            String sellerId = rs.getString("seller_id");
            String dt = rs.getString("dt");
            out.println("<tr><td>" + rs.getString("vehicle_name") + "</td><td>" + rs.getString("vehicle_model") + "</td><td>" + rs.getString("vehicle_type") + "</td><td>" + rs.getString("license_plate") + "</td><td>" + rs.getString("full_name")+ "</td><td>" + rs.getString("listing_price") + "</td><td>" + rs.getString("time_left") + "</td><td>" + rs.getInt("bid_amount") + "</td><td><form action='bidform.jsp' method='POST'><input type='hidden' name='seller_id' value='" + rs.getString("seller_id") + "'><input type='hidden' name='vehicle_id' value='" + rs.getInt("vehicle_id") + "'><input type='hidden' name='license_plate' value='" + rs.getString("license_plate") + "'><input type='hidden' name='dt' value='" + rs.getTimestamp("dt") + "'><button type='submit' class='btn-primary'>Bid</button></form></td>");
            
            if (roleId < 3) {
                out.println("<td><form action='deletelisting.jsp' method='POST'><input type='hidden' name='vehicle_id' value='" + rs.getInt("vehicle_id") + "'><input type='hidden' name='dt' value='" + rs.getTimestamp("dt") + "'><input type='hidden' name='license_plate' value='" + rs.getString("license_plate") + "'><button type='submit' class='btn btn-danger'>Delete</button></form></td>");
            }
            out.println("</tr>");
        }

        out.println("</tbody>");
        out.println("</table>");

        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
<script>
function formatTimeLeft(secondsLeft) {
  const hours = Math.floor(secondsLeft / 3600);
  const minutes = Math.floor((secondsLeft % 3600) / 60);
  const seconds = secondsLeft % 60;
  return `${hours}h ${minutes}m ${seconds}s`;
}

function updateTimers() {
  const timeLeftElements = document.querySelectorAll("[id^='time-left-']");
  timeLeftElements.forEach((element) => {
    let secondsLeft = parseInt(element.getAttribute("data-seconds-left"));
    if (secondsLeft > 0) {
      secondsLeft--;
      element.setAttribute("data-seconds-left", secondsLeft);
      element.textContent = formatTimeLeft(secondsLeft);
    }
  });
}

setInterval(updateTimers, 1000);
</script>