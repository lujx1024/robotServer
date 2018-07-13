package org.sgpro.signalmaster;

import java.nio.ByteBuffer;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.FormParam;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.hibernate.Transaction;
import org.sgpro.db.HibSf;
import org.sgpro.db.ViewEndpointLatestStatus;
import org.sgpro.db.ViewEndpointLatestStatusId;
import org.sgpro.db.ViewRemoteEndpointLatestStatus;
import org.sgpro.db.ViewRemoteEndpointLatestStatusId;
import org.sgpro.db.ViewRemoteUserRobotBindList;
import org.sgpro.db.ViewUserRobotBindList;


//@Path("/dao")
public class RemoteDBFunctionUtils {
	private static Connection connection = HibSf.getConnection();

	public static String getConfig(String imei, String name) throws Throwable {
		
		return (String)ViewUtils.dbFunc("dbo.[FUNC_GET_CONFIG_VALUE]", imei, name, null);
		 
	}
	
	@Deprecated
	public static ViewRemoteEndpointLatestStatusId getREndPointById(String  epid) {
		// TODO Auto-generated method stub
		ViewRemoteEndpointLatestStatusId ret = null;

    	try {
    		
			CallableStatement call = connection.prepareCall
					("exec SP_GET_ENDPOINT_STATUS_BY_ENDPOINT_ID ?");
			call.setString(1, epid);
			ResultSet rs = call.executeQuery();
			
			if (rs.next()) {
				ret = new ViewRemoteEndpointLatestStatusId(
						  rs.getLong("END_POINT_ID")
					    , rs.getString("END_POINT_NAME")
						, rs.getDate("UPDATE_DATETIME")
						, rs.getString("WSS_SESSION_ID")
						, rs.getBoolean("ONLINE")
						, rs.getString("EXTRA_INFO")
						, rs.getBoolean("IS_ROBOT"));
			}
    	} catch (Throwable t) {
    		throw new RuntimeException(t);
    	}
		
		return ret;
	}
	
	public static ViewRemoteEndpointLatestStatusId getEndPointByIdNt(String  epid) throws Throwable {
		// TODO Auto-generated method stub

		return 
		(ViewRemoteEndpointLatestStatusId) ViewUtils.getViewData(
		ViewUtils.dbProcQuery
		(ViewRemoteEndpointLatestStatus.class, "SP_REMOTE_GET_ENDPOINT_STATUS_BY_ENDPOINT_ID", epid));
		
	}
	
	
//	public static void validateLoginSession(HttpServletRequest request) throws Throwable {
//		
//		if (request != null ) {
//			System.out.println(request);
//			System.out.println(request.getSession().getId());
//			System.out.println(request.getSession().getAttribute(Admin.ADMIN));
//
//			Object admin = request.getSession().getAttribute(Admin.ADMIN);
//			validateLoginSession((Boolean)admin, request.getSession().getId());
//		}
//	}
//	
//	
//	public static void validateLoginSession(Boolean admin, String sessionId) throws Throwable {
//		
//		if (admin == null || !(Boolean)admin) {
//			boolean ret = (Boolean)ViewUtils.dbFunc("dbo.[FUNC_HAS_CURRENT_SESSION_EXPIRED]", sessionId );
//			if (ret) {
//				RTCWssStreamInBound pipe = RTCWssStreamInBound.pipes.get(sessionId);
//				
//				if (pipe != null) {
//					RTCWssStreamInBound.pipes.remove(sessionId);
//					pipe.getWsOutbound().close(2, ByteBuffer.wrap("登录已失效，请重新登录！".getBytes("utf-8")));
//				}
//				
//				throw new LoginExprException("登录已失效，请重新登录！");
//			}
//		}
//	}
	
	public static void validateRemoteLoginSession(Boolean admin, String sessionId) throws Throwable {
		
		if (admin == null || !(Boolean)admin) {
			boolean ret = (Boolean)ViewUtils.dbFunc("dbo.[FUNC_REMOTE_HAS_CURRENT_SESSION_EXPIRED]", sessionId );
			if (ret) {
				RTCWssStreamInBound pipe = RTCWssStreamInBound.pipes.get(sessionId);
				
				if (pipe != null) {
					RTCWssStreamInBound.pipes.remove(sessionId);
					pipe.getWsOutbound().close(2, ByteBuffer.wrap("登录已失效，请重新登录！".getBytes("utf-8")));
				}
				
				throw new LoginExprException("登录已失效，请重新登录！");
			}
		}
	}
	
	
	public static List  getBindlistBySessionIdNt(String sessionId) throws Throwable {
		
		
		return 
				ViewUtils.getViewDataList(
				ViewUtils.dbProcQuery
				(ViewRemoteEndpointLatestStatus.class, "SP_REMOTE_GET_BIND_LIST_BY_SESSION_ID", sessionId));
				

	}
	
//	@Deprecated
//	public static List<ViewEndpointLatestStatusId> getBindlistBySessionId(String sessionId) {
//		
//
//		// TODO Auto-generated method stub
//		List<ViewEndpointLatestStatusId> ret = new ArrayList<>();
//
//    	try {
//    		
//			CallableStatement call = connection.prepareCall
//					("exec SP_GET_BIND_LIST_BY_SESSION_ID ?");
//			call.setString(1, sessionId);
//			ResultSet rs = call.executeQuery();
//			
//			while (rs.next()) {
//				ViewEndpointLatestStatusId item = new ViewEndpointLatestStatusId(
//						  rs.getLong("END_POINT_ID")
//					    , rs.getString("END_POINT_NAME")
//						, rs.getDate("UPDATE_DATETIME")
//						, rs.getString("WSS_SESSION_ID")
//						, rs.getBoolean("ONLINE")
//						, rs.getString("EXTRA_INFO")
//						, rs.getBoolean("IS_ROBOT"));
//				ret.add(item);
//			}
//    	} catch (Throwable t) {
//    		throw new RuntimeException(t);
//    	}
//		
//		return ret;
//	}

	public static ViewRemoteEndpointLatestStatusId getEndPointBySessionIdNt (
			String sessionId) throws Throwable {
		 
		return (ViewRemoteEndpointLatestStatusId) ViewUtils
				.getViewData(ViewUtils.dbProcQuery(
						ViewRemoteEndpointLatestStatus.class,
						"SP_REMOTE_GET_ENDPOINT_STATUS_BY_SESSION_ID", sessionId));
	}

	
//	@Deprecated
//	public static ViewEndpointLatestStatusId getEndPointBySessionId(
//			String sessionId) {
//		// TODO Auto-generated method stub
//		ViewEndpointLatestStatusId ret = null;
//
//    	try {
//    		
//			CallableStatement call = connection.prepareCall
//					("exec SP_GET_ENDPOINT_STATUS_BY_SESSION_ID ?");
//			call.setString(1, sessionId);
//			ResultSet rs = call.executeQuery();
//			
//			if (rs.next()) {
//				ret = new ViewEndpointLatestStatusId(
//						  rs.getLong("END_POINT_ID")
//					    , rs.getString("END_POINT_NAME")
//						, rs.getDate("UPDATE_DATETIME")
//						, rs.getString("WSS_SESSION_ID")
//						, rs.getBoolean("ONLINE")
//						, rs.getString("EXTRA_INFO")
//						, rs.getBoolean("IS_ROBOT"));
//			}
//    	} catch (Throwable t) {
//    		throw new RuntimeException(t);
//    	}
//		
//		return ret;
//	}
	
	@Deprecated
	public static ViewRemoteEndpointLatestStatusId getRemoteEndPointBySessionId(
			String sessionId) {
		// TODO Auto-generated method stub
		ViewRemoteEndpointLatestStatusId ret = null;

    	try {
    		
			CallableStatement call = connection.prepareCall
					("exec SP_REMOTE_GET_ENDPOINT_STATUS_BY_SESSION_ID ?");
			call.setString(1, sessionId);
			ResultSet rs = call.executeQuery();
			
			if (rs.next()) {
				ret = new ViewRemoteEndpointLatestStatusId(
						  rs.getLong("END_POINT_ID")
					    , rs.getString("END_POINT_NAME")
						, rs.getDate("UPDATE_DATETIME")
						, rs.getString("WSS_SESSION_ID")
						, rs.getBoolean("ONLINE")
						, rs.getString("EXTRA_INFO")
						, rs.getBoolean("IS_ROBOT"));
			}
    	} catch (Throwable t) {
    		throw new RuntimeException(t);
    	}
		
		return ret;
	}


	public static void saveRTCSessionStatus(long robotId, long userId,
			boolean robotInitiate, String state) {
		// TODO Auto-generated method stub

    	try {
    		
			CallableStatement call = connection.prepareCall
					("exec SP_ADD_RTC_SESSION_NEW_STATE ?, ?, ?, ?");
			int argCount = 1;
			call.setLong(argCount++, robotId);
			call.setLong(argCount++, userId);
			call.setBoolean(argCount++, robotInitiate);
			call.setString(argCount++, state);
			call.execute();
    	} catch (Throwable t) {
    		throw new RuntimeException(t);
    	}
	}
	
	
	
	public static List getUserRobotBindList(
			String sessionId) throws Throwable {

		return  ViewUtils.getViewDataList(
				ViewUtils.dbProcQuery(
						ViewRemoteUserRobotBindList.class, "SP_REMOTE_GET_USER_ROBOT_BIND_LIST_BY_SESSION_ID" , sessionId)
				);
		
	}
	
//	@Path("/copy/")
//	@POST
//	@Produces(MediaType.APPLICATION_JSON)
//	public String copyObject(
//			@FormParam("id") Long sourceId,
//			@FormParam("name") String rename,
//			@FormParam("target") String objectName			
//    		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
//      		,  @HeaderParam(Admin.VERSION) String VERSION  		  
//			) {
//
//		Result r = Result.success();
//		Transaction trans = null;
//		try {
//			trans = HibSf.getSession().beginTransaction();
//
//			Class<?> clazz = Class.forName("org.sgpro.db.View" + objectName + "Simple"); 
//			String tableName = fuckHibernateFUckkkkkkkkkkkkkkkkkk(objectName);
//			r.setData(
//					ViewUtils.getViewDataList(
//					RemoteDBFunctionUtils.editKnowledgeBaseQ(ACCESS_KEY, VERSION
//					, clazz, "SP_COPY_ENT" + tableName, sourceId 
//					,  sourceId, rename)));
//
//			trans.commit();
//		} catch (Throwable t) {
//			r = Result.unknowException(t);
//			if (trans != null) {
//				try {
//					trans.rollback();
//				} catch (Throwable t1) {
//					r = Result.unknowException(t1);
//					t1.printStackTrace();
//				}
//			}
//		}
//		
//		return r.toString();
//	}
//
//	private String fuckHibernateFUckkkkkkkkkkkkkkkkkk(String objectName) {
//		// TODO Auto-generated method stub
//		int length = objectName == null? 0 : objectName.length();
//		String ret = null;
//		if (length > 0) {
//			StringBuffer tableName = new StringBuffer();
//			
//			for (int i = 0; i < objectName.length(); i++) {
//				char c = objectName.charAt(i);
//				if (Character.isUpperCase(c)) {
//					tableName.append("_");
//				}
//				
//				tableName.append(c);
//			}
//			ret = tableName.toString();
//		}
//		
//		return ret;
//	}
//

//	
//
//	public static void editKnowledgeBase(
//			  String ACCESS_KEY
//			, String VERSION
//			, String PROC
//			, Long   objectId
//			, Object... params) {
//		// TODO Auto-generated method stub
//		// 保存log
//		ViewUtils.dbProc("SP_SAVE_WORDS_OPERATION_LOG", ACCESS_KEY, VERSION, PROC,  objectId,  Arrays.asList(params).toString());    		
//		ViewUtils.dbProc(PROC, params);
//		
//	}
//	public static <T> List<T>  editKnowledgeBaseQ(
//			  String ACCESS_KEY
//			, String VERSION
//			, Class<T> entityClass
//			, String PROC
//			, Long   objectId
//			, Object... params) {
//		// TODO Auto-generated method stub
//		// 保存log
//		ViewUtils.dbProc("SP_SAVE_WORDS_OPERATION_LOG", ACCESS_KEY, VERSION, PROC,  objectId,  Arrays.asList(params).toString());    		
//		return ViewUtils.dbProcQuery(entityClass, PROC, params);
//		
//	}

}
