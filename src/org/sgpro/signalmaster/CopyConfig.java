package org.sgpro.signalmaster;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

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
import org.sgpro.db.TblCustomizedConfigForRobot;
import org.sgpro.db.ViewUserRobotBindList;
import org.sgpro.util.ExceptionUtil;
import org.sgpro.util.StringUtil;

import config.Log4jInit;

@Path("/copyconfig")
public class CopyConfig extends HttpServlet{
	static Logger logger = Logger.getLogger(CopyConfig.class.getName());
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Context 
    private HttpServletRequest request;
    @Context 
    private HttpServletResponse  response;

	@POST
    @Produces(MediaType.APPLICATION_JSON)
    public String copyConfig(
    		  @FormParam("robotId1") Long robotId1
    		  ,@FormParam("robotId2") Long robotId2
  		) throws Throwable {
		Result r = Result.success();
		
		String ret = null;
		try{
			Connection c = HibSf.getConnection();
			
			if (StringUtil.isNullOrEmpty(String.valueOf(robotId1))) {
    			throw new Exception("模板机器人不能为空");
    		}
    		
    		if (StringUtil.isNullOrEmpty(String.valueOf(robotId2))) {
    			throw new Exception("目标机器人不能为空");
    		}
    		
    		logger.info("模板机器人号："+robotId1+"目标机器人号："+robotId2);
    		
    		CallableStatement call =
    				c.prepareCall("exec [SP_COPY_CONFIG] ?, ?");
    		call.setLong(1, robotId1);
    		call.setLong(2, robotId2);
    		
    		call.execute();
    		
		}catch(Throwable th){
			r = Result.unknowException(th);
    		th.printStackTrace();
			
		}
		
		ret = r.toString();
		logger.info(ret);
		
    	return ret;
		
		
		
	}

}
