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


<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
  <head>
  	<link rel="stylesheet" type="text/css" href="stylesheets/navigation_bar_style.css" />
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
<%

		List<Stream> th = OfyService.ofy().load().type(Stream.class).list();

		Collections.sort(th);

		for (int i = 0; i < th.size(); i++) {
			Stream s = th.get(i);
			if (i%4==0){
				%>
				<tr>
				<% 
			}	
%>
			<td class="one">
       		<img width="250" src=<%=s.coverImageUrl %>>
       		<br>
       		<a href="ViewStreamImage.jsp?streamId=<%= s.id %>&streamName=<%= s.name %>&offset=0"> <%=s.name %></a>
       		</td>	
       		<%
       		if (i%4==3){
       		%>
       		</tr>
			<% 
			} 
		}
%>
	</table>
  </body>
</html>