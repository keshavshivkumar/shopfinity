<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Properties" %>

<%
    HttpSession session1 = request.getSession();
    
        int vehicleId = Integer.parseInt(request.getParameter("vehicle_id"));
        String userEmail = session1.getAttribute("user").toString();

        Connection connection = null;
        PreparedStatement preparedStatement = null;

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
            
            preparedStatement = connection.prepareStatement("INSERT INTO Wishlists (email_id, vehicle_id) VALUES (?, ?)");
            preparedStatement.setString(1, userEmail);
            preparedStatement.setInt(2, vehicleId);
            preparedStatement.executeUpdate();

            session.setAttribute("wishlistMessage", "Vehicle added to wishlist successfully!");
            response.sendRedirect("wishlist.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("wishlistMessage", "Error adding vehicle to wishlist!");
            response.sendRedirect("wishlist.jsp");
        } finally {
            if (preparedStatement != null) preparedStatement.close();
            if (connection != null) connection.close();
        }
    
%>
