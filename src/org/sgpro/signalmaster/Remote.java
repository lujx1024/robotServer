package org.sgpro.signalmaster;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 远程控制  接口
 * CREATE BY LvDW
 * 2018-04-27
 * */
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.hibernate.Transaction;
import org.json.JSONObject;
import org.sgpro.db.HibSf;
import org.sgpro.db.ViewRemoteRobotConfigForAndroid;
import org.sgpro.db.ViewRemoteRobotList;
import org.sgpro.db.ViewRemoteSelectUserinfoList;
import org.sgpro.db.ViewRemoteVoice;
import org.sgpro.util.DateUtil;
import org.sgpro.util.Digest;
import org.sgpro.util.http.Request;
import org.sgpro.util.http.Response;

@Path("/remote")
public class Remote extends HttpServlet {
	static Logger logger = Logger.getLogger(Remote.class.getName());

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Remote() {
		super();
		// TODO Auto-generated constructor stub
	}

	@Context
	private HttpServletRequest request;
	@Context
	private HttpServletResponse response;

	/**
	 * 输出日志
	 */
	long prevTicks = 0;

	public void outputLog(String str) {
		long thisTics = System.currentTimeMillis();
		long tooks = prevTicks == 0 ? 0 : thisTics - prevTicks;
		logger.info(String.format("CURRENT:[%s] TOOKS:[%04d] %s", DateUtil.toDefaultFmtString(thisTics), tooks, str));
		prevTicks = thisTics;
	}

