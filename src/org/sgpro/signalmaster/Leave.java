package org.sgpro.signalmaster;

import javax.servlet.http.HttpServlet;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.apache.log4j.Logger;

import config.Log4jInit;

/**
 * Servlet implementation class CatchPkg
 */
@Path("/leave")
public class Leave extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static Logger logger = Logger.getLogger(Leave.class.getName());   
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Leave() {
        super();
        // TODO Auto-generated constructor stub
    }

    @Path("/{room}/{client}")
    @POST
    @Produces(MediaType.TEXT_PLAIN)    
    public String doLevea(@PathParam("room") String room,
    		@PathParam("client") String client) {
    	// return  client + " leave " + room + "!";
    	Roomes.getGlobalRoomes().leaveRoom(room, client);
    	String rsp = HttpResult.aSuccess(null).toString();
    	
    	logger.info("rest leave." + client + " leave " + room + "!");
    	return rsp;
    }
     

}
