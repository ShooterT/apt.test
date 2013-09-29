<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.adnan.AppUser"%>
<%@ page import="com.adnan.OfyService"%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<title>Connexus.us</title>
    	<link rel="stylesheet" type="text/css" href="stylesheets/navigation_bar_style.css" />
    	<link rel="stylesheet" type="text/css" href="stylesheets/font.css" /> 
</head>
<body>
<div id="fb-root"></div>
<script>
  window.fbAsyncInit = function() {
  FB.init({
    appId      : '368096253322828', // App ID
    channelUrl : '//tongzhao-apt-connexus.appspot.com/channel.html', // Channel File
    status     : true, // check login status
    cookie     : true, // enable cookies to allow the server to access the session
    xfbml      : true  // parse XFBML
  });

  FB.Event.subscribe('auth.authResponseChange', function(response) {
    if (response.status === 'connected') {
      // The response object is returned with a status field that lets the app know the current
      // login status of the person. In this case, we're handling the situation where they 
      // have logged in to the app.
      testAPI();
    } else if (response.status === 'not_authorized') {
      // In this case, the person is logged into Facebook, but not into the app, so we call
      // FB.login() to prompt them to do so. 
      // In real-life usage, you wouldn't want to immediately prompt someone to login 
      // like this, for two reasons:
      // (1) JavaScript created popup windows are blocked by most browsers unless they 
      // result from direct interaction from people using the app (such as a mouse click)
      // (2) it is a bad experience to be continually prompted to login upon page load.
      FB.login();
    } else {
      // In this case, the person is not logged into Facebook, so we call the login() 
      // function to prompt them to do so. Note that at this stage there is no indication
      // of whether they are logged into the app. If they aren't then they'll see the Login
      // dialog right after they log in to Facebook. 
      // The same caveats as above apply to the FB.login() call here.
      FB.login();
    }
  });
  };

  // Load the SDK asynchronously
  (function(d){
   var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
   if (d.getElementById(id)) {return;}
   js = d.createElement('script'); js.id = id; js.async = true;
   js.src = "//connect.facebook.net/en_US/all.js";
   ref.parentNode.insertBefore(js, ref);
  }(document));

  // Here we run a very simple test of the Graph API after login is successful. 
  // This testAPI() function is only called in those cases. 
  function testAPI() {
    console.log('Welcome!  Fetching your information.... ');
    FB.api('/me', function(response) {
      console.log('Good to see you, ' + response.name + '.');
    });
  }
</script>


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

<!--
  Below we include the Login Button social plugin. This button uses the JavaScript SDK to
  present a graphical Login button that triggers the FB.login() function when clicked.

  Learn more about options for the login button plugin:
  /docs/reference/plugins/login/ -->

<fb:login-button show-faces="true" width="200" max-rows="1"></fb:login-button>



</body>
</html>