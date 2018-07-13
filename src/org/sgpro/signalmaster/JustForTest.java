package org.sgpro.signalmaster;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Types;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.apache.log4j.Logger;
import org.sgpro.db.HibSf;

import config.Log4jInit;

/**
 */
@Path("/test")
public class JustForTest  extends HttpServlet  {
	static Logger logger = Logger.getLogger(JustForTest.class.getName());
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public JustForTest() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;
    
    @GET
    @Produces(MediaType.APPLICATION_JSON )
    public String autoTalk() throws Throwable {
    	
    	Result r = Result.success();
    	
    	try {
    		Connection c = HibSf.getConnection();
    		
    		CallableStatement call =
    				
    				c.prepareCall("exec SP_DEMO ?");
    		
    		int argCount = 1;
    		call.registerOutParameter(argCount, Types.VARCHAR);
    		
    		// call.execute();
    		ResultSet rs = call.executeQuery();
    		
    		String strRs = "";
    		
    		while (rs.next()) {
    			strRs = rs.getString(argCount);
    			logger.info(strRs); 
    		}
    		
    		int intOut = call.getInt(argCount);
    		logger.info(intOut);
    		
    		r.setData(strRs + ":" + intOut);
    		
    	} catch (Throwable th) {
    		r = Result.unknowException(th);
    		th.printStackTrace();
    	}
    	
    	return r.toString();
    }
}
