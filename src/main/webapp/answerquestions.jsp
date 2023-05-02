<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.Properties" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<html>
<head>
    <title>Index</title>
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700&display=swap" rel="stylesheet">
</head>

<body>
<%
    HttpSession session1 = request.getSession();
%>
<header class="navbar navbar-expand-lg navbar-dark bg-primary py-3">
    <div class="container">
        <a href="index.jsp" class="navbar-brand text-decoration-none">
            <h1 class="text-white">ShopFinity</h1>
        </a>
        <div class="navbar-text text-white">
            <% if (session1.getAttribute("user") != null) { %>
                <small>Hello <%= session1.getAttribute("user") %>!</small>
            <% } else { %>
                <small>Hello Guest!</small>
            <% } %>
        	</div>
        <nav class="navbar-nav ms-auto">
            <% if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn")) { %>
                <li class="nav-item">
                            <a href="mylistings.jsp" class="nav-link">My Listings</a>
                </li>
                <li class="nav-item">
                            <a href="allquestions.jsp" class="nav-link">All Questions</a>
                        </li>
                <li class="nav-item">
                    <a href="sell.jsp" class="nav-link">Sell</a>
                </li>
                <li class="nav-item">
                            <a href="notifications.jsp" class="nav-link">Notifications</a>
                        </li>
                        <li class="nav-item">
                            <a href="wishlist.jsp" class="nav-link">Wishlist</a>
                        </li>
                <li class="nav-item">
                    <a href="logout.jsp" class="nav-link">Sign Out</a>
                </li>
            <% } else { %>
                <li class="nav-item">
                    <a href="login.jsp" class="nav-link">Log In</a>
                </li>
            <% } %>
        </nav>
    </div>
</header>
<div class="container">
  <div class="row">
    <div class="col-md-12">
      <h2 class="text-center mt-4 mb-3">Unanswered Questions</h2>
      <% if (request.getParameter("error") != null && request.getParameter("error").equals("invalid")) { %>
    <div class="alert alert-danger">
        <strong>Error:</strong> <%= request.getParameter("errorMessage") %>
    </div>
		<% } %>
      

      <% if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn") && (Integer) session1.getAttribute("role_id") == 2) { %>

        <table class="table table-bordered table-hover">
          <thead>
            <tr>
              <th>Customer ID</th>
              <th>Question</th>
              <th>Asked Datetime</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <%
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
              String query = "SELECT * FROM Questions WHERE representative_id IS NULL";
              PreparedStatement ps = conn.prepareStatement(query);

              // Execute the query
              ResultSet rs = ps.executeQuery();

              // Iterate through the result set and display the questions
              while (rs.next()) {
            %>
            <tr>
              <td><%= rs.getString("customer_id") %></td>
              <td><%= rs.getString("question") %></td>
              <td><%= rs.getTimestamp("asked_datetime") %></td>
              <td><button class="btn btn-primary" data-toggle="modal" data-target="#answerModal" data-question-id="<%= rs.getInt("question_id") %>">Answer</button></td>
            </tr>
            <%
              }
              // Close the database connection
              conn.close();
            %>
          </tbody>
        </table>

        <!-- Answer Modal -->
        <div class="modal fade" id="answerModal" tabindex="-1" role="dialog" aria-labelledby="answerModalLabel" aria-hidden="true">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="answerModalLabel">Answer Question</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body">
                <form id="answerForm" action="submitanswer.jsp" method="POST">
                  <input type="hidden" name="question_id" id="question_id">
                  <input type="hidden" name="rep_id" value="<%= session1.getAttribute("user") %>">

                  <div class="form-group">
                    <label for="answer">Answer:</label>
                    <textarea name="answer" id="answer" class="form-control" required></textarea>
                  </div>

                  <div class="form-group mt-3">
                                      <button type="submit" class="btn btn-primary">Submit Answer</button>
                  </div>
                </form>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
              </div>
            </div>
          </div>
        </div>
        <!-- End of Answer Modal -->

      <% } else { %>
        <div class="alert alert-warning">You must be logged in as a customer representative to view this page.</div>
      <% } %>
    </div>
  </div>
</div>

<!-- Include jQuery and Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
  $(document).ready(function () {
    $('#answerModal').on('show.bs.modal', function (event) {
      var button = $(event.relatedTarget); // Button that triggered the modal
      var questionId = button.data('question-id'); // Extract the question ID from data-* attribute

      // Update the form's question_id input field with the extracted question ID
      var modal = $(this);
      modal.find('#question_id').val(questionId);
    });
  });
</script>
                    

</body>