package org.sgpro.signalmaster;

import java.sql.CallableStatement;
import java.sql.Connection;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.sgpro.db.HibSf;
import org.sgpro.util.StringUtil;
/**
 */
@Path("/delete_config")
public class DeleteConfig  extends HttpServlet  {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteConfig() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;

    @Context 
    private HttpServletResponse  response;
    
    /**
     * 删除配置
     * @param user_id
     * @param robot_id
     * @param config_key
     * @return
     * @throws Throwable
     */
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public String setConfig(
 		   @FormParam("user_id") Long user_id
  		  ,@FormParam("owner_id") Long owner_id
  		  ,@FormParam("priority") Long priority
  		  ,@FormParam("config_key") String config_key
  		) throws Throwable {
    	
    	Result r = Result.success();
    	
    	try {
    		
    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		
    		Connection c = HibSf.getConnection();
    		
    		if (StringUtil.isNullOrEmpty(config_key)) {
    			throw new Exception("配置key不能为空");
    		}
    		
    		CallableStatement call =
    				
    				c.prepareCall("exec SP_DELETE_CUSTOMIZED_CONFIG_WITH_OWNER ?, ?, ?, ?");
    		
    		int argCount = 1;
    		
    		call.setObject(argCount++,  user_id);
    		call.setObject(argCount++,  owner_id);
    		call.setObject(argCount++,  priority);
    		call.setObject(argCount++,  config_key);
    		call.execute();
    		
    	} catch (Throwable th) {
    		r = Result.unknowException(th);
    		th.printStackTrace();
    	}
    	
    	return r.toString();
    }
}
