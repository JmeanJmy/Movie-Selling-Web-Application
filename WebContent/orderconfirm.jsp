<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="javax.naming.*"%>
<%@ page import="javax.sql.DataSource"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Order Confirm Page</title>
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
</head>
<body>
<div class="w3-container w3-dark-grey">
    <a href="mainpage.jsp" class="w3-button w3-padding-large">Home</a>
    &nbsp<a href="shoppingcart.jsp" class="w3-button w3-padding-large">Cart</a>
    &nbsp<a href="searching.jsp" class="w3-button w3-padding-large">Search</a>
    &nbsp<a href="browsing.jsp" class="w3-button w3-padding-large">Browse</a>
    <a href="logout.jsp" class="w3-button w3-padding-large w3-right">Logout</a>
</div>
<% if(session.isNew()){
	session.setAttribute("isLogin", "0");%>
	<jsp:forward page="login.jsp">
		<jsp:param name="funcID" value="2"/>
	</jsp:forward><%
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
    String useremail = (String)session.getAttribute("useremail");
    String c_ccid = request.getParameter("ccid");
    String c_firstname = request.getParameter("firstname");
    String c_lastname = request.getParameter("lastname");
    String c_date = request.getParameter("date");
    //Statement stmt = conn.createStatement();
    //String sql = "SELECT cr.id, cr.firstname, cr.lastname, cr.expiration FROM creditcards AS cr " +
    //" WHERE cr.id = '" + c_ccid + "'";
    //ResultSet rs = stmt.executeQuery(sql);
    String sql = "SELECT cr.id, cr.firstname, cr.lastname, cr.expiration FROM creditcards AS cr WHERE cr.id = ?";
    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setString(1, c_ccid);
    ResultSet rs = ps.executeQuery();
	if(rs.next()){
		String ccid = rs.getString(1);
		String firstname = rs.getString(2);
		String lastname = rs.getString(3);
		String date = rs.getString(4);
		//stmt.close();
		ps.close();
		rs.close();
		//Statement stmtuser = conn.createStatement();
	    //String sqluser = "SELECT cu.id FROM customers AS cu " +
	    //" WHERE cu.email = '" + useremail + "'";
	    //ResultSet rssuer = stmtuser.executeQuery(sqluser);
	    String sqluser = "SELECT cu.id FROM customers AS cu WHERE cu.email = ?";
	    PreparedStatement psuser = conn.prepareStatement(sqluser);
	    psuser.setString(1, useremail);
		ResultSet rsuser = psuser.executeQuery();
		rsuser.next();
		String cid = rsuser.getString(1);
		//stmtuser.close();
		ps.close();
		rsuser.close();
		
		if(ccid.equals(c_ccid) && firstname.equals(c_firstname) && lastname.equals(c_lastname) && date.equals(c_date)){
			out.println("Congratulation! Your order is placed!");
			Map<String, String[]> tempMap = new HashMap<>();
			tempMap = (HashMap)session.getAttribute("cartmap");
			for (String key : tempMap.keySet()) {
				java.util.Date nowDate= new java.util.Date();
				SimpleDateFormat sqlFmt = new SimpleDateFormat("yyyy-MM-dd");
				String sqlDate = sqlFmt.format(nowDate);
				String[] tempary = new String[2];
				tempary = tempMap.get(key);
			    int qty = Integer.parseInt(tempary[0]);
				for(int i = 0;i < qty; i++){
				    String sqlsale = "INSERT INTO sales VALUES(default, ?, ?, ?)";
					PreparedStatement pssale = conn.prepareStatement(sqlsale);
					pssale.clearParameters();
					pssale.setString(1, cid);
					pssale.setString(2, key);
					pssale.setString(3, sqlDate);
					pssale.executeUpdate();
					ResultSet rssale = pssale.getGeneratedKeys();
					rssale.next();
					//out.println("Successfully added. Gallery_ID:"+ rssale.getInt(1) + "of the movie" + key);
					pssale.close();
					rssale.close();
				}
			}
			for (Iterator<Map.Entry<String, String[]>> it = tempMap.entrySet().iterator(); it.hasNext();){
			    Map.Entry<String, String[]> item = it.next();
			    it.remove();
			}%>
			<a href="mainpage.jsp?">Back to Main Page</a><%
		}
		else{
			out.println("Sorry, the credit card information is not correct. Please try again ");
		%>
		<br></br><a href="checkout.jsp?">Back to Checkout Page</a>
		<%}
		conn.close();
		}
	else{
		out.println("Sorry, the credit card information is not correct. Please try again ");
		%>
		<br></br><a href="checkout.jsp?">Back to Checkout Page</a>
		<%}
		conn.close();
}
else{%>
	<jsp:forward page="login.jsp">
		<jsp:param name="funcID" value="2"/>
	</jsp:forward><%
}%>
</body>
</html>