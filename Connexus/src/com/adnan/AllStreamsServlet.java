package com.adnan;
 
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.List;

import javax.servlet.http.*;
 
import java.util.ArrayList;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
 
import static com.googlecode.objectify.ObjectifyService.ofy;

public class AllStreamsServlet extends HttpServlet{

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException{
		List<Stream> th = OfyService.ofy().load().type(Stream.class).list();
		Gson gson = new Gson();
		String json = gson.toJson(th);
		resp.getWriter().print(json);
    	
    	Type t = new TypeToken<List<Stream>>(){}.getType();
    	List<Stream> fromJson = (List<Stream>) gson.fromJson(json, t);
    	for (Stream s : fromJson ) {
      		System.out.println(s);
    	}
	}
 }