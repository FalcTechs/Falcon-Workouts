//[START all]
package com.falctechs.logger;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

import java.util.*;

/**
 * Each Post entity is registered in {@link OfyHelper} and contains a timestamp, author e-mail, author ID, and content.
 * These are then printed in logger.jsp, and stored to a page in a Logger object.
 */

@Entity
public class Post {
  @Parent Key<Logger> log;
  @Id public Long id;

  public String author_email;
  public String author_id;
  public String content;
  @Index public Date date;

  // Nullary constructor
  public Post() {
    date = new Date();
  }

  public Post(String page, String content) {
    this();
    if( page != null ) {
      log = Key.create(Logger.class, page);
    } else {
      log = Key.create(Logger.class, "main"); // Default page is "main"
    }
    this.content = content;
  }

  public Post(String page, String content, String id, String email) {
    this(page, content);
    author_email = email;
    author_id = id;
  }

}
//[END all]
