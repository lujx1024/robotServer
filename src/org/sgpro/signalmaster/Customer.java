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
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.hibernate.Transaction;
import org.sgpro.db.EntCustomer;
import org.sgpro.db.HibSf;
import org.sgpro.db.ViewNvp;



@Path("/customer")
public class Customer extends HttpServlet  {
    
    /**
	 * 
	 */
	
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public Customer() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;
    @Context 
    private HttpServletResponse  response;
    
    
    /**
     * 获取顾客注册的人脸相关信息
     * @param customerId, customerGroupId
     * @return
     * @throws Throwable
     */
    @Path("/customerInfo/{customerId}/{customerGroupId}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String customerEnrollInfo(
    		@PathParam("customerId") String customerId 
    	  , @PathParam("customerGroupId") String customerGroupId 
  		) throws Throwable {
    	
    	Result r = Result.success();
    	Transaction trans = null;
    	try {
       		
    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		trans = HibSf.getSession().beginTransaction();
    		
    		r.setData(
    		
    		ViewUtils.dbProcQuery(EntCustomer.class
    				, "[SP_GET_CUSROMER_ENROLL_INFO]", customerId, customerGroupId));
    		
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
     * 保存顾客注册的人脸相关信息
     * @param customerId, customerGroupId
     * @return
     * @throws Throwable
     */
    @Path("/saveCustomer/")
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public String enrollCustomer(
  		    @FormParam("customerId") String customerId 
 		  , @FormParam("name") String name
		  , @FormParam("nick_name") String nick_name
		  , @FormParam("english_name") String english_name
		  , @FormParam("sex") String sex
		  , @FormParam("customerGroupId") String customerGroupId 
  		) throws Throwable {
    	
    	Result r = Result.success();
    	Transaction trans = null;
    	try {
       		
    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		trans = HibSf.getSession().beginTransaction();
    		
    		r.setData(
    				ViewUtils.dbProcQuery(EntCustomer.class
    						, "[SP_SAVE_CUSROMER_ENROLL_INFO]", customerId, name, nick_name, english_name, sex, customerGroupId));
    		
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
     * 删除顾客注册的人脸相关信息
     * @param customerId, customerGroupId
     * @return
     * @throws Throwable
     */
    @Path("/deleteCustomer/")
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public String deleteEnrollCustomer(
  		    @FormParam("customerId") String customerId 
		  , @FormParam("customerGroupId") String customerGroupId 
  		) throws Throwable {
    	
    	
    	Result r = Result.success();
    	
    	try {
    		Connection c = HibSf.getConnection();
    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		CallableStatement call =
    				c.prepareCall("exec [SP_DELETE_CUSROMER_ENROLL_INFO] ?, ?");
    		
    		int argCount = 1;
    		call.setString(argCount++, customerId);
    		call.setString(argCount++, customerGroupId);

    		call.execute();
    	
    	} catch (Throwable th) {
    		r = Result.unknowException(th);
    		th.printStackTrace();
    	}
    	
    	return r.toString();
    }

    
    
    /**
     * 保存顾客注册的人脸相关信息
     * @param customerId, customerGroupId
     * @return
     * @throws Throwable
     */
    @Path("/listCustomers/{customerGroupId}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String listEnrollCustomerByGroupId(
    		@PathParam("customerGroupId") String customerGroupId 
  		) throws Throwable {
    	
    	Result r = Result.success();
    	Transaction trans = null;
    	try {
       		
    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		trans = HibSf.getSession().beginTransaction();
    		
    		r.setData(
    				ViewUtils.dbProcQuery(EntCustomer.class
    						, "[SP_GET_CUSROMER_ENROLL_LIST_BY_CUSTOMER_GROUP_ID]", customerGroupId));
    		
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