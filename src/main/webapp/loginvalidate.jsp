<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
	HttpSession session1 = request.getSession();
	String email = request.getParameter("email");
	String password = request.getParameter("password");

	String connectionURL = "jdbc:mysql://localhost:3306/shopfinity";
	Connection connection = null;
	ResultSet rs = null;
	Statement statement = null;
	Class.forName("com.mysql.jdbc.Driver");
	connection = DriverManager.getConnection(connectionURL, "root", "mutexlock");
	statement = connection.createStatement();
	String query = "SELECT * FROM EndUsers WHERE email_id='" + email + "' AND passwd='" + password + "'";
	rs = statement.executeQuery(query);

	if (rs.next()) {
		// Login successful, redirect to home page
		session1.setAttribute("loggedIn", false);
		response.sendRedirect("index.jsp?login=success");
	} else {
		// Login failed, redirect back to login form
		response.sendRedirect("login.jsp?error=invalid");
	}
	statement.close();
	connection.close();

%>

