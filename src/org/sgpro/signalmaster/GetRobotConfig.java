package org.sgpro.signalmaster;

import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.hibernate.Transaction;
import org.sgpro.db.HibSf;
import org.sgpro.db.ViewConfig;
import org.sgpro.db.ViewConfigModuleBitMask;
import org.sgpro.db.ViewNvp;
import org.sgpro.db.ViewNvpId;
import org.sgpro.db.ViewRobotConfigForEditor;
/**
 */
@Path("/config")
public class GetRobotConfig  extends HttpServlet  {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public GetRobotConfig() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;
    @Context 
    private HttpServletResponse  response;
 
    /**
     * 只获取客户端APP的配置
     * @param imei
     * @return
     * @throws Throwable
     */
    @Path("/{imei}/")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String robotAppConfigs(
  		  @PathParam("imei") String imei 
  		  ,@HeaderParam("extra") String  extra 
  		) throws Throwable {
    	
    	Result r = Result.success();
    	Transaction trans = null;
    	try {
       		
    		// response.addHeader("Access-Control-Allow-Origin" , "*");
    		trans = HibSf.getSession().beginTransaction();
    		
    		r.setData(
    		ViewUtils.getViewDataList(
    		ViewUtils.dbProcQuery(ViewNvp.class
    				, "[SP_GET_ROBOT_CONFIG_FOR_APP]", imei)));
    		
    		if (extra != null) {
    			String[] params = extra.split(",");
    				
    			List<ViewNvpId> l = (List<ViewNvpId>) r.getData();
    			for (ViewNvpId item : l) {
    				for (int i = 0; i < params.length; i++) {
    					String param = params[i];
    					item.setValue(item.getValue().replaceAll("@p" + i, param));
    				}
    			}
    		}
    		
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

    /**
     * 编辑常用配置
     * @param imei
     * @return
     * @throws Throwable
     */
    @Path("/main/{owner_id}/{priority}/{keyword}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String robotMainEditor(
  		   @PathParam("owner_id") Long owner_id
  		  ,@PathParam("priority") Long priority
  		  ,@PathParam("keyword") String keyword 
  		) throws Throwable {
    	
    	return configEditor(1, owner_id, priority, keyword);
    }
    

    /**
     * 编辑全部配置
     * @param imei
     * @return
     * @throws Throwable
     */
    @Path("/all/{owner_id}/{priority}/{keyword}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String robotAllConfigEditor(
  		   @PathParam("owner_id") Long owner_id
  		  ,@PathParam("priority") Long priority
  		  ,@PathParam("keyword") String keyword 
  		) throws Throwable {
    	
    	return configEditor(1 | 2 | 4 | 8 | 16, owner_id, priority, keyword);
    }

    /**
     * 编辑高级配置
     * @param imei
     * @return
     * @throws Throwable
     */
    @Path("/advance/{owner_id}/{priority}/{keyword}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String robotAdvanceConfigEditor(
  		   @PathParam("owner_id") Long owner_id
  		  ,@PathParam("priority") Long priority
  		  ,@PathParam("keyword") String keyword 
  		) throws Throwable {
    	
    	return configEditor(4, owner_id, priority, keyword);
    }

    /**
     * 编辑行业配置
     * @param imei
     * @return
     * @throws Throwable
     */
    @Path("/industry/{owner_id}/{priority}/{keyword}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String robotUserConfigEditor(
  		   @PathParam("owner_id") Long owner_id
  		  ,@PathParam("priority") Long priority
  		  ,@PathParam("keyword") String keyword 
  		) throws Throwable {
    	
    	return configEditor(16, owner_id, priority, keyword);
    }

    
	private String configEditor(int bitmask, Long owner_id, Long priority,
			String keyword) {
		// TODO Auto-generated method stub
    	
    	Result r = Result.success();
    	Transaction trans = null;
    	try {
       		
    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		trans = HibSf.getSession().beginTransaction();
    		
    		
    		DBFunctionUtils.validateLoginSession(request);
    		
    		r.setData(
    		ViewUtils.getViewDataList(
    		ViewUtils.dbProcQuery(ViewRobotConfigForEditor.class
    				, "[SP_GET_ROBOT_CONFIG_FOR_EDITOR]", owner_id, priority, keyword, bitmask)));
    		
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
 
	/**
	 * 配置类别
	 * @return
	 */
    @Path("/kinds/")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
	public String configKinds() {
		// TODO Auto-generated method stub
    	
    	Result r = Result.success();
    	Transaction trans = null;
    	try {
       		
    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		trans = HibSf.getSession().beginTransaction();
    		
    		
    		r.setData(
    				ViewUtils.getViewDataList(
    						HibSf.getSession()
    						.createSQLQuery("SELECT * FROM VIEW_CONFIG_MODULE_BIT_MASK").addEntity(ViewConfigModuleBitMask.class).list()
    						));
    		
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
 
    
	/**
	 * 配置项定义
	 * @return
	 */
    @Path("/define/{keyword}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
	public String define(
			@PathParam("keyword")
			String keyword
			) {
		// TODO Auto-generated method stub
    	
    	Result r = Result.success();
    	Transaction trans = null;
    	try {
       		
    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		trans = HibSf.getSession().beginTransaction();
    		
    		
    		r.setData(
    				ViewUtils.getViewDataList(ViewUtils.dbProcQuery(ViewConfig.class, "SP_GET_CONFIG_DEFINED"
    						,keyword )));
    		
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
    
	/**
	 * 配置项设置
	 * @return
	 */
    @Path("/define/save")
    @POST
    @Produces(MediaType.APPLICATION_JSON)
	public String saveDefine(
			  @FormParam("name") String name,
			  @FormParam("ownerId") long ownerId,
			  @FormParam("ownerName") String ownerName,
			  @FormParam("ownerType") long ownerType,
			  @FormParam("ownerTypeName") String ownerTypeName,
			  @FormParam("type") String type,
			  @FormParam("value") String value,
			  @FormParam("level") long level,
			  @FormParam("limitL") String limitL,
			  @FormParam("limitH") String limitH,
			  @FormParam("candidate") String candidate,
			  @FormParam("pattern") String pattern,
			  @FormParam("description") String description	
			) {
		// TODO Auto-generated method stub
    	
    	Result r = Result.success();
    	Transaction trans = null;
    	try {
       		
    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		trans = HibSf.getSession().beginTransaction();
    		
    		ViewUtils.dbProc("SP_SAVE_CONFIG_DEFINE",
    				name,
    				ownerId,
    				ownerType,
    				type,
    				value,
    				level,
    				limitL,
    				limitH,
    				candidate,
    				pattern,
    				description
    				);
    		
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
    
	/**
	 * 获取行业
	 * @return
	 */
    @Path("/industries/{keyword}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
	public String industries(
			@PathParam("keyword")
			String keyword
			) {
		// TODO Auto-generated method stub
    	
    	Result r = Result.success();
    	Transaction trans = null;
    	try {
       		
    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		trans = HibSf.getSession().beginTransaction();
    		
    		r.setData(
    				ViewUtils.getViewDataList(ViewUtils.dbProcQuery(ViewNvp.class, "SP_GET_INDUSTRIES"
    						,keyword )));
    		
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
    
	/**
	 * 获取企业
	 * @return
	 */
    @Path("/userGroups/{industry_id}/{keyword}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
	public String userGroups(
			@PathParam("industry_id")
			Long industry_id,
			@PathParam("keyword")
			String keyword
			) {
		// TODO Auto-generated method stub
    	
    	Result r = Result.success();
    	Transaction trans = null;
    	try {
       		
    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		trans = HibSf.getSession().beginTransaction();
    		
    		r.setData(
    				ViewUtils.getViewDataList(ViewUtils.dbProcQuery(ViewNvp.class, "SP_GET_USER_GROUPS"
    						, industry_id,keyword )));
    		
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
    
	/**
	 * 获取场景
	 * @return
	 */
    @Path("/userGroupsScenes/{user_group_id}/{keyword}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
	public String userGroupsScenes(
			@PathParam("user_group_id")
			Long user_group_id,
			@PathParam("keyword")
			String keyword
			) {
		// TODO Auto-generated method stub
    	
    	Result r = Result.success();
    	Transaction trans = null;
    	try {
       		
    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		trans = HibSf.getSession().beginTransaction();
    		
    		r.setData(
    				ViewUtils.getViewDataList(ViewUtils.dbProcQuery(ViewNvp.class, "SP_GET_USER_GROUP_SCENES_NVP"
    						, user_group_id,keyword )));
    		
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
    
	/**
	 * 获取机器
	 * @return
	 */
    @Path("/robots/{industry_id}/{user_group_id}/{user_group_scene_id}/{keyword}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
	public String robots(
			@PathParam("industry_id")
			Long industry_id,
			@PathParam("user_group_id")
			Long user_group_id,
			@PathParam("user_group_scene_id")
			Long user_group_scene_id,
			@PathParam("keyword")
			String keyword
			) {
		// TODO Auto-generated method stub
    	
    	Result r = Result.success();
    	Transaction trans = null;
    	try {
       		
    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		trans = HibSf.getSession().beginTransaction();
    		
    		r.setData(
    				ViewUtils.getViewDataList(ViewUtils.dbProcQuery(ViewNvp.class, "SP_GET_ROBOTS_NVP_V2"
    						, industry_id, user_group_id, user_group_scene_id, keyword )));
    		
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
    
	/**
	 * 获取机器
	 * @return
	 */
    @Path("/robots_sn/{industry_id}/{user_group_id}/{user_group_scene_id}/{keyword}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
	public String robotssn(
			@PathParam("industry_id")
			Long industry_id,
			@PathParam("user_group_id")
			Long user_group_id,
			@PathParam("user_group_scene_id")
			Long user_group_scene_id,
			@PathParam("keyword")
			String keyword
			) {
		// TODO Auto-generated method stub
    	
    	Result r = Result.success();
    	Transaction trans = null;
    	try {
       		
    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		trans = HibSf.getSession().beginTransaction();
    		
    		r.setData(
    				ViewUtils.getViewDataList(ViewUtils.dbProcQuery(ViewNvp.class, "SP_GET_ROBOTS_SN_NVP"
    						, industry_id, user_group_id, user_group_scene_id, keyword )));
    		
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
