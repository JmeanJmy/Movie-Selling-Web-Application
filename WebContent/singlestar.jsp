<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.naming.*"%>
<%@ page import="javax.sql.DataSource"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Single Star Page</title>
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
</head>
<body>
	<% if(session.isNew()){
	session.setAttribute("isLogin", "0");%>
	<jsp:forward page="login.jsp">
		<jsp:param name="funcID" value="2" />
	</jsp:forward>
	<%
}
else if(session.getAttribute("isLogin").equals("1")){
	/*String loginUser = "root";
    String loginPassword = "950205jmy";
    String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
    try {
    	Class.forName("com.mysql.jdbc.Driver").newInstance();
    	}catch(Exception e) {
    	out.println("can't load mysql driver");
    	out.println(e.toString());
    }
    Connection conn = DriverManager.getConnection(loginUrl, loginUser, loginPassword);*/
	Context initCtx = new InitialContext();
    Context envCtx = (Context) initCtx.lookup("java:comp/env");
    DataSource ds = (DataSource) envCtx.lookup("jdbc/FablixDB");
    Connection conn = ds.getConnection();
    //Statement stmt = conn.createStatement();
    String starId = request.getParameter("starid");
    //String sql = "SELECT s.id, s.name, s.birthYear FROM stars AS s WHERE s.id = '" + starId + "'";
    //ResultSet rs = stmt.executeQuery(sql);
    String sql = "SELECT s.id, s.name, s.birthYear FROM stars AS s WHERE s.id = ?";
    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setString(1, starId);
    ResultSet rs = ps.executeQuery();
    rs.next();
    String starName = rs.getString("s.name");
    String StarBirthYear = rs.getString("s.birthYear");
    rs.close();
    ps.close();%>
	<div class="w3-container w3-dark-grey">
		<a href="mainpage.jsp" class="w3-button w3-padding-large">Home</a>
		&nbsp<a href="shoppingcart.jsp" class="w3-button w3-padding-large">Cart</a>
		&nbsp<a href="searching.jsp" class="w3-button w3-padding-large">Search</a>
		&nbsp<a href="browsing.jsp" class="w3-button w3-padding-large">Browse</a>
		<a href="logout.jsp" class="w3-button w3-padding-large w3-right">Logout</a>
	</div>
	<div class="w3-container">
		<div class="w3-panel w3-card-4 w3-center w3-dark-grey w3-animate-zoom">
			<p>
				Star ID:
				<%=starId %></p>
			<p>
				Name:
				<%=starName %></p>
			<p>
				Birth Year:
				<%=StarBirthYear %></p>
			<p>
				Movies:
				<% 
	//sql = "SELECT m.id, m.title FROM stars_in_movies AS sim, movies AS m WHERE sim.starId = '" + starId +"' AND sim.movieId = m.id";
	//rs = stmt.executeQuery(sql);
	String sqlMovie = "SELECT m.id, m.title FROM stars_in_movies AS sim, movies AS m WHERE sim.starId = ? AND sim.movieId = m.id";
	PreparedStatement psMovie = conn.prepareStatement(sqlMovie);
	psMovie.setString(1, starId);
	ResultSet rsMovie = psMovie.executeQuery();
	while(rsMovie.next()){
		String m_title = rsMovie.getString("m.title");
		String movieId = rsMovie.getString("m.id");%>
				<a href="singlemovie.jsp?movieid=<%=movieId %>"><%=m_title %></a>
				<% }%>

			</p>
		</div>
	</div>
	<% 
	rsMovie.close();
    //stmt.close();
    psMovie.close();
    conn.close();%>
	<br></br>
	<p align="center">
		<a href="javascript:;" onClick="javascript:history.back(-1);">Back
			to previous page</a>
	</p>
	<hr />
	<div class="w3-container w3-bottom w3-center">
		<P>Copyright &copy; CS-122B-Team-99</p>
		<br />
	</div>

	<%
}
else{%>
	<jsp:forward page="login.jsp">
		<jsp:param name="funcID" value="2" />
	</jsp:forward>
	<%
}%>
</body>
</html>