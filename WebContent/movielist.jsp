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
<title>Movie List Page</title>
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css?family=Lato">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css?family=Montserrat">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>


	<%
		if (session.isNew()) {
			session.setAttribute("isLogin", "0");
	%>
	<jsp:forward page="login.jsp">
		<jsp:param name="funcID" value="2" />
	</jsp:forward>
	<%
		} else if (session.getAttribute("isLogin").equals("1")) {
			String s_title = request.getParameter("title");
			String s_year = request.getParameter("year");
			String s_director = request.getParameter("director");
			String s_star = request.getParameter("star");
			String s_normal = request.getParameter("normal");
			String genreId = request.getParameter("genreid");
			String initial = request.getParameter("initial");
			String title_cap = request.getParameter("titlecapital");
			String sort_title = request.getParameter("titlesort");
			String sort_year = request.getParameter("yearsort");
			String limit = request.getParameter("limit");
			String offset = request.getParameter("offset");
			String movieId = request.getParameter("movieid");
			boolean emptyTitle = "".equals(s_title) || "null".equals(s_title) || s_title == null;
			boolean emptyYear = "".equals(s_year) || "null".equals(s_year) || s_year == null;
			boolean emptyDirector = "".equals(s_director) || "null".equals(s_director) || s_director == null;
			boolean emptyStar = "".equals(s_star) || "null".equals(s_star) || s_star == null;
			boolean emptyInitial = "".equals(initial) || "null".equals(initial) || initial == null;
			boolean emptyGenre = "".equals(genreId) || "null".equals(genreId) || genreId == null;
			boolean emptyNormal = "".equals(s_normal) || "null".equals(s_normal) || s_normal == null;
			Map<String, String[]> tempMap = new HashMap<>();
			/*String loginUser = "root";
			String loginPassword = "950205jmy";
			String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
			try {
				Class.forName("com.mysql.jdbc.Driver").newInstance();
			} catch (Exception e) {
				out.println("can't load mysql driver");
				out.println(e.toString());
			}
			Connection conn = DriverManager.getConnection(loginUrl, loginUser, loginPassword);*/
			Context initCtx = new InitialContext();
		    Context envCtx = (Context) initCtx.lookup("java:comp/env");
		    DataSource ds = (DataSource) envCtx.lookup("jdbc/FablixDB");
		    Connection conn = ds.getConnection();
			//Statement stmt = conn.createStatement();
			String sql = "SELECT m.id, m.title, m.year, m.director"
					+ " FROM movies AS m, genres_in_movies AS gim, genres AS g, stars_in_movies AS sim, stars AS s"
					+ " WHERE m.id = gim.movieId AND gim.genreId = g.id AND m.id = sim.movieId AND sim.starId = s.id";
			if (limit == null || "null".equals(limit)) {
				limit = "10";
			}
			if (offset == null || "null".equals(offset)) {
				offset = "0";
			}
			String nextOffset = "" + (Integer.parseInt(offset) + Integer.parseInt(limit));
			String prevOffset = "" + (Integer.parseInt(offset) - Integer.parseInt(limit));
			if (Integer.parseInt(prevOffset) < 0) {
				prevOffset = "0";
			}
			int titlePos = 0, yearPos = 0, directorPos = 0, starPos = 0, genrePos = 0, initialPos = 0, pos = 0;
			if (!emptyTitle) {
				//sql = sql + " AND m.title LIKE '%" + s_title + "%'";
				sql = sql + " AND m.title LIKE ?";
				titlePos = pos + 1;
				pos++;
			}
			if (!emptyYear) {
				//sql = sql + " AND m.year = '" + s_year + "'";
				sql = sql + " AND m.year = ?";
				yearPos = pos + 1;
				pos++;
			}
			if (!emptyDirector) {
				//sql = sql + " AND m.director LIKE '%" + s_director + "%'";
				sql = sql + " AND m.director LIKE ?";
				directorPos = pos + 1;
				pos++;
			}
			if (!emptyStar) {
				//sql = sql + " AND s.name LIKE '%" + s_star + "%'";
				sql = sql + " AND s.name LIKE ?";
				starPos = pos + 1;
				pos++;
			}
			if (!emptyGenre) {
				//sql = sql + " AND g.id = '" + genreId + "'";
				sql = sql + " AND g.id = ?";
				genrePos = pos + 1;
				pos++;
			}
			if (!emptyInitial) {
				//sql = sql + " AND m.title LIKE '" + initial + "%'";
				sql = sql + " AND m.title LIKE ?";
				initialPos = pos +1;
				pos++;
			}
			if (!emptyNormal) {
				String[] normalArray = s_normal.split(" ");
				sql = sql + " AND (MATCH (m.title) AGAINST ('";
				for(int i = 0; i< normalArray.length; i++){
					sql = sql + "+" + normalArray[i] + "* ";
				}
				sql = sql + "' IN BOOLEAN MODE)";
				sql = sql + " OR edth(LOWER(m.title), LOWER('" + s_normal + "'), 2))";
			}
			sql = sql + " GROUP BY m.id, m.title, m.year, m.director";

			if ("asc".equals(sort_title)) {
				sql = sql + " ORDER BY m.title ASC";
			} else if ("desc".equals(sort_title)) {
				sql = sql + " ORDER BY m.title DESC";
			} else if ("asc".equals(sort_year)) {
				sql = sql + " ORDER BY m.year ASC";
			} else if ("desc".equals(sort_year)) {
				sql = sql + " ORDER BY m.year DESC";
			}
			sql = sql + " LIMIT " + limit;
			sql = sql + " OFFSET " + offset;
			//ResultSet rs = stmt.executeQuery(sql);
			
			PreparedStatement ps = conn.prepareStatement(sql);
			if (!emptyTitle) {
				ps.setString(titlePos, "%" + s_title + "%");
			}
			if (!emptyYear) {
				ps.setString(yearPos, s_year);
			}
			if (!emptyDirector) {
				ps.setString(directorPos, "%" + s_director + "%");
			}
			if (!emptyStar) {
				ps.setString(starPos, "%" + s_star + "%");
			}
			if (!emptyGenre) {
				ps.setString(genrePos, genreId);
			}
			if (!emptyInitial) {
				ps.setString(initialPos,  initial + "%");
			}
			ResultSet rs = ps.executeQuery();
	%>
	
	<div class="w3-container w3-dark-grey">
		<a href="mainpage.jsp" class="w3-button w3-padding-large">Home</a>
		&nbsp <a href="shoppingcart.jsp" class="w3-button w3-padding-large">Cart</a>
		&nbsp<a href="searching.jsp" class="w3-button w3-padding-large">Search</a>
		&nbsp<a href="browsing.jsp" class="w3-button w3-padding-large">Browse</a>
		<a href="logout.jsp" class="w3-button w3-padding-large w3-right">Logout</a>
	</div>

	<form class="w3-container" action="movielist.jsp">
		<input name="titlesort" type="hidden" value="none"> <input
			name="yearsort" type="hidden" value="none"> <input
			name="limit" type="hidden" value="10"> <input name="offset"
			type="hidden" value="0">
		<div class="w3-row-padding">

			<div class="w3-quarter">
				<label>Title</label> <input class="w3-input w3-border" name="title"
					type="text" size="40">
			</div>

			<div class="w3-quarter">
				<label>Year</label> <input class="w3-input w3-border" name="year"
					type="text"
					onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}">
			</div>

			<div class="w3-quarter">
				<label>Director</label> <input class="w3-input w3-border"
					name="director" type="text">
			</div>

			<div class="w3-quarter">
				<label>Star</label> <input class="w3-input w3-border" name="star"
					type="text">
			</div>
			<br /> <br />
			<div class="w3-quarter">
				<button class="w3-btn w3-dark-grey" type="submit">Search</button>
			</div>

		</div>
	</form>

	<div class="w3-container">
		<span>&nbsp sort by &nbsp</span>
		<%
			if ("none".equals(sort_title)) {
		%>

		<a
			href="movielist.jsp?titlesort=asc&yearsort=none&limit=<%=limit%>&offset=0&title=<%=s_title%>&year=<%=s_year%>&director=<%=s_director%>&star=<%=s_star%>&genreid=<%=genreId%>&initial=<%=initial%>&normal=<%=s_normal%>">title</a>
		<%
			} else if ("asc".equals(sort_title)) {
		%>
		<a
			href="movielist.jsp?titlesort=desc&yearsort=none&limit=<%=limit%>&offset=0&title=<%=s_title%>&year=<%=s_year%>&director=<%=s_director%>&star=<%=s_star%>&genreid=<%=genreId%>&initial=<%=initial%>&normal=<%=s_normal%>">title&#8593</a>
		<%
			} else if ("desc".equals(sort_title)) {
		%>
		<a
			href="movielist.jsp?titlesort=asc&yearsort=none&limit=<%=limit%>&offset=0&title=<%=s_title%>&year=<%=s_year%>&director=<%=s_director%>&star=<%=s_star%>&genreid=<%=genreId%>&initial=<%=initial%>&normal=<%=s_normal%>">title&#8595</a>
		<%
			} else {
		%>
		<a
			href="movielist.jsp?titlesort=asc&yearsort=none&limit=<%=limit%>&offset=0&title=<%=s_title%>&year=<%=s_year%>&director=<%=s_director%>&star=<%=s_star%>&genreid=<%=genreId%>&initial=<%=initial%>&normal=<%=s_normal%>">title</a>
		<%
			}
		%>
		&nbsp
		<%
			if ("none".equals(sort_year) || sort_year == null) {
		%>
		<a
			href="movielist.jsp?titlesort=none&yearsort=asc&limit=<%=limit%>&offset=0&title=<%=s_title%>&year=<%=s_year%>&director=<%=s_director%>&star=<%=s_star%>&genreid=<%=genreId%>&initial=<%=initial%>&normal=<%=s_normal%>">year</a>
		<%
			} else if ("asc".equals(sort_year)) {
		%>
		<a
			href="movielist.jsp?titlesort=none&yearsort=desc&limit=<%=limit%>&offset=0&title=<%=s_title%>&year=<%=s_year%>&director=<%=s_director%>&star=<%=s_star%>&genreid=<%=genreId%>&initial=<%=initial%>&normal=<%=s_normal%>">year&#8593</a>
		<%
			} else if ("desc".equals(sort_year)) {
		%>
		<a
			href="movielist.jsp?titlesort=none&yearsort=asc&limit=<%=limit%>&offset=0&title=<%=s_title%>&year=<%=s_year%>&director=<%=s_director%>&star=<%=s_star%>&genreid=<%=genreId%>&initial=<%=initial%>&normal=<%=s_normal%>">year&#8595</a>
		<%
			} else {
		%>
		<a
			href="movielist.jsp?titlesort=none&yearsort=asc&limit=<%=limit%>&offset=0&title=<%=s_title%>&year=<%=s_year%>&director=<%=s_director%>&star=<%=s_star%>&genreid=<%=genreId%>&initial=<%=initial%>&normal=<%=s_normal%>">year</a>
		<%
			}
		%>
		&nbsp
	</div>
	<%
		tempMap = (HashMap) session.getAttribute("cartmap");
			if ("2".equals(request.getParameter("funcID"))) {
				tempMap.remove(movieId);
			}
			if ("1".equals(request.getParameter("funcID"))) {
				String qty = request.getParameter("qty");
				String movieTitle = request.getParameter("movietitle");
				String[] tempary = new String[2];
				tempary[0] = qty;
				tempary[1] = movieTitle;
				if (qty.equals("0") || qty.equals("")) {
					tempMap.remove(movieId);
				} else if (!qty.equals("0")) {
					tempMap.put(movieId, tempary);
				} else {
					tempMap.remove(movieId);
				}
			}
			boolean flag_movie = rs.next();
			if ((flag_movie == false) && (Integer.parseInt(offset) == 0)) {
				out.println("<br></br>" + "<h3><b><center>" + "There is no movie matching your searching keywords."
						+ "</center></b></h3>" + "<br></br>");
			} else if ((flag_movie == false) && (Integer.parseInt(offset) > 0)) {
				out.println("<br></br>" + "<h3><b><center>" + "There is no more movie matching the keywords."
						+ "</center></b></h3>" + "<br></br>");

			}
			rs.previous();
			while (rs.next()) {
				if (emptyTitle && emptyYear && emptyDirector && emptyStar && emptyInitial && emptyGenre && emptyNormal) {
					out.println("<br></br>" + "<h3><b><center>"
							+ "Please provide at least a valid searching keyword or try browsing."
							+ "</center></b></h3>" + "<br></br>");
					break;
				}
				String m_title = rs.getString("m.title");
				String m_id = rs.getString("m.id");
				String m_year = rs.getString("m.year");
				String m_director = rs.getString("m.director");
	%>
	<%
		String itemqty = "0";
				if (tempMap.containsKey(m_id)) {
					String[] tempary = new String[2];
					tempary = tempMap.get(m_id);
					itemqty = tempary[0];
				}
	%>
	<div class="w3-container w3-panel w3-animate-zoom">

		<div class="w3-card-4">
			<header class="w3-container w3-dark-grey" style="height:60%">
			<h3>
				<a class="w3-btn" href="singlemovie.jsp?movieid=<%=m_id%>"><%=m_title%></a>
			</h3>

			</header>
			<div class="w3-container w3-light-grey">
				<br /> <span>Year: <%=m_year%> &nbsp Director: <%=m_director%>
					&nbsp Id: <%=m_id%>
				</span> <br /> <span>Genres:&nbsp</span>
				<%
					//String sqlGenre = "SELECT g.id, g.name FROM genres_in_movies AS gim, genres AS g WHERE gim.movieId = '"
					//				+ m_id + "' AND gim.genreId = g.id";
					//Statement stmtGenre = conn.createStatement();
					//ResultSet rsGenre = stmtGenre.executeQuery(sqlGenre);
					String sqlGenre = "SELECT g.id, g.name FROM genres_in_movies AS gim, genres AS g WHERE gim.movieId = ? AND gim.genreId = g.id";
					PreparedStatement psGenre = conn.prepareStatement(sqlGenre);
					psGenre.setString(1, m_id);
					ResultSet rsGenre = psGenre.executeQuery();
					while (rsGenre.next()) {
						String g_name = rsGenre.getString("g.name");
				%>
				<%=g_name%>
				&nbsp
				<%
					}
							rsGenre.close();
							//stmtGenre.close();
							psGenre.close();
							//String sqlStar = "SELECT s.id, s.name FROM stars_in_movies AS sim, stars AS s WHERE sim.movieId = '"
							//		+ m_id + "' AND sim.starId = s.id";
							//Statement stmtStar = conn.createStatement();
							//ResultSet rsStar = stmtStar.executeQuery(sqlStar);
							String sqlStar = "SELECT s.id, s.name FROM stars_in_movies AS sim, stars AS s WHERE sim.movieId = ? AND sim.starId = s.id";
							PreparedStatement psStar = conn.prepareStatement(sqlStar);
							psStar.setString(1, m_id);
							ResultSet rsStar = psStar.executeQuery();
				%>

				<hr />
				<span>Stars:&nbsp</span>
				<%
					while (rsStar.next()) {
								String s_id = rsStar.getString("s.id");
								String s_name = rsStar.getString("s.name");
				%>
				<a href="singlestar.jsp?starid=<%=s_id%>"><%=s_name%></a> &nbsp
				<%
 	}
 			rsStar.close();
 			//stmtStar.close();
 			psStar.close();
 %>
				<br /> <br />

				<div class="w3-dropdown-hover">
					Add to cart
					<div class="w3-dropdown-content w3-card-4" style="width: 280px">
						<div class="w3-container w3-dark-grey">
							<form method="get" style="float: left">
								This movie has <input style="width: 35px" name="qty" type="text"
									size="10"
									onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"
									value=<%=itemqty%>> in the cart. <input name="normal"
									type="hidden" value=<%=s_normal%>> <input
									name="titlesort" type="hidden" value=<%=sort_title%>> <input
									name="yearsort" type="hidden" value=<%=sort_year%>> <input
									name="limit" type="hidden" value=<%=limit%>> <input
									name="offset" type="hidden" value=<%=prevOffset%>> <input
									name="title" type="hidden" value=<%=s_title%>> <input
									name="year" type="hidden" value=<%=s_year%>> <input
									name="director" type="hidden" value=<%=s_director%>> <input
									name="star" type="hidden" value=<%=s_star%>> <input
									name="genreid" type="hidden" value=<%=genreId%>> <input
									name="initial" type="hidden" value=<%=initial%>> <input
									name="movieid" type="hidden" value=<%=m_id%>> <input
									name="movietitle" type="hidden" value=<%="'" + m_title + "'"%>>
								<input name="funcID" type="hidden" value="1"> </br> <input
									class="w3-btn w3-grey" type="submit" value="update" />
							</form>

							<form method="get" style="float: left">
								<input name="titlesort" type="hidden" value=<%=sort_title%>>
								<input name="yearsort" type="hidden" value=<%=sort_year%>>
								<input name="normal" type="hidden" value=<%=s_normal%>>
								<input name="limit" type="hidden" value=<%=limit%>> <input
									name="offset" type="hidden" value=<%=prevOffset%>> <input
									name="title" type="hidden" value=<%=s_title%>> <input
									name="year" type="hidden" value=<%=s_year%>> <input
									name="director" type="hidden" value=<%=s_director%>> <input
									name="star" type="hidden" value=<%=s_star%>> <input
									name="genreid" type="hidden" value=<%=genreId%>> <input
									name="initial" type="hidden" value=<%=initial%>> <input
									name="movieid" type="hidden" value=<%=m_id%>> <input
									name="funcID" type="hidden" value="2"> </br> <input
									class="w3-btn w3-grey" style="width: 83.5px" type="submit"
									value="remove" /> </br> </br>
							</form>
							<br></br>
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
												String title = tempary[1];
								%>
								<tr>
									<td><%=key%></td>
									<td><%=title%></td>
									<td><%=qty%></td>
									<%
										}
									%>
								</tr>
							</TABLE>

						</div>
					</div>
				</div>

			</div>
		</div>
	</div>
	<%
		}
			rs.close();
			//stmt.close();
			ps.close();

			//bowsing in genres
			//Statement stmtBrowse = conn.createStatement();
			String sqlBrowse = "SELECT g.id, g.name FROM genres AS g";
			PreparedStatement psBrowse = conn.prepareStatement(sqlBrowse);
			ResultSet rsBrowse = psBrowse.executeQuery();
			//ResultSet rsBrowse = stmtBrowse.executeQuery(sqlBrwose);
	%>
	<div class="w3-container">
		Genres:&nbsp
		<%
		while (rsBrowse.next()) {
				String genreId1 = rsBrowse.getString("g.id");
				String g_name1 = rsBrowse.getString("g.name");
	%>
		<a href="movielist.jsp?genreid=<%=genreId1%>"><%=g_name1%></a>
		<%
			}
				rsBrowse.close();
				//stmtBrowse.close();
				psBrowse.close();
		%>
	</div>

	<div class="w3-container">
		Title:&nbsp
		<%
		char alpha = 'A';
			for (int i = 0; i++ < 26;) {
	%>
		<a href="movielist.jsp?initial=<%=alpha%>"><%=alpha%></a>
		<%
			alpha++;
				}
				for (int i = 0; i++ < 10;) {
		%>
		<a href="movielist.jsp?initial=<%=i - 1%>"><%=i - 1%></a>
		<%
			}
				conn.close();
		%>

	</div>
	<%
		
	%>

	<div class="w3-container w3-center">
		<form method="get">
			<input name="titlesort" type="hidden" value=<%=sort_title%>>
			<input name="yearsort" type="hidden" value=<%=sort_year%>> <select
				name="limit" value="25">
				<option value="10">10</option>
				<option value="25">25</option>
				<option value="50">50</option>
				<option value="100">100</option>
			</select>
			<input name="normal" type="hidden" value=<%=s_normal%>>
			<input name="offset" type="hidden" value=<%=offset%>> <input
				name="title" type="hidden" value=<%=s_title%>> <input
				name="year" type="hidden" value=<%=s_year%>> <input
				name="director" type="hidden" value=<%=s_director%>> <input
				name="star" type="hidden" value=<%=s_star%>> <input
				name="genreid" type="hidden" value=<%=genreId%>> <input
				name="initial" type="hidden" value=<%=initial%>> &nbsp &nbsp
			&nbsp
			<button class="w3-btn w3-dark-grey w3-padding-small" type="submit">list</button>
		</form>

		<br />
		<%
			if (Integer.parseInt(offset) > 0) {
		%>
		<form method="get">
			<input name="titlesort" type="hidden" value=<%=sort_title%>>
			
			<input name="yearsort" type="hidden" value=<%=sort_year%>> <input
				name="limit" type="hidden" value=<%=limit%>> <input
				name="offset" type="hidden" value=<%=prevOffset%>> <input
				name="title" type="hidden" value=<%=s_title%>> <input
				name="year" type="hidden" value=<%=s_year%>> <input
				name="director" type="hidden" value=<%=s_director%>> <input
				name="star" type="hidden" value=<%=s_star%>> <input
				name="genreid" type="hidden" value=<%=genreId%>> <input
				name="initial" type="hidden" value=<%=initial%>>
			<button class="w3-btn w3-dark-grey w3-padding-small" type="submit">Prev</button>
		</form>
		<%
			}
				if (flag_movie) {
		%>
		<form method="get">
			<input name="normal" type="hidden" value=<%=s_normal%>>
			<input name="titlesort" type="hidden" value=<%=sort_title%>>
			<input name="yearsort" type="hidden" value=<%=sort_year%>> <input
				name="limit" type="hidden" value=<%=limit%>> <input
				name="offset" type="hidden" value=<%=nextOffset%>> <input
				name="title" type="hidden" value=<%=s_title%>> <input
				name="year" type="hidden" value=<%=s_year%>> <input
				name="director" type="hidden" value=<%=s_director%>> <input
				name="star" type="hidden" value=<%=s_star%>> <input
				name="genreid" type="hidden" value=<%=genreId%>> <input
				name="initial" type="hidden" value=<%=initial%>>
			<button class="w3-btn w3-dark-grey w3-padding-small" type="submit">Next</button>
		</form>
		<%
			}
		%>

		<hr />
		<footer>Copyright &copy; CS-122B-Team-99</footer>
		<br /> <br />
	</div>
	<%
		} else {
	%>
	<jsp:forward page="login.jsp">
		<jsp:param name="funcID" value="2" />
	</jsp:forward>
	<%
		}
	%>
</body>
</html>