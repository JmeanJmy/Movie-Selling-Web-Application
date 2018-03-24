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
<title>Browsing Page</title>
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
else if(session.getAttribute("isLogin").equals("1")){%>

	<div class="w3-container w3-dark-grey">
		<a href="mainpage.jsp" class="w3-button w3-padding-large">Home</a>
		&nbsp<a href="shoppingcart.jsp" class="w3-button w3-padding-large">Cart</a>
		&nbsp<a href="searching.jsp" class="w3-button w3-padding-large">Search</a>
		&nbsp<a href="browsing.jsp" class="w3-button w3-padding-large">Browse</a>
		<a href="logout.jsp" class="w3-button w3-padding-large w3-right">Logout</a>
	</div>

	<h3>Browsing by Movie Genre</h3>
	<%	
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
	
	String sql = "SELECT g.id, g.name FROM genres AS g";
	PreparedStatement ps = conn.prepareStatement(sql);
	ResultSet rs = ps.executeQuery();
	//ResultSet rs = stmt.executeQuery(sql);
	while(rs.next()){
		String genreId = rs.getString("g.id");
		String g_name = rs.getString("g.name");%>
	<font face="verdana" size="3"><a
		href="movielist.jsp?genreid=<%=genreId %>"><%=g_name %></a></font>&nbsp<%
	}
	rs.close();
	ps.close();
	conn.close();
	%>
	<h3>Browsing by Movie Initial</h3>
	<% char alpha = 'A';
    for(int i = 0; i++ < 26;){%>
	<font face="verdana" size="3"><a
		href="movielist.jsp?initial=<%=alpha %>"><%=alpha %></a></font> &nbsp<%
		alpha++;
	}
	for(int i = 0; i++ < 10;){%>
	<font face="verdana" size="3"><a
		href="movielist.jsp?initial=<%=i-1 %>"><%=i-1 %></a></font> &nbsp<%
	}
}
else{%>
	<jsp:forward page="login.jsp">
		<jsp:param name="funcID" value="2" />
	</jsp:forward>
	<%
}%>

	<div class="w3-container w3-bottom w3-center">
		<P>Copyright &copy; CS-122B-Team-99</p>
		<br />
	</div>
</body>
</html>