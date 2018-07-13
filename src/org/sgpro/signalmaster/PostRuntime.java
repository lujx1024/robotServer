package org.sgpro.signalmaster;

import javax.servlet.http.HttpServlet;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.sgpro.db.HibSf;

/**
 * Servlet implementation class Welcome
 */
@Path("/post_runtime")
public class PostRuntime   {
	@SuppressWarnings("unused")
	private static final long serialVersionUID = 1L;
    
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PostRuntime() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    //@Context 
    // private HttpServletRequest request;

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public String postData(
    		@FormParam("robotImei") String model
     		  ,@FormParam("app") String app
    		  ,@FormParam("type") String type
    		  ,@FormParam("message") String message
    		  ,@FormParam("details") String details
    		) throws Throwable {
    	
    	Result r = Result.success();
    	Transaction t = null;
    	try {
    		Session s = HibSf.getSession();
    		t = s.beginTransaction();
    		s.clear();
//    		System.out.println(
//    				String.format("Report runtime : robot='%s' app='%s' type='%s' message='%s' details='%s' ", 
//    						model, app,type, message, details));
    		
    		Query query = s.createSQLQuery
    				("exec [dbo].[SP_REPORT_RUNTIME] ?, ?, ?, ? , ?");
    		int argCount = 0;
    		query.setString(argCount++, model);
    		query.setString(argCount++, app);
    		query.setString(argCount++, type);
    		query.setString(argCount++, message);
			query.setString(argCount++, details);
    		
    		query.executeUpdate();			    	
    		
    		t.commit();
    	} catch (Throwable th) {
    		r = Result.unknowException(th);
    		if (t != null) {
    			t.rollback();
    		}
    	}
    	
    	return r.toString();
    }
}
