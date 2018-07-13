package org.sgpro.signalmaster;

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
import org.sgpro.db.ViewRobotAppBindList;
/**
 */
@Path("/app_lastest_version")
public class GetRobotAppLastestVersion  extends HttpServlet  {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public GetRobotAppLastestVersion() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;
    @Context 
    private HttpServletResponse  response;
 
    @Path("/{imei}/")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String getAll(
  		  @PathParam("imei") String imei 
  		) throws Throwable {
		Result r = Result.success();
		Transaction trans = null;
		try {
			
			trans = HibSf.getSession().beginTransaction();
			response.addHeader("Access-Control-Allow-Origin" , "*");
			r.setData(
			ViewUtils.getViewDataList(
			ViewUtils.dbProcQuery(ViewRobotAppBindList.class, "SP_GET_ROBOT_APP_LASTEST_VERSION"
					, imei, null, true)));
			
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
