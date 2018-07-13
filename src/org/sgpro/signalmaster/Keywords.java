package org.sgpro.signalmaster;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.websocket.server.PathParam;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.hibernate.Transaction;
import org.sgpro.db.EntKeyWords;
import org.sgpro.db.HibSf;

@Deprecated
@Path("/keyword")
public class Keywords  extends HttpServlet  {
	  
	    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@Path("/save/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String save(
			@FormParam("id") Long id,
			@FormParam("keyword") String kw,
			@FormParam("cat") String cat
			) {
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			r.setData(ViewUtils.dbProcQuery(EntKeyWords.class, "SP_SAVE_KEY_WORD", id, kw, cat));
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
				} catch (Throwable t1) {
					t1.printStackTrace();
				}
			}
		}
		
		return r.toString();
	}

   @Context 
    private HttpServletRequest request;
    @Context 
    private HttpServletResponse  response;
 
  	
    @Path("/query/{xxx}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
	public String query(
			@PathParam("xxx") String keyword
			) throws Throwable {
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			r.setData(ViewUtils.dbProcQuery(EntKeyWords.class, "SP_GET_KEY_WORD", keyword));
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
