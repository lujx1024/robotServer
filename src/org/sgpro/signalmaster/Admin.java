package org.sgpro.signalmaster;

import java.sql.SQLException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.apache.log4j.Logger;
import org.hibernate.Transaction;
import org.sgpro.db.HibSf;
import org.sgpro.db.ViewEndpointLatestStatusId;
import org.sgpro.db.ViewUserRobotBindList;
import org.sgpro.util.Digest;
import org.sgpro.util.ExceptionUtil;
import org.sgpro.util.StringUtil;

import config.Log4jInit;
/**
 */
@Path("/admin")
public class Admin  extends HttpServlet  {
	static Logger logger = Logger.getLogger(Admin.class.getName());
    
    public static final String ADMIN = "admin";
    public static final String ACCESS_KEY = "ACCESS_KEY";
    public static final String VERSION = "VERSION";
    
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
 
	/**
     * @see HttpServlet#HttpServlet()
     */
    public Admin() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;
    @Context 
    private HttpServletResponse  response;
    
    public class BindingListener implements HttpSessionBindingListener
    {
        public void valueBound(HttpSessionBindingEvent arg0) {
            //System.out.println("valueBound");
        }
        public void valueUnbound(HttpSessionBindingEvent arg0) {
        	  HttpSession s = arg0.getSession();
            logger.info(
            		String.format("seesion unbound: id=%s, [%s:%s], source=%s"
            				, s.getId(), arg0.getName(), arg0.getValue(), arg0.getSource()));
        	
        	ViewEndpointLatestStatusId item = DBFunctionUtils.getEndPointBySessionId(arg0.getSession().getId());
        	if (item != null && item.getOnline() && !item.getIsRobot()) {
        		logout();
        	}
        }
    }
    
    private BindingListener ls = new BindingListener();
    
    
    @Path("/login/")
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public String login(
  		   @FormParam("username") String username 
  		  ,@FormParam("password") String password 
  		  ,@HeaderParam("User-Agent") String useragent
  		  ,@FormParam("imei") String imei
  		  ,@FormParam("hijack") Boolean hijack
  		) throws Throwable {
    	String ret = null;
    	
    	Result r = Result.success();
    	HttpSession s = request.getSession();
    	s.setAttribute("listener", ls);
    	
    	String sessionId = s.getId();
		Transaction trans = null;
		response.addHeader("Access-Control-Allow-Origin" , "*");
		try {
			trans = HibSf.getSession().beginTransaction();
			
			logger.info("login sessionId=" + sessionId);
			
			Boolean  isAdmin = (Boolean)ViewUtils.dbFunc("dbo.FUNC_IS_ADMIN_ACCOUNT", username);
			
			
			logger.info("REQUEST ID:" + request.getSession().getId());
			logger.info(request);
			
			request.getSession().setAttribute(ADMIN, isAdmin);
			
			if (isAdmin) {
				logger.info("LOGIN:" + request.getSession().getAttribute(ADMIN));
				
				r.setData(
				ViewUtils.getViewDataList(		
				ViewUtils.dbProcQuery(ViewUserRobotBindList.class, "SP_ADMIN_LOGIN"
						, username, Digest.getMD5(password))));
			} else {
				// 用户，机器人登录
				
				Long loginCount = 0L;
				if (StringUtil.isNullOrEmpty(imei)) {
					r.setData(
					ViewUtils.getViewDataList(		
					ViewUtils.dbProcQuery(ViewUserRobotBindList.class, 
							" SP_USER_LOGIN"
							, useragent
							, username
							, password
							, Digest.getMD5(password)
							, sessionId
							, loginCount 
							, hijack
							)));
				} else {

					r.setData(
					ViewUtils.getViewDataList(		
					ViewUtils.dbProcQuery(ViewUserRobotBindList.class, 
							" SP_ROBOT_LOGIN"
							, useragent
							, username
							, password
							, Digest.getMD5(password)
							, imei
							, sessionId
							, loginCount 
							)));
				
				}
			}
    		
    		trans.commit();
		} catch (Throwable t) {
			SQLException sqlex = ExceptionUtil.getRoot(t, SQLException.class);
			if (sqlex != null) {

				if (trans != null) {
					try {
						trans.rollback();
						r = new Result(sqlex.getSQLState(), sqlex.getMessage());
					} catch (Throwable t1) {
						t1.printStackTrace();
						r = Result.unknowException(t1);
					}
				}
			} else {
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
		}
    	
		ret = r.toString();
		logger.info(ret);
		
    	return ret;
    }
    
    @Path("/logout/")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String logout(
  		)     {
    	
    	Result r = Result.success();
    	
		Transaction trans = null;
		// response.addHeader("Access-Control-Allow-Origin" , "*");
		try {
			trans = HibSf.getSession().beginTransaction();
			String id = request.getSession().getId();
			ViewUtils.dbProc("SP_LOGOUT", id);
			logger.info("logout:" + id);
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
