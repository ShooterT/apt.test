<%@page import="com.adnan.AppUser"%>
<%@ page import="com.adnan.Stream" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.adnan.OfyService"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html> 
	<head> 
    	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<title>Connexus.us</title>
    	<link rel="stylesheet" type="text/css" href="stylesheets/navigation_bar_style.css" />
    	<link rel="stylesheet" type="text/css" href="stylesheets/font.css" />    
    	<link rel="stylesheet" type="text/css" href="stylesheets/table.css" />  
    	<link rel="stylesheet" type="text/css" href="stylesheets/search_box_style.css" />  
    	<link rel="stylesheet" type="text/css" href="stylesheets/power.css" />  
	</head>

	<body> 
<%
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();

%>	
	<ul id="navigation">
	<li> <a href="index.jsp" class="main">Connexus</a> </li>

    <li> <a href="manage.jsp" class="main">Manage</a> </li>
    
    <li> <a href="viewAllStream.jsp" class="main">View</a> </li>
    
    <li> <a href="createStream.jsp" class="main">Create</a></li>
    
    <li> <a href="search.jsp" class="main">Search</a></li>
    
    <li> <a href="trending.jsp" class="main">Trending</a></li>

	<li> <a href="social.jsp" class="main">Social</a></li>
   
   

<% 
	if (user != null) {
    	pageContext.setAttribute("user", user);
    	List<AppUser> list = OfyService.ofy().load().type(AppUser.class).list();
    	if (list.isEmpty()){
    		OfyService.ofy().save().entities(new AppUser(user.getNickname(),user.getEmail())).now();
    	}else{
    		boolean flag = false;
    		for (AppUser a:list){
    			if (a.userName.equals(user.getNickname())){
    				flag = true;
    				break;
    			}
    		}
    		if (!flag){
    			OfyService.ofy().save().entities(new AppUser(user.getNickname(),user.getEmail())).now();
    		}
    	}
%>
		<li> <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>" class="main">${fn:escapeXml(user.nickname)}</a></li>
<%
	}else{
%>
		<li> <a href="<%= userService.createLoginURL(request.getRequestURI()) %>" class="main">Login</a></li>
<% 
	}
%>
	</ul>

	<%-- regard not logging in as a user with no stream/subscription --%>
	<form action="manage" method="get">
	<h2>Stream Management</h2>
	<h3>Streams I own</h3>
	<div class="table">
	<table>
	<% 
	if (user == null){
	%>
		<tr>You don't have any streams yet.</tr>
	<% 
	}else{
		List<AppUser> th = OfyService.ofy().load().type(AppUser.class).list();
		AppUser appUser = new AppUser(); 
		for (AppUser a:th ){
			if (a.userName.equals(user.getNickname())){
				appUser = a;
				break;
			}
		}
		List<Stream> sth = OfyService.ofy().load().type(Stream.class).list();
		if (appUser.streamsOwned.isEmpty()){
	%>
			<tr>You don't have any streams yet.</tr>
	<%		
		}else{
	%>

			<tr>
				<td>Name</td>
				<td>Last New Picture</td>
				<td>Number of Pictures</td>
				<td>Delete</td>
			</tr>
	<%
			ArrayList<Stream> streamlist1 = new ArrayList<Stream>();
			for (String string:appUser.streamsOwned){
				for (Stream stream:sth){
					if (stream.name.equals(string)){
						streamlist1.add(stream);
						break;
					}
				}
			}
			for (int i = 0; i < streamlist1.size(); i++){
	%>			
				<tr>
					<td><a href="ViewStreamImage.jsp?streamId=<%= streamlist1.get(i).id %>&streamName=<%= streamlist1.get(i).name %>&offset=0"><%= streamlist1.get(i).name %></a></td>
					<td><%= streamlist1.get(i).newImageDate %></td>
					<td><%= streamlist1.get(i).pictureNum %></td>
					<td>	
						<input type="checkbox" name="deleteOwnItem" value= <%= streamlist1.get(i).name %> >
					</td>

				</tr>
	<%
			}
			%>
			<button type="submit" class="action" name = "submitOwn">Delete checked</button>
			<% 
		}
	}
	 %>

	</table>


	</div>


	<h3>Streams I subscribe to</h3>
	<div class="table">
	<table>
	<% 
	if (user == null){
	%>
		<tr>You didn't subscribe to any streams yet.</tr>
	<% 
	}else{
		List<AppUser> th = OfyService.ofy().load().type(AppUser.class).list();
		AppUser appUser = new AppUser(); 
		for (AppUser a:th ){
			if (a.userName.equals(user.getNickname())){
				appUser = a;
				break;
			}
		}
		List<Stream> sth = OfyService.ofy().load().type(Stream.class).list();

		if (appUser.streamsSubed.isEmpty()){
	%>
			<tr>You didn't subscribe to any streams yet.</tr>
	<%		
		}else{
	%>
			<tr>
				<td>Name</td>
				<td>Last New Picture</td>
				<td>Number of Pictures</td>
				<td>Views</td>
				<td>Unsubscribe</td>
			</tr>
	<%
			ArrayList<Stream> streamlist2 = new ArrayList<Stream>();
			for (String string:appUser.streamsSubed){
				for (Stream stream:sth){
					if (stream.name.equals(string)){
						streamlist2.add(stream);
					break;
					}
				}
			}

			for (int i = 0; i < streamlist2.size(); i++){
	%>			
				<tr>
					<td><a href="ViewStreamImage.jsp?streamId=<%= streamlist2.get(i).id %>&streamName=<%= streamlist2.get(i).name %>&offset=0"><%= streamlist2.get(i).name %></a></td>
					<td><%= streamlist2.get(i).newImageDate %></td>
					<td><%= streamlist2.get(i).pictureNum %></td>
					<td><%= streamlist2.get(i).visitTime %></td>
					<td>	
						<input type="checkbox" name="deleteSubItem" value= <%= streamlist2.get(i).name %> >
					</td>

				</tr>
	<%
			}
			%>
			<button type="submit" class="action" name = "submitSub" id="submit">Unsubscribe checked</button>
			<% 

		}
	}
	%>

	</table>

	</div>

	</form>

	</body>

</html>