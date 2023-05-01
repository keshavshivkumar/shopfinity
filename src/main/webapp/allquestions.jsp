<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Properties" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


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
    String userEmail = session.getAttribute("user").toString();

    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;
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
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <% if (session1.getAttribute("loggedIn") != null && (Boolean) session1.getAttribute("loggedIn")) { 
                    	if (session1.getAttribute("role_id").equals(1)){%>
                    	<li class="nav-item">
                            <a href="salesreports.jsp" class="nav-link">Reports</a>
                        </li>
                    	<li class="nav-item">
                            <a href="reps.jsp" class="nav-link">Representatives</a>
                        </li>
                        <% } 
                        if (session1.getAttribute("role_id").equals(2)){%>
                        <li class="nav-item">
                            <a href="answerquestions.jsp" class="nav-link">Answer Questions</a>
                        </li>
                        <% } 
                        if (session1.getAttribute("role_id").equals(3)){%>
                        <li class="nav-item">
                            <a href="askquestions.jsp" class="nav-link">Ask Questions</a>
                        </li>
                        <li class="nav-item">
                            <a href="yourquestions.jsp" class="nav-link">Your Questions</a>
                        </li>
                        <% } %>
                        <li class="nav-item">
                            <a href="mylistings.jsp" class="nav-link">My Listings</a>
                        </li>
                        <li class="nav-item">
                            <a href="mybids.jsp" class="nav-link">My Bids</a>
                        </li>
                        <li class="nav-item">
                            <a href="sell.jsp" class="nav-link">Sell</a>
                        </li>
                        <li class="nav-item">
                            <a href="logout.jsp" class="nav-link">Sign Out</a>
                        </li>
                    <% } else { %>
                        <li class="nav-item">
                            <a href="login.jsp" class="nav-link">Log In</a>
                        </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </header>
    <main class="container my-4">
    <h2 class="mb-3">Questions</h2>
    <div class="input-group mb-3">
        <input type="text" id="search-input" class="form-control" placeholder="Search..." onkeyup="searchFunction()">
        <button class="btn btn-primary" type="button">Search</button>
    </div>
    <div class="table-responsive">
        <table class="table table-striped" id="questions-table">
            
                <thead>
				    <tr>
				        <th scope="col" onclick="loadSortedQuestions('question_id', 'asc')">Question ID</th>
				        <th scope="col" onclick="loadSortedQuestions('customer_id', 'asc')">Customer ID</th>
				        <th scope="col" onclick="loadSortedQuestions('representative_id', 'asc')">Representative ID</th>
				        <th scope="col" onclick="loadSortedQuestions('question', 'asc')">Question</th>
				        <th scope="col" onclick="loadSortedQuestions('answer', 'asc')">Answer</th>
				        <th scope="col" onclick="loadSortedQuestions('asked_datetime', 'asc')">Asked Datetime</th>
				        <th scope="col" onclick="loadSortedQuestions('answered_datetime', 'asc')">Answered Datetime</th>
				    </tr>
				</thead>


            
            <tbody>
                <%
                    // Initialize database connection and fetch data
                    Properties props = new Properties();
                    FileInputStream in = new FileInputStream(getServletContext().getRealPath("/resources/database.properties"));
                    props.load(in);
                    in.close();
                    String url = props.getProperty("db.url");
                    String username = props.getProperty("db.username");
                    String pswd = props.getProperty("db.password");
                    Class.forName("com.mysql.jdbc.Driver");
                    connection = DriverManager.getConnection(url, username, pswd);

                    String sortField = request.getParameter("sortField") != null ? request.getParameter("sortField") : "question_id";
                    String sortDirection = request.getParameter("sortDirection") != null ? request.getParameter("sortDirection") : "asc";

                    String query = "SELECT * FROM Questions ORDER BY " + sortField + " " + sortDirection;
                    preparedStatement = connection.prepareStatement(query);

                    resultSet = preparedStatement.executeQuery();

                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

                    while (resultSet.next()) {
                %>
                <tr>
                    <th scope="row"><%= resultSet.getInt("question_id") %></th>
                    <td><%= resultSet.getString("customer_id") %></td>
                    <td><%= resultSet.getString("representative_id") %></td>
                    <td><%= resultSet.getString("question") %></td>
                    <td><%= resultSet.getString("answer") %></td>
                    <td><%= sdf.format(resultSet.getTimestamp("asked_datetime")) %></td>
                    <td><%= resultSet.getTimestamp("answered_datetime") != null ? sdf.format(resultSet.getTimestamp("answered_datetime")) : "" %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <form id="sortForm" method="get" style="display:none;">
		    <input type="hidden" id="sortField" name="sortField" value="">
		    <input type="hidden" id="sortDirection" name="sortDirection" value="">
	</form>
        
    </div>
</main>

<script>
    function searchFunction() {
        const searchInput = document.getElementById("search-input");
        const filter = searchInput.value.toUpperCase();
        const table = document.getElementById("questions-table");
        const tr = table.getElementsByTagName("tr");

        for (let i = 1; i < tr.length; i++) {
            let txtValue = tr[i].textContent || tr[i].innerText;
            if (txtValue.toUpperCase().indexOf(filter) > -1) {
                tr[i].style.display = "";
            } else {
                tr[i].style.display = "none";
            }
        }
    }
    
    function loadSortedQuestions(sortField, sortDirection) {
        document.getElementById("sortField").value = sortField;
        document.getElementById("sortDirection").value = sortDirection;
        document.getElementById("sortForm").submit();
    }


    function sortTable(columnIndex) {
        let table = document.getElementById("questionsTable");
        let switching = true;
        let rows, i, x, y, shouldSwitch, direction;
        let switchCount = 0;

        direction = "asc";

        while (switching) {
            switching = false;
            rows = table.rows;

            for (i = 1; i < (rows.length - 1); i++) {
                shouldSwitch = false;
                x = rows[i].getElementsByTagName("td")[columnIndex];
                y = rows[i + 1].getElementsByTagName("td")[columnIndex];
                let xValue, yValue;

                if (isNaN(parseFloat(x.innerHTML))) {
                    xValue = x.innerHTML.toLowerCase();
                    yValue = y.innerHTML.toLowerCase();
                } else {
                    xValue = parseFloat(x.innerHTML);
                    yValue = parseFloat(y.innerHTML);
                }

                if (direction === "asc") {
                    if (xValue > yValue) {
                        shouldSwitch = true;
                        break;
                    }
                } else if (direction === "desc") {
                    if (xValue < yValue) {
                        shouldSwitch = true;
                        break;
                    }
                }
            }

            if (shouldSwitch) {
                rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                switching = true;
                switchCount++;
            } else {
                if (switchCount === 0 && direction === "asc") {
                    direction = "desc";
                    switching = true;
                }
            }
        }
    }

</script>
</body>
</html>
    