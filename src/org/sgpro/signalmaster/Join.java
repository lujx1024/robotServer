package org.sgpro.signalmaster;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.apache.log4j.Logger;
import org.sgpro.signalmaster.Roomes.Client;
import org.sgpro.signalmaster.Roomes.Room;
import org.sgpro.util.RequestUtil;


/**
 * Servlet implementation class CatchPkg
 */
@Path("/join")
public class Join  {

	private static final long serialVersionUID = 1L;
	static Logger logger = Logger.getLogger(Join.class.getName());   
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Join() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;
    
    

    static PcConfigIceServers servers = new PcConfigIceServers();
    static {
    	/**
    	 * var iceServer = {
    "iceServers": [{
        "url": "stun:stun.l.google.com:19302"
    }]
};
    	 */
    	// servers.add(new PcConfigIceServer("turn:yinshengge@120.26.60.161:3478", "yinshengge"));
    	servers.add(new PcConfigIceServer("stun:stun.l.google.com:19302", null));
    }
    
    
    /*
     
     * 
     * */
    @Path("/{room}")
    @POST
    @Produces(MediaType.TEXT_PLAIN)
    public String join(@PathParam("room") String room ) throws Throwable {
		
    	String path = request.getContextPath();

    	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    	
    	RoomParameter hr = new RoomParameter();
    	Roomes rooms = Roomes.getGlobalRoomes();
    	Room thisRoom = rooms.getRoom(room);
    	
    	String clientId = null;
    	if (thisRoom == null) {
    		hr.setIs_initiator(true);
    		clientId = rooms.joinRoom(room).getId();
    		thisRoom = rooms.getRoom(room);
    	} else {
    		hr.setIs_initiator(false);
    		clientId = rooms.joinRoom(thisRoom).getId();
    	}
    	
    	hr.setClient_id(clientId);
    	hr.setRoom_id(room);
    	hr.setRoom_link(basePath + "r/" + room);
    	hr.getMedia_constraints().put("audio", true);
    	hr.getMedia_constraints().put("video", true);
        // hr.setTurn_url(String.format("%susername=%s&key=%s"
        //		 , "https://computeengineondemand.appspot.com/turn?", clientId, clientId));

    	//https://computeengineondemand.appspot.com/turn?username=16562789&key=4080218913
    	// http://salestracktomcat6-ppcireic3b.elasticbeanstalk.com/turns_on_aws?uid=sgpro&key=sgpro
    	
    	// hr.setPc_config(servers);
    	 hr.setTurn_url(
    			String.format("http://salestracktomcat6-ppcireic3b.elasticbeanstalk.com/turns_on_aws?uid=%s&key=%s"
    					, "sgpro", "sgpro"));
    	
    	hr.setWss_url(
    			String.format("wss://%s:%d%s/ws"
    					, request.getServerName()
    					, request.getServerPort()
    					, path));
    	
    	hr.getPc_constraints().put("optional", new String[0]);
    	//hr.getPc_config().put("iceServers", new String[0]);
    	hr.setPc_config(servers);
    	hr.setWss_post_url(basePath + "rest/wss_post");
    	hr.getOffer_constraints().put("optional", new String[0]);
    	hr.getOffer_constraints().put("mandatory", new String[0]);
    	
    	if (!hr.isIs_initiator()) {
    		// sdp offer, ice
    		Client offerProvider = thisRoom.getClients().peek();
    		
    		List<String> msgList = hr.getMessages();
    		
    		msgList.addAll(offerProvider.getMessageOriginal());
    	}

    	// hr.setWss_url("wss://192.168.30.170:443/ws");
    	
    	String rsp = HttpResult.aSuccess(hr).toString();
    	logger.info(this.getClass().getSimpleName()+ ".join:" + rsp);
    	return rsp;
    }
    
 
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		ServletInputStream is = request.getInputStream();
		String data = RequestUtil.dumpDataToString(is);
		
		String output = String.format("response:[%s]", data);
		response.getWriter().print(output);
		logger.info(output);
		
	}
}
