package com.adnan;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DigestServlet  extends HttpServlet{
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException{
		if (req.getParameter("No Report")!=null){
			OfyService.freq = 0;
			OfyService.count = 0;
		}else if(req.getParameter("Every 5 minutes")!=null){
			OfyService.freq = 5;
			OfyService.count = 0;
		}else if(req.getParameter("Every 1 hour")!=null){
			OfyService.freq = 60;
			OfyService.count = 0;
		}else if(req.getParameter("Every day")!=null){
			OfyService.freq = 60 * 24;
			OfyService.count = 0;
		}

		resp.sendRedirect("/trending.jsp");
	}

}
