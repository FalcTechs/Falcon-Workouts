//[START all]
package com.falctechs.logger;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import com.googlecode.objectify.ObjectifyService;

import java.io.*;
import java.util.*;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * This class is a form handling servlet.
 * The LogServlet is mainly utilized in logger.jsp, which displays the {@link Post}'s.
 * 
 * The servlet contains one method, {@link #doPost(<#HttpServletRequest req#>, <#HttpServletResponse resp#>)}.
 */
public class LogServlet extends HttpServlet {
  /**
   * Takes the post data and saves it using Objectify.
   * Each Post is classified through the page name, author e-mail, author ID, and content.
   * 
   * This method also reloads the page immediately after every post is made.
   * 
   * @param req  the request from the HttpServlet
   * @param resp the response from the HttpServlet
   */
  @Override
  public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    Post post;

    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();

    // Creates the post
    String logPage = req.getParameter("logPage");
    String content = req.getParameter("content");
    if (user != null) {
      post = new Post(logPage, content, user.getUserId(), user.getEmail());
    } else {
      post = new Post(logPage, content);
    }

    ObjectifyService.ofy().save().entity(post).now();
    // Reloads the page
    resp.sendRedirect("/logger.jsp?logPage=" + logPage);
  }
}
//[END all]
