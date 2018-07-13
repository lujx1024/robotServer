package org.sgpro.signalmaster;

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
import org.sgpro.db.TblRuntimeData;

@Path("/robot_exception")
public class GetRobotException extends HttpServlet{

	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public GetRobotException() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;
    @Context 
    private HttpServletResponse  response;
 
    
    /**
     * 
     * @param groupId 公司id
     * @param sn 机器人 sn
     * @param end 截至时间
     * @param range 间隔范围
     * @param unit  
     * @param keyword
     * @param maxcount
     * @return
     * @throws Throwable
     */
    @Path("/list/")
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public String list(
   		   @FormParam("groupId") Long groupId 
  		  ,@FormParam("sn") String sn 
  		  ,@FormParam("end") String end 
  		  ,@FormParam("range") Long range
  		  /*,@FormParam("unit") String unit */
  		  ,@FormParam("keyword") String keyword 
  		  /*,@FormParam("maxCount") Long maxCount */
  		  
  		) throws Throwable {
		Result r = Result.success();
		Transaction trans = null;
		try {
				
			trans = HibSf.getSession().beginTransaction();
			response.addHeader("Access-Control-Allow-Origin" , "*");
			r.setData(
			ViewUtils.dbProcQuery(TblRuntime.class, "SP_GET_ROBOT_EXCEPTION"
					, groupId, sn, end, range, /*unit*/"day", keyword/*, maxCount*/));
			
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
