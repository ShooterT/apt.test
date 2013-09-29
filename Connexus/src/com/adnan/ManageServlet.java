package com.adnan;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;


public class ManageServlet extends HttpServlet{
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException{

		if (req.getParameter("submitOwn")!=null){
			String[] deleteItemStrings=req.getParameterValues("deleteOwnItem");
			if (deleteItemStrings != null){
				HashSet<String> hashSet = new HashSet<String>();
				for (String string : deleteItemStrings){
					hashSet.add(string);
				}

				UserService userService = UserServiceFactory.getUserService();
				User user = userService.getCurrentUser();

				List<AppUser> th = OfyService.ofy().load().type(AppUser.class).list();
				AppUser appUser = new AppUser();
				for (AppUser a:th){
					if (a.userName.equals(user.getNickname())){
						appUser = a;
						break;
					}
				}			
				for (Iterator<String> iter = hashSet.iterator(); iter.hasNext();){
					String s = iter.next();
					appUser.streamsOwned.remove(s);
				}
				OfyService.ofy().save().entity(appUser).now();


				List<Stream> streams = OfyService.ofy().load().type(Stream.class).list();
				for (Iterator<Stream> iterator = streams.iterator();iterator.hasNext();){
					Stream stream = iterator.next();
					if (hashSet.contains(stream.name)){
						OfyService.ofy().delete().entity(stream).now();
					}
				}

				List<ConnexusImage> images = OfyService.ofy().load().type(ConnexusImage.class).list();
				for (Iterator<ConnexusImage> iterator = images.iterator();iterator.hasNext();){
					ConnexusImage image = iterator.next();
					if (hashSet.contains(image.streamName)){
						OfyService.ofy().delete().entity(image).now();
					}
				}
			}
		}else if (req.getParameter("submitSub")!=null){

			String[] deleteItemStrings=req.getParameterValues("deleteSubItem");
			if (deleteItemStrings != null){
				HashSet<String> hashSet = new HashSet<String>();
				for (String string : deleteItemStrings){
					hashSet.add(string);
				}

				UserService userService = UserServiceFactory.getUserService();
				User user = userService.getCurrentUser();
				List<AppUser> th = OfyService.ofy().load().type(AppUser.class).list();
				AppUser appUser = new AppUser();
				for (AppUser a:th){
					if (a.userName.equals(user.getNickname())){
						appUser = a;
						break;
					}
				}
				for (Iterator<String> iter = hashSet.iterator(); iter.hasNext();){
					String s = iter.next();
					appUser.streamsSubed.remove(s);
				}
				OfyService.ofy().save().entity(appUser).now();

			}

		}


		resp.sendRedirect("/manage.jsp");

	}

}
