<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.naming.*"%>
<%@ page import="javax.sql.DataSource"%>
<!DOCTYPE html>
<html>
<title>Fablix</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.devbridge-autocomplete/1.4.7/jquery.autocomplete.min.js"></script>

<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css?family=Lato">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css?family=Lobster">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css?family=Montserrat">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css?family=Tangerine">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="style.css">
<style>
body, h1, h2, h3, h4, h5, h6 {
	font-family: "Lato", sans-serif
}

.w3-bar, h1, button {
	font-family: "Montserrat", sans-serif
}

.fa-anchor, .fa-coffee {
	font-size: 200px
}

.w3-tangerine {
	font-family: "Tangerine", serif;
}

.w3-lobster {
	font-family: "Lobster", serif;
}

#adsearch {
	margin-top: 40px;
	margin-left: 20px
}
</style>
<body>

	<!-- Navbar -->
	<div class="w3-top">
		<div class="w3-bar w3-dark-grey w3-card w3-left-align w3-large">
			<a
				class="w3-bar-item w3-button w3-hide-medium w3-hide-large w3-right w3-padding-large w3-hover-white w3-large w3-red"
				href="javascript:void(0);" onclick="myFunction()"
				title="Toggle Navigation Menu"><i class="fa fa-bars"></i></a> <a
				href="#" class="w3-bar-item w3-button w3-padding-large w3-white">Home</a>
			<a href="shoppingcart.jsp"
				class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white">Cart</a>
			<a href="#"
				class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white">About</a>
			<a href="logout.jsp" class="w3-button w3-padding-large w3-right">Logout</a>
		</div>

		<!-- Navbar on small screens -->
		<div id="navDemo"
			class="w3-bar-block w3-white w3-hide w3-hide-large w3-hide-medium w3-large">
			<a href="#" class="w3-bar-item w3-button w3-padding-large w3-white">Home</a>
			<a href="shoppingcart.jsp"
				class="w3-bar-item w3-button w3-padding-large">Cart</a> <a href="#"
				class="w3-bar-item w3-button w3-padding-large">About</a> <a
				href="logout.jsp" class="w3-button w3-padding-large w3-right">Logout</a>
		</div>
	</div>

	<!-- Header -->
	<div class="w3-container w3-center w3-light-gray"
		style="padding: 65px 250px">
		<div class="w3-container w3-tangerine">
			<p class="w3-xxlarge">He's not a hero. He's a silent guardian, a
				watchful protector, a Dark Knight.</p>
		</div>
		<div class="w3-card-4 w3-display-container mySlides">
			<img src="assets/images/5th.jpg" style="width: 100%">
		</div>

		<div class="w3-card-4 w3-display-container mySlides">
			<img src="assets/images/1st.jpg" style="width: 100%">
		</div>

		<div class="w3-card-4 w3-display-container mySlides">
			<img src="assets/images/4th.jpg" style="width: 100%">
		</div>

		<button class="w3-button w3-dark-grey w3-display-left"
			onclick="plusDivs(-1)">&#10094;</button>
		<button class="w3-button w3-dark-grey w3-display-right"
			onclick="plusDivs(1)">&#10095;</button>
		<h1 class="w3-margin w3-jumbo">Best Movies For You</h1>
		<p class="w3-xlarge">Designed By team-99</p>
		<button
			onclick="document.getElementById('search').style.display='block'"
			class="w3-btn w3-black w3-padding-large w3-large w3-margin-top">search</button>
		<button
			onclick="document.getElementById('borwse').style.display='block'"
			class="w3-btn w3-black w3-padding-large w3-large w3-margin-top">browse</button>
	</div>

	<% if(session.isNew()){
	session.setAttribute("isLogin", "0");%>
	<jsp:forward page="login.jsp">
		<jsp:param name="funcID" value="2" />
	</jsp:forward>
	<%
	}
	else if(session.getAttribute("isLogin").equals("1")){%>

	<h3 id="adsearch">Advanced Search</h3>
	<div style="margin-bottom: 60px;">
		<input class="w3-input w3-padding-16 w3-border" style = "width:80%; float:left; margin-right: 40px" name="normal" type="text" size="40" id="autocomplete">
		<span>
			<input class="w3-btn w3-black" type="button" id="search" onclick='doNormalSearch();' value ="Search">
		</span>
		<script src="mainpage-search.js"></script>
	</div>

	<!-- Search Model -->
	<div id="search" class="w3-modal">
		<div class="w3-modal-content w3-animate-zoom">
			<div class="w3-container w3-black w3-display-container">
				<span
					onclick="document.getElementById('search').style.display='none'"
					class="w3-button w3-display-topright w3-large">x</span>
			</div>
			<div class="w3-container">
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
			</div>
		</div>
	</div>

	<!-- Browse Model -->
	<div id="borwse" class="w3-modal">
		<div class="w3-modal-content w3-animate-zoom">
			<div class="w3-container w3-black w3-display-container">
				<span
					onclick="document.getElementById('borwse').style.display='none'"
					class="w3-button w3-display-topright w3-large">x</span>
			</div>
			<div class="w3-container">
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
	//ResultSet rs = stmt.executeQuery(sql);
	PreparedStatement ps = conn.prepareStatement(sql);
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		String genreId = rs.getString("g.id");
		String g_name = rs.getString("g.name");%>
				<font face="verdana" size="3"><a
					href="movielist.jsp?genreid=<%=genreId %>"><%=g_name %></a></font>&nbsp<%
	}
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
	%>
			</div>
		</div>
	</div>
	<%
}
else{%>
	<jsp:forward page="login.jsp">
		<jsp:param name="funcID" value="2" />
	</jsp:forward>
	<%
}%>

	<!-- First Grid -->
	<div class="w3-row w3-padding-64 w3-container w3-black">

		<div class="w3-twothird">
			<div class="w3-content">
				<h1>Guideline</h1>
				<h3 class="w3-padding-32">How to use this website?</h3>
				<h5 class="w3-text-white">This is a movie shopping website for
					you. Go to serach the best movie you like and check it out! Enjoy
					it!</h5>
			</div>
		</div>
		<div class="w3-third">
			<img src="assets/images/firstgrid.jpg" class="w3-padding-small"
				style="width: 80%" align="right">
		</div>
	</div>


	<div class="w3-row-padding w3-center w3-padding-64 w3-light-grey">
		<div class="w3-col m3">
			<img src="assets/images/1st.jpg" style="width: 100%"
				onclick="onClick(this)" class="w3-hover-opacity" alt="Bane">
		</div>

		<div class="w3-col m3">
			<img src="assets/images/2nd.jpg" style="width: 100%"
				onclick="onClick(this)" class="w3-hover-opacity" alt="Batman">
		</div>

		<div class="w3-col m3">
			<img src="assets/images/3rd.jpg" style="width: 100%"
				onclick="onClick(this)" class="w3-hover-opacity" alt="Dark Knight">
		</div>

		<div class="w3-col m3">
			<img src="assets/images/4th.jpg" style="width: 100%"
				onclick="onClick(this)" class="w3-hover-opacity" alt="Couples">
		</div>
	</div>

	<div id="modal01" class="w3-modal w3-black"
		onclick="this.style.display='none'">
		<span class="w3-button w3-large w3-black w3-display-topright"
			title="Close Modal Image"><i class="fa fa-remove"></i></span>
		<div
			class="w3-modal-content w3-animate-zoom w3-center w3-transparent w3-padding-64">
			<img id="img01" class="w3-image">
			<p id="caption" class="w3-opacity w3-large"></p>
		</div>

	</div>


	<div class="w3-container w3-black w3-center w3-opacity w3-padding-64">
		<h1 class="w3-margin w3-xlarge">Enjoy your time here!</h1>
	</div>

	<!-- Footer -->
	<footer class="w3-container w3-padding-64 w3-center w3-opacity">
		<div class="w3-xlarge w3-padding-32">
			<i class="fa fa-facebook-official w3-hover-opacity"></i> <i
				class="fa fa-instagram w3-hover-opacity"></i> <i
				class="fa fa-snapchat w3-hover-opacity"></i> <i
				class="fa fa-pinterest-p w3-hover-opacity"></i> <i
				class="fa fa-twitter w3-hover-opacity"></i> <i
				class="fa fa-linkedin w3-hover-opacity"></i>
		</div>
		<p>Powered by CS-122B Team-99</p>
	</footer>

	<script>
// Used to toggle the menu on small screens when clicking on the menu button
function myFunction() {
    var x = document.getElementById("navDemo");
    if (x.className.indexOf("w3-show") == -1) {
        x.className += " w3-show";
    } else { 
        x.className = x.className.replace(" w3-show", "");
    }
}
var slideIndex = 1;
showDivs(slideIndex);

function plusDivs(n) {
    showDivs(slideIndex += n);
}

function showDivs(n) {
    var i;
    var x = document.getElementsByClassName("mySlides");
    if (n > x.length) {slideIndex = 1} 
    if (n < 1) {slideIndex = x.length} ;
    for (i = 0; i < x.length; i++) {
        x[i].style.display = "none"; 
    }
    x[slideIndex-1].style.display = "block"; 
}

//Modal Image Gallery
function onClick(element) {
  document.getElementById("img01").src = element.src;
  document.getElementById("modal01").style.display = "block";
  var captionText = document.getElementById("caption");
  captionText.innerHTML = element.alt;
}
</script>

</body>
</html>