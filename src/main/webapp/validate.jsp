<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.Properties" %>

<%
	// Get the form data
	String full_name = request.getParameter("full_name");
	String email = request.getParameter("email_id");
	long ph_no = Long.parseLong(request.getParameter("ph_no"));
	String passwd = request.getParameter("passwd");
	try{
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
        String pswd= props.getProperty("db.password");
		Connection conn = DriverManager.getConnection(url, username, pswd);
		
		// Prepare the SQL query
		String query = "INSERT INTO EndUsers (full_name, email_id, ph_no, passwd) VALUES (?, ?, ?, ?)";
		PreparedStatement ps = conn.prepareStatement(query);
		ps.setString(1, full_name);
		ps.setString(2, email);
		ps.setLong(3, ph_no);
		ps.setString(4, passwd);
		
		// Execute the query
		ps.executeUpdate();
		
		// Close the database connection
		conn.close();
		
		// Redirect to a success page
		session1.setAttribute("signedUp", false);
		response.sendRedirect("login.jsp?signup=success");
	} catch(Exception e){
		response.sendRedirect("signup.jsp?error=invalid");
	}
%>