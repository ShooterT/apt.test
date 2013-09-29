<%@page import="com.googlecode.objectify.Result"%>
<%@page import="com.adnan.AppUser"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.adnan.OfyService"%>
<%@ page import="java.util.List" %>
<html> 
	<head> 
    	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<title>Connexus.us</title>
    	<link rel="stylesheet" type="text/css" href="stylesheets/navigation_bar_style.css" />
    	<link rel="stylesheet" type="text/css" href="stylesheets/font.css" />  
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

	<div class="box5">  
       <img src="http://www.wpthemegenerator.com/wp-content/uploads/2012/06/Image.jpg">
       <div class="fold_box5"></div>
       <div class="fold2_box5"></div>
    </div>
    <p>
         Error, you tried to create a new stream whose name is the same to an existing one.
    </p>
    <br>
    <p>
    	Operation didn't complete.
    </p>
    

	</body>
</html>