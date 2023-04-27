<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<%
	try {
	    String query = request.getParameter("query");
	    if (query == null || query.isEmpty()) {
	        return;
	    }
	
	    String connectionURL = "jdbc:mysql://localhost:3306/shopfinity";
	    String username = "root";
	    String password = "";
	
	    Class.forName("com.mysql.jdbc.Driver");
	    Connection con = DriverManager.getConnection(connectionURL, username, password);
	
	    PreparedStatement stmt = con.prepareStatement("SELECT v.vehicle_id, v.vehicle_name, l.seller_id, e.full_name, l.listing_price, CONCAT(TIMESTAMPDIFF(HOUR, NOW(), l.expiration_datetime), 'h ', TIMESTAMPDIFF(MINUTE, NOW(), l.expiration_datetime) % 60, 'm ', TIMESTAMPDIFF(SECOND, NOW(), l.expiration_datetime) % 60, 's') AS time_left FROM Vehicles AS v, Listings AS l, EndUsers as e WHERE v.vehicle_id=l.vehicle_id AND l.seller_id = e.email_id AND v.vehicle_name LIKE ?");
		stmt.setString(1, "%" + query + "%");
	
	    ResultSet rs = stmt.executeQuery();
	
	    out.println("<table class=\"results-table\" style=\"width: 100%; text-align: center; margin-left: auto; margin-right: auto;\">");
	    out.println("<thead>");
	    out.println("<tr><th>Vehicle Name</th><th>Seller</th><th>Listing Price</th><th>Time Left (minutes)</th><th></th></tr>");
	    out.println("</thead>");
	    out.println("<tbody>");
	
	    int counter = 0;
	    while (rs.next()) {
	        counter++;
	        String vehicleId = rs.getString("vehicle_id");
	        String sellerId = rs.getString("seller_id");
	        out.println("<tr><td>" + rs.getString("vehicle_name") + "</td><td>" + rs.getString("full_name")+ "</td><td>" + rs.getString("listing_price") + "</td><td>" + rs.getString("time_left") + "</td><td><button id='bid-button-" + counter + "' data-vehicle-id='" + vehicleId + "' data-seller-id='" + sellerId + "'>Bid</button></td></tr>");
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