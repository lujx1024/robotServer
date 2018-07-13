package org.sgpro.signalmaster;

import java.sql.CallableStatement;
import java.sql.Connection;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.hibernate.Transaction;
import org.sgpro.db.HibSf;
import org.sgpro.db.ViewUserRobotBindList;
import org.sgpro.util.Digest;
/**
 */
@Path("/activate_robot")
public class ActivateRobot  extends HttpServlet  {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public ActivateRobot() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;
    @Context 
    private HttpServletResponse  response;
 
    @Path("/{username}/{password}/{robotname}/{robotimei}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String activeRobot(
  		  @PathParam("username") String username 
  		  ,@PathParam("password") String password 
  		  ,@PathParam("robotname") String robotname 
  		  ,@PathParam("robotimei") String robotImei 
  		) throws Throwable {
    	
    	Result r = Result.success();
    	
    	try {
    		Connection c = HibSf.getConnection();
    		
    		CallableStatement call =
    				c.prepareCall("exec SP_ACTIVATE_ROBOT ?, ?, ?, ?, ?");
			String dig = Digest.getMD5(password);

    		int argCount = 1;
    		call.setString(argCount++, username);
    		call.setString(argCount++, password);
    		call.setString(argCount++, dig);
    		call.setString(argCount++, robotname);
    		call.setString(argCount++, robotImei);
    		
    		call.execute();
    	
    	} catch (Throwable th) {
    		r = Result.unknowException(th);
    		th.printStackTrace();
    	}
    	
    	return r.toString();
    }
    
    @Path("/info/{robotimei}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String activeRobot(
  		  @PathParam("robotimei") String robotImei 
  		) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		try {
			
			trans = HibSf.getSession().beginTransaction();
			response.addHeader("Access-Control-Allow-Origin" , "*");
			r.setData(ViewUtils.getViewDataList(
					ViewUtils.dbProcQuery(ViewUserRobotBindList.class
							, "SP_GET_ACTIVIATED_INFO"
							, robotImei)));
			trans.commit();
		} catch (Throwable th) {
			r = Result.unknowException(th);
			th.printStackTrace();
			try {
				if (trans != null) {
					trans.rollback();
				}
			} catch (Throwable t) {
				r = Result.unknowException(t);
				t.printStackTrace();
			}
		}
		return r.toString();
	}
}
