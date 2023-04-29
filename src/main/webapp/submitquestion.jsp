<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.Properties" %>

<%
    // Get the form data
    String customer_id = request.getParameter("customer_id");
    String question = request.getParameter("question");

    try {
        HttpSession session1 = request.getSession();

        // Load the MySQL driver
        Class.forName("com.mysql.jdbc.Driver");

        // Connect to the database
        Properties props = new Properties();
        FileInputStream in = new FileInputStream(getServletContext().getRealPath("/resources/database.properties"));
        props.load(in);
        in.close();
        String url = props.getProperty("db.url");
        String username = props.getProperty("db.username");
        String pswd = props.getProperty("db.password");
        Connection conn = DriverManager.getConnection(url, username, pswd);

        // Prepare the SQL query
        String query = "INSERT INTO Questions (customer_id, question, representative_id, asked_datetime) VALUES (?, ?, NULL, CURRENT_TIMESTAMP)";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, customer_id);
        ps.setString(2, question);

        // Execute the query
        ps.executeUpdate();

        // Close the database connection
        conn.close();

        // Redirect to a success page
        response.sendRedirect("askquestions.jsp?submission=success");
    } catch (Exception e) {
        response.sendRedirect("askquestions.jsp?error=invalid");
    }
%>
