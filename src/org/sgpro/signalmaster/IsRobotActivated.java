package org.sgpro.signalmaster;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Types;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.sgpro.db.HibSf;
/**
 */
@Path("/is_robot_activated")
public class IsRobotActivated  extends HttpServlet  {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public IsRobotActivated() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;
    
    @Path("/{robotimei}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String activeRobot(
  		  @PathParam("robotimei") String robotImei 
  		) throws Throwable {
    	
    	Result r = Result.success();
    	
    	try {
    		Connection c = HibSf.getConnection();
    		
    		CallableStatement call =
    				c.prepareCall("exec SP_IS_ROBOT_ACTIVATED ?, ?");
    		
    		int argCount = 1;
    		call.setString(argCount++, robotImei);
    		call.registerOutParameter(argCount++, Types.BIT);
    		call.execute();
    		r.setData( call.getBoolean(2));
    	
    	} catch (Throwable th) {
    		r = Result.unknowException(th);
    		th.printStackTrace();
    	}
    	
    	return r.toString();
    }
}
