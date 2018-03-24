<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="javax.naming.*"%>
<%@ page import="javax.sql.DataSource"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Dashboard login Page</title>
<link rel="stylesheet" type="text/css" href="css/login.css">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
</head>
<body>

<div id="content">
	<p align="center">Welcome administrator! Please login</p>
	<form method="post">
			<input name="funcID" type="hidden" value="1">
			<div class="login-input-box">
            		<span class="icon icon-user"></span>
            		<input name="userEmail" type="text" placeholder="Please enter your email/phone">
        		</div>	
			<div class="login-input-box">
            		<span class="icon icon-password"></span>
            		<input name="userPasswd" type="password" placeholder="Please enter your password">
        		</div>
        		<div class="login-button-box">
        			<button>Login</button>
    			</div>
	</form>
	
	<div class="logon-box">
        <a href="">Forgot?</a>
        <a href="">Register</a>
    </div>
	
</div> 

<% 
String isLoginDB = null;
isLoginDB = (String)session.getAttribute("isLoginDB");
if("1".equals(isLoginDB)){%>
	<jsp:forward page="dashboard.jsp?funcID=0"/><%
}
session.setAttribute("isLoginDB", "0");
if("1".equals(request.getParameter("funcID"))){
	String userEmail = request.getParameter("userEmail");
	String userPassword = request.getParameter("userPasswd");
	
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
    PreparedStatement ps = null;
    //Statement stmt = conn.createStatement();
    //String sql = "SELECT * FROM employees AS e WHERE e.email ='" + userEmail + "' AND e.password ='" + userPassword +"'";
    String sql = "SELECT * FROM employees AS e WHERE e.email = ? AND e.password = ?";
    ps = conn.prepareStatement(sql);
    ps.setString(1, userEmail);
    ps.setString(2, userPassword);
    ResultSet rs = ps.executeQuery();
    //ResultSet rs = stmt.executeQuery(sql);
    if(rs.next()){
    	session.setAttribute("isLoginDB", "1");%>
		<jsp:forward page="dashboard.jsp?funcID=0"/><%
    }
    else{%>
    	<p align="center" style="color:white">Login failed, the email or password is not correct</p>
    <%}
    rs.close();
    //stmt.close();
    ps.close();
    conn.close();
}
if("2".equals(request.getParameter("funcID"))){
	%>
	<p align="center" style="color:white">Please login first</p>
	<%
}%>
</body>
</html>