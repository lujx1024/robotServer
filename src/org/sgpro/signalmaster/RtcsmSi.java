package org.sgpro.signalmaster;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.io.StringReader;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.catalina.websocket.StreamInbound;
import org.apache.catalina.websocket.WsOutbound;
import org.apache.log4j.Logger;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.sgpro.signalmaster.Roomes.Client;
import org.sgpro.signalmaster.Roomes.Room;

import com.google.gson.Gson;
import com.google.gson.stream.JsonReader;

import config.Log4jInit;

public class RtcsmSi extends StreamInbound {

	static Logger logger = Logger.getLogger(RtcsmSi.class.getName());
	static class ChatSession {
		public RtcsmSi offer;
		public RtcsmSi answer;
		public ChatSession(RtcsmSi offer, RtcsmSi answer) {
			super();
			this.offer = offer;
			this.answer = answer;
		}
		 
	}
	
	static Map<String, HashSet<RtcsmSi>> rooms = new HashMap<String, HashSet<RtcsmSi>>();

	private HttpServletRequest request;
	private String sessionId ;
	public RtcsmSi(String arg0, HttpServletRequest arg1) {
		// TODO Auto-generated constructor stub
		request = arg1;
		String prefix = arg0;
		sessionId = request.getSession().getId();
		pipes.put(sessionId, this);
	}


	public abstract class WsCommand {
		private String cmd;

		public String getCmd() {
			return cmd;
		}

		public void setCmd(String cmd) {
			this.cmd = cmd;
		}

		public WsCommand() {
			super();
			// TODO Auto-generated constructor stub
		}

		public WsCommand(String cmd) {
			super();
			this.cmd = cmd;
		}
		
		
	}
	
	public class WsClient extends WsCommand {
		private String clientid;
		private String roomid;
		private RtcsmSi bindwsPipe;
		
		public String getClientid() {
			return clientid;
		}
		public void setClientid(String clientid) {
			this.clientid = clientid;
		}
		public String getRoomid() {
			return roomid;
		}
		public void setRoomid(String roomid) {
			this.roomid = roomid;
		}
		public WsClient(String clientid, String roomid) {
			super();
			this.clientid = clientid;
			this.roomid = roomid;
		}
		public WsClient() {
			super();
			// TODO Auto-generated constructor stub
		}
		public WsClient(String cmd) {
			super(cmd);
			// TODO Auto-generated constructor stub
		}
		
		@Override
		public int hashCode() {
			// TODO Auto-generated method stub
			return clientid.hashCode() ;
		}
		
		public RtcsmSi getBindwsPipe() {
			return bindwsPipe;
		}
		public void setBindwsPipe(RtcsmSi bindwsPipe) {
			this.bindwsPipe = bindwsPipe;
		}
		@Override
		public boolean equals(Object arg0) {
			// TODO Auto-generated method stub
			WsClient wsc = (WsClient)arg0;
			return clientid.equals(wsc.getClientid()) && roomid.equals(wsc.getRoomid());
		}
	}
	
	
	public class WsMsgbody extends JSONObject {
		
		// answer
		// offer
		// bye
		// candidate
		
		public String getType() {
			return optString("type");
		}

		public void setType(String type) {
			try {
				put("type", type);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		public WsMsgbody(String source) throws JSONException {
			super(source);
		}
		
		public WsMsgbody() {
			// TODO Auto-generated constructor stub
		}
	}
	
	class WsSend extends WsCommand {
		private String msg;

		public String getMsg() {
			return msg;
		}

		public void setMsg(String msg) {
			this.msg = msg;
		}
	}
	

	class WsReponse {
		private WsMsgbody msg;

		public WsMsgbody getMsg() {
			return msg;
		}

		public void setMsg(WsMsgbody msg) {
			this.msg = msg;
		}
		
		private String error;

		public String getError() {
			return error;
		}

		public void setError(String error) {
			this.error = error;
		}
		
		@Override
		public String toString() {
			// TODO Auto-generated method stub
			JSONObject jo = new JSONObject();
			
			try {
				
				jo.put("error", error);
				jo.put("msg", msg.toString());
			} catch (Throwable t) {
				
			}
			
			return jo.toString();
		}
		
	}
	
	
	public static Map<String, WsClient> registeredClients
		= new HashMap<String, RtcsmSi.WsClient>();
	
	public static Map<String, RtcsmSi> pipes = new HashMap<String, RtcsmSi>();
	// public static Map<>
	
	
	public enum EndPointType {
		  PCBrowser
		, RobotApp
	}
	
	public enum EndPointStatus {
		Login,
		RequestDial,
		AnswerDial,
		EndDial
	}
	
	class EndPoint {
		// 管道id， 对应输入输出
		public String pipeId;
		// 终端类型，浏览器/应用
		public EndPointType type;
		// 终端id
		public long  endpointId;				
		// 终端状态
		public EndPointStatus status;
	}
	
	static List<EndPoint> online = new ArrayList<EndPoint>();
	
	static EndPoint findEpByPipeId(String pipeId) {
		EndPoint ret = null;
		
		for (EndPoint ep : online) {
			if (pipeId.equals(ep.pipeId)) {
				ret = ep;
				break;
			}
		}
		
		return ret;
	}
	
	static EndPoint findEp(long epId, EndPointType epType) {
		EndPoint ret = null;
		
		for (EndPoint ep : online) {
			if (epId  == ep.endpointId && epType.equals(ep.type)) {
				ret = ep;
				break;
			}
		}
		
		return ret;
	}
 	
	static Map<Long, Long> requestMap = new HashMap<>();
	
	@Override
	protected void onTextData(Reader arg0) throws IOException {
		// TODO Auto-generated method stub
		try {
			StringBuffer sb = new StringBuffer();
			char[] cbuf = new char[4096];
			
			int count = 0;
			while ((count = arg0.read(cbuf)) != -1) {
				sb.append(cbuf, 0, count);
			}
			
			
			
			String upload = sb.toString();
			JsonReader jr = new JsonReader(new StringReader(upload));
			jr.setLenient(true);
			Gson gson = GsonProvider.getGson();
			JSONObject jo = new JSONObject(upload);
			String cmd = jo.optString("cmd");
			JSONObject data = jo.optJSONObject("data");
			// String roomId = data.optString("roomId");
		
			// System.out.println(cmd);
			logger.info(upload);
			EndPoint currentEp = findEpByPipeId(sessionId);
			// 登录，在线
			if ("login".equals(cmd)) {
				if (currentEp != null) {
					throw new IOException("has login");
				}
				currentEp = new EndPoint();
				currentEp.endpointId =  data.getLong("id");
				currentEp.pipeId = sessionId;
				currentEp.status  = EndPointStatus.Login;
				currentEp.type =  EndPointType.valueOf(data.getString("type"));
				
				online.add(currentEp);
				
				String loginMessage = "{\"cmd\" : \"login_done\"}";
				
				// pipes.get(currentEp.pipeId).getWsOutbound().writeTextMessage(CharBuffer.wrap(loginMessage));
				p2pSend(null, currentEp, loginMessage);
			} 
			
			else if ("offer".equals(cmd)  ) {
				// 呼叫请求
//                "data": {
//                "sdp": desc
//                "target" : 426 // 小机器人
//            }
				if (currentEp == null) {
					throw new Exception("can not obtain current endpoint ");
				}
				
				String sdp = data.getString("sdp");
				long   target = data.getLong("target");
				
				EndPointType targetType = 
						EndPointType.PCBrowser.equals(
						currentEp.type)? EndPointType.RobotApp : EndPointType.PCBrowser;
				EndPoint targetEp = findEp(target, targetType);
				
				if (targetEp != null && targetEp.status == EndPointStatus.Login) {
					// 把offer 传过来
					pipes.get(targetEp.pipeId).getWsOutbound().writeTextMessage(CharBuffer.wrap( jo.toString()));
					currentEp.status = EndPointStatus.RequestDial;
				} else {
					logger.error("target offline");
				}
 			} else if ("answer".equals(cmd)) {
				// 呼叫请求				
				String sdp = data.getString("sdp");
				long   target = data.getLong("target");
				
				EndPointType targetType = 
						EndPointType.PCBrowser.equals(
						currentEp.type)? EndPointType.RobotApp : EndPointType.PCBrowser;
				EndPoint targetEp = findEp(target, targetType);
				
				if (targetEp != null && targetEp.status != EndPointStatus.Login) {
					// 把 answer 传过来
					// pipes.get(targetEp.pipeId).getWsOutbound().writeTextMessage(CharBuffer.wrap( jo.toString()));
					p2pSend(currentEp, targetEp, jo.toString());
					currentEp.status = EndPointStatus.AnswerDial;
				} else {
					logger.error("target has not dialed.");
				}
 			}  else if ("candidate".equals(cmd)) {
				long   target = data.getLong("target");
				
				EndPointType targetType = 
						EndPointType.PCBrowser.equals(
						currentEp.type)? EndPointType.RobotApp : EndPointType.PCBrowser;
				EndPoint targetEp = findEp(target, targetType);
				
				if (targetEp != null) {
					// 传 candidate
					// pipes.get(targetEp.pipeId).getWsOutbound().writeTextMessage(CharBuffer.wrap( jo.toString()));
					p2pSend(currentEp, targetEp, jo.toString());
					currentEp.status = EndPointStatus.AnswerDial;
				} else {
					logger.error("target has not dialed.");
				}				
 			}
			
			
//			if (!rooms.containsKey(roomId)) {
//				// 新来的
//				HashSet<RtcsmSi> hs = new HashSet<RtcsmSi>();
//				hs.add(this);
//				rooms.put(roomId, hs);
//			}
			
		} catch (Throwable t) {
			t.printStackTrace();
		}
	}
	
	private void p2pSend(String epIdFrom , String epIdTo, String data) {
		p2pSend(findEpByPipeId(epIdFrom), findEpByPipeId(epIdTo), data);
	}
	
	
	private void p2pSend(EndPoint epFrom , EndPoint epTo, String data) {
		try {
			
			String epIdTo = epTo.pipeId;
			
			WsOutbound bound = pipes.get(epIdTo).getWsOutbound();
			String trace = String.format("SEND DATA [%s] -> [%s]: '%s'"
					, epFrom == null? "<SERVER>" : epFrom.endpointId, epTo.endpointId, data);
			logger.info(trace);
			bound.writeTextMessage(CharBuffer.wrap(data));
			logger.info("sent done.");
		} catch (Throwable e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	protected void onTextDataOld(Reader arg0) throws IOException {
		
		try {
			
			// TODO Auto-generated method stub
			
			WsClient self = registeredClients.get(sessionId);
			
			CharBuffer response = null;
			StringBuffer sb = new StringBuffer();
			char[] cbuf = new char[4096];
			
			int count = 0;
			while ((count = arg0.read(cbuf)) != -1) {
				sb.append(cbuf, 0, count);
			}
			
			String upload = sb.toString();
			logger.info(this.getClass().getSimpleName()
					+ ".onTextData[" + (self == null? " new client " : self.clientid ) + "]:" + upload);
			
			JSONObject jo = null;
			jo = new JSONObject(upload);
			// TODO Auto-generated catch block
			
			JsonReader jr = new JsonReader(new StringReader(upload));
			jr.setLenient(true);
			Gson gson = GsonProvider.getGson();
			
			String cmd = jo.optString("cmd");
			WsReponse wsr = new WsReponse();
			WsMsgbody wmb = new WsMsgbody();
			
			if ("register".equals(cmd)) {
				WsClient wsc = gson.fromJson(jr, WsClient.class);
				wsc.setBindwsPipe(this);
				logger.info("get register command");
				
				// send sdp for new comer.
				// WsSend
				
				for (WsClient c : registeredClients.values()) {
					Room m = Roomes.getGlobalRoomes().getRoom(c.getRoomid());
					Client client = m == null? null : m.getClient(c.getClientid());
					if (client != null ) {
						Map<String, String> sdp = client.getSdp();
						
						for (String key : sdp.keySet()) {
							if ("offer".equals(key)) {
								wmb.setType(key);
								wmb.put("sdp", sdp.get(key));
								
								wsr.setMsg(wmb);
								// wsc.getBindwsPipe().getWsOutbound().writeTextMessage(CharBuffer.wrap(wsr.toString()));
								break;
							}
						}
					}
				}
				registeredClients.put(sessionId, wsc);
				
			} else if ("send".equals(cmd)) {
				WsSend wsc = gson.fromJson(jr, WsSend.class);
				logger.info("get send command");
				
				// jr = new JsonReader(new StringReader( wsc.getMsg()));
				// jr.setLenient(true);
				// WsMsgbody wsm = gson.fromJson(jr, WsMsgbody.class);
				WsMsgbody body = null;
				
				body = new WsMsgbody(wsc.getMsg());
				
				if ("bye".equals(body.getType())) {
					// wsc.get
					byebye();
				} else if ("answer".equals(body.getType())) {
					// self = registeredClients.get(sessionId);
					
					/// for (WsClient c : registeredClients.values()) {
					WsClient pt = getPartener();
						if (pt != null) {
							 wmb.setType(body.getType());
							 wmb.putOpt("sdp", body.optString("sdp"));
							 wsr.setMsg(wmb);
							 pt.getBindwsPipe().getWsOutbound().writeTextMessage(CharBuffer.wrap(wsr.toString()));
						}
					// }
				} else if ("candidate".equals(body.getType())) {
					// self = registeredClients.get(sessionId);
					
					// for (WsClient c : registeredClients.values()) {
					WsClient pt = getPartener();
					
						if (pt != null) {
							wmb.setType(body.getType());
							wmb.put("id", body.optString("id"));
							wmb.put("candidate", body.optString("candidate"));
							wmb.put("label", body.optInt("label"));
							wsr.setMsg(wmb);
							
							pt.getBindwsPipe().getWsOutbound().writeTextMessage(CharBuffer.wrap(wsr.toString()));
						}
					// }
				}
			}
			
		} catch (Throwable t) {
			logger.error(t.getMessage());
			throw new IOException(t);
		}
	}
	
	private void byebye() {
		// TODO Auto-generated method stub
		WsClient client = registeredClients.get(sessionId);
		
		if (client != null) {
			logger.info("rtcsmsi." + client.getClientid() + " leave from " + client.getRoomid());
			Roomes.getGlobalRoomes().leaveRoom(client.getRoomid(), client.getClientid());
			registeredClients.remove(sessionId);
		}

	}

	@Override
	protected void onBinaryData(InputStream arg0) throws IOException {
		// TODO Auto-generated method stub
		// getWsOutbound().writeTextMessage(CharBuffer.wrap("recevied binary"));
		
		
		
		int length = 4096;
		byte[] buffer = new byte[length];
		int readCount =  0;
		ByteArrayOutputStream bao = new ByteArrayOutputStream();
		while ((readCount = arg0.read(buffer , 0, length)) > 0) {
			bao.write(buffer, 0, readCount);
		}
		
		bao.close();
		byte[] bytes = bao.toByteArray();
		
		WsClient pt = getPartener();
		if (pt != null) {
			pt.getBindwsPipe().getWsOutbound().writeBinaryMessage(ByteBuffer.wrap(bytes));
		}
		
		logger.info("recevied binary");
		
		// Logger g = Logger.getAnonymousLogger();
		// g.
		
	}
	
	protected WsClient getPartener() {
		WsClient  ret = null;
		WsClient  self = registeredClients.get(sessionId);
		

		if (self != null) {
			for (WsClient c : registeredClients.values()) {
				// Room m = Roomes.getGlobalRoomes().getRoom(c.getRoomid());
				
				if (c.getRoomid().equals(self.getRoomid()) && !self.equals(c)) {
					ret = c;
					break;
				}
			}		
			
		}
		return ret;
	}


	@Override
	protected void onClose(int status) {
		// TODO Auto-generated method stub
		super.onClose(status);
		byebye();
	 	EndPoint pp = findEpByPipeId(sessionId);
	 	if (pp != null) {
	 		logger.info("wss closed. sessionId:" + sessionId + " ep: " + pp.endpointId);
	 		pipes.remove(sessionId);
	 		online.remove(pp);
	 	}
	}

	@Override
	protected void onOpen(WsOutbound outbound) {
		// TODO Auto-generated method stub
		super.onOpen(outbound);
	}
	
	

}
