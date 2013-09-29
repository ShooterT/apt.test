<%@page import="com.googlecode.objectify.Result"%>
<%@page import="com.adnan.AppUser"%>
<%@ page import="com.adnan.OfyService"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html> 
	<head> 
    	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<title>Connexus.us</title>
    	<link rel="stylesheet" type="text/css" href="stylesheets/navigation_bar_style.css" />
    	<link rel="stylesheet" type="text/css" href="stylesheets/font.css" />  
    	<link rel="stylesheet" type="text/css" href="stylesheets/create_style.css" />  
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
	<%-- action links the url-pattern in web.xml --%>
	<%-- url-pattern will search servlet java class according to its servlet name --%>
<%--

	boolean flag;
	String result="success";
	try{
		System.out.println("sign--");
		result = request.getParameter("createRes");
		System.out.println(result);
		flag = false;
	}catch (NullPointerException npe){
		flag = true;
	}

	if (!flag && result!=null && result.equals("fail")){
--%>		

<%--
	}

--%>
	<form name="createStreamInput" action="createStreamServlet" method="get">
	<ul>
        <li>
        	<label for="name"><b>Name your stream:</b></label>
            <input type="text" size="50" id="name" name="streamName" />
        </li>
        <li>
        	<label for="tag"><b>Tag your stream:</b></label>
            <input type="text" size="50" id="name" name="tags"/>
        </li>
        <li>
        	<label for="url"><b>URL to cover image(optional):</b></label>
            <input type="text" size="50" id="url" name="url" />
        </li>

		<li>
        	<label for="subscribers"><b>Add subscribers:</b></label>
            <input type="email" size="50" id="subscribers" name="subscribers" />
		</li>
        <li>
        	<label for="message"><b>Message for invite(optional): </b></label>
            <textarea cols="50" rows="5" id="message" name="message"></textarea>
		</li>
	</ul>
    <p>
        <button type="reset" class="right">Reset</button>
        <button type="submit" class="action">Create Stream</button>
    </p>
	</form>


	</body>

</html>