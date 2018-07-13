package org.sgpro.signalmaster;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.hibernate.Transaction;
import org.sgpro.db.HibSf;
import org.sgpro.db.ViewRobotAppBindList;
import org.sgpro.db.ViewRobotAppVersion;
/**
 */
@Path("/app")
public class App  extends HttpServlet  {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public App() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	@Context 
	private HttpServletRequest request;
	@Context 
	private HttpServletResponse  response;
	
	@Path("/list/{imei}/{keyword}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String list(
			@PathParam("imei") String imei ,
			@PathParam("keyword") String keyword
			) throws Throwable {
		Result r = Result.success();
		Transaction trans = null;
		try {
			
			trans = HibSf.getSession().beginTransaction();
			response.addHeader("Access-Control-Allow-Origin" , "*");
			
			DBFunctionUtils.validateLoginSession(request);

			r.setData(
					ViewUtils.getViewDataList(
							ViewUtils.dbProcQuery(ViewRobotAppBindList.class, "SP_GET_ROBOT_APP_LASTEST_VERSION"
									, imei, keyword, false)));
			
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
	
	
	@Path("/save")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	/**
	 * 	 @ID AS BIGINT
	,@PAKCAGE_NAME AS NVARCHAR(100)
	,@APP_NAME AS NVARCHAR(50)
	,@GROUP_ID AS BIGINT
	,@ENABLE AS BIT
	,@DESCRIPTION AS NVARCHAR(500)

	 * @param imei
	 * @param keyword
	 * @return
	 * @throws Throwable
	 */
	public String save(
			@FormParam("id") Long id,
			@FormParam("packageName") String packageName,
			@FormParam("appName") String appName,
			@FormParam("groupId") Long groupId,
			@FormParam("enable") Boolean enable,
			@FormParam("description") String description
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		try {
			
			trans = HibSf.getSession().beginTransaction();
			response.addHeader("Access-Control-Allow-Origin" , "*");
			DBFunctionUtils.validateLoginSession(request);

			ViewUtils.dbProc("SP_SAVE_APP", id, packageName, appName, groupId, enable, description);
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
	
	
	
	@Path("/version/save")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	/**
	
		@ROBOT_APP_ID bigint
	   ,@VERSION_CODE bigint
	   ,@VERSION_NAME nvarchar(500)
	   ,@DOWNLOAD_URL nvarchar(500)
	   ,@RELEASE_NOTE nvarchar(500)
	   ,@ENABLED bit
	 * @param imei
	 * @param keyword
	 * @return
	 * @throws Throwable
	 */
	public String saveVersion(
			@FormParam("appId") Long appId,
			@FormParam("versionCode") Long versionCode,
			@FormParam("versionName") String versionName,
			@FormParam("downloadUrl") String downloadUrl,
			@FormParam("releaseNote") String releaseNote,
			@FormParam("enable") Boolean enable
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		try {
			
			trans = HibSf.getSession().beginTransaction();
			response.addHeader("Access-Control-Allow-Origin" , "*");
			DBFunctionUtils.validateLoginSession(request);

			ViewUtils.dbProc("SP_SAVE_APP_VERSION", appId, versionCode, versionName, downloadUrl, releaseNote, enable);
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
	
	@Path("/version/list/{appId}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String list(
			@PathParam("appId") Long appId
			) throws Throwable {
		return list(appId, null, null, null);
	}    
    
	
	@Path("/version/list/{appId}/{keyword}/{from}/{to}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String list(
			@PathParam("appId") Long appId,
			@PathParam("keyword") String keyword,
			@PathParam("from") String from,
			@PathParam("to") String to
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		try {
			
			trans = HibSf.getSession().beginTransaction();
			response.addHeader("Access-Control-Allow-Origin" , "*");
			DBFunctionUtils.validateLoginSession(request);

			r.setData(ViewUtils.getViewDataList(
					ViewUtils.dbProcQuery(ViewRobotAppVersion.class
							, "SP_GET_ROBOT_APP_VERSION_HISTORY"
							, appId
							, keyword
							, from
							, to)));
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
    
	@Path("/version/delete/{appId}/{versionCode}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String delete(
			@PathParam("appId") Long appId,
			@PathParam("versionCode") Long versionCode
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		try {
			
			trans = HibSf.getSession().beginTransaction();
			response.addHeader("Access-Control-Allow-Origin" , "*");
			DBFunctionUtils.validateLoginSession(request);

			ViewUtils.dbProc("SP_DELETE_APP_VERSION", appId, versionCode);
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
