package org.sgpro.signalmaster;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.hibernate.Transaction;
import org.sgpro.db.HibSf;
import org.sgpro.util.Digest;
/**
 */
@Path("/deactivate_robot")
public class DeactivateRobot  extends HttpServlet  {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public DeactivateRobot() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;
    
    @Path("/{username}/{password}/{robotimei}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String activeRobot(
  		  @PathParam("username") String username 
  		  ,@PathParam("password") String password 
  		  ,@PathParam("robotimei") String robotImei 
  		) throws Throwable {
    	
    	Result r = Result.success();
    	
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			String dig = Digest.getMD5(password);
			
    		ViewUtils.dbProc("SP_DEACTIVATE_ROBOT", username, password, dig, robotImei);
    		trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
					r = Result.unknowException(t);
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
    	
    	return r.toString();
    }
}
