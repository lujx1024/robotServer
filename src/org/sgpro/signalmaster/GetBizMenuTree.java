package org.sgpro.signalmaster;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.apache.log4j.Logger;
import org.sgpro.db.HibSf;
import org.sgpro.db.ViewBizMenutreeId;

import config.Log4jInit;
/**
 */
@Path("/menutree")
public class GetBizMenuTree  extends HttpServlet  {
	static Logger logger = Logger.getLogger(GetBizMenuTree.class.getName());
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public GetBizMenuTree() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;
    @Context 
    private HttpServletResponse  response;
 
    @Path("/{entry_name}/")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String menu(
  		  @PathParam("entry_name") String entry_name 
  		) throws Throwable {
    	
    	Result r = Result.success();
    	
		try {

			response.addHeader("Access-Control-Allow-Origin", "*");

			Connection c = HibSf.getConnection();

			CallableStatement call = c
					.prepareCall("exec  SP_GET_BIZ_MENUTREE  ?");

			int argCount = 1;
			call.setString(argCount++, entry_name);

			ResultSet rs = call.executeQuery();
			List<ViewBizMenutreeId> l = new ArrayList<>();

			while (rs.next()) {

				ViewBizMenutreeId item = new ViewBizMenutreeId();
				item.setAction(rs.getString("action"));
				item.setActionExtra(rs.getString("action_Extra"));
				item.setActionType(rs.getString("action_Type"));
				item.setActionUri(rs.getString("action_Uri"));
				// item.setMenuEntryName(menuEntryName);
				item.setActionPackageName(rs.getString("action_Package_Name"));
				item.setActionClassName(rs.getString("action_Class_Name"));
				item.setMenuExtra(rs.getString("menu_Extra"));
				item.setMenuId(rs.getLong("menu_Id"));
				item.setMenuLabel(rs.getString("menu_Label"));;
				item.setMenuSeq(rs.getLong("menu_Seq"));
				item.setParentMenuId(rs.getLong("parent_Menu_Id"));
				
				l.add(item);
			}
			r.setData(l);
			logger.info(entry_name + ":" + ":" + r.toString());
		} catch (Throwable th) {
    		r = Result.unknowException(th);
    		th.printStackTrace();
    	}
    	
    	return r.toString();
    }
}
