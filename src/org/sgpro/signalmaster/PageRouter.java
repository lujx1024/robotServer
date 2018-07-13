package org.sgpro.signalmaster;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.sgpro.util.StringUtil;

/**
 */
@Path("/page_router")
public class PageRouter  extends HttpServlet  {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public PageRouter() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;
    
    @Context 
    private HttpServletResponse response;
    
    @GET
    @Path("/{redirect}")
    @Produces(MediaType.TEXT_HTML)
    public String pageRouter(
    		@PathParam("redirect") String redirect
    		) throws Throwable {
    	if (StringUtil.isNotNullAndEmpy(redirect )) {
    		// response.sendRedirect(redirect);
    		return "<script > document.location = 'http://" + redirect + "'</script>";
    	} else {
    		return "null";
    	}
    }
}
