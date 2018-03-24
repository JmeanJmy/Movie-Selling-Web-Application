<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Checkout Page</title>
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
</head>
<body>

	<div class="w3-container w3-dark-grey">
		<a href="mainpage.jsp" class="w3-button w3-padding-large">Home</a>
		&nbsp<a href="shoppingcart.jsp" class="w3-button w3-padding-large">Cart</a>
		&nbsp<a href="searching.jsp" class="w3-button w3-padding-large">Search</a>
		<a href="logout.jsp" class="w3-button w3-padding-large w3-right">Logout</a>
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
	tempMap = (HashMap)session.getAttribute("cartmap"); %>
	<div class="w3-container">
		Check your item in your order before place it! <br></br>Below is your
		order detail: <br></br>
		<TABLE class="w3-table w3-bordered w3-border">
			<tr>
				<th>MovieID</th>
				<th>Title</th>
				<th>Qty</th>
			</tr>
			<%
	for (String key : tempMap.keySet()) {
		String[] tempary = new String[2];
		tempary = tempMap.get(key);
	    String qty = tempary[0];
	    String title = tempary[1];%>
			<tr>
				<td><%=key %></td>
				<td><%=title %></td>
				<td><%=qty %></td>
			</tr>
			<%

	}
	out.println("</table>");%>
		</TABLE>
	</div>
	<br />
	<br />
	<div class="w3-card-4 w3-container">
		Please provide your credit card information and name on it <br />
		<br />
		<div class="w3-container w3-black">
			<h3>Proceed to checkout</h3>
		</div>
		<form method="post" action="orderconfirm.jsp">
			<div class="w3-row-padding">
				<div class="w3-half">
					<label><b>First Name</b></label> <input class="w3-input w3-border"
						name="firstname" type="text">
				</div>
				<div class="w3-half">
					<label><b>Last Name</b></label> <input class="w3-input w3-border"
						name="lastname" type="text">
					</p>
				</div>
				<div class="w3-half">
					<label><b>Credit Card Number</b></label> <input
						class="w3-input w3-border" name="ccid" type="text">
					</p>
				</div>
				<div class="w3-half">
					<label><b>Expiration Date</b></label> <input
						class="w3-input w3-border" name="date" type="text">
					</p>
				</div>

				<button type="submit" class="w3-btn w3-black">Confirm</button>
				</p>
			</div>
		</form>
	</div>
	<br />
	<br />
	<a href="shoppingcart.jsp?">Back to Shopping Cart Page</a>
	<% }
else{%>
	<jsp:forward page="login.jsp">
		<jsp:param name="funcID" value="2" />
	</jsp:forward>
	<%
}%>
</body>
</html>