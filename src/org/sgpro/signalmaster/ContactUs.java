package org.sgpro.signalmaster;

import java.sql.CallableStatement;
import java.sql.Connection;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.apache.log4j.Logger;
import org.sgpro.db.HibSf;

import config.Log4jInit;
/**
 */
@Path("/contact_us")
public class ContactUs  extends HttpServlet  {
	static Logger logger = Logger.getLogger(ContactUs.class.getName());
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public ContactUs() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;

    @Context 
    private HttpServletResponse  response;
    
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public String contactUs(
 		   @FormParam("email") String email
  		  ,@FormParam("subject") String subject
  		  ,@FormParam("content") String content
  		  ,@FormParam("name") String name
  		  ,@FormParam("authcode") String authCode
  		) throws Throwable {
    	
    	Result r = Result.success();
    	
    	try {
    		
    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		
    		Connection c = HibSf.getConnection();
    		
    		CallableStatement call =
    				
    				c.prepareCall("exec SP_SAVE_USER_FEEDBACK ?, ?, ?, ?");
    		
    		int argCount = 1;
    		
    		call.setString(argCount++, name);
    		call.setString(argCount++, email);
    		call.setString(argCount++, subject);
       		call.setString(argCount++, content);
    		call.execute();
    		
    		logger.info(email + ":" + subject + ":"  + name + ":" + authCode + ":"  + r.toString());
    	} catch (Throwable th) {
    		r = Result.unknowException(th);
    		th.printStackTrace();
    	}
    	
    	return r.toString();
    }
}
