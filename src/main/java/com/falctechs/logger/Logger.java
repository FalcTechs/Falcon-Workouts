//[START all]
package com.falctechs.logger;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

/**
 * Creates a Logger object that is registered in OfyHelper.java.
 * 
 * Additionally, each Logger is identified through its name, or page.
 */
@Entity
public class Logger {
  @Id public String page;
}
//[END all]
