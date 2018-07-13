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
import org.sgpro.db.HibSf;

/**
 */
@Path("/push")
public class Push extends HttpServlet {

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
	public Push() {
		super();
		// TODO Auto-generated constructor stub
	}

	@Context
	private HttpServletRequest request;
	@Context
	private HttpServletResponse response;

	@Path("/content/{id}/{text}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String push(
			@PathParam("id") String id
			,@PathParam("text") String text
			) {

		Result r = Result.success();
		Transaction trans = null;

		try { 
			trans = HibSf.getSession().beginTransaction();
			RTCWssStreamInBound.httpPush(id, text, null, null, null, null, null, null);
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
	
	@Path("/content/{id}/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String push(
			@PathParam("id") String id
			,@FormParam("text") String text
			,@FormParam("path") String path
			,@FormParam("emotion") String emotion
			,@FormParam("command") Long command
			,@FormParam("commandParam") String commandParam
			,@FormParam("_3rd") Long _3rd
			,@FormParam("_3rdParam") String _3rdParam
			) {

		Result r = Result.success();
		Transaction trans = null;

		try { 
			trans = HibSf.getSession().beginTransaction();
			RTCWssStreamInBound.httpPush(id, text, path, emotion, command, commandParam, _3rd, _3rdParam);
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
