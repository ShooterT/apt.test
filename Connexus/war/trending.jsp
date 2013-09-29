<%@page import="java.util.Date"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.adnan.AppUser"%>
<%@ page import="com.adnan.Stream" %>
<%@ page import="com.adnan.OfyService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.lang.Integer"%>


<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
  <head>
  	<link rel="stylesheet" type="text/css" href="stylesheets/navigation_bar_style.css" />
  	<link rel="stylesheet" type="text/css" href="stylesheets/search_box_style.css" />
    <link rel="stylesheet" type="text/css" href="stylesheets/font.css" />   
    <style type="text/css">
	table.one
	{
	border-collapse: separate;
	border-spacing: 20px;
	position:absolute;
	left:100px;
	}
	td.one{
	text-align:center;
	}
	</style>
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
		<li> <a href="index.jsp" class="main">${fn:escapeXml(user.nickname)}</a></li>
<%
	}else{
%>
		<li> <a href="<%= userService.createLoginURL(request.getRequestURI()) %>" class="main">Login</a></li>
<% 
	}
%>
	</ul>
	<table class="one" border="1">
	<tr>
	<%

		//get result of top 3 streams
		List<Stream> th = OfyService.ofy().load().type(Stream.class).list();
		Date base = new Date();
		int max1 = -1;
		int max2 = -1;
		int max3 = -1;
		for (int i = 0; i < th.size(); i++){
			int count = th.get(i).updateQueue(base);
			if (max1 == -1){
				max1 = i;
			}else if (max2 == -1){
				if (count > th.get(max1).visitQueue.size()){
					max2 = max1;
					max1 = i;
				}else{
					max2 = i;
				}
			}else if (max3 == -1){
				if (count > th.get(max1).visitQueue.size()){
					max3 = max2;
					max2 = max1;
					max1 = i;
				}else if (count > th.get(max2).visitQueue.size()){
					max3 = max2;
					max2 = i;
				}else{
					max3 = i;
				}
			}else if (count > th.get(max1).visitQueue.size()){
				max3 = max2;
				max2 = max1;
				max1 = i;
			}else if(count > th.get(max2).visitQueue.size()){
				max3 = max2;
				max2 = i;
			}else if(count > th.get(max3).visitQueue.size()){
				max3 = i;
			}
		}
		OfyService.ofy().save().entities(th).now();

		if (max1 != -1){
			%>
			<td class="one">
			<img width="250" src=<%=th.get(max1).coverImageUrl%>>
       		<br>
       		<a href="ViewStreamImage.jsp?streamId=<%= th.get(max1).id %>&streamName=<%= th.get(max1).name %>">
       		<%=th.get(max1).name %></a>
			</td>
			<%
		}
		if (max2 != -1){
			%>
			<td class="one">
			<img width="250" src=<%=th.get(max2).coverImageUrl%>>
       		<br>
       		<a href="ViewStreamImage.jsp?streamId=<%= th.get(max2).id %>&streamName=<%= th.get(max2).name %>">
       		<%=th.get(max2).name %></a>
			</td>
			<%
		}
		if (max3 != -1){
			%>
			<td class="one">
			<img width="250" src=<%=th.get(max3).coverImageUrl%>>
       		<br>
       		<a href="ViewStreamImage.jsp?streamId=<%= th.get(max3).id %>&streamName=<%= th.get(max3).name %>">
       		<%=th.get(max3).name %></a>
			</td>
			<%
		}

	%>

		<td class="one"></td>
		<td class="one">

		<form action="digest" method="get">
			<input type="checkbox" name="No Report"  > No Reports <br>
			<input type="checkbox" name="Every 5 minutes"  > Every 5 minutes <br>
			<input type="checkbox" name="Every 1 hour"  > Every 1 hour <br>
			<input type="checkbox" name="Every day"  > Every day <br>
			<button class="action" type="submit" >Update Rate</button>
		</form>

		</td>

	</tr>