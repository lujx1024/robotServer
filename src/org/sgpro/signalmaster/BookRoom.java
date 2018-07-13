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
import org.sgpro.db.EntRoom;
import org.sgpro.db.HibSf;
import org.sgpro.db.TblOrderRoom;
import org.sgpro.db.ViewOrderRoom;
/**
 */
@Path("/custom_room_order")
public class BookRoom  extends HttpServlet  {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public BookRoom() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	@Context 
	private HttpServletRequest request;
	@Context 
	private HttpServletResponse  response;
	
	/**
	 * 可用房间
	 * @return
	 * @throws Throwable
	 */
	@Path("/room/list/{orderDate}/{night}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String roomList(
			@PathParam("orderDate") String orderDate
			,@PathParam("night") Boolean night
			) throws Throwable {
		Result r = Result.success();
		Transaction trans = null;
		try {
			
			trans = HibSf.getSession().beginTransaction();
			response.addHeader("Access-Control-Allow-Origin" , "*");
			r.setData(ViewUtils.dbProcQuery(EntRoom.class, "SP_CUSTOM_GET_AVALIABLE_ROOM_LIST"
									, orderDate, night));
			
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
	 * 	 @ROOM_ID BIGINT
	,@ORDER_DATE NVARCHAR(50)
	,@NIGHT BIT
	,@ORDER_NAME NVARCHAR(50)
	,@MOBILE_PHONE NVARCHAR(50)
 
	 * @return
	 * @throws Throwable
	 */
	@Path("/room/order")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String roomOrder(
			@FormParam("roomId") Long roomId,
			@FormParam("orderDate") String orderDate,
			@FormParam("orderName") String orderName,
			@FormParam("mobilePhone") Long mobilePhone,
			@FormParam("night") Boolean night
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		try {
			
			trans = HibSf.getSession().beginTransaction();
			response.addHeader("Access-Control-Allow-Origin" , "*");
			r.setData(
			ViewUtils.dbProcQuery(TblOrderRoom.class, "SP_CUSTOM_ORDER_ROOM", roomId, orderDate, night, orderName, mobilePhone));
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
	 * 	 @ROOM_ID BIGINT
	,@ORDER_DATE NVARCHAR(50)
	,@NIGHT BIT
	,@ORDER_NAME NVARCHAR(50)
	,@MOBILE_PHONE NVARCHAR(50)
 
	 * @return
	 * @throws Throwable
	 */
	@Path("/room/delete")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String deleteOrder(
			@FormParam("roomId") Long roomId,
			@FormParam("orderDate") String orderDate,
			@FormParam("night") Boolean night
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		try {
			
			trans = HibSf.getSession().beginTransaction();
			response.addHeader("Access-Control-Allow-Origin" , "*");
			ViewUtils.dbProc("SP_CUSTOM_DELETE_ORDER", roomId, orderDate, night);
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
 
 
	@Path("/order/list/")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String list(
			) throws Throwable {
		return orderList(null);
	}    
    
	@Path("/order/list/{keyword}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String orderList(
			@PathParam("keyword") String keyword
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		try {
			
			trans = HibSf.getSession().beginTransaction();
			response.addHeader("Access-Control-Allow-Origin" , "*");
			r.setData(ViewUtils.getViewDataList(
					ViewUtils.dbProcQuery(ViewOrderRoom.class
							, "SP_CUSTOM_GET_ORDER_LIST"
							, keyword)));
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
