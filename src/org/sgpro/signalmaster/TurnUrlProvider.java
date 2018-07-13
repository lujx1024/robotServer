package org.sgpro.signalmaster;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.apache.log4j.Logger;
import org.eclipse.jdt.internal.compiler.ast.ArrayAllocationExpression;

import config.Log4jInit;

/**
 * Servlet implementation class CatchPkg
 */
@Path("/turn")
public class TurnUrlProvider extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static Logger logger = Logger.getLogger(TurnUrlProvider.class.getName());   
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TurnUrlProvider() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;

  // {"username": "1428558975:yinshengge", "password": "FTPYwYxZ6gi/Y4snHIskCnf+UWY=", "uris": ["turn:192.158.29.168:3478?transport=udp", "turn:192.158.29.168:3478?transport=tcp", "turn:192.158.29.168:3479?transport=udp", "turn:192.158.29.168:3479?transport=tcp"]}
    
    /**
     * 
     * {
    "username": "1428558975:yinshengge",
    "password": "FTPYwYxZ6gi/Y4snHIskCnf+UWY=",
    "uris": [
        "turn:192.158.29.168:3478?transport=udp",
        "turn:192.158.29.168:3478?transport=tcp",
        "turn:192.158.29.168:3479?transport=udp",
        "turn:192.158.29.168:3479?transport=tcp"
    ]
}
     * 
     * 
     * @author Administrator
     *
     */

    class TurnServerResult {
    	String username;
    	String password;
    	List<String> uris = new ArrayList<String>() ;
    	
    	public String getUsername() {
			return username;
		}
    	public void setUsername(String username) {
			this.username = username;
		}
    	
		public String getPassword() {
			return password;
		}
		public void setPassword(String password) {
			this.password = password;
		}
		public boolean add(String e) {
			return uris.add(e);
		}
		public boolean contains(Object o) {
			return uris.contains(o);
		}
		public boolean remove(Object o) {
			return uris.remove(o);
		}
		public int size() {
			return uris.size();
		}
		
		@Override
		public String toString() {
		// TODO Auto-generated method stub
			return  GsonProvider.getGson().toJson(this);
		}
    }
    
    
    @Path("/{username}")
    @GET
    @Produces(MediaType.TEXT_PLAIN)    
    public String getTurn(@PathParam("username") String userName) throws Throwable {
    	
    	logger.info(this.getClass().getSimpleName()+ ".getTurn:" + userName);
	
		String ret = null;
		
		TurnServerResult tr = new TurnServerResult();
		tr.setUsername("1428659492:yinshengge");
		tr.setPassword("QsS/SCPpc53p2JdAyZm1fALmOvs=");
		
//        "turn:192.158.29.168:3478?transport=udp",
//        "turn:192.158.29.168:3478?transport=tcp",
//        "turn:192.158.29.168:3479?transport=udp",
//        "turn:192.158.29.168:3479?transport=tcp"
		
		tr.add("turn:192.158.29.168:3478?transport=udp");
		tr.add("turn:192.158.29.168:3478?transport=tcp");
		tr.add("turn:192.158.29.168:3479?transport=udp");
		tr.add("turn:192.158.29.168:3479?transport=tcp");
		
    	return tr.toString();
    }
}
