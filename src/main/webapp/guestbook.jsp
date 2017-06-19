<%-- //[START all]--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%-- //[START imports]--%>
<%@ page import="com.falctechs.logger.Post" %>
<%@ page import="com.falctechs.logger.Logger" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%-- //[END imports]--%>

<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
</head>

<body>

<%
    String logPage = request.getParameter("logPage");
    if (logPage == null) {
        logPage = "main";
    }
    // The only valid pages are "main" and those with format "MM/DD", representing a valid date.
    if (logPage.equals("main")) {
        pageContext.setAttribute("logPage", logPage);
    } else {
        try {
            if (logPage.length() != 5) {
                throw new Exception();
            }
            int m = Integer.parseInt(logPage.substring(0,2));
            int d = Integer.parseInt(logPage.substring(3,5));
            if (logPage.charAt(2) != '/') {
                throw new Exception();
            }
            if ((m < 1) || (m > 12)) {
                throw new Exception();
            }
            if (((m < 8) && (m % 2 == 1)) || ((m > 7) && (m % 2 == 0))) {
                if ((d < 1) || (d > 31)) {
                    throw new Exception();
                }
            } else if (m == 2) {
                if ((d < 1) || (d > 28)) {
                    throw new Exception();
                }
            } else {
                if ((d < 1) || (d > 30)) {
                    throw new Exception();
                }
            }
            pageContext.setAttribute("logPage", logPage);
        } catch(Exception e){
%>
<p>
<font color="red">
Please choose a valid board.<br />
Current operational boards are: "main", and a valid date (in format "mm/dd")
</font>
</p>
<%
            logPage = "main"; // If a valid page is not entered "main" is set as a placeholder.
            pageContext.setAttribute("logPage", logPage);
        }
    }
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
        pageContext.setAttribute("user", user);
%>

<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
    <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
<%
    } else {
%>
<p>Hello, and welcome to Falcon Workouts!
    <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
    to post your workout progress.</p>
<%
    }
%>

<%-- //[START datastore]--%>
<%
      Key<Logger> log = Key.create(Logger.class, logPage);

      List<Post> posts = ObjectifyService.ofy()
          .load()
          .type(Post.class) // Only Posts
          .ancestor(log)    // All posts in the specific log
          .order("date")    // Most recent last
          .list();

    if (posts.isEmpty()) {
%>
<p>Board '${fn:escapeXml(logPage)}' has no messages.</p>
<%
    } else {
%>
<p>Messages in Board '${fn:escapeXml(logPage)}'.</p>
<%
        for (Post post : posts) {
            pageContext.setAttribute("post_content", post.content);
            String author;
            if (post.author_email != null) { // Posts without authors are not included
                author = post.author_email;
                String author_id = post.author_id;
                if (user != null && user.getUserId().equals(author_id)) {
                    author += " (You)";
                }
                pageContext.setAttribute("post_user", author);
%>
<p><b>${fn:escapeXml(post_user)}</b> wrote:</p>
<blockquote>${fn:escapeXml(post_content)}</blockquote>
<%
            }
        }
    }
%>

<form action="/sign" method="post">
    <div><textarea name="content" rows="3" cols="60"></textarea></div>
    <div><input type="submit" value="Post Message"/></div>
    <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
</form>
<%-- //[END datastore]--%>
<form action="/guestbook.jsp" method="get">
    <div><input type="text" name="guestbookName" value="${fn:escapeXml(logPage)}"/></div>
    <div><input type="submit" value="Switch Board	"/></div>
</form>
<%
    if (!(logPage.equals("main"))) { // Displays a link with videos if on a page represented with a day
%>
<p>
<br />
<br />
Need demonstrations on some of the workouts? Try <a href="https://falconworkouts.bubbleapps.io/version-test/videopage">this link</a>.
</p>
<%
    }
%>


</body>
</html>
<%-- //[END all]--%>
