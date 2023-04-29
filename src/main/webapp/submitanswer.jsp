<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.net.URLEncoder" %>


<%
  // Get the form data
  int question_id = Integer.parseInt(request.getParameter("question_id"));
  String rep_id = request.getParameter("rep_id");
  String answer = request.getParameter("answer");

  try {
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
    String query = "UPDATE Questions SET representative_id = ?, answer = ?, answered_datetime = CURRENT_TIMESTAMP WHERE question_id = ?";
    PreparedStatement ps = conn.prepareStatement(query);
    ps.setString(1, rep_id);
    ps.setString(2, answer);
    ps.setInt(3, question_id);

    // Execute the query
    ps.executeUpdate();

    // Close the database connection
    conn.close();

    // Redirect to a success page
    response.sendRedirect("answerquestions.jsp?submit=success");
  } catch (Exception e) {
	  
	    String errorMessage = URLEncoder.encode(e.getMessage(), "UTF-8");
	    response.sendRedirect("answerquestions.jsp?error=invalid&errorMessage=" + errorMessage);
  }
%>
