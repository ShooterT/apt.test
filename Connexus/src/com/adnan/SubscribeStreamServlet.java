package com.adnan;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class SubscribeStreamServlet extends HttpServlet{
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException{
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		if (user == null){
			resp.sendRedirect(userService.createLoginURL(req.getRequestURI()));
		}else{
			List<AppUser> th = OfyService.ofy().load().type(AppUser.class).list();
			String streamName = req.getParameter("subscribe");
			for (AppUser a:th){
				if (a.userName.equals(user.getNickname())){
					a.streamsSubed.add(streamName);
					OfyService.ofy().save().entity(a).now();
					break;
				}
			}

			resp.sendRedirect("/manage.jsp");
		}


	}
}
