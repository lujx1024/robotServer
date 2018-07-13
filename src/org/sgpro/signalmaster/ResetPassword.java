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
@Path("/reset_password")
public class ResetPassword  extends HttpServlet  {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public ResetPassword() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;
    
    @Path("/{username}/{password}/{new_password}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String resetPwd(
  		  @PathParam("username") String username 
  		  ,@PathParam("password") String password 
  		  ,@PathParam("new_password") String new_password 
  		) throws Throwable {
    	
    	Result r = Result.success();
    	
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
    		ViewUtils.dbProc("SP_RESET_USER_PASSWORD"
    				, username
    				, Digest.getMD5(password)
    				, Digest.getMD5(new_password)
    				);
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
