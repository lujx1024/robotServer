package org.sgpro.signalmaster;

import java.sql.Timestamp;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.hibernate.Transaction;
import org.sgpro.db.HibSf;
import org.sgpro.db.TblRuntime;
import org.sgpro.db.TblRuntimeHome;
/**
 */
@Path("/submit_runtime")
public class SubmitRuntime  extends HttpServlet  {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public SubmitRuntime() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;

    @Context 
    private HttpServletResponse  response;
    
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public String submitRuntime(
 		   @FormParam("imei") String imei
  		  ,@FormParam("message") String message
  		  ,@FormParam("description") String description
  		  ,@FormParam("note") String note
  		) throws Throwable {
    	
    	Result r = Result.success();

    	Transaction trans = null;
    	try {
    		
    		response.addHeader("Access-Control-Allow-Origin" , "*");
    	
    		// System.out.println("submitRuntime-" + message + "-" + description + "-" + note);
    		
    		trans = HibSf.getSession().beginTransaction();
    		TblRuntimeHome dao = new TblRuntimeHome();
    		dao.persist(new TblRuntime(System.currentTimeMillis(), imei, message, description, note, new Timestamp(System.currentTimeMillis())));
    		trans.commit();

    	} catch (Throwable th) {
    		r = Result.unknowException(th);
    		th.printStackTrace();
    		if (trans != null) {
    			trans.rollback();
    		}
    	}
    	
    	return r.toString();
    }
}
