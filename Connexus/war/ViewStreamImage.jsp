<%@page import="java.util.ArrayList"%>
<%@page import="com.sun.tools.internal.xjc.reader.gbind.ConnectedComponent"%>
<%@page import="com.adnan.ConnexusImage"%>
<%@page import="com.adnan.AppUser"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.adnan.AppUser"%>
<%@ page import="com.adnan.Stream" %>
<%@ page import="com.adnan.OfyService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Date"%>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- If the stream belongs to current user, shows add image button --%>
<%-- If the stream doesn't belong to current user, shows subscribe stream button --%>
<%-- If no user is signed in now, still shows subscribe stream button. If button is clicked, remind him or her to sing in--%>


    
<html xmlns:fb="http://ogp.me/ns/fb#">
	<head>

	<style>
input[type="file"]
{
width:150px;
display:block;
margin-top:400px;
}
input[type="submit"]
{
width:150px;
margin-top:300px;
display:block;
}

</style>
	<link rel="stylesheet" type="text/css" href="stylesheets/navigation_bar_style.css" />
    <link rel="stylesheet" type="text/css" href="stylesheets/font.css" />  
    <link rel="stylesheet" type="text/css" href="stylesheets/create_style.css" />
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

  <div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=1383666768534008";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
function pageRedirect(address)
{
	window.location.replace(address);
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
	Long streamId = new Long(request.getParameter("streamId"));
	String streamName = request.getParameter("streamName");
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
	<table class="one">

<%
		List<Stream> sth = OfyService.ofy().load().type(Stream.class).list();
		for (int i = 0; i < sth.size(); i++){
			if (sth.get(i).name.equals(streamName)){
				sth.get(i).visitTime++;
				sth.get(i).visitQueue.add(new Date());
			}
		}
		OfyService.ofy().save().entities(sth).now();

		// get image lists belonging to this stream, then sort
		List<ConnexusImage> th = OfyService.ofy().load().type(ConnexusImage.class).list();
		ArrayList<ConnexusImage> candidates = new ArrayList<ConnexusImage>();
		for (ConnexusImage image : th){
			if (image.streamId.equals(streamId)){
				candidates.add(image);
			}
		}
		Collections.sort(candidates);
		int offset;
		if (request.getParameter("offset") == null){
			offset = 0;
		}else{
			 offset = Integer.parseInt(request.getParameter("offset"));
		}
		int tail = offset+3>candidates.size()?candidates.size():offset+3;
		System.out.println("tail = "+tail);
		%>
		<tr>
		<% 
		for (int i = offset; i < tail; i++  ) {
		  // APT: calls to System.out.println go to the console, calls to out.println go to the html returned to browser
		  // the line below is useful when debugging (jsp or servlet)
		  ConnexusImage image = candidates.get(i);

		  %>
		  <td class="one">
		  <img width="250" src="<%= image.bkUrl %>"> 
		  </td> 
<% 
		}
%>
		</tr>

    </table>
    <%
    	String address = new String();
    	if (offset > 0){
    		int offset_ = offset - 3;
    		address = "/ViewStreamImage.jsp?streamId="+streamId+"&streamName="+streamName+"&offset="+offset_;
    %>
    	<button onclick="pageRedirect('<%=address%>');" style="margin-top:60%">Newer</button>
    <%
    	}
    %>
    <%
    	
    	if (tail < candidates.size()){
    		int offset_ = offset + 3;
    		address = "/ViewStreamImage.jsp?streamId="+streamId+"&streamName="+streamName+"&offset="+offset_;
    	
    %>
    	<button onclick="pageRedirect('<%=address%>');" style="margin-top:70%">Older</button>
    	
    	<% 
    	}
    %>
<%
boolean flag = true;
boolean flagSubscribe = true;
if (user == null){
	flag = false;
}else{
	List<AppUser> ath = OfyService.ofy().load().type(AppUser.class).list();
	AppUser appUser = new AppUser(); 
	for (AppUser a:ath ){
		if (a.userName.equals(user.getNickname())){
			appUser = a;
			break;
		}
	}
	if (!appUser.streamsOwned.contains(streamName)){
		flag = false;
		System.out.println(streamName);
		if (appUser.streamsSubed.contains(streamName)){
			flagSubscribe = false;
			System.out.println("fuck");
		}
	}
}
	BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	if (flag){

%>
	<form action="<%= blobstoreService.createUploadUrl("/upload?streamId=" 
			+ streamId + "&streamName=" + streamName) %>" 
			method = "post" enctype="multipart/form-data">
	    	<input type="file" name="myFile" value="Browse" ><br> 
	    	<input type="submit" name="upload" value="Upload File">
   </form>
 <%
		}else if(flagSubscribe){
			%>
			<form action="subscribe" method="get">
			<button type="submit" class="action"  name="subscribe" value=<%=streamName %> >Subscribe</button>
			</form>
			<% 
		}else{
			%>
			<form action="subscribe" method="get">
			<button type="submit" class="action"  name="unsubscribe" value=<%=streamName %> >Unsubscribe</button>
			</form>
			<% 
		}
 
 %>
  <fb:like href="https://tong-apt-connexus.appspot.com/ViewStreamImage.jsp?streamId=<%= streamId %>&streamName=<%= streamName %>&offset=0" width="450" show_faces="true" send="true"></fb:like>	
  </body>
  
</html>