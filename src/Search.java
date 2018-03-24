import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

import javax.sql.DataSource;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.naming.Context;
import javax.sql.DataSource;

import com.google.gson.Gson;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class Search extends HttpServlet {

	String loginUser = "root";
	String loginPassword = "950205jmy";
	String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
	String sql = "SELECT m.id, m.title, m.year, m.director"
			+ " FROM movies AS m, genres_in_movies AS gim, genres AS g, stars_in_movies AS sim, stars AS s"
			+ " WHERE m.id = gim.movieId AND gim.genreId = g.id AND m.id = sim.movieId AND sim.starId = s.id";
	Map<String, ArrayList<String>> map;
	ArrayList<String> title;
	ArrayList<String> id;
	ArrayList<String> year;
	ArrayList<String> director;
	ArrayList<String> genres;
	ArrayList<String> stars;

	public String getServletInfo() {
		return "Servlet connects to MySQL database and displays result of a SELECT";
	}

	// Use http GET

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		// Output stream to STDOUT
		long TS_start = System.nanoTime();
		String sql = "SELECT m.id, m.title, m.year, m.director"
				+ " FROM movies AS m, genres_in_movies AS gim, genres AS g, stars_in_movies AS sim, stars AS s"
				+ " WHERE m.id = gim.movieId AND gim.genreId = g.id AND m.id = sim.movieId AND sim.starId = s.id";
		String mv_title = request.getParameter("title");
		String limit = request.getParameter("limit");
		String offset = request.getParameter("offset");

		if (limit == null || "null".equals(limit)) {
			limit = "10";
		}
		if (offset == null || "null".equals(offset) || Integer.valueOf(offset) < 0) {
			offset = "0";
		}

		if (mv_title == null || mv_title.equals("")) {
			return;
		}
		
		boolean emptyNormal = "".equals(mv_title) || "null".equals(mv_title) || mv_title == null;

		if (!emptyNormal) {
			String[] normalArray = mv_title.split(" ");
			sql = sql + " AND (MATCH (m.title) AGAINST ('";
			for (int i = 0; i < normalArray.length; i++) {
				sql = sql + "+" + normalArray[i] + "* ";
			}
			sql = sql + "' IN BOOLEAN MODE)" + " OR edth(LOWER(m.title), LOWER('" + mv_title + "'), 2))"  + " GROUP BY m.id, m.title, m.year, m.director" + " LIMIT " + limit
					+ " OFFSET " + offset;
		}
		PrintWriter out = response.getWriter();
		List<Map> movieList = new ArrayList<>();
		Connection conn;
		
	    

//		try {
//			Class.forName("com.mysql.jdbc.Driver").newInstance();
//		} catch (Exception e) {
//			out.println("can't load mysql driver");
//			out.println(e.toString());
//		}

		try {
			long TJ_start = System.nanoTime();
			Context initCtx = new InitialContext();
			Context envCtx = (Context) initCtx.lookup("java:comp/env");
		    DataSource ds = (DataSource) envCtx.lookup("jdbc/FablixDB");
		    conn = ds.getConnection();
						
			//conn = DriverManager.getConnection(loginUrl, loginUser, loginPassword);
			PreparedStatement ps = conn.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();
			long TJ_end = System.nanoTime();
			long tjTime = TJ_end- TJ_start; 
			while (rs.next()) {
				map = new HashMap<>();
				title = new ArrayList<>();
				id = new ArrayList<>();
				year = new ArrayList<>();
				director = new ArrayList<>();
				genres = new ArrayList<>();
				stars = new ArrayList<>();

				String m_title = rs.getString("m.title");
				String m_id = rs.getString("m.id");
				String m_year = rs.getString("m.year");
				String m_director = rs.getString("m.director");

				title.add(m_title);
				year.add(m_year);
				id.add(m_id);
				director.add(m_director);

				map.put("title", title);
				map.put("id", id);
				map.put("year", year);
				map.put("director", director);
				map.put("genres", genres);
				map.put("stars", stars);

				String sqlGenre = "SELECT g.id, g.name FROM genres_in_movies AS gim, genres AS g WHERE gim.movieId = '"
						+ m_id + "' AND gim.genreId = g.id";
				Statement stmtGenre = conn.createStatement();
				ResultSet rsGenre = stmtGenre.executeQuery(sqlGenre);
				while (rsGenre.next()) {
					String g_name = rsGenre.getString("g.name");
					map.get("genres").add(g_name);
				}
				rsGenre.close();
				stmtGenre.close();

				String sqlStar = "SELECT s.id, s.name FROM stars_in_movies AS sim, stars AS s WHERE sim.movieId = '"
						+ m_id + "' AND sim.starId = s.id";
				Statement stmtStar = conn.createStatement();
				ResultSet rsStar = stmtStar.executeQuery(sqlStar);
				while (rsStar.next()) {
					String s_name = rsStar.getString("s.name");
					map.get("stars").add(s_name);
				}
				rsStar.close();
				stmtStar.close();
				movieList.add(map);

			}
			long TS_end = System.nanoTime();
			long tsTime = TS_end- TS_start; 
			System.out.println("T " + tsTime + " " + tjTime);
			rs.close();
			ps.close();
			//stmt.close();
			conn.close();
			response.setCharacterEncoding("utf-8");
			Gson gson = new Gson();
			String s = gson.toJson(movieList);
			out.print(s);
			out.flush();
			out.close();

		} catch (NamingException | SQLException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();

		}

	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		doGet(request, response);
	}
}
