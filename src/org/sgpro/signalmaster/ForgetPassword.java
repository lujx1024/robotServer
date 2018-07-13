package org.sgpro.signalmaster;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Types;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.sgpro.db.HibSf;
import org.sgpro.util.StringUtil;
/**
 */
@Path("/forget_password")
public class ForgetPassword  extends HttpServlet  {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public ForgetPassword() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;

    @Context 
    private HttpServletResponse  response;
    
    @Path("/{username}/{robotimei}")    
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String forgetPassword(
    		@PathParam("username") String username
    		, @PathParam("robotimei") String robotimei
  		) throws Throwable {
    	
    	Result r = Result.success();
    	
    	try {

    		if (StringUtil.isNullOrEmpty(username)) {
    			r.setCode("1001");
    			r.setMessage("帐号不能为空!");
    			
    			
    		} else {
    			

        		Connection c = HibSf.getConnection();
        		
        		CallableStatement call =
        				c.prepareCall("exec SP_GET_USER_EMAIL_FROM_ROBOT_EP ?, ?, ?");
        		
        		int argCount = 1;
        		call.setString(argCount++, username);
        		call.setString(argCount++, robotimei);
        		call.registerOutParameter(argCount++, Types.VARCHAR);
        		call.execute();
        		
        		String email = call.getString(3);
        		
        		if (StringUtil.isNotNullAndEmpy(email)) {
        			// 发送邮件
        			
        		} else {
        			// 帐号不存在
        			r.setCode("1002");
        			r.setMessage("帐号不存在!");
        		}
    		}
    	} catch (Throwable th) {
    		r = Result.unknowException(th);
    		th.printStackTrace();
    	}
    	
    	return r.toString();
    }
}
