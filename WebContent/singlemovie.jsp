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
<title>Single Movie Page</title>
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
	String movieId = request.getParameter("movieid");
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
    //String sql = "SELECT m.id, m.title, m.year, m.director" + 
    //	" FROM movies AS m" + 
    //	" WHERE m.id = '" + movieId + "'";
    //ResultSet rs = stmt.executeQuery(sql);
    String sql = "SELECT m.id, m.title, m.year, m.director FROM movies AS m WHERE m.id = ?";
    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setString(1, movieId);
    ResultSet rs = ps.executeQuery();
    rs.next();
    String m_title = rs.getString("m.title");
    String m_id = rs.getString("m.id");
    String m_year = rs.getString("m.year");
    String m_director = rs.getString("m.director");
    rs.close();
    ps.close();
    %>
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
				Movie ID:
				<%=m_id %></p>
			<p>
				Title:
				<%=m_title %></p>
			<p>
				Year:
				<%=m_year %></p>
			<p>
				Director:
				<%=m_director %></p>
			<p>
				Genres:
				<% 
	//sql = "SELECT g.id, g.name FROM genres_in_movies AS gim, genres AS g WHERE gim.movieId = '" + movieId +"' AND gim.genreId = g.id";
	//rs = stmt.executeQuery(sql);
	String sqlGenre = "SELECT g.id, g.name FROM genres_in_movies AS gim, genres AS g WHERE gim.movieId = ? AND gim.genreId = g.id";
	PreparedStatement psGenre = conn.prepareStatement(sqlGenre);
	psGenre.setString(1, movieId);
	ResultSet rsGenre = psGenre.executeQuery();
	while(rsGenre.next()){
		String g_id = rsGenre.getString("g.id");
		String g_name = rsGenre.getString("g.name");%>
				<a href="movielist.jsp?genreid=<%=g_id %>"><%=g_name %></a>
				<% }
	psGenre.close();
	rsGenre.close();
	%>
			</p>
			<p>
				Stars:
				<% 
	
	//sql = "SELECT s.id, s.name FROM stars_in_movies AS sim, stars AS s WHERE sim.movieId = '" + movieId +"' AND sim.starId = s.id";
	//rs = stmt.executeQuery(sql);
	String sqlStar = "SELECT s.id, s.name FROM stars_in_movies AS sim, stars AS s WHERE sim.movieId = ? AND sim.starId = s.id";
	PreparedStatement psStar = conn.prepareStatement(sqlStar);
	psStar.setString(1, movieId);
	ResultSet rsStar = psStar.executeQuery();
	while(rsStar.next()){
		String s_id = rsStar.getString("s.id");
		String s_name = rsStar.getString("s.name");%>
				<a href="singlestar.jsp?starid=<%=s_id %>"><%=s_name %></a>
				<% }%>
			</p>
		</div>
	</div>
	<% 
	rsStar.close();
	psStar.close();
    //stmt.close();
    Map<String, String[]> tempMap = new HashMap<>();
    tempMap = (HashMap)session.getAttribute("cartmap");
    if("2".equals(request.getParameter("funcID"))){
    	tempMap.remove(movieId);
    }
    String itemqty = "0";
    if(tempMap.containsKey(movieId)){
    	String[] tempary = new String[2];
    	tempary = tempMap.get(movieId);
    	itemqty = tempary[0];
    }
    if("1".equals(request.getParameter("funcID"))){
    	itemqty = request.getParameter("qty");
    	String movieTitle = request.getParameter("movietitle");
    	String[] tempary = new String[2];
    	tempary[0] = itemqty;
    	tempary[1] = movieTitle;
    	if(itemqty.equals("0") || itemqty.equals("")){
    		tempMap.remove(movieId);
    	}
    	else if(!itemqty.equals("0")){
    		tempMap.put(movieId, tempary);
    	}
    	else{
    		tempMap.remove(movieId);
    	}
    }
    
    %>
	<br></br>
	<form method="get" style="float: left">
		This movie has <input name="qty" type="text" size="10"
			onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"
			value=<%=itemqty %>> in the cart. <input name="movieid"
			type="hidden" value=<%=movieId %>> <input name="movietitle"
			type="hidden" value=<%="'" + m_title +"'" %>> <input
			name="funcID" type="hidden" value="1"> <input type="submit"
			value="update" />
	</form>
	<form method="get" style="float: left">
		<input name="movieid" type="hidden" value=<%=movieId %>> <input
			name="funcID" type="hidden" value="2"> <input type="submit"
			value="remove" />
	</form>
	<br></br>
	<br></br>Cart detail:
	<br></br>
	<TABLE class="w3-table w3-bordered w3-border">
		<tr>
			<th>MovieID</th>
			<th>Title</th>
			<th>Qty</th>
		</tr>
		<% 	for (String key : tempMap.keySet()) {
		String[] tempary = new String[2];
		tempary = tempMap.get(key);
	    String qty = tempary[0];
	    String title = tempary[1];%>
		<tr>
			<td><%=key %></td>
			<td><%=title %></td>
			<td><%=qty %></td>
			<% 
	    }
	conn.close();%>
		</tr>
	</TABLE>
	<a href="shoppingcart.jsp?">Edit my shopping cart</a>
	<br></br>
	<a href="javascript:;" onClick="javascript:history.back(-1);">Back
		to previous page</a>

	<div class="w3-container w3-bottom w3-center">
		<P>Copyright &copy; CS-122B-Team-99</p>
		<br />
	</div>
	<% }
else{%>
	<jsp:forward page="login.jsp">
		<jsp:param name="funcID" value="2" />
	</jsp:forward>
	<%
}%>
</body>
</html>