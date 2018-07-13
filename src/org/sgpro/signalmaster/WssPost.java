package org.sgpro.signalmaster;

import javax.servlet.http.HttpServlet;
import javax.ws.rs.DELETE;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.apache.log4j.Logger;

import config.Log4jInit;

/**
 * Servlet implementation class CatchPkg
 */
@Path("/wss_post")
public class WssPost extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static Logger logger = Logger.getLogger(WssPost.class.getName());   
    /**
     * @see HttpServlet#HttpServlet()
     */
    public WssPost() {
        super();
        // TODO Auto-generated constructor stub
    }

    @Path("/{room}/{client}")
    @DELETE
    @Produces(MediaType.TEXT_PLAIN)    
    public String delete(@PathParam("room") String room,
    		@PathParam("client") String client) {
    	// return  client + " leave " + room + "!";
    	Roomes.getGlobalRoomes().leaveRoom(room, client);
    	String rsp = HttpResult.aSuccess(null).toString();
    	
    	logger.info("wss_post." + client + " leave " + room + "!");
    	return rsp;
    }
     

}
