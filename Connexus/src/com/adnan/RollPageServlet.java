package com.adnan;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RollPageServlet extends HttpServlet{

	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException{
		int offset = Integer.parseInt(req.getParameter("offset"));
		Long streamId = new Long(req.getParameter("streamId"));
		String streamName = req.getParameter("streamName");
		if (req.getParameter("NextPage")!=null){
			offset += 3;
			resp.sendRedirect("/ViewStreamImage.jsp?streamId=" + streamId + "&"
					+ "streamName=" + streamName + "&offset= " + offset);
		}else if (req.getParameter("PreviousPage")!=null){
			offset -= 3;
			resp.sendRedirect("/ViewStreamImage.jsp?streamId=" + streamId + "&"
					+ "streamName=" + streamName + "&offset= " + offset);

		}else{
			resp.sendRedirect("/ViewStreamImage.jsp?streamId=" + streamId + "&"
					+ "streamName=" + streamName + "&offset= " + offset);
		}
	}

}