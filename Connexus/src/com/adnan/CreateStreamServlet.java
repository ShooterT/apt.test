package com.adnan;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.condition.IfZero;

import static com.googlecode.objectify.ObjectifyService.ofy;

// Backs up CreateStream.html form submission. Trivial since there's no image uploaded, just a URL
@SuppressWarnings("serial")
public class CreateStreamServlet extends HttpServlet{
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException{

		// user service to add in servlet
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();

		
		String streamName = req.getParameter("streamName");
		List<Stream> streams = ofy().load().type(Stream.class).list();
		for(Stream s : streams){
			if (s.name.equals(streamName)){
				resp.sendRedirect("/error.jsp");
				return ;
			}
		}

		Stream s;
		if (req.getParameter("url").isEmpty() || req.getParameter("url").equals("")){
			s = new Stream(req.getParameter("streamName"),
					req.getParameter("tags"));
			System.out.println("null " + s.coverImageUrl);
		}
		else{
			s = new Stream(req.getParameter("streamName"),
					req.getParameter("tags"), req.getParameter("url"));
		}

		ofy().save().entity(s).now();

		List<AppUser> th = OfyService.ofy().load().type(AppUser.class).list();
		AppUser appUser = new AppUser();
		String emailString = req.getParameter("subscribers");
		String invitationMsg = req.getParameter("message");
		if (invitationMsg==null || invitationMsg.equals("")){
			invitationMsg = "Hey, come and share your world on Connexus!";
		}
		System.out.println(emailString);
		System.out.println(invitationMsg);
		OfyService.sendmail(emailString,invitationMsg);
		if (th.isEmpty()){
			appUser = new AppUser(user.getNickname(),user.getEmail());
		}else{
			boolean flag = false;
			for (AppUser a:th ){
				if (a.userName.equals(user.getNickname())){
					appUser = a;
					flag = true;
					break;
				}
			}
			if (!flag){
				appUser = new AppUser(user.getNickname(),user.getEmail());
			}
		}
		appUser.streamsOwned.add(s.name);
		System.out.println("appuser = "+appUser.userName + " added stream "+s.name);
		ofy().save().entity(appUser).now();

		resp.sendRedirect("/manage.jsp");


	}

}