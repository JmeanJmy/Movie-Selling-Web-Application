<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Searching Page</title>
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

	<form action="movielist.jsp" method="get">
		<input class="w3-input w3-border" name="titlesort" type="hidden"
			value="none"> <input name="yearsort" type="hidden"
			value="none"> <input name="limit" type="hidden" value="10">
		<input name="offset" type="hidden" value="0">
		<h3>Title</h3>
		<input class="w3-input w3-padding-16 w3-border" name="title"
			type="text" size="40">
		<h3>Year</h3>
		<input class="w3-input w3-padding-16 w3-border" name="year"
			type="text"
			onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}">
		<h3>Director</h3>
		<input class="w3-input w3-padding-16 w3-border" name="director"
			type="text">
		<h3>Star</h3>
		<input class="w3-input w3-padding-16 w3-border" name="star"
			type="text">
		<p>
			<button class="w3-btn w3-black w3-left-align" type="submit">Search</button>
		</p>
	</form>
	<% 
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