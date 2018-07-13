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

import org.apache.log4j.Logger;
import org.hibernate.Transaction;
import org.sgpro.db.HibSf;
import org.sgpro.db.TblRuntime;
import org.sgpro.db.TblRuntimeData;
import org.sgpro.db.TblRuntimeHome;

import config.Log4jInit;
/**
 */
@Path("/runtime")
public class Runtime  extends HttpServlet  {
	static Logger logger = Logger.getLogger(Runtime.class.getName());
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public Runtime() {
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
    	
    		// logger.debug("submitRuntime-" + message + "-" + description + "-" + note);
    		
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
  		  ,@FormParam("packageName") String packageName 
  		  ,@FormParam("end") String end 
  		  ,@FormParam("range") Long range
  		  ,@FormParam("unit") String unit 
  		  ,@FormParam("keyword") String keyword 
  		  ,@FormParam("maxCount") Long maxCount 
  		  
  		) throws Throwable {
		Result r = Result.success();
		Transaction trans = null;
		try {
//			  @GROUP_ID BIGINT  -- 公司ID
//				, @SN  NVARCHAR(50) -- 机器人SN号
//				, @START  NVARCHAR(20) -- 起始时间
//				, @RANGE BIGINT -- 范围
//				, @UNIT  NVARCHAR(10) -- 单位
//				, @keyword NVARCHAR(120) -- 关键字 
//				, @MAX_COUNT BIGINT
				
			trans = HibSf.getSession().beginTransaction();
			response.addHeader("Access-Control-Allow-Origin" , "*");
			r.setData(
			ViewUtils.dbProcQuery(TblRuntimeData.class, "SP_GET_LOG"
					, groupId, sn, packageName, end, range, unit, keyword, maxCount));
			
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
