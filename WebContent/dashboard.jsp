<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="javax.naming.*"%>
<%@ page import="javax.sql.DataSource"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Dashboard Page</title>
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
</head>
<body>
<div class="w3-container">
Insert a star
<form  method="get">
    Name<input name="star" type="text">
    Birth Year(optional)<input name="birthyear" type="text" onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}">
    <input name="funcID" type="hidden" value="1">
    <input type="submit" value="Insert"/>
</form>
<%
if(session.isNew()){
	session.setAttribute("isLoginDB", "0");%>
	<jsp:forward page="login.jsp">
		<jsp:param name="funcID" value="2"/>
	</jsp:forward><%
}
else if(session.getAttribute("isLoginDB").equals("1")){
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
DataSource ds = (DataSource) envCtx.lookup("jdbc/Master");
Connection conn = ds.getConnection();
if("1".equals(request.getParameter("funcID"))){
	String star = request.getParameter("star");
	String birthYear = request.getParameter("birthyear");
	if("".equals(star)){
		out.println("Please input the star name!");
	}
	else{
		//Statement stmtstar = conn.createStatement();
	    //String sqlstar = "SELECT s.id FROM stars AS s WHERE s.name ='" + star +"'";
	    //ResultSet rsstar = stmtstar.executeQuery(sqlstar);
	    String sqlstar = "SELECT s.id FROM stars AS s WHERE s.name = ?";
	    PreparedStatement psstar = conn.prepareStatement(sqlstar);
	    psstar.setString(1, star);
		ResultSet rsstar = psstar.executeQuery();
	    String sid;
	    if(rsstar.next()){
	    	sid = rsstar.getString("s.id");
	    	out.println("Inputing star already in the databae");
	    }
	    else{
	    	//Statement stmtstarid = conn.createStatement();
		    String sqlstarid = "SELECT starid FROM helper WHERE id = 1";
		    PreparedStatement psstarid = conn.prepareStatement(sqlstar);
			ResultSet rsstarid = psstarid.executeQuery();
		    //ResultSet rsstarid = stmtstar.executeQuery(sqlstarid);
		    rsstarid.next();
		    sid = rsstarid.getString("starid");
		    sid = sid.substring(2, sid.length());
		    sid = Integer.toString(Integer.parseInt(sid) + 1);
		    sid = "nm" + sid;
		    //stmtstarid.close();
		    psstarid.close();
		    rsstarid.close();
		    String sqlname = "INSERT INTO stars(id, name) VALUES(?, ?)";
			PreparedStatement psname = conn.prepareStatement(sqlname);
			psname.clearParameters();
			psname.setString(1, sid);
			psname.setString(2, star);
			psname.executeUpdate();
			ResultSet rsname = psname.getGeneratedKeys();
			rsname.next();
			psname.close();
			rsname.close();
			String sqlhelp = "UPDATE helper SET starid = ? WHERE id = 1";
			PreparedStatement pshelp = conn.prepareStatement(sqlhelp);
			pshelp.clearParameters();
			pshelp.setString(1, sid);
			pshelp.executeUpdate();
			ResultSet rshelp = pshelp.getGeneratedKeys();
			rshelp.next();
			pshelp.close();
			rshelp.close();
			out.println("Input a new star successfully");
	    }
	    if(!"".equals(birthYear)){
	    	String sqlby = "UPDATE stars SET birthYear = ? WHERE id = ?";
			PreparedStatement psby = conn.prepareStatement(sqlby);
			psby.clearParameters();
			psby.setString(1, birthYear);
			psby.setString(2, sid);
			psby.executeUpdate();
			ResultSet rsby = psby.getGeneratedKeys();
			rsby.next();
			psby.close();
			rsby.close();
			out.println(" Update the birthYear successfully");

	    }
	    //stmtstar.close();
	    psstar.close();
	    rsstar.close();
	}
}
%>
Add a movie
<form  method="get">
    Title<input name="mtitle" type="text">
    Year<input name="myear" type="text" onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}">
    Director<input name="mdirector" type="text">
    Star<input name="mstar" type="text">
    Genre<input name="mgenre" type="text">
    <input name="funcID" type="hidden" value="2">
    <input type="submit" value="Add"/>
</form>

<%if("2".equals(request.getParameter("funcID"))){
	String m_title = request.getParameter("mtitle");
	String m_year = request.getParameter("myear");
	String m_director = request.getParameter("mdirector");
	String m_star = request.getParameter("mstar");
	String m_genre = request.getParameter("mgenre");
	if("".equals(m_year)){
		m_year = "-1";
	}
	String sqlcall = "{ CALL add_movie(?, ?, ?, ?, ?) }";
	CallableStatement cStmt = conn.prepareCall(sqlcall);
	cStmt.setString(1, m_title);
	cStmt.setInt(2, Integer.parseInt(m_year));
	cStmt.setString(3, m_director);
	cStmt.setString(4, m_star);
	cStmt.setString(5, m_genre);
	boolean resultFlag = cStmt.execute();
	ResultSet rs = cStmt.getResultSet();
	rs.next();
	String inf = rs.getString(1);
	out.println(inf + "<br></br>");
	rs.close();
	cStmt.close();
}
%>
If you want to insert a new movie, please provide full corresponding information. If you want to change the information belonging to a movie, blank inputing will be handled with no change to this field.<br></br>
<%  DatabaseMetaData metadata = conn.getMetaData();
    String table[] = {"TABLE"};
	ResultSet rs = metadata.getTables(null, null, null, table);
	List<String> tables = new ArrayList<String>();
	while (rs.next()) {
		tables.add(rs.getString("TABLE_NAME"));
	}
	rs.close();
	ResultSet rscol = null;
	for (String tempTable : tables) {
		rscol = metadata.getColumns(null, null, tempTable, null);
		out.println("<b>" + tempTable +"</b>");
		out.println("<br></br>");
		out.println("<table class=\"w3-table w3-bordered w3-border\"><tr><th>Column</th><th>Type</th><th>size</th></tr>");
		while (rscol.next()) {
			out.println("<tr><td>" + rscol.getString("COLUMN_NAME") + "</td><td>"
					+ rscol.getString("TYPE_NAME") + "</td><td>"
					+ rscol.getString("COLUMN_SIZE") + "</td></tr>");
		}
		out.println("</table><br></br>");
	}
	rscol.close();
	conn.close();
}
else{%>
<jsp:forward page="_dashboard.jsp">
	<jsp:param name="funcID" value="2"/>
</jsp:forward><%
}%>

</div>
</body>
</html>