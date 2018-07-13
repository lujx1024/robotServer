package org.sgpro.signalmaster;

import java.io.StringReader;

import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.apache.log4j.Logger;
import org.codehaus.jettison.json.JSONObject;
import org.sgpro.signalmaster.Roomes.Client;
import org.sgpro.signalmaster.Roomes.Room;
import org.sgpro.util.RequestUtil;

import com.google.gson.stream.JsonReader;

import config.Log4jInit;

/**
 * Servlet implementation class CatchPkg
 */
@Path("/message")
public class Message extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static Logger logger = Logger.getLogger(Log4jInit.class.getName());   
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Message() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;


    abstract class GAEMessage {
    	private String type;

		public String getType() {
			return type;
		}

		public void setType(String type) {
			this.type = type;
		}

		public GAEMessage(String type) {
			super();
			this.type = type;
		}
    }
    public class GAECandidate extends GAEMessage {

		public GAECandidate(String type) {
			super(type);
			// TODO Auto-generated constructor stub
		}
    	
		String id;
		String candidate;
		int label;
		public String getId() {
			return id;
		}
		public void setId(String id) {
			this.id = id;
		}
		public String getCandidate() {
			return candidate;
		}
		public void setCandidate(String candidate) {
			this.candidate = candidate;
		}
		public int getLabel() {
			return label;
		}
		public void setLabel(int label) {
			this.label = label;
		}
		public GAECandidate(String type, String id, String candidate, int label) {
			super(type);
			this.id = id;
			this.candidate = candidate;
			this.label = label;
		}
		
		
    }
    
    class GAESdp extends GAEMessage {
    	String sdp;

		public String getSdp() {
			return sdp;
		}

		public void setSdp(String sdp) {
			this.sdp = sdp;
		}

		public GAESdp(String type, String sdp) {
			super(type);
			this.sdp = sdp;
		}
    	
    }
    
    
    @Path("/{room}/{client}")
    @POST
    @Produces(MediaType.TEXT_PLAIN)    
    public String doMessage(@PathParam("room") String room,
    		@PathParam("client") String client) throws Throwable {
    	
		ServletInputStream is = request.getInputStream();
		String data = RequestUtil.dumpDataToString(is);

		logger.info(this.getClass().getSimpleName()+ ".doMessage:" + data);
		
		JSONObject jo = new JSONObject(data);
		
		String type = jo.optString("type");
		boolean isSdp = jo.has("sdp");
		
		JsonReader jr = new JsonReader(new StringReader(data));
		jr.setLenient(true);
		
		
		Room r = Roomes.getGlobalRoomes().getRoom(room);
		
	 
		Client c = r == null? null : r.getClient(client);
		
		String ret = HttpResult.aError(null).toString();
		
		if (r != null) {
			if ("candidate".equals(type)) {
				GAECandidate cand = GsonProvider.getGson().fromJson(jr, GAECandidate.class);
				logger.info("received candiate " + cand.getCandidate());
				
				if (c != null) {
					c.addIce(cand);
				}
			} else if (isSdp) {
				GAESdp sdp = GsonProvider.getGson().fromJson(jr, GAESdp.class);
				logger.info("received sdp " + sdp.getType());
				c.setSdp(sdp.getType(), sdp.getSdp());
			}
			
			c.addMessageOriginal(data);
			
			ret = HttpResult.aSuccess(null).toString();
		} else {
			
		}
		
		// logger.info(this.getClass().getSimpleName()+ ".result:" + ret);
    	return  ret;
    }
}
