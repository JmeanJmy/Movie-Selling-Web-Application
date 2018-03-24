import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class Login extends HttpServlet {

	String loginUser = "root";
	String loginPassword = "950205jmy";
	String loginUrl = "jdbc:mysql://localhost:3306/moviedb";

	public String getServletInfo() {
		return "Servlet connects to MySQL database and displays result of a SELECT";
	}

	// Use http GET

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		// Output stream to STDOUT
		String success = "fail";
		Connection conn;
		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();
		String userEmail = request.getParameter("userEmail");
		String userPassword = request.getParameter("userPasswd");
		if (userEmail == null || userPassword == null) {
			return;
		}

		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
		} catch (Exception e) {
			out.println("can't load mysql driver");
			out.println(e.toString());
		}

		try {
			conn = DriverManager.getConnection(loginUrl, loginUser, loginPassword);
			Statement stmt = conn.createStatement();
			String sql = "SELECT * FROM customers AS c WHERE c.email ='" + userEmail + "' AND c.password ='"
					+ userPassword + "'";
			ResultSet rs = stmt.executeQuery(sql);
			if (rs.next()) {
				success = "OK";
			} else {
				return;
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		response.setCharacterEncoding("utf-8");
		out.write(success);
		out.flush();
		out.close();
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		doGet(request, response);
	}
}
