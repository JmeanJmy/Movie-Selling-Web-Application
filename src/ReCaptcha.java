
/* A servlet to display the contents of the MySQL movieDB database */

import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ReCaptcha extends HttpServlet
{
    public String getServletInfo()
    {
       return "Servlet connects to MySQL database and displays result of a SELECT";
    }

    // Use http GET

    public void doGet(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
        // Output stream to STDOUT
        PrintWriter out = response.getWriter();

	String gRecaptchaResponse = request.getParameter("g-recaptcha-response");
	System.out.println("gRecaptchaResponse=" + gRecaptchaResponse);
	// Verify CAPTCHA.
	boolean valid = VerifyUtils.verify(gRecaptchaResponse);
	System.out.print(valid);
	if (!valid) {
	    //errorString = "Captcha invalid!";
	    out.println("<HTML>" +
			"<HEAD><TITLE>" +
			"MovieDB: Error" +
			"</TITLE></HEAD>\n<BODY>" +
			"<P>Recaptcha WRONG!!!! </P></BODY></HTML>");
	    return;
	}
	
		String userEmail = request.getParameter("userEmail");
		String userPassword = request.getParameter("userPasswd");
		String funcID = request.getParameter("funcID");
		
		
		HttpSession session=request.getSession();
		session.setAttribute("userEmail", userEmail);
		session.setAttribute("userPasswd", userPassword);
		session.setAttribute("funcID", funcID);
		
		response.sendRedirect("/fabflix/login.jsp");

        out.close();
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
    	doGet(request, response);
    }
}
