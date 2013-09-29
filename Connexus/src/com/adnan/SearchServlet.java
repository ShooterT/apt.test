package com.adnan;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import static com.adnan.OfyService.ofy;

public class SearchServlet extends HttpServlet{
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException, ServletException{
		ArrayList<Stream> results = new ArrayList<Stream>();
		String query = req.getParameter("keywordName");
		//String queryEnd = query + "\uFFFD";
        //List<Stream> streams = ofy().load().type(Stream.class).filter("streamName >=", query)
         //       .filter("streamName <", queryEnd).list();
		List<Stream> streams = OfyService.ofy().load().type(Stream.class).list();
        for (Stream stream : streams) {
            if (stream.name.contains(query) && !results.contains(stream) ) {
                    results.add(stream);
            }
        }
        req.setAttribute("result", results);
        getServletContext().getRequestDispatcher("/search.jsp").forward(req, resp);

	}

}