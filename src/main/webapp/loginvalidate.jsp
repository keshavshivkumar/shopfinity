<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.Properties" %>

<%
	HttpSession session1 = request.getSession();
	String email = request.getParameter("email");
	String password = request.getParameter("password");

	Connection connection = null;
	ResultSet rs = null;
	Statement statement = null;
	Class.forName("com.mysql.jdbc.Driver");
	Properties props = new Properties();
    FileInputStream in = new FileInputStream(getServletContext().getRealPath("/resources/database.properties"));
    props.load(in);
    in.close();
    String url = props.getProperty("db.url");
    String username = props.getProperty("db.username");
    String pswd = props.getProperty("db.password");
	connection = DriverManager.getConnection(url, username, pswd);
	statement = connection.createStatement();
	String query = "SELECT * FROM EndUsers WHERE email_id='" + email + "' AND passwd='" + password + "'";
	rs = statement.executeQuery(query);

	if (rs.next()) {
		// Login successful, redirect to home page
		session1.setAttribute("loggedIn", false);
		session1.setAttribute("user", email);
		session1.setAttribute("role_id", rs.getInt("role_id"));
		response.sendRedirect("index.jsp?login=success");
	} else {
		// Login failed, redirect back to login form
		response.sendRedirect("login.jsp?error=invalid");
	}
	statement.close();
	connection.close();

%>