	/**
	 * 记录日志
	 */
	public void recordLog(long userId, String work, String robotSn) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
		Date date = new Date();
		outputLog("系统当前时间：" + sdf.format(date));
		outputLog("往数据库存日志:" + userId + "," + work);
		ViewUtils.dbSql("INSERT INTO REMOTE_LOGGING (USER_ID,DATE,WORK,ROBOT_SN) VALUES(?,?,?,?)", userId,
				sdf.format(date), work, robotSn);

	}

	/**
	 * 用户登录接口
	 */
	@Path("login")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String login(@FormParam("userName") String userName, @FormParam("password") String password,
			@FormParam("sessionId") String sessionId) throws Throwable {
		Result r = Result.success();
		Transaction trans = null;

		try {
			trans = HibSf.getSession().beginTransaction();

			sessionId = Digest.getMD5(String.valueOf(System.currentTimeMillis()));

			try {
				r.setUserId(ViewUtils.dbFunc1("SELECT USER_ID FROM REMOTE_USERINFO WHERE USER_NAME=? AND PASSWORD = ?",
						userName, password));
			} catch (Throwable th) {
				th.printStackTrace();
			}

			r.setSessionId(sessionId);

			// CallableStatement call = connection
			// .prepareCall(
			// "SELECT COUNT(USER_NAME) AS RET FROM REMOTE_USERINFO WHERE
			// USER_ID = ? AND LOGGIN_SESSION = ?"
			// );
			//// ret = ViewUtils.dbProc("SP_REMOTE_LIMITS", userId,robotId);
			// call.setLong(1,userId );
			// call.setString(2,sessionId );
			//
			// ResultSet rs = call.executeQuery();
			//
			// while(rs.next()){
			// count = rs.getInt("RET");
			// }

			ViewUtils.dbProc(" SP_REMOTE_LOGIN", userName, password, Digest.getMD5(password), sessionId);

			r.setData(ViewUtils.getViewDataList(
					ViewUtils.dbProcQuery(ViewRemoteRobotList.class, " SP_REMOTE_LOGIN_BY_USERID", r.getUserId())));
			trans.commit();
		} catch (Throwable th) {
			r = Result.unknowException(th);
			th.printStackTrace();

			try {
				if (trans != null) {
					trans.rollback();
				}
			} catch (Throwable t) {
				r = Result.unknowException(t);
				t.printStackTrace();
			}
		}

		return r.toString();
	}

	/**
	 * 获取单个机器人的语料配置
	 * 
	 * @param robotSn
	 * @param userId
	 * @param sessionId
	 * @return
	 * @throws Throwable
	 */
	@Path("/selectvoice")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String getVoice(@FormParam("robotImei") String robotSn, @FormParam("userId") long userId,
			@FormParam("sessionId") String sessionId) throws Throwable {

		Result r = Result.success();

		Transaction trans = null;

		Connection connection = null;

		int count = 0;
		try {
			connection = HibSf.getConnection();
			connection.setAutoCommit(false);
			trans = HibSf.getSession().beginTransaction();

			CallableStatement call = connection.prepareCall(
					"SELECT COUNT(USER_NAME) AS RET FROM REMOTE_USERINFO WHERE USER_ID = ? AND LOGGIN_SESSION = ?");
			// ret = ViewUtils.dbProc("SP_REMOTE_LIMITS", userId,robotId);
			call.setLong(1, userId);
			call.setString(2, sessionId);

			ResultSet rs = call.executeQuery();

			while (rs.next()) {
				count = rs.getInt("RET");
			}

			r.setIsSession(String.valueOf(count));

			r.setData(ViewUtils.getViewDataList(
					ViewUtils.dbProcQuery(ViewRemoteVoice.class, " SP_REMOTE_GET_VOICE", robotSn, userId)));

			recordLog(userId, "接管机器人", robotSn);

			connection.commit();
			trans.commit();
		} catch (Throwable th) {
			r = Result.unknowException(th);
			th.printStackTrace();

			try {
				if (connection != null) {
					connection.rollback();
				}

				if (trans != null) {
					trans.rollback();
				}
			} catch (Throwable t) {
				r = Result.unknowException(t);
				t.printStackTrace();
			}
		}
		return r.toString();
	}

	

	/**
	 * 2.4自定义语料扩展
	 */
	@Path("/savevoice")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String saveVoice(@FormParam("voiceType") String voiceType, @FormParam("voiceName") String voiceName,
			@FormParam("voicePath") String voicePath, @FormParam("voiceText") String voiceText,
			@FormParam("voiceCat") String voiceCat, @FormParam("voiceDescription") String voiceDescription,
			@FormParam("voiceCommand") String voiceCommand, @FormParam("voiceCommandParam") String voiceCommandParam,
			@FormParam("voiceThirdpardName") String voiceThirdpardName,
			@FormParam("voiceThirdparTypeMethod") String voiceThirdparTypeMethod,
			@FormParam("voiceThirdpartyapiHeaderparams") String voiceThirdpartyapiHeaderparams,
			@FormParam("voiceThirdpartyapiUrl") String voiceThirdpartyapiUrl,
			@FormParam("voiceThirdpartyapiResulttype") String voiceThirdpartyapiResulttype,
			@FormParam("voiceThirdpartyapiRunatserver") boolean voiceThirdpartyapiRunatserver,
			@FormParam("voiceIncprop") String voiceIncprop, @FormParam("voiceExcerpt") String voiceExcerpt,
			@FormParam("voiceEmotion") String voiceEmotion, @FormParam("voiceEnabled") boolean voiceEnabled,
			@FormParam("remake1") String remake1, @FormParam("remake2") String remake2,
			@FormParam("userId") long userId, @FormParam("robotImei") String robotSn) throws Throwable {
		Result r = Result.success();

		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();

			ViewUtils.dbSql(
					"INSERT INTO REMOTE_VOICE(VOICE_TYPE,VOICE_NAME,VOICE_PATH,VOICE_TEXT,VOICE_CAT,VOICE_DESCRIPTION, VOICE_COMMAND,"
							+ "VOICE_COMMAND_PARAM,VOICE_THIRDPARTYAPI_NAME,VOICE_THIRDPARTYAPI_METHOD,VOICE_THIRDPARTYAPI_HEADERPARAMS,"
							+ "VOICE_THIRDPARTYAPI_URL,VOICE_THIRDPARTYAPI_RESULTTYPE,VOICE_THIRDPARTYAPI_RUNATSERVER,VOICE_INCPROP,"
							+ "VOICE_EXCPROP,VOICE_EMOTION,VOICE_ENABLED,REMAKE1,REMAKE2,ROBOT_SN)  VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
					voiceType, voiceName, voicePath, voiceText, voiceCat, voiceDescription, voiceCommand,
					voiceCommandParam, voiceThirdpardName, voiceThirdparTypeMethod, voiceThirdpartyapiHeaderparams,
					voiceThirdpartyapiUrl, voiceThirdpartyapiResulttype, voiceThirdpartyapiRunatserver, voiceIncprop,
					voiceExcerpt, voiceEmotion, voiceEnabled, remake1, remake2, robotSn);

			recordLog(userId, "增加机器人语料" + voiceName, robotSn);

			trans.commit();
		} catch (Throwable th) {
			r = Result.unknowException(th);
			th.printStackTrace();

			try {
				if (trans != null) {
					trans.rollback();
				}
			} catch (Throwable t) {
				r = Result.unknowException(t);
				t.printStackTrace();
			}
		}

		return r.toString();
	}

	/**
	 * 增加用户
	 */
	@Path("/adduser")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String addUser(@FormParam("userName") String userName, @FormParam("password") String password,
			@FormParam("userLevel") String userLevel, @FormParam("userRelateRobot") String userRelateRobot)
			throws Throwable {

		Result r = Result.success();

		Transaction trans = null;

		try {
			trans = HibSf.getSession().beginTransaction();

			String[] robotList = userRelateRobot.split(",");
			long time = System.currentTimeMillis();
			ViewUtils.dbSql(
					"INSERT INTO REMOTE_USERINFO(USER_ID,USER_NAME,PASSWORD,USER_LEVEL,EXTRA_INFO) VALUES(?,?,?,?,?)",
					time, userName, password, userLevel, "PC");

			for (int i = 0; i < robotList.length; i++) {
				ViewUtils.dbSql("INSERT INTO REMOTE_USER_ROBOT(USER_ID,ROBOT_SN) VALUES(?,?)", time,
						robotList[i].trim());
			}

			recordLog(000l, "新建用户" + userName, "");

			trans.commit();
		} catch (Throwable th) {
			r = Result.unknowException(th);
			th.printStackTrace();

			try {
				if (trans != null) {
					trans.rollback();
				}
			} catch (Throwable t) {
				r = Result.unknowException(t);
				t.printStackTrace();
			}
		}
		return r.toString();

	}

	/**
	 * 修改用户
	 */
	@Path("/updateuser")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String updateUser(@FormParam("userId") long userId, @FormParam("userName") String userName,
			@FormParam("password") String password, @FormParam("userLevel") String userLevel,
			@FormParam("userRelateRobot") String userRelateRobot) throws Throwable {

		Result r = Result.success();

		Transaction trans = null;

		try {
			trans = HibSf.getSession().beginTransaction();

			String[] robotList = userRelateRobot.split(",");
			ViewUtils.dbSql("UPDATE REMOTE_USERINFO SET USER_NAME=?,PASSWORD=?,USER_LEVEL=? WHERE USER_ID=?", userName,
					password, userLevel, userId);
			ViewUtils.dbSql("DELETE FROM REMOTE_USER_ROBOT WHERE USER_ID=?", userId);

			for (int i = 0; i < robotList.length; i++) {
				ViewUtils.dbSql("INSERT INTO REMOTE_USER_ROBOT(USER_ID,ROBOT_SN) VALUES(?,?)", userId,
						robotList[i].trim());
			}

			recordLog(000l, "修改用户" + userName, "");

			trans.commit();
		} catch (Throwable th) {
			r = Result.unknowException(th);
			th.printStackTrace();

			try {
				if (trans != null) {
					trans.rollback();
				}
			} catch (Throwable t) {
				r = Result.unknowException(t);
				t.printStackTrace();
			}
		}
		return r.toString();

	}

	/**
	 * 删除用户
	 */
	@Path("/deleteuser")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String deleteUser(@FormParam("userId") long userId) throws Throwable {

		Result r = Result.success();

		Transaction trans = null;

		try {
			trans = HibSf.getSession().beginTransaction();

			ViewUtils.dbSql("DELETE FROM REMOTE_USERINFO WHERE USER_ID=?", userId);

			ViewUtils.dbSql("DELETE FROM REMOTE_USER_ROBOT WHERE USER_ID=?", userId);

			recordLog(000l, "删除用户" + userId, "");

			trans.commit();
		} catch (Throwable th) {
			r = Result.unknowException(th);
			th.printStackTrace();

			try {
				if (trans != null) {
					trans.rollback();
				}
			} catch (Throwable t) {
				r = Result.unknowException(t);
				t.printStackTrace();
			}
		}
		return r.toString();

	}

	/**
	 * 查询用户 目前数据组装有问题
	 */
	@Path("/selectuser")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String deleteUser() throws Throwable {

		Result r = Result.success();

		Transaction trans = null;

		try {
			trans = HibSf.getSession().beginTransaction();

			r.setData(ViewUtils.getViewDataList(ViewUtils.dbProcQuery1(ViewRemoteSelectUserinfoList.class,
					" SELECT USER_ID,USER_NAME,PASSWORD,USER_LEVEL,ISNULL(ROBOT_SN,'') AS ROBOT_SN FROM VIEW_REMOTE_SELECT_USERINFO_LIST")));

			recordLog(000l, "查询用户", "");
			trans.commit();
		} catch (Throwable th) {
			r = Result.unknowException(th);
			th.printStackTrace();

			try {
				if (trans != null) {
					trans.rollback();
				}
			} catch (Throwable t) {
				r = Result.unknowException(t);
				t.printStackTrace();
			}
		}
		return r.toString();

	}

	/**
	 * Android端获取机器人配置
	 */
	@Path("/selectconfig")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String selectCamera(@FormParam("robotImei") String robotSn, @FormParam("userId") long userId,
			@FormParam("sessionId") String sessionId) throws Throwable {
		Result r = Result.success();
		Connection connection = null;

		Transaction trans = null;

		int count = 0;

		try {
			trans = HibSf.getSession().beginTransaction();

			connection = HibSf.getConnection();

			connection.setAutoCommit(false);

			// count = ViewUtils.sqlNonQuery("SELECT COUNT(USER_NAME) FROM
			// REMOTE_USERINFO WHERE USER_ID = ? AND LOGGIN_SESSION = ?",
			// userId,sessionId);
			CallableStatement call = connection.prepareCall(
					"SELECT COUNT(USER_NAME) AS RET FROM REMOTE_USERINFO WHERE USER_ID = ? AND LOGGIN_SESSION = ?");
			// ret = ViewUtils.dbProc("SP_REMOTE_LIMITS", userId,robotId);
			call.setLong(1, userId);
			call.setString(2, sessionId);

			ResultSet rs = call.executeQuery();

			while (rs.next()) {
				count = rs.getInt("RET");
			}

			r.setIsSession(String.valueOf(count));

			int RET = ViewUtils.dbProc("SP_REMOTE_ANDROID_LIMITS", userId, robotSn);
			r.setIsLimit(Integer.toString(RET));
			r.setData(ViewUtils.getViewDataList(ViewUtils.dbProcQuery1(ViewRemoteRobotConfigForAndroid.class,
					" SELECT APP_KEY,SECRET,ACCESS_TOKEN,VOIDE_URL,CONTROL_URL,DEVICE_SERIAL,DEVICE_NAME,CAMERA_N0 FROM VIEW_REMOTE_ROBOT_CONFIG_FOR_ANDROID WHERE ROBOT_SN='"
							+ robotSn + "'")));

			recordLog(userId, "安卓用户加载视频地址和控制界面", robotSn);

			connection.commit();
			trans.commit();

		} catch (Throwable th) {
			r = Result.unknowException(th);
			th.printStackTrace();

			try {
				if (connection != null) {
					connection.rollback();
				}
				if (trans != null) {
					trans.rollback();
				}
			} catch (Throwable t) {
				r = Result.unknowException(t);
				t.printStackTrace();
			}
		}
		return r.toString();

	}

	/**
	 * 用户登出
	 */
	/**
	 * 用户登出
	 */
	@Path("/userlogout")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String userLogout(@FormParam("userId") long userId, @FormParam("sessionId") String sessionId)
			throws Throwable {

		Result r = Result.success();
		Connection connection = null;
		Transaction trans = null;
		try {
			connection = HibSf.getConnection();
			// connection.setAutoCommit(false);
			trans = HibSf.getSession().beginTransaction();
			CallableStatement call = connection.prepareCall(
					"SELECT  A.ID AS ROBOT_ID  FROM ENT_ROBOT A,REMOTE_ROBOTINFO B WHERE A.IMEI = B.ROBOT_SN AND B.USER_ID =  ?");
			call.setLong(1, userId);
			ResultSet rs = call.executeQuery();
			long target = 0;
			while (rs.next()) {
				target = rs.getLong("ROBOT_ID");
			}
			// connection.commit();
			if (target > 0) {
				String date = "{cmd: \"manual_mode_switch\", data: {target:\"" + target + "\",sessionId:\"" + sessionId
						+ "\",manualModeStatus:\"0\"}}";
				JSONObject jo = new JSONObject(date);
				RTCWssStreamInBound rtc = new RTCWssStreamInBound();
				rtc.wssCommand(RTCWssCommandEnum.manual_mode_switch, jo);
			}

			ViewUtils.dbProc("SP_REMOTE_USER_LOGOUT", userId, sessionId);
			recordLog(userId, "用户登出", "");
			trans.commit();

		} catch (Throwable th) {
			r = Result.unknowException(th);
			th.printStackTrace();

			try {
				if (trans != null) {
					trans.rollback();
				}
				if (connection != null) {
					connection.rollback();
				}
			} catch (Throwable t) {
				r = Result.unknowException(t);
				t.printStackTrace();
			}
		}
		return r.toString();

	}

	/**
	 * 删除配置
	 */
	@Path("/deletevoice")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String deleteVoice(@FormParam("userId") long userId, @FormParam("sessionId") String sessionId,
			@FormParam("voiceId") String voiceId) throws Throwable {

		Result r = Result.success();

		Transaction trans = null;

		try {
			trans = HibSf.getSession().beginTransaction();

			String[] voiceIdList = voiceId.split(",");

			for (int i = 0; i < voiceIdList.length; i++) {
				ViewUtils.dbProc("SP_REMOTE_DELETE_VOICE", userId, sessionId, voiceIdList[i]);
			}

			recordLog(userId, "用户删除配置", "");

			trans.commit();
		} catch (Throwable th) {
			r = Result.unknowException(th);
			th.printStackTrace();

			try {
				if (trans != null) {
					trans.rollback();
				}
			} catch (Throwable t) {
				r = Result.unknowException(t);
				t.printStackTrace();
			}
		}
		return r.toString();

	}

	/**
	 * Android端查询机器人在线状态
	 */
	@Path("/getonline")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String getOnline(@FormParam("userId") long userId) throws Throwable {

		Result r = Result.success();

		Connection connection = null;

		try {

			connection = HibSf.getConnection();
			connection.setAutoCommit(false);
			CallableStatement call = connection.prepareCall(
					"SELECT ROBOT_IMEI,ROBOT_LATEST_STATUS_ONLINE from VIEW_REMOTE_USER_ROBOT_BIND_LIST WHERE USER_ID = ?");
			call.setLong(1, userId);

			ResultSet rs = call.executeQuery();

			List<Map<String, String>> pushNotifyList = new ArrayList<Map<String, String>>();

			while (rs.next()) {
				Map<String, String> pushNotify = new HashMap<String, String>();
				pushNotify.put("statusOnline", rs.getString("ROBOT_LATEST_STATUS_ONLINE"));
				pushNotify.put("robotSn", rs.getString("ROBOT_IMEI"));
				pushNotifyList.add(pushNotify);
			}

			r.setData(pushNotifyList);

			connection.commit();
		} catch (Throwable th) {
			r = Result.unknowException(th);
			th.printStackTrace();

			try {
				if (connection != null) {
					connection.rollback();
				}
			} catch (Throwable t) {
				r = Result.unknowException(t);
				t.printStackTrace();
			}
		}
		return r.toString();

	}

	/**
	 * 人工从页面上手动获取萤石第三方的AccessToken 并存入数据库中
	 */
	@Path("/getAndSetAccessToken")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String getAndSetAccessToken() throws Throwable {
		Result r = new Result();

		Transaction trans = null;

		try {
			trans = HibSf.getSession().beginTransaction();
			Request req = new Request();
			String date = null;
			String url = "https://open.ys7.com/api/lapp/token/get?appKey=47944ece9e834bb7bfae0947ed21f655&appSecret=54bd4dcabb45f5f4f28475de624f33ce";
			Response rsp = null;
			String ret = null;
			try {

				rsp = req.getResponse(url, date);
				ret = rsp.asString();
				JSONObject jo = new JSONObject(ret);
				String code = jo.optString("code");
				String msg = jo.optString("msg");
				String data = "";
				if ("200".equals(code)) {
					data = jo.optString("data");
					JSONObject jo1 = new JSONObject(data);
					logger.info("获取到正确的AccessToken为：" + jo1.optString("accessToken") + ",获取到正确的expireTime为："
							+ jo1.optString("expireTime"));
					ViewUtils.dbSql("UPDATE REMOTE_CAMERAINFO SET ACCESS_TOKEN = ?", jo1.optString("accessToken"));
					r.setData(jo1.opt("accessToken"));
				}
				r.setCode(code);
				r.setMessage(msg);
				logger.info("获取AccessToken的结果为：" + msg);
			} catch (Throwable e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				logger.info("获取AccessToken出现异常！");
			}
			trans.commit();
		} catch (Throwable th) {
			r = Result.unknowException(th);
			th.printStackTrace();

			try {
				if (trans != null) {
					trans.rollback();
				}
			} catch (Throwable t) {
				r = Result.unknowException(t);
				t.printStackTrace();
			}
		}
		return r.toString();

	}

}
