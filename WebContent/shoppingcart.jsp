<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Shopping Cart Page</title>
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/icon?family=Material+Icons">
</head>
<body>

	<div class="w3-container w3-dark-grey">
		<a href="mainpage.jsp" class="w3-button w3-padding-large">Home</a>
		&nbsp <a href="shoppingcart.jsp" class="w3-button"
			class="w3-button w3-padding-large">Cart</a> &nbsp<a
			href="searching.jsp" class="w3-button"
			class="w3-button w3-padding-large">Search</a> &nbsp<a
			href="browsing.jsp" class="w3-button w3-padding-large">Browse</a> <a
			href="logout.jsp" class="w3-button w3-padding-large w3-right">Logout</a>
	</div>
	<% if(session.isNew()){
	session.setAttribute("isLogin", "0");%>
	<jsp:forward page="login.jsp">
		<jsp:param name="funcID" value="2" />
	</jsp:forward>
	<%
}
else if(session.getAttribute("isLogin").equals("1")){
	Map<String, String[]> tempMap = new HashMap<>();
	tempMap = (HashMap)session.getAttribute("cartmap"); 
	if (tempMap.isEmpty()) {
		out.println("You have no items now!");	
		%>
	<p align="left">
		<a href="javascript:;" onClick="javascript:history.back(-1);">Back
			to previous page</a>
	</p>
	<% 
	}
	
	else {
	%>
	<div class="w3-container">
		Cart detail:<br></br>
	</div>
	<%
    String m_title = request.getParameter("item");
    if("2".equals(request.getParameter("funcID"))){
    	String movieId = request.getParameter("movieid");
    	tempMap.remove(movieId);
    }
    if("1".equals(request.getParameter("funcID"))){
    	String movieId = request.getParameter("movieid");
    	String movieTitle = request.getParameter("movietitle");
    	String itemqty = request.getParameter("qty");
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
	for (String key : tempMap.keySet()) {
		String[] tempary = new String[2];
		tempary = tempMap.get(key);
	    String qty = tempary[0];
	    String title = tempary[1];
		%>
	<div class="w3-container w3-panel w3-animate-zoom">
		<div class="w3-card-4">
			<header class="w3-container w3-dark-grey" style="height:40%">
			<h4>
				<%=key %>&nbsp
				<%=title %>
				<div class="w3-row">
					<div class="w3-threequarter">
						<form method="get">
							Num: <input style="padding: 1px; width: 48px" name="qty"
								type="text" size="10"
								onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"
								value=<%=qty %>> <input name="movieid" type="hidden"
								value=<%=key %>> <input name="movietitle" type="hidden"
								value=<%="'" + title +"'" %>> <input name="funcID"
								type="hidden" value="1">
							<button class="w3-button" type="submit">Update</button>
						</form>
					</div>

					<div class="w3-right">
						<form method="get" style="float: left">
							<input name="movieid" type="hidden" value=<%=key %>> <input
								name="funcID" type="hidden" value="2">
							<button class="w3-button w3-hover-red" type="submit">
								<i class="material-icons">delete</i>
							</button>
							</br>
						</form>
					</div>
			</h4>
		</div>
		</header>
	</div>
	</div>
	<hr>
	<%
		}
	%>
	<div class="w3-container">
		<a href="checkout.jsp?" class="w3-btn w3-black w3-margin-top">Checkout</a>
	</div>
	<%
	}
}
else{%>
	<jsp:forward page="login.jsp">
		<jsp:param name="funcID" value="2" />
	</jsp:forward>
	<%
}%>
</body>
</html>