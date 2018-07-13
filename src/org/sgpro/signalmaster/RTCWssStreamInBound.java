package org.sgpro.signalmaster;

import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.nio.CharBuffer;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.catalina.websocket.StreamInbound;
import org.apache.catalina.websocket.WebSocketServlet;
import org.apache.catalina.websocket.WsOutbound;
import org.apache.log4j.Logger;
import org.hibernate.Transaction;
import org.json.JSONObject;
import org.sgpro.db.HibSf;
import org.sgpro.db.TblRtcSession;
import org.sgpro.db.TblRtcSessionHome;
import org.sgpro.db.ViewRemoteEndpointLatestStatusId;
import org.sgpro.db.ViewRemoteEndpointLatestStatusId;
import org.sgpro.db.ViewRemoteUserRobotBindListId;
import org.sgpro.db.ViewUserRobotBindListId;
import org.sgpro.util.Digest;
import org.sgpro.util.RuntimeUtil;

import config.Log4jInit;

@SuppressWarnings("deprecation")
public class RTCWssStreamInBound extends StreamInbound {
	static Logger logger = Logger.getLogger(RTCWssStreamInBound.class.getName());
	// private HttpServletRequest request;
	private String sessionId ;
	public static Map<String, RTCWssStreamInBound> pipes = new HashMap<String, RTCWssStreamInBound>();
	private static Connection connection = HibSf.getConnection();
		 
	
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return sessionId + "'s stream in bound." ;
	}
	
	private WebSocketServlet wss;
	private HttpServletRequest request;
	private String wssSessionId;
	
	/**
	 * 构造
	 * @param rtcsm
	 * @param arg0
	 * @param arg1
	 */
	public RTCWssStreamInBound(Rtcsm rtcsm, String arg0, HttpServletRequest arg1) {
//		// TODO Auto-generated constructor stub
		logger.info(
				String.format("WSS BOUND created! hashcode:%X", hashCode()));
		wss = rtcsm;
		request = arg1;
		wssSessionId = request.getSession().getId();
	}
	
	

	public RTCWssStreamInBound() {
		super();
	}



	/**
	 * 二进制数据传入
	 */
	@Override
	protected void onBinaryData(InputStream arg0) throws IOException {
		// TODO Auto-generated method stub
		
	}

	/**
	 * 文本数据传入
	 */
	@SuppressWarnings("unchecked")
	@Override
	protected void onTextData(Reader arg0) throws IOException {
		// TODO Auto-generated method stub
		logger.info("@@@@@@@@@@@@@@@进入webSocket通讯的时间："+System.currentTimeMillis());
		Transaction trans = null;
		Remote remote = new Remote();
		try {
			trans = HibSf.getSession().beginTransaction();
			
			StringBuffer sb = new StringBuffer();
			char[] cbuf = new char[4096];
			
			int count = 0;
			while ((count = arg0.read(cbuf)) != -1) {
				sb.append(cbuf, 0, count);
			}
			
			String upload = sb.toString();
			JSONObject jo = new JSONObject(upload);
			String cmd = jo.optString("cmd");
			
			JSONObject optSession = jo.optJSONObject("data");
			if (sessionId == null && optSession != null && optSession.has("sessionId")) {
				sessionId = optSession.getString("sessionId");
				if (!pipes.containsKey(sessionId)) {
					pipes.put(sessionId, this);
					logger.info(
							String.format("[%s]Pipe be created！ id:%s hashcode:%X", sessionId, sessionId , hashCode()));
					
				}
			}
			logger.error("OnText Data: " + sessionId );
			currentEp = RemoteDBFunctionUtils.getEndPointBySessionIdNt(sessionId);
			bindList = RemoteDBFunctionUtils.getUserRobotBindList(sessionId);
			
			try{//记录日志
				if(currentEp.getIsRobot()){
					remote.recordLog(1000l, "远程控制操作指令:"+cmd, String.valueOf(currentEp.getEndPointId()));
				}else{
					String robotSn="";
					if(optSession.has("target")&&optSession.getString("target")!=null && !"".equals(optSession.getString("target"))){
						robotSn = String.valueOf(ViewUtils.dbFunc1("SELECT IMEI FROM ENT_ROBOT WHERE ID = ?",optSession.getString("target")));
					}
					remote.recordLog(currentEp.getEndPointId(), "远程控制操作指令:"+cmd, robotSn);
				}
			}catch(Throwable th1){
				logger.error("记录日志异常");
			}
			
			
			
			logger.error(epDescription() + " TEXT RCV " + upload);
			String result = wssCommand(RTCWssCommandEnum.valueOf(cmd), jo);
			
			if (result != null) {
				p2pSend(null, sessionId, result);
			}
			
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				trans.rollback();
			}
			logger.error(t.getMessage());
			// WSSResult r = WSSResult.unknowException(t);
			// p2pSend(null, sessionId, r.toString());
		}
	}

	/**
	 * WSS 的命令
	 * @param cmd
	 * @param data
	 * @return
	 * @throws Throwable
	 */
	public String wssCommand(RTCWssCommandEnum cmd, JSONObject data) throws Throwable {
		// TODO Auto-generated method stub
		String result = null;
		switch (cmd) {
		case ping:
			result = ping(data);
		break;
		// 收到answer sdp， 转发至target
		case answer:
			answer(data);
			break;
		// 收到 candidate，转发至 target
		case candidate:
			candidate(data);
			break;
		// 收到连接变化的状态	
		case connection_state_changed:
			connectionStateChanged(data);
			break;
		// 终端登录	
		case login:
			result = login(data);
			break;
		// 收到 offer sdp.	
		case offer:
			offer(data);
			break;
		// 登出	
		case logout:
			//result = logout();
			break;
		// 关闭	
		case close:
			if (wss != null) {
				wss.destroy();
			}
			break;
		// 手动模式切换	
		case manual_mode_switch:
			result = modeSwitch(data);
			
			break;
			// 手工聊天
		case manual_talk:
			result = manualTalk(data);
			break;
			
		case stop_talk:
			result = stopTalk(data);
			break;
			
		case running_talk:
			result = runningTalk(data);
			break;
			
		case remote_video_status_changed:
			rtmpChanged(data);
			break;
			
		case get_bind_list:
			  result =  getBindEpListString(data);
		break;
		default:
			break;
		
		}
		return result;
	}
	

	private void rtmpChanged(JSONObject rtmpObject) throws Throwable {
		// TODO Auto-generated method stub
		
		JSONObject data = rtmpObject.optJSONObject("data");
		String  sn = data.optString("sn");
		String  status = data.optString("status");
		String cfgRotate = RemoteDBFunctionUtils.getConfig(sn, "remote_video_rotate");
		
		int rotateStyle = cfgRotate == null? 1 : Integer.valueOf(cfgRotate);
		
		if ("connected".equals(status)) {
			String command = 
					String.format(
							"C:\\ffmpeg\\bin\\ffmpeg -i rtmp://localhost/live/%s -c:a copy  -f flv -vf transpose=%d rtmp://localhost/live/%s_r"
							, sn, rotateStyle, sn);
			
			RuntimeUtil.windowsCommand(command);
			logger.info("remote video connected: sn = " + sn);
			
		} else if ("disconnected".equals(status)) {
			logger.info("remote video disconnected: sn = " + sn);
		}
		
		List<ViewRemoteUserRobotBindListId> list = getBindList();
		
		for (ViewRemoteUserRobotBindListId item : list) {
			if (item.getUserLastestStatusOnline()) {
				p2pSend(null, item.getUserLastestStatusWssSessionId(), rtmpObject.toString());
			}
		}
		
	}

//	private String ping(JSONObject data) throws Throwable {
//		
//		// TODO Auto-generated method stub
//		WSSResult result = new WSSResult();
//		result.setCmd("ping_ack");
//		
//		data = data.optJSONObject("data");
//		long count = data.optLong("count");
//		String sn = data.optString("sn");
//		
//		result.setData(count + 1);
//		ViewRemoteEndpointLatestStatusId ep = getCurrentEp();
//		
//		if (ep == null || !ep.getOnline()) {
//			logger.error("此机器丢失联系，重新设置登录状态");
//			ViewUtils.dbProc("SP_REMOTE_SET_ROBOT_ONLINE", sn, this.sessionId);
//		}
//		
////		System.out.println("ping count=" + count);
//		
//		return  result.toString();
//		
//	}
	
private String ping(JSONObject data) throws Throwable {
		
		// TODO Auto-generated method stub
		WSSResult result = new WSSResult();
		result.setCmd("ping_ack");
		
		data = data.optJSONObject("data");
		long count = data.optLong("count");
		String sn = data.optString("sn");
		
		String power = "0";//data.optString("power");
		String sound = "1";//data.optString("sound");
		
		result.setData(count + 1);
		ViewRemoteEndpointLatestStatusId ep = getCurrentEp();
		
		if (ep == null || !ep.getOnline()) {
			logger.error("此机器丢失联系，重新设置登录状态");
			ViewUtils.dbProc("SP_REMOTE_SET_ROBOT_ONLINE", sn, this.sessionId);
		}
		
		CallableStatement call = connection
				.prepareCall(
						"SP_REMOTE_GET_STATUS ?" 
						);
		call.setString(1,sn );
		
		ResultSet rs = call.executeQuery();
		
		String userSession = "";
		String manualMode = "0";
		while(rs.next()){
			logger.info("存储过程存在返回值："+rs.getString("MANUAL_MODE"));
			userSession = rs.getString("SESSION_ID");
			manualMode = rs.getString("MANUAL_MODE");
		}
		
		result.setManualMode(manualMode);
		logger.info("返回给机器人端的是否手动/自动");
		
		if(!"".equals(userSession)){
			logger.info("存在当前控制机器人的用户，主动推送电池电量与是否静音");
			JSONObject pushNotify = new JSONObject();
			pushNotify.put("cmd", RTCWssCommandEnum.status_remind.toString());
			pushNotify.put("power", power);
			pushNotify.put("sound", sound);
			p2pSend(null,userSession,pushNotify.toString());
		}
		
//		System.out.println("ping count=" + count);
		logger.info("返回给机器人的数据："+result.toString());
		return  result.toString();
		
	}
	
	public Long zeroToNull(Long num) {
		return  num != null && num == 0? null : num;
	}
	
	public String emptyToNull(String str) {
		return emptyTo(str, null);
	}
	
	public String emptyTo(String str, String rep) {
		return "".equals(str)? rep : str;
	}
	
	public static void httpPush(
			String targetId
			, String text
			, String path
			, String emotion
			, Long   command
			, String commandParam
			, Long _3rd
			, String _3rdParam
			) throws Throwable {

		// TODO Auto-generated method stub
		logger.info("***********人工模式***************");
		
		ViewRemoteEndpointLatestStatusId target = RemoteDBFunctionUtils
				.getEndPointByIdNt(targetId);
 
			if (target.getOnline()) {
				
				ViewUtils.dbProc(
						"SP_SAVE_VOICE_MANUAL"
						, target.getEndPointId()
						, path
						, emotion
						, text
						, command
						, commandParam
						, _3rd
						, _3rdParam);
				
				logger.info("服务端收到并保存人工结果");
				
				long epId = target.getEndPointId();
				AutoTalkV2 at = AutoTalkV2.ManualTalks.get(epId);
				
				if (at != null) {
					// 手动回复
					synchronized (at) {
						logger.info("已发送人工结果，通知 HTTP 回复");
						at.notify();
					}
				} else {
					// 通知客户端 来吧 发起远程请求
					logger.info("主动推送给客户端通知取人工结果");
					JSONObject pushNotify = new JSONObject();
					pushNotify.put("cmd", RTCWssCommandEnum.manual_talk.toString());
					p2pSend(null, target, pushNotify.toString());
				}
			} else {
				logger.error(epDescription(target)  + " ***离线鸟*** 人工模式发送失败！");
			}
	}
	
	private synchronized String manualTalk(JSONObject data) throws Throwable {
		WSSResult result = new WSSResult();
	
		// TODO Auto-generated method stub
		logger.info("***********人工模式***************");
		
		JSONObject body = data.optJSONObject("data");
		ViewRemoteEndpointLatestStatusId target = RemoteDBFunctionUtils
				.getEndPointByIdNt(body.optString("target"));
		ViewRemoteEndpointLatestStatusId current = RemoteDBFunctionUtils
				.getEndPointBySessionIdNt(sessionId);
		
		/**
		 * 判断权限
		 * */
		boolean isLimits = false;
		
		if(current !=null){
			isLimits = UserPermissionJudgment(current.getEndPointId(),target.getEndPointId());
		}
		
		if(!isLimits){
			result.setCmd("not_limits");
			return result.toString();
		}
		
		
		if (target != null && current != null) {
			
			if (!(target.getIsRobot() ^ current.getIsRobot())) {
				throw new RuntimeException("机器人与机器人，用户与用户之间不能会话");
			}
			
			
			if (!current.getIsRobot()) {
				RemoteDBFunctionUtils.validateRemoteLoginSession(false, sessionId);
			}
			
			if (target.getOnline()) {
				
				ViewUtils.dbProc(
						"SP_SAVE_VOICE_MANUAL"
						, target.getEndPointId()
						, emptyToNull(body.optString("path"))
						, emptyToNull(body.optString("emotion"))
						, emptyToNull(body.optString("text"))
						, zeroToNull(body.optLong("command") )
						, emptyToNull(body.optString("commandParam"))
						, zeroToNull(body.optLong("thirdPartyApiId") )
						, zeroToNull(body.optLong("thirdPartyApiParamsValueId")));
				
				logger.info("服务端收到并保存人工结果");
				
				long epId = target.getEndPointId();
				AutoTalkV2 at = AutoTalkV2.ManualTalks.get(epId);
				
				if (at != null) {
					// 手动回复
					synchronized (at) {
						logger.info("已发送人工结果，通知 HTTP 回复");
						at.notify();
					}
				} else {
					// 通知客户端 来吧 发起远程请求
					logger.info("主动推送给客户端通知取人工结果");
					JSONObject pushNotify = new JSONObject();
					pushNotify.put("cmd", RTCWssCommandEnum.manual_talk.toString());
					p2pSend(current, target, pushNotify.toString());
					logger.info("@@@@@@@@@@@@@@@webSocket通讯发送之后的时间："+System.currentTimeMillis());
				}
			} else {
				logger.error(epDescription(target)  + " ***离线鸟*** 人工模式发送失败！");
			}
		} else {
			logger.error(String.format("参数错误，current=%s, target=%s", current, target));
		}
		
		return result.toString();
	}
	
	private synchronized String stopTalk(JSONObject data) throws Throwable {
		WSSResult result = new WSSResult();
	
		// TODO Auto-generated method stub
		logger.info("***********人工模式--中断***************");
		
		JSONObject body = data.optJSONObject("data");
		ViewRemoteEndpointLatestStatusId target = RemoteDBFunctionUtils
				.getEndPointByIdNt(body.optString("target"));
		ViewRemoteEndpointLatestStatusId current = RemoteDBFunctionUtils
				.getEndPointBySessionIdNt(sessionId);
		
		/**
		 * 判断权限
		 * */
		boolean isLimits = false;
		
		if(current !=null){
			isLimits = UserPermissionJudgment(current.getEndPointId(),target.getEndPointId());
		}
		
		if(!isLimits){
			result.setCmd("not_limits");
			return result.toString();
		}
		
		
		if (target != null && current != null) {
			
			if (!(target.getIsRobot() ^ current.getIsRobot())) {
				throw new RuntimeException("机器人与机器人，用户与用户之间不能会话");
			}
			
			
			if (!current.getIsRobot()) {
				RemoteDBFunctionUtils.validateRemoteLoginSession(false, sessionId);
			}
			
			if (target.getOnline()) {
				long epId = target.getEndPointId();
				AutoTalkV2 at = AutoTalkV2.ManualTalks.get(epId);
				
				if (at != null) {
					// 手动回复
					synchronized (at) {
						logger.info("已发送人工结果，通知 HTTP 回复");
						at.notify();
					}
				} else {
					logger.info("主动推送给客户端人工结果");
					JSONObject pushNotify = new JSONObject();
					pushNotify.put("cmd", RTCWssCommandEnum.stop_talk.toString());
					p2pSend(current, target, pushNotify.toString());
					logger.info("@@@@@@@@@@@@@@@webSocket通讯发送之后的时间："+System.currentTimeMillis());
				}
			} else {
				logger.error(epDescription(target)  + " ***离线鸟*** 人工模式发送失败！");
			}
		} else {
			logger.error(String.format("参数错误，current=%s, target=%s", current, target));
		}
		
		return result.toString();
	}
	
	private synchronized String runningTalk(JSONObject data) throws Throwable {
		WSSResult result = new WSSResult();
	
		// TODO Auto-generated method stub
		logger.info("***********人工模式--移动***************");
		
		JSONObject body = data.optJSONObject("data");
		ViewRemoteEndpointLatestStatusId target = RemoteDBFunctionUtils
				.getEndPointByIdNt(body.optString("target"));
		ViewRemoteEndpointLatestStatusId current = RemoteDBFunctionUtils
				.getEndPointBySessionIdNt(sessionId);
		
		/**
		 * 判断权限
		 * */
		boolean isLimits = false;
		
		if(current !=null){
			isLimits = UserPermissionJudgment(current.getEndPointId(),target.getEndPointId());
		}
		
		if(!isLimits){
			result.setCmd("not_limits");
			return result.toString();
		}
		
		
		if (target != null && current != null) {
			
			if (!(target.getIsRobot() ^ current.getIsRobot())) {
				throw new RuntimeException("机器人与机器人，用户与用户之间不能会话");
			}
			
			
			if (!current.getIsRobot()) {
				RemoteDBFunctionUtils.validateRemoteLoginSession(false, sessionId);
			}
			
			if (target.getOnline()) {
				
				// 通知客户端 来吧 发起远程请求
				logger.info("主动推送给客户端移动人工结果");
				JSONObject pushNotify = new JSONObject();
				pushNotify.put("cmd", RTCWssCommandEnum.running_talk.toString());
				pushNotify.put("data", body.optString("runningParam"));
				p2pSend(current, target, pushNotify.toString());
				logger.info("@@@@@@@@@@@@@@@webSocket通讯发送之后的时间："+System.currentTimeMillis());
			} else {
				logger.error(epDescription(target)  + " ***离线鸟*** 人工模式发送失败！");
			}
		} else {
			logger.error(String.format("参数错误，current=%s, target=%s", current, target));
		}
		
		return result.toString();
	}
	
	private boolean UserPermissionJudgment(long userId,long robotId) {
		// TODO Auto-generated method stub
		int ret = 0;
		boolean result = false;
		try{
			CallableStatement call = connection
					.prepareCall(
							"exec SP_REMOTE_LIMITS  ?, ?"
							);
//			ret = ViewUtils.dbProc("SP_REMOTE_LIMITS", userId,robotId);
			call.setLong(1,userId );
			call.setLong(2,robotId );
			
			ResultSet rs = call.executeQuery();
			
			while(rs.next()){
				ret = rs.getInt("RET");
			}
			
			if(ret == 1){
				result =  true;
			}
		}catch(Throwable t){
			logger.error("@@@@@@@@@@@@@@@@@@权限判断异常"+t);
			t.printStackTrace();
		}
		
		
		return result;
	}

	private String modeSwitch(JSONObject data) throws Throwable {
		WSSResult result = new WSSResult();
		result.setCmd("manual_mode_switch_succeed");
		
		// TODO Auto-generated method stub
		JSONObject body = data.optJSONObject("data");
		String RemoteSessionId = body.optString("sessionId");
		String Remotetarget = body.optString("target");
		ViewRemoteEndpointLatestStatusId target  = null;
		ViewRemoteEndpointLatestStatusId current = null;
		if(RemoteSessionId.isEmpty()){
			target = RemoteDBFunctionUtils.getEndPointByIdNt(Remotetarget);
			current = RemoteDBFunctionUtils.getEndPointBySessionIdNt(sessionId);
		}else{
			target = RemoteDBFunctionUtils.getEndPointByIdNt(Remotetarget);
			current = RemoteDBFunctionUtils.getEndPointBySessionIdNt(RemoteSessionId);
			p2pSend(current, target, data.toString());
			return result.toString();
		}
		
		
		/**
		 * 判断权限
		 * */
		boolean isLimits = false;
		
		if(current !=null){
			isLimits = UserPermissionJudgment(current.getEndPointId(),target.getEndPointId());
		}
		
		if(!isLimits){
			result.setCmd("not_limits");
			return result.toString();
		}
		
		
		if (target != null && current != null) {
			
			if (!current.getIsRobot()) {
				RemoteDBFunctionUtils.validateRemoteLoginSession(false, sessionId);
			}
			
			if (!(target.getIsRobot() ^ current.getIsRobot())) {
				throw new RuntimeException("机器人与机器人，用户与用户之间不能会话");
			}
			
			ViewUtils.dbProc("SP_REMOTE_SWITCH_MANUAL_MODE"
					, current.getEndPointId()
					, target.getEndPointId());
			p2pSend(current, target, data.toString());
		}
		
		return result.toString();
	}



	/**
	 * ICE 状态更改，只从电脑端/用户端 发出
	 * @param data
	 */
	private void connectionStateChanged(JSONObject data) throws Throwable {
		
		JSONObject body = data.optJSONObject("data");
		ViewRemoteEndpointLatestStatusId target  = RemoteDBFunctionUtils.getEndPointByIdNt(body.optString("target"));
		ViewRemoteEndpointLatestStatusId current = RemoteDBFunctionUtils.getEndPointByIdNt(body.optString("sender"));
		boolean robotInitiate = body.optBoolean("robotInitiate");
		String state = body.optString("state");
		
		if (target != null && current != null) {
			
			// 存入 session.
			if (!(target.getIsRobot() ^ current.getIsRobot())) {
				throw new RuntimeException("机器人与机器人，用户与用户之间不能会话");
			} 
			
			RemoteDBFunctionUtils.saveRTCSessionStatus(target.getEndPointId()
					, current.getEndPointId()
					, robotInitiate
					, state);
		}
	
	}

	/**
	 * 发送ICE候选
	 * @param data
	 */
	private void candidate(JSONObject data) throws Throwable {
		// TODO Auto-generated method stub
		JSONObject body = data.optJSONObject("data");
		ViewRemoteEndpointLatestStatusId target  = RemoteDBFunctionUtils.getEndPointByIdNt(body.optString("target"));
		ViewRemoteEndpointLatestStatusId current = RemoteDBFunctionUtils.getEndPointBySessionIdNt(sessionId);
		
		if (target != null && current != null) {
			
			// 存入 session.
			if (!(target.getIsRobot() ^ current.getIsRobot())) {
				throw new RuntimeException("机器人与机器人，用户与用户之间不能会话");
			}
			if (target.getOnline()) {
				// 在线，直接把 candidate 传给对方
				p2pSend(current, target, data.toString());
			}  
		}
	}

	/**
	 * 发送answer sdp.
	 * @param data
	 */
	private void answer(JSONObject data) throws Throwable  {
		// TODO Auto-generated method stub
		JSONObject body = data.optJSONObject("data");
		ViewRemoteEndpointLatestStatusId target  = RemoteDBFunctionUtils.getEndPointByIdNt(body.optString("target"));
		ViewRemoteEndpointLatestStatusId current = RemoteDBFunctionUtils.getEndPointBySessionIdNt(sessionId);
		
		if (target != null && current != null) {
			
			if (!(target.getIsRobot() ^ current.getIsRobot())) {
				throw new RuntimeException("机器人与机器人，用户与用户之间不能会话");
			}
			
			if (target.getOnline()) {
				// 在线，直接把sdp 传给对方
				p2pSend(current, target, data.toString());
			}  
		}
	}

	/**
	 * 发送 answer sdp 给对端。
	 * @param data
	 */
	private void offer(JSONObject data) throws Throwable  {
		// TODO Auto-generated method stub
		JSONObject body = data.optJSONObject("data");
		ViewRemoteEndpointLatestStatusId target  = RemoteDBFunctionUtils.getEndPointByIdNt(body.optString("target"));
		ViewRemoteEndpointLatestStatusId current = RemoteDBFunctionUtils.getEndPointBySessionIdNt(sessionId);
		if (target != null && current != null) {
			
			// 存入 session.
			TblRtcSessionHome tsh = new TblRtcSessionHome();
			
			if (!(target.getIsRobot() ^ current.getIsRobot())) {
				throw new RuntimeException("机器人与机器人，用户与用户之间不能会话");
			}
			
			boolean currentIsRobot = current.getIsRobot();
			
			
			tsh.persist(new TblRtcSession(
					System.currentTimeMillis()
					, currentIsRobot? current.getEndPointId() : target.getEndPointId()
							, currentIsRobot? target.getEndPointId()  : current.getEndPointId()
									, currentIsRobot
									, new Timestamp(System.currentTimeMillis())				
					));
			if (target.getOnline()) {
				// 在线，直接把sdp 传给对方
				p2pSend(current, target, data.toString());
			}  
		}
		
	}
	
	private ViewRemoteEndpointLatestStatusId currentEp;
	
	public ViewRemoteEndpointLatestStatusId getCurrentEp() throws Throwable {
		if (currentEp == null) {
			currentEp = RemoteDBFunctionUtils.getEndPointBySessionIdNt(sessionId);
		}
		return currentEp;
	}
	
	@SuppressWarnings("unchecked")
	public List<ViewRemoteUserRobotBindListId> getBindList() throws Throwable {
		if (bindList == null) {
			bindList = RemoteDBFunctionUtils.getUserRobotBindList(sessionId);
		}
		return bindList;
	}
	
	
	public List<ViewRemoteUserRobotBindListId> bindList;
	
	public String epDescription(String sessionId) throws Throwable {
		return epDescription(RemoteDBFunctionUtils.getEndPointBySessionIdNt(sessionId));
	}
	
	public String epDescription() throws Throwable {
		return epDescription(getCurrentEp());
	}
	public static String epDescription(ViewRemoteEndpointLatestStatusId id) {
		return 
				id == null? "<null>" :
				String.format("[%s](%s:%s - %s)"
						, id.getWssSessionId()
						, id.getIsRobot()? "ROBOT" : "USER"
						, id.getEndPointName()
						, id.getOnline()? "online" : "offline"
						)
				;
	}
	
	
	public String getBindEpListString(JSONObject data)  throws Throwable {
		WSSResult result = new WSSResult();
		
		RemoteDBFunctionUtils.validateRemoteLoginSession(false, sessionId);
		result.setCmd("get_bind_list_done");
		result.setData(getBindList());
		broadcastStatus(bindList, false, true);
		
		return result.toString();
	}
	
	
	//@SuppressWarnings("unchecked")
	//public List<ViewRemoteEndpointLatestStatusId> getBindEpList() throws Throwable {
	//	return RemoteDBFunctionUtils.getBindlistBySessionIdNt(sessionId);
	//}
	/**
	 * 登出
	 * @return
	 */
	@SuppressWarnings("unchecked")
	private static String logout_new(String sessionId) throws Throwable {
		// TODO Auto-generated method stub
		Result result = Result.success();
		
		// String strEp = epDescription(epId);
		
		logger.info(sessionId + " SP_LOGOUT ");
		ViewUtils.dbProc("SP_REMOTE_LOGOUT", sessionId);
		
		ViewRemoteEndpointLatestStatusId current = 
				RemoteDBFunctionUtils.getEndPointBySessionIdNt(sessionId);
		
		List<ViewRemoteEndpointLatestStatusId> list = RemoteDBFunctionUtils.getBindlistBySessionIdNt(sessionId);
		
		
		if (list != null && current != null) {
			
			JSONObject broadcast = new JSONObject();
			broadcast.put("cmd", "endpoint_status_changed");
			JSONObject broadcastData = new JSONObject();
			broadcastData.put("id", current.getEndPointId());
			broadcastData.put("online", false);
			broadcast.put("data", broadcastData);
			
			logger.info(sessionId + " broadcast login status: "
					+ broadcastData);
			
			for (Object o : list) {
				ViewRemoteEndpointLatestStatusId item = (ViewRemoteEndpointLatestStatusId) o;
				if (item.getOnline()) {
					p2pSend(sessionId, item.getWssSessionId(), broadcast.toString());
				} else {
					logger.error(epDescription(item) + "===已离线=== 无法通知");
				}
			}
		}
		
		return result.toString();
	}
	
	/**

	   用户登录
	 @USER_AGENT AS NVARCHAR(4000)  -- IN
	 @USER_NAME  AS NVARCHAR(4000)  -- IN
	 @PASSWORD   AS NVARCHAR(4000)  -- IN
	 @SESSION_ID AS NVARCHAR(4000)  -- IN
	 @LOGIN_COUNT   AS BIGINT OUTPUT -- 登录次数	

	  机器人登录
	 @USER_AGENT AS NVARCHAR(4000)  -- IN
	 @USER_NAME  AS NVARCHAR(4000)  -- IN
	 @PASSWORD   AS NVARCHAR(4000)  -- IN
	 @IMEI       AS NVARCHAR(50)    -- IN
	 @SESSION_ID AS NVARCHAR(4000)  -- IN
	 @LOGIN_COUNT   AS BIGINT OUTPUT -- 登录次数
		 
	 * */
	
	private String login(JSONObject data) throws Throwable {
		// TODO Auto-generated method stub
		WSSResult result = new WSSResult();
    	result.setCmd("login_done");
    	
		try {
			data = data.optJSONObject("data");
			boolean isRobot = data.has("imei");
			// robot 登录
			CallableStatement call = connection
					.prepareCall(
							isRobot?
//							"exec SP_REMOTE_ROBOT_LOGIN ?, ?, ?, ?, ?, ?, ?" :
						    "exec SP_ROBOT_LOGIN ?, ?, ?, ?, ?, ?, ?" :
							"exec SP_USER_LOGIN  ?, ?, ?, ?, ? , ?"
							);

			int argCount = 1;

			String pwd = data.getString("password");
			String dig = Digest.getMD5(pwd);
			
			call.setString(argCount++, data.getString("useragent"));
			call.setString(argCount++, data.getString("username"));
			call.setString(argCount++, pwd);
			call.setString(argCount++, dig);
			
			if (isRobot) {
				call.setString(argCount++, data.getString("imei"));
				sessionId = wssSessionId;
				pipes.put(sessionId, this);
			}
			
			call.setString(argCount++, sessionId);

			call.registerOutParameter(argCount++, Types.BIGINT);
			
			ResultSet rs = call.executeQuery();

			/**
			 * 
			 * 输出
			 * 
			 */
			bindList = new ArrayList<>();
			while (rs.next()) {
				ViewRemoteUserRobotBindListId item = new ViewRemoteUserRobotBindListId();

				item.setRobotId(rs.getLong("ROBOT_ID"));
				item.setRobotName(rs.getString("ROBOT_NAME"));
				item.setRobotImei(rs.getString("ROBOT_IMEI"));
				item.setRobotActivateDatetime(rs.getTimestamp("ROBOT_ACTIVATE_DATETIME"));
				item.setRobotLatestStatusUpdateDatetime(rs
						.getTimestamp("ROBOT_LATEST_STATUS_UPDATE_DATETIME"));
				item.setRobotLatestStatusWssSessionId(rs
						.getString("ROBOT_LATEST_STATUS_WSS_SESSION_ID"));
				item.setRobotLatestStatusOnline(rs
						.getBoolean("ROBOT_LATEST_STATUS_ONLINE"));
				item.setRobotLatestStatusExtraInfo(rs
						.getString("ROBOT_LATEST_STATUS_EXTRA_INFO"));
				item.setUserId(rs.getLong("USER_ID"));
				item.setIsActivateUser(rs.getBoolean("IS_ACTIVATE_USER"));
				item.setUserName(rs.getString("USER_NAME"));
				item.setUserPassword(rs.getString("USER_PASSWORD"));
//				item.setUserGroupId(rs.getLong("USER_GROUP_ID"));
//				item.setUserGroupName(rs.getString("USER_GROUP_NAME"));
				item.setUserLastestStatusUpdateDatetime(rs
						.getTimestamp("USER_LASTEST_STATUS_UPDATE_DATETIME"));
//				item.setUserLastestStatusWssSessionId(rs
//						.getString("USER_LASTEST_STATUS_WSS_SESSION_ID"));
				item.setUserLastestStatusWssSessionId(sessionId);
				item.setUserLastestStatusOnline(rs
						.getBoolean("USER_LASTEST_STATUS_ONLINE"));
//				item.setUserLastestStatusExtraInfo(rs
//						.getString("USER_LASTEST_STATUS_EXTRA_INFO"));

//				item.setRobotManualMode(rs
//						.getBoolean("ROBOT_MANUAL_MODE"));
//				item.setUserGroupIndustryId(rs
//						.getLong("user_Group_Industry_Id"));
//				item.setUserGroupSceneId(rs
//						.getLong("user_Group_Scene_Id"));
//				item.setUserGroupIndustryName(rs
//						.getString("user_Group_Industry_Name"));
//				item.setUserGroupSceneName(rs
//						.getString("user_Group_Scene_Name"));
				
				bindList.add(item);
			}
			
			result.setData(bindList);
			
			if (bindList.size() == 0) {
				logger.error("login faile");
				throw new Exception(isRobot? "登录用户名、密码或IMEI错误" : "登录用户名或密码错误");
			} else {
				currentEp = RemoteDBFunctionUtils.getRemoteEndPointBySessionId(sessionId);
				
				logger.info(epDescription(sessionId) + " has login！");
				broadcastStatus(bindList, isRobot, true);
			}
				
			long loginCount = 0;
			if (isRobot) {
				loginCount = call.getLong(--argCount);
			}
			logger.info("login count=" + loginCount);
		} catch (SQLException t) {
			result.setCode(t.getSQLState());
			result.setMessage(t.getMessage());
			result.setCmd("error");
    	} catch (Throwable t) {
			result = WSSResult.unknowException(t);
    	}

		
    	return  result.toString();
	}
	
	public void broadcast(RTCWssCommandEnum cmd, JSONObject data) throws Throwable {
		
		if (bindList != null && getCurrentEp() != null) {
			for (ViewRemoteUserRobotBindListId item : bindList){
				// 向其他终端广播登录消息
				JSONObject broadcast = new JSONObject();
				broadcast.put("cmd", cmd.toString());
				broadcast.put("data", data);
				p2pSend(sessionId,
						getCurrentEp().getIsRobot()? item.getUserLastestStatusWssSessionId() : item.getRobotLatestStatusWssSessionId()
								, broadcast.toString());
			}
			
		}
	}

	
	/**
	 * 广播状态给相关的终端
	 * @param r
	 * @param isRobot
	 * @param b
	 * @throws Throwable
	 */
	private void broadcastStatus(List<ViewRemoteUserRobotBindListId> r, boolean isRobot, boolean b) throws Throwable {
		// TODO Auto-generated method stub
		
		if (r != null ) {
			
			JSONObject broadcast = new JSONObject();
			broadcast.put("cmd", "endpoint_status_changed");
			JSONObject broadcastData = new JSONObject();
			broadcastData.put("id", isRobot? r.get(0).getRobotId() : r.get(0).getUserId());
			broadcastData.put("online", b);
			broadcast.put("data", broadcastData);
			
			
			for (ViewRemoteUserRobotBindListId item : r) {
				// 向其他终端广播登录消息
				
				boolean isOnline =
						isRobot? item.getUserLastestStatusOnline() : item.getRobotLatestStatusOnline();
						if (isOnline) {
							p2pSend(sessionId
									, isRobot? item.getUserLastestStatusWssSessionId() : item.getRobotLatestStatusWssSessionId()
											, broadcast.toString());
						}
			}
		}
	}
	public void serverSend(String epToId, String data) {
		p2pSend(null, epToId, data);
	}

	/**
	 * wss 消息发送
	 * @param epFrom
	 * @param epTo
	 * @param data
	 */
	private static void p2pSend(ViewRemoteEndpointLatestStatusId epFrom , ViewRemoteEndpointLatestStatusId epTo, String data) {
		try {
			if (epTo != null) {
				p2pSend(epFrom == null? null : epFrom.getWssSessionId(), epTo.getWssSessionId(), data);
			}
		} catch (Throwable e) {
			// TODO Auto-generated catch block
			throw new RuntimeException(e);
		}
	}
	
	/**
	 * wss 消息发送
	 * @param epFrom
	 * @param epTo
	 * @param data
	 */
	private static void p2pSend(String epFromId , String epToId, String data) {
		try {
			
			
			WsOutbound bound = 
					pipes.containsKey(epToId)?
					pipes.get(epToId).getWsOutbound() : null;
			
			if (bound != null) {
				
				bound.writeTextMessage(CharBuffer.wrap(data));
				String trace = String.format("SEND DATA [%s] -> [%s]: '%s'"
						, epFromId == null? "<SERVER>" : epFromId, epToId, data);
				logger.info(trace + "\r\nsent done.");
			} else {
				logger.error("sent fail! bound no exists [" + epToId + "]");
				
				boolean inLogout = false;
				for (StackTraceElement th : Thread.currentThread().getStackTrace()) {
					if ("logout".equals(th.getMethodName())) {
						inLogout = true;
						break;
					}
				}
				
				if (!inLogout) {
					logger.error(epToId + "！！！！！！！！！管道破裂，注销状态！！！！！！");
					logout_new(epToId);
				}
			}
		} catch (Throwable e) {
			// TODO Auto-generated catch block
			throw new RuntimeException(e);
		}
	}
	@Override
	protected void onClose(int status) {
		// TODO Auto-generated method stub
		super.onClose(status);
		
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			String strEp = epDescription();
			logger.info(strEp+ " wss close. ");
			if (pipes.containsKey(sessionId)) {
				pipes.remove(sessionId);
				ViewRemoteEndpointLatestStatusId ep = getCurrentEp();
				if (ep != null && getCurrentEp().getIsRobot()) {
					logout_new(sessionId);
					logger.info(strEp + " has logout, status=" + status);
				}
			} else {
				logger.error(strEp + " not exists!!!");
			}
			
			
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				trans.rollback();
			}
			logger.error(t.getMessage());
		}
	}
}
