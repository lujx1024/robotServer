package org.sgpro.signalmaster;

import java.sql.CallableStatement;
import java.sql.Connection;

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
import org.sgpro.db.ViewUserGroupScene;
import org.sgpro.util.StringUtil;
/**
 */
@Path("/set_config")
public class SetConfig  extends HttpServlet  {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public SetConfig() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;

    @Context 
    private HttpServletResponse  response;
    
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public String setConfig(
  		   @FormParam("user_id") Long user_id
   		  ,@FormParam("owner_id") Long owner_id
   		  ,@FormParam("priority") Long priority
   		  ,@FormParam("config_key") String config_key
  		  ,@FormParam("config_value") String config_value
  		) throws Throwable {
    	
    	Result r = Result.success();
    	
    	try {
    		
    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		
    		Connection c = HibSf.getConnection();
    		
    		if (StringUtil.isNullOrEmpty(config_key)) {
    			throw new Exception("配置key不能为空");
    		}
    		
    		if (StringUtil.isNullOrEmpty(config_value)) {
    			throw new Exception("配置value不能为空");
    		}
    		
    		CallableStatement call =
    				
    				c.prepareCall("exec SP_SET_CUSTOMIZED_CONFIG ?, ?, ?, ?, ?");
    		
    		int argCount = 1;
    		
    		call.setObject(argCount++,  user_id);
    		call.setObject(argCount++,  owner_id);
    		call.setObject(argCount++,  priority);
    		call.setObject(argCount++,  config_key);
    		call.setObject(argCount++,  config_value);
       		
    		call.execute();
    		
    	} catch (Throwable th) {
    		r = Result.unknowException(th);
    		th.printStackTrace();
    	}
    	
    	return r.toString();
    }
    
	@Path("/scenes/{user_group_id}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String list(
			@PathParam("user_group_id") Long user_group_id
			) {
		Result r = Result.success();
		Transaction trans = null;
		try {

    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		
			trans = HibSf.getSession().beginTransaction();
			r.setData(ViewUtils.dbProcQuery(ViewUserGroupScene.class, "SP_GET_USER_GROUP_SCENES", user_group_id));
			trans.commit();
		} catch (Throwable t) {
			r = Result.unknowException(t);
			if (trans != null) {
				try {
					trans.rollback();
				} catch (Throwable t1) {
					r = Result.unknowException(t1);
					t1.printStackTrace();
				}
			}
		}
		
		return r.toString();
	}
    
	@Path("/saveScene/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String save(
			@FormParam("id") Long id,
			@FormParam("user_group_id") Long user_group_id,
			@FormParam("name") String name
			) {
		Result r = Result.success();
		Transaction trans = null;
		try {

    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		
			trans = HibSf.getSession().beginTransaction();
			r.setData(ViewUtils.dbProcQuery(ViewUserGroupScene.class, "SP_SAVE_USER_GROUP_SCENE", id, user_group_id, name));
			trans.commit();
		} catch (Throwable t) {
			r = Result.unknowException(t);
			if (trans != null) {
				try {
					trans.rollback();
				} catch (Throwable t1) {
					r = Result.unknowException(t1);
					t1.printStackTrace();
				}
			}
		}
		
		return r.toString();
	}
    
	@Path("/deleteScene/{id}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String deleteScene(
			@PathParam("id") Long id
			) {
		Result r = Result.success();
		Transaction trans = null;
		try {

    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		
			trans = HibSf.getSession().beginTransaction();
			r.setData(ViewUtils.dbProc("SP_DELETE_USER_GROUP_SCENE", id));
			trans.commit();
		} catch (Throwable t) {
			r = Result.unknowException(t);
			if (trans != null) {
				try {
					trans.rollback();
				} catch (Throwable t1) {
					r = Result.unknowException(t1);
					t1.printStackTrace();
				}
			}
		}
		
		return r.toString();
	}
	
	  
	@Path("/robotToScene/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String robotToScene(
			@FormParam("group_scene_id") Long group_scene_id,
			@FormParam("robot_id") Long robot_id
			) {
		Result r = Result.success();
		Transaction trans = null;
		try {

    		response.addHeader("Access-Control-Allow-Origin" , "*");
			trans = HibSf.getSession().beginTransaction();
			r.setData(ViewUtils.dbProc("SP_SET_ROBOT_TO_USER_GROUP_SCENE"
					,  group_scene_id, robot_id));
			trans.commit();
		} catch (Throwable t) {
			r = Result.unknowException(t);
			if (trans != null) {
				try {
					trans.rollback();
				} catch (Throwable t1) {
					r = Result.unknowException(t1);
					t1.printStackTrace();
				}
			}
		}
		
		return r.toString();
	}
}
