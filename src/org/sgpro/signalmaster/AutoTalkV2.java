package org.sgpro.signalmaster;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.NavigableSet;
import java.util.Random;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.UUID;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import net.sf.json.xml.XMLSerializer;

import org.apache.log4j.Logger;
import org.hibernate.Transaction;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.sgpro._1988executor._1988;
import org.sgpro._nlp_external.NLP;
import org.sgpro.db.EntRobot;
import org.sgpro.db.HibSf;
import org.sgpro.db.TblCustomizedConfigForRobot;
import org.sgpro.db.TblCustomizedConfigForRobotId;
import org.sgpro.db.ViewEndpointLatestStatusId;
import org.sgpro.db.ViewRemoteEndpointLatestStatusId;
import org.sgpro.db.ViewRemoteUserRobotBindListId;
import org.sgpro.db.ViewUserRobotBindListId;
import org.sgpro.db.ViewValue;
import org.sgpro.db.ViewVoiceGroup;
import org.sgpro.db.ViewVoiceGroupId;
import org.sgpro.util.ChineseGramaLex;
import org.sgpro.util.ChineseGramaLex.LexItem;
import org.sgpro.util.DateUtil;
import org.sgpro.util.ReflectUtil;
import org.sgpro.util.StringUtil;
import org.sgpro.util.http.HttpUtil;
import org.sgpro.util.http.Request;
import org.sgpro.util.http.Response;

import com.google.gson.Gson;

import config.Log4jInit;

/**
 */
@Path("/auto_talk")
public class AutoTalkV2  extends HttpServlet  {
	static Logger logger = Logger.getLogger(AutoTalkV2.class.getName());
    
    private static final int INVALID_INDEX_OR_NONARRAY = -1;

	private static final int RELAY_RANDOM_INDEX_GEN = -2;
	
	/*
	 *ADD BY LvDW 用于缓存session信息的map
	 * */
	private static Map<String,Map<String,String>> sessionInfoMap = new HashMap<String,Map<String,String>>();

	/*
	 * ADD BY LvDW 用于缓存ak对应的access_tokrn以及时间
	 * */
	public static Map<String,Map<String,Object>> accessTokenMap = new HashMap<String,Map<String,Object>>();
	
	
	/*
	 * ADD BY LvDW 用于缓存上下文返回的待确定的巡游
	 * */
	public static Map<String,String> patrolMap = new HashMap<String,String>();
	//add sunff 无法回答的问题
	private   List<Integer> list = new ArrayList<>();;
	private String [] cannotReplys=
									{
									"您这个问题问的好，不过我还不知道回答您。请问您还有什么需要我帮助的吗？",
//									"您太厉害了，我还没理解您说的话",
									"人家看到您害羞了，我都不会说话了。请问您还有什么需要我帮助的吗？",
//									"Sorry, would you please speak more slowly.",
									"您说的太快了，我没听懂。请问您还有什么需要我帮助的吗？",
									"我还小啦，我不知道怎么回答您。请问您还有什么需要我帮助的吗？",
//									"sorry, your question is too difficult. ",
//									"您是我见过的最会说话的人。",
//									"sorry, I don't know how to answer you.",
									"这个我还不会耶。请问您还有什么需要我帮助的吗？",
//									"sorry,I don't understand! Come again?",
									"您的问题好难啊，让我思考一下。请问您还有什么需要我帮助的吗？",
//									"六六六，这个问题问的好，我正好不会。",
//									"这个问题我选择沉默。",
									"你真的难倒我了。请问您还有什么需要我帮助的吗？",
									"您的问题太深奥了，这次放过我吧。请问您还有什么需要我帮助的吗？",
									"抱歉，请容我思考一下。请问您还有什么需要我帮助的吗？",
									"这个还没人教我，等我学会了再告诉您吧。请问您还有什么需要我帮助的吗？",
									"不好意思，妈妈还没有教我怎么回答。请问您还有什么需要我帮助的吗？",
									"抱歉，我没听懂，请您再说一遍",
									"不好意思，爸爸还没有教我怎么回答这个问题。请问您还有什么需要我帮助的吗？",
									"您说的太快了，我的思维都跟不上您。请问您还有什么需要我帮助的吗？",
//									"这个问题我还不知道呢，您要不问点别的吧",
									"我没听懂，您又开始调戏我啦。请问您还有什么需要我帮助的吗？",
//									"Sorry, I couldn't catch your meaning."
									};
	private void initList(){
		 
	 	 for(int i=0;i<cannotReplys.length;i++){
	 		list.add(i);
	 	 }
	}
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public AutoTalkV2() {
        super();
        initList();
        // TODO Auto-generated constructor stub
    }
    
    public String setInputParams(String text, Map<String, String> params) {
    	String ret = text;
    	
    	if (text != null && params != null) {
    		for (String param : params.keySet()) {
    			if (param != null) {
    				ret = ret.replace("@" + param,  params.get(param));
    			}
    		}
    	}
    	
    	return ret;
    }
    
    long prevTicks = 0;
    public void outputLog(String str) {
    	long thisTics = System.currentTimeMillis();
    	long tooks = prevTicks == 0? 0 : thisTics - prevTicks;
    	logger.info(
    			String.format("CURRENT:[%s] TOOKS:[%04d] %s" ,  DateUtil.toDefaultFmtString(thisTics) , tooks , str));
    	prevTicks = thisTics;
    }
    
    public static Map<Number, AutoTalkV2> ManualTalks = new HashMap<Number, AutoTalkV2>();
    
    @Context 
    private HttpServletRequest request;
    @Context 
    private HttpServletResponse  response;

	private ViewVoiceGroupId vid;
 
	public void setVid(ViewVoiceGroupId vid) {
		this.vid = vid;
	}
	
	private class Recommand  {
		private transient TreeSet<String> ori = new TreeSet<>(); 
		
		private List<String> items = new ArrayList<String>();
		public boolean add(String e) {
			// TODO Auto-generated method stub
			boolean b = ori.add(e);
			if (b) {
				items.add(e);
			}
			return b;
		}
		public boolean equals(Object o) {
			return ori.equals(o);
		}
		public int hashCode() {
			return ori.hashCode();
		}
		public Object[] toArray() {
			return ori.toArray();
		}
		public boolean removeAll(Collection<?> c) {
			return ori.removeAll(c);
		}
		public <T> T[] toArray(T[] a) {
			return ori.toArray(a);
		}
		public Iterator<String> iterator() {
			return ori.iterator();
		}
		public Iterator<String> descendingIterator() {
			return ori.descendingIterator();
		}
		public NavigableSet<String> descendingSet() {
			return ori.descendingSet();
		}
		public int size() {
			return ori.size();
		}
		public boolean isEmpty() {
			return ori.isEmpty();
		}
		public boolean contains(Object o) {
			return ori.contains(o);
		}
		public boolean remove(Object o) {
			return ori.remove(o);
		}
		public boolean containsAll(Collection<?> c) {
			return ori.containsAll(c);
		}
		public void clear() {
			ori.clear();
		}
		public boolean addAll(Collection<? extends String> c) {
			return ori.addAll(c);
		}
		public NavigableSet<String> subSet(String fromElement,
				boolean fromInclusive, String toElement, boolean toInclusive) {
			return ori.subSet(fromElement, fromInclusive, toElement,
					toInclusive);
		}
		public boolean retainAll(Collection<?> c) {
			return ori.retainAll(c);
		}
		public NavigableSet<String> headSet(String toElement, boolean inclusive) {
			return ori.headSet(toElement, inclusive);
		}
		public NavigableSet<String> tailSet(String fromElement,
				boolean inclusive) {
			return ori.tailSet(fromElement, inclusive);
		}
		public SortedSet<String> subSet(String fromElement, String toElement) {
			return ori.subSet(fromElement, toElement);
		}
		public SortedSet<String> headSet(String toElement) {
			return ori.headSet(toElement);
		}
		public SortedSet<String> tailSet(String fromElement) {
			return ori.tailSet(fromElement);
		}
		public String toString() {
			return ori.toString();
		}
		public Comparator<? super String> comparator() {
			return ori.comparator();
		}
		public String first() {
			return ori.first();
		}
		public String last() {
			return ori.last();
		}
		public String lower(String e) {
			return ori.lower(e);
		}
		public String floor(String e) {
			return ori.floor(e);
		}
		public String ceiling(String e) {
			return ori.ceiling(e);
		}
		public String higher(String e) {
			return ori.higher(e);
		}
		public String pollFirst() {
			return ori.pollFirst();
		}
		public String pollLast() {
			return ori.pollLast();
		}
		public Object clone() {
			return ori.clone();
		}
	
	}
	
	/*
	 * 通讯协议update by  LvDW
	 * */
//    @Path("/{imei}/{model}/{input}/{session_id}/")
	@Path("/{imei}/{model}/{input}/")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String autoTalk(
    	  @PathParam("imei") String imei 
  		  ,@PathParam("model") String model 
  		  ,@PathParam("input") String input 
//  		  ,@PathParam("session_id") String session_id
  		,@PathParam("imei") String session_id
  		) throws Throwable {
//    	
    	Timestamp start = DateUtil.getNow();
    	long systemTime = System.currentTimeMillis();
    	Result r = Result.success();
    	String output = null;
    	Transaction trans = null;
    	int analyzeWordNums=0;
    	try {

    		// log
    		outputLog("autoTalk begin: {" + imei+ "," + model + "," + input + "}");
    		// 支持跨域
    		// response.addHeader("Access-Control-Allow-Origin" , "*");

    		// 启事务
    		trans = HibSf.getSession().beginTransaction();
    		
    		// 获取请求信息
    		String clientIp =  request.getRemoteAddr();
    		String requestAddr =  request.getHeader("h_addr") == null? null : new String(request.getHeader("h_addr").getBytes("ISO-8859-1"), "utf-8");
    		String now = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(start);
    		String version = request.getHeader("h_version");
    		
    		
    		List<LexItem> lexItems = null;
    		StringBuffer lexer = new StringBuffer();
    		try{
    			ChineseGramaLex lex = //new ChineseGramaLex.BsonNLP();
   					 new SCWS();
    			lexItems = lex.analyze(input);
    			for (LexItem li : lexItems) {
    				lexer.append(li.getValue());
    				lexer.append(" ");
   			}
    		}catch(Exception e){//如果分词错误，就不分词了
    			lexer.append(input);
    		}

			
			analyzeWordNums=lexItems.size();
    		// 保存请求属性
       		outputLog("autoTalk save request");
    		StringBuffer sb = new StringBuffer("INSERT INTO [ENT_REQUEST](ID,path,input,lexer,sn,randint,user_agent,start,timegreeting,client_ip,[current_date],h_version,h_latitude,h_longtitude,h_city,h_addr,h_country,h_addrdesc,h_street)");
    		sb.append("VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
    		String uid = UUID.randomUUID().toString();
    		ViewUtils.sqlNonQuery(sb.toString()
    				, uid
    				, request.getContextPath()
    				, input
    				, lexer.toString()
    				, imei
    				, String.valueOf(new Random().nextInt(500))
    				, request.getHeader("user-agent")
    				, now
    				, DateUtil.getTimespanDescription()
    				, clientIp
    				, new SimpleDateFormat("yyyy-MM-dd").format(start)
    				, version
    				, request.getHeader("h_latitude")
    				, request.getHeader("h_longtitude")
    				, request.getHeader("h_city") == null? null : new String(request.getHeader("h_city").getBytes("ISO-8859-1"), "utf-8")
		    		, requestAddr
		    		, request.getHeader("h_country") == null? null : new String(request.getHeader("h_country").getBytes("ISO-8859-1"), "utf-8")
		    		, request.getHeader("h_addrdesc") == null? null : new String(request.getHeader("h_addrdesc").getBytes("ISO-8859-1"), "utf-8")
		    		, request.getHeader("h_street") == null? null : new String(request.getHeader("h_street").getBytes("ISO-8859-1"), "utf-8")    				
    				);
    		
    		// 把请求信息推送给管理者
    		Map<String, RTCWssStreamInBound> wssPipe = RTCWssStreamInBound.pipes;
    		List<RTCWssStreamInBound> activedPipes = new ArrayList<>();
    		
    		// 获取请求的机器人登记信息
    		EntRobot en = (EntRobot) ViewUtils.getViewDataFirstIndex(
    		ViewUtils.sqlQuery("SELECT TOP 1 * FROM ENT_ROBOT WHERE IMEI = ?", EntRobot.class, imei));
    		long robotId = en.getId();
    		    		
			JSONObject pushRecordToManagerData = new JSONObject();
			JSONObject pushRecordToManager = new JSONObject();
			ViewRemoteEndpointLatestStatusId currentEp = null;
			
    		if (wssPipe != null && !wssPipe.isEmpty()) {
    			
    			pushRecordToManagerData.put("request", input);
    			pushRecordToManagerData.put("requestAddr", requestAddr);
    			pushRecordToManagerData.put("requestClientIp", clientIp);
    			pushRecordToManagerData.put("requestClientVersion", version);
    			pushRecordToManagerData.put("requestEpSn", imei);
    			pushRecordToManagerData.put("requestModel", model);
    			pushRecordToManagerData.put("dateTime", now);
    			
    			pushRecordToManager.put("cmd", RTCWssCommandEnum.custom_talk);
    			pushRecordToManager.put("data", pushRecordToManagerData);
    			String sData = pushRecordToManager.toString();
    			for (String wssId : wssPipe.keySet()) {
    				RTCWssStreamInBound pipe = wssPipe.get(wssId);
    				 
    				currentEp = pipe.getCurrentEp();
    				if (pipe != null &&  currentEp != null && !currentEp.getIsRobot()) {
    					List<ViewRemoteUserRobotBindListId> bl = pipe.getBindList();

    					// outputLog("当前活动用户：" + pipe.epDescription() + ", 所绑定机器人数：" + bl.size()); 
    					if (bl != null) {
    						for (ViewRemoteUserRobotBindListId bind : bl) {
    							
    							if (bind.getRobotLatestStatusOnline() && bind.getRobotId() == robotId) {
    								
    								outputLog("机器人与用户双向长连接在线:" 
    										+ pipe.epDescription(currentEp)
    										+ " <-> " + pipe.epDescription(bind.getRobotLatestStatusWssSessionId())); 
    								
    								outputLog("目标机器：" + bind.getRobotName());
    								outputLog("发送回复至网页控制台");
    								pipe.serverSend(currentEp.getWssSessionId(), sData);
    								activedPipes.add(pipe);
    								break;
    							}
    						}
    					}
    				}
    			}
    		}
    		
    		String access_token ="";
    		if ("^".equals(input)) {
    			outputLog("获取人工推送");
    		}else{
    			outputLog("自动模式，需要开始获取access_token");
    			long timeIn = System.currentTimeMillis();
        		//定期(25天)获取一次access_token
        		String clientId = DBFunctionUtils.getConfig(imei, "API_KEY");
        		String clientSecret = DBFunctionUtils.getConfig(imei, "SECRET_KEY");
        		Map<String,Object> accessTokenMap_Map = new HashMap<String,Object>();
        		Map<String,Object> accessTokenMap_Map1 = new HashMap<String,Object>();
        		accessTokenMap_Map = accessTokenMap.get(clientId);
        		long access_time = 0;
        		if(null!=accessTokenMap_Map){
        			access_time = (long) (accessTokenMap.get(clientId).get("ACCESS_TIME")==null?0:accessTokenMap.get(clientId).get("ACCESS_TIME"));//上一次重置access_token的时间戳
        			access_token = (String)accessTokenMap.get(clientId).get("ACCESS_TOKEN");
        		}
        		if((null==access_token)||("".equals(access_token))||(systemTime-access_time>2160000000l)){
        			outputLog(clientId+"帐号对应的access_token已经过期，需要重新获取。");
        			access_token = getAuth(clientId, clientSecret);
        			access_time = System.currentTimeMillis();
        			accessTokenMap_Map1.put("ACCESS_TOKEN", access_token);
        			accessTokenMap_Map1.put("ACCESS_TIME", access_time);
        			accessTokenMap.put(clientId, accessTokenMap_Map1);
        		}
        		outputLog("access_token检查完成");
    		}
    		
    		// 手工模式，且当前有绑定的用户
    		if (en.isManualMode()  && activedPipes.size() > 0) {
				// 手工模式
    			outputLog("手工模式");
				synchronized (this) {
					ManualTalks.put(robotId, this);
					int ticks = 0;
					while (ViewUtils.dbFunc("DBO.FUNC_GET_MANUAL_VOICE", robotId) == null) {
						// 查找人工生成的结果是否存在
						if (++ticks <= 3) {
							outputLog("没有人工结果，等待 " + ticks);
							wait(5 * 1000);
						} else {
							// 不等了。。
							outputLog("超时不等了");
							break;
						}
					}
					
					ManualTalks.remove(robotId);
				}
    		}
    		
    		/*
    		 *ADD BY LvDW 接入百度语义流程
    		 * */
    		
    		outputLog("调用百度语义流程之前耗时："+(System.currentTimeMillis()-systemTime));
    		
    		
    		outputLog("开始进行语音调用的流程,先进行本地语料库识别");
    		localOpenNLP(uid,trans);
    		
    		if(!"2".equals(vid.getVoiceCat())){
    			String baiduFlag ="";
    			String baiduString = "";
    			String baiduSceneId = "";
    			String baiduJson = "";
    			outputLog("本地语料库识别 成功");
    			if(null!=vid.getVoiceText()&&!"".equals(vid.getVoiceText())){
    				baiduFlag = vid.getVoiceText().substring(0,1);
    			}
    			if("@".equals(baiduFlag)){
    				outputLog("语料库返回的是百度上下文的多进单出,此时开始调用百度上下文");
    				try{
    					if(vid.getVoiceText().length()>10){
    						baiduString = vid.getVoiceText().substring(1,vid.getVoiceText().length()-10);
    						baiduSceneId = vid.getVoiceText().substring(vid.getVoiceText().length()-5,vid.getVoiceText().length());
    						baiduJson = utterance(baiduSceneId,session_id,baiduString,access_token);//调用百度
    						
    						JSONObject jo = null;
    						JSONObject jo1 = null;
    						String say="";
    						String sayString = "";
    						String sayPatrol = "";
    						try{
    							jo = new JSONObject(baiduJson);
    							jo1 = new JSONObject(jo.getString("result"));
    							jo1 = (JSONObject)jo1.getJSONArray("action_list").get(0);
    							say = jo1.getString("say");//拿到百度的返回
//    							say = "*patrol+bank_Corporate_Receipt";
    						}catch(Exception e){
    							e.printStackTrace();
    							outputLog("百度返回的json解析错误："+e);
    							say="";
    						}
    						
    						String sayFlag = "";
    						if(!"".equals(say)){
    							sayFlag = say.substring(0,1);
    							if("$".equals(sayFlag)){
    								outputLog("百度返回的是查找参数对应值的类型");
    								say = say.substring(1,say.length());
    								say = checkValueLocal(say,imei);//本地数据库查找参数对应的值
    								vid.setVoiceCat("3");
        							vid.setVoiceText(say);
    							}else if("*".equals(sayFlag)){
    								outputLog("百度返回的是巡游命令的类型");
    								int index = say.indexOf("+");
    								sayPatrol = say.substring(1,index);
    								sayPatrol = checkValueLocal(sayPatrol,imei);//本地数据库查找参数对应的值_巡游路径
    								sayString = say.substring(index+1,say.length());
    								sayString = checkValueLocal(sayString,imei);//本地数据库查找参数对应的值_回答文本
//    								vid.setVoiceCommand(1003l);
//    								vid.setVoiceCommandParam(sayPatrol);
    								patrolMap.put(imei, sayPatrol);//将巡游路径缓存起来，待下次确定之后再返回给终端
    								vid.setVoiceCat("3");
        							vid.setVoiceText(sayString);
    							}else if("^".equals(sayFlag)){//特殊情况，此时上下文返回的是"确定"上一次的巡游
    								outputLog("特殊情况，此时上下文返回的是确定上一次的巡游");
    								if(null!=patrolMap.get(imei)&&!"".equals(patrolMap.get(imei))){
    									vid.setVoiceCommand(1003l);
        								vid.setVoiceCommandParam(patrolMap.get(imei));
        								vid.setVoiceCat("4");
            							vid.setVoiceText("好的,请您跟我来!");
            							patrolMap.remove(imei);
    								}else{
    									vid.setVoiceCat("3");
            							vid.setVoiceText(checkValueLocal("notPatrol",imei));
    								}
    							}else if("%".equals(sayFlag)){//特殊情况，此时上下文返回的是"否定"上一次的巡游
    								outputLog("特殊情况，此时上下文返回的是否定上一次的巡游");
    								say = say.substring(1,say.length());
    								say = checkValueLocal(say,imei);//本地数据库查找参数对应的值
    								if(null!=patrolMap.get(imei)&&!"".equals(patrolMap.get(imei))){
    									patrolMap.remove(imei);
    								}
    								vid.setVoiceCat("3");
        							vid.setVoiceText(say);
    							}else if("&".equals(sayFlag)){
    								outputLog("特殊情况，此时上下文返回的是再次询问上一次的巡游");
    								say = say.substring(1,say.length());
    								if(null!=patrolMap.get(imei)&&!"".equals(patrolMap.get(imei))){
    									say = checkValueLocal(say,imei);//本地数据库查找参数对应的值
    								}else{
    									say = checkValueLocal("changequestion3",imei);
    								}
    								vid.setVoiceCat("3");
        							vid.setVoiceText(say);
    							}else{
    								outputLog("百度返回的直接是文本类型");
    								vid.setVoiceCat("3");
        							vid.setVoiceText(say);
    							}
    							
    							
    						}else{
    							outputLog("百度上下文返回字段为空");
    							vid.setVoiceCat("2");
    							vid.setVoiceText("");
    						}
    					}else{
    						outputLog("百度语料没有配置场景号");
    						vid.setVoiceCat("2");
							vid.setVoiceText("");
    					}
    				}catch(Exception e){
    					outputLog("执行整个百度上下文流程出现问题："+e);
    					vid.setVoiceCat("2");
						vid.setVoiceText("");
//						if(null!=patrolMap.get(imei)&&!"".equals(patrolMap.get(imei))){
//							patrolMap.remove(imei);
//						}
    				}
    			}else{
    				outputLog("本地语料返回的不是百度上下文，只是普通问答。");
//    				if(null!=patrolMap.get(imei)&&!"".equals(patrolMap.get(imei))){
//						patrolMap.remove(imei);
//					}
    			}
    		}
    		
    	

    		/*//开始进行语音调用的流程
    		Map<String,String> sessionInfoMap_Map = new HashMap<String,String>();
    		sessionInfoMap_Map = sessionInfoMap.get(session_id);
    		String flag="0";
    		String count="0";
    		String scene_id = "";
    		if(null!=sessionInfoMap_Map){
    			flag =(String) sessionInfoMap_Map.get("flag");
    			count =(String) sessionInfoMap_Map.get("count");
    			scene_id =(String) sessionInfoMap_Map.get("scene_id");
    		}
    		
    		if("1".equals(flag)){
    			outputLog("flag=1时先走百度语义识别");
    			long timeBaidu = System.currentTimeMillis();
    			String baiduJson = utterance(scene_id,session_id,input,access_token);
    			outputLog("走百度语义识别耗时："+(System.currentTimeMillis()-timeBaidu));
    			JSONObject jo = null;
				JSONObject jo1 = null;
				String say = "";
				String say_last = "";
				try{
					jo = new JSONObject(baiduJson);
					jo1 = new JSONObject(jo.getString("result"));
					jo1 = (JSONObject)jo1.getJSONArray("action_list").get(0);
					say = jo1.getString("say");
				}catch(Exception e){
					e.printStackTrace();
					outputLog("百度返回的json解析错误："+e);
					say="";
				}
				if(say.length()>=11){
					say_last = say.substring(say.length()-11, say.length());
				}
				if((!"".equals(say))&&(!"notResponse".equals(say))){
					if("endResponse".equals(say_last)){
						say = say.substring(0,say.length()-11);
						outputLog("场景结束！");
						//将值缓存
						setSessionInfoMap(session_id,"0","0","");
					}else{
						setSessionInfoMap(session_id,flag,"0",scene_id);
					}
					vid = new ViewVoiceGroupId();
					vid.setVoiceCat("3");
					vid.setVoiceText(say);
				}else{
					count = String.valueOf((Integer.valueOf(count)+1));
					if("2".equals(count)){
						setSessionInfoMap(session_id,"0","0","");
					}else{
						setSessionInfoMap(session_id,"1",count,scene_id);
					}
					
					outputLog("flag=1时,但是百度未返回，继而又走入本地语料库识别。");
					long time1 =System.currentTimeMillis(); 
	    			localOpenNLP(uid,trans);
	    			logger.info("调用本地库的时间"+(System.currentTimeMillis()-time1));
	    			outputLog("调用本地库的时间"+(System.currentTimeMillis()-time1));
	    			if(!"2".equals(vid.getVoiceCat())){
	    				outputLog("本地语料库识别 成功");
	    				try{
	    					if("baidu".equals(vid.getVoiceText().substring(0,5))){
	    						outputLog("本地语料库返回的是百度场景,开始调用百度语义");
	    						scene_id = vid.getVoiceText().substring(5);//从本地库里获取百度场景id
	    						timeBaidu = System.currentTimeMillis();
	    						baiduJson = utterance(scene_id,session_id,input,access_token);
	    						outputLog("又走百度语义识别耗时："+(System.currentTimeMillis()-timeBaidu));
	    						jo = null;
	    						jo1 = null;
	    						say = "";
	    						say_last = "";
	    						try{
	    							jo = new JSONObject(baiduJson);
	    							jo1 = new JSONObject(jo.getString("result"));
	    							jo1 = (JSONObject)jo1.getJSONArray("action_list").get(0);
	    							say = jo1.getString("say");
	    						}catch(Exception e){
	    							e.printStackTrace();
	    							outputLog("百度返回的json解析错误："+e);
	    							say="";
	    						}
	    						if(say.length()>=11){
	    							say_last = say.substring(say.length()-11, say.length());
	    						}
	    						if((!"".equals(say))&&(!"notResponse".equals(say))){
	    							vid.setVoiceCat("3");
	    							vid.setVoiceText(say);
	    							if(!"endResponse".equals(say_last)){
	    								outputLog("场景未结束！");
	        							//将值缓存
	    								setSessionInfoMap(session_id,"1","0",scene_id);
	    							}	
	    						}
	    					}else{
	    						outputLog("本地语料返回的并不是百度场景");
	    					}
	    				}catch(Exception e){
	    					e.printStackTrace();
	    					outputLog("百度语义调用错误或者本地返回的并不是百度场景");
	    				}
	    				
	    			}
					
				}
    			
    		}else{
    			outputLog("flag=0时先走本地语料库识别。");
    			long time1 =System.currentTimeMillis(); 
    			localOpenNLP(uid,trans);
    			logger.info("调用本地库的时间"+(System.currentTimeMillis()-time1));
    			if(!"2".equals(vid.getVoiceCat())){
    				outputLog("本地语料库识别 成功");
    				try{
    					if("baidu".equals(vid.getVoiceText().substring(0,5))){
    						outputLog("本地语料库返回的是百度场景,开始调用百度语义");
    						scene_id = vid.getVoiceText().substring(5);//从本地库里获取百度场景id
    						long timeBaidu = System.currentTimeMillis();
    						String baiduJson = utterance(scene_id,session_id,input,access_token);
    						outputLog("调用百度语义耗时："+(System.currentTimeMillis()-timeBaidu));
    						JSONObject jo = null;
    						JSONObject jo1 = null;
    						String say = "";
    						String say_last = "";
    						try{
    							jo = new JSONObject(baiduJson);
    							jo1 = new JSONObject(jo.getString("result"));
    							jo1 = (JSONObject)jo1.getJSONArray("action_list").get(0);
    							say = jo1.getString("say");
    						}catch(Exception e){
    							e.printStackTrace();
    							outputLog("百度返回的json解析错误："+e);
    							say="";
    						}
    						if(say.length()>=11){
    							say_last = say.substring(say.length()-11, say.length());
    						}
    						if((!"".equals(say))&&(!"notResponse".equals(say))){
    							vid.setVoiceCat("3");
    							vid.setVoiceText(say);
    							if(!"endResponse".equals(say_last)){
    								outputLog("场景未结束！");
        							//将值缓存
    								setSessionInfoMap(session_id,"1","0",scene_id);
    							}	
    						}
    					}else{
    						outputLog("本地语料返回的并不是百度场景");
    					}
    				}catch(Exception e){
    					e.printStackTrace();
    					outputLog("百度语义调用错误或者本地返回的并不是百度场景");
    				}
    				
    			}
    		}
    		
    		outputLog("整个百度流程相关的耗时："+(System.currentTimeMillis()-timeIn));*/
    		
    		
    		
    		

//    		if (vid == null || ".".equals(vid.getVoiceText())) {
//    			// 自动模式
//    			outputLog("autoTalk exec [SP_SMART_DIALOG] begin");
//    			vid  = getVoice(uid);
//    			outputLog("autoTalk exec [SP_SMART_DIALOG] end");    		
//    		}
//    		
//    		// 事务提交
//    		trans.commit();
//    		
//    		trans = HibSf.getSession().beginTransaction();
//    		
//    		handler(vid);
    		
    		// 未匹配
    		long timeKeda = System.currentTimeMillis();
    		if ("2".equals(vid.getVoiceCat())) {
    			// 进入到第三方NLP插件链
    		 	List<NLP> nlpPluginChain = getNlpList(imei, en.getId());
    		 	
    		 	if (nlpPluginChain != null) {
    		 		for (NLP nlp : nlpPluginChain) {
    		 			outputLog("接入第三方NLP：" + nlp.description());  
    		 			nlp.execute(this, vid, input, imei, uid);
    		 			if ("3".equals(vid.getVoiceCat())) {
    		 				vid.setVoiceDescription(nlp.description());
    		 				break;
    		 			}
    		 		}
    		 	}
    		 	
    		} 
    		outputLog("调用科大讯飞的耗时："+(System.currentTimeMillis()-timeKeda));
    		
    		long timeZhineng = System.currentTimeMillis();
    		// 智能推荐
    		Recommand recommands = new Recommand();
    		{
    			List<ViewValue> rec = ViewUtils.dbProcQuery(ViewValue.class, "SP_GET_RECOMMENDS_ADVANCE", uid, imei);
    			for (ViewValue v : rec) {
    				recommands.add(v.getValue());
    			}
    			
				if (recommands.items.size() != 0 && vid.getVoiceCommand() == 0) {
					vid.setVoiceCommand(80L);
					
		    		 if ("2".equals(vid.getVoiceCat())) {
		    			 vid.setVoiceText(DBFunctionUtils.getConfig(imei, "suggest_tip"));
		    		 }
					
					vid.setVoiceCommandParam(GsonProvider.getGson().toJson(recommands));
				}
    		}
    		outputLog("智能推荐的耗时："+(System.currentTimeMillis()-timeZhineng));
    		
    		vid.setVoiceText(StringUtil.removeHtmlTags(vid.getVoiceText()));
    		
    		outputLog("分词个数："+analyzeWordNums);
    		//add lvdw 解决噪音不回答问题 20171220
    		if((vid.getVoiceText().length()<1)&&("噪音".equals(vid.getVoiceName()))&&(analyzeWordNums>6)){
    		 	vid.setVoiceDescription("我还不知道");
    		 	Collections.shuffle(list);   
    		 	vid.setVoiceText(cannotReplys[list.get(0)]);
    		 	vid.setVoiceCommand(0L);
    		}
    		r.setData(vid);
    		
    		pushRecordToManagerData.put("text", vid.getVoiceText());
    		pushRecordToManagerData.put("command", vid.getVoiceCommand());
    		pushRecordToManagerData.put("commandParam", vid.getVoiceCommandParam());
    		pushRecordToManagerData.put("emotion", vid.getVoiceEmotion());
    		pushRecordToManagerData.put("path", vid.getVoicePath());
    		
    		String sAnsData = pushRecordToManager.toString();
    		for (RTCWssStreamInBound pipe : activedPipes) {
    			outputLog("**发送会话结果到后台管理用户**");
    			currentEp = pipe.getCurrentEp();
    			if (currentEp != null) {
        			pipe.serverSend(currentEp.getWssSessionId(), sAnsData);
    			}
    		}
    		
    		trans.commit();
    		outputLog("autoTalk exec SP_RECORD_SMART_DIALOG_RESULT begin");
    		trans = HibSf.getSession().beginTransaction();
    		
			ViewUtils.dbProc("SP_RECORD_SMART_DIALOG_RESULT"
					, uid
					, vid.getVoiceCat()
					, vid.getVoiceName()
					, vid.getVoiceText()
					, vid.getVoicePath()
					, vid.getVoiceEmotion()
					, vid.getVoiceCommand()
					, vid.getVoiceCommandParam()
					, vid.getVoiceIncProp()
					, vid.getVoiceThirdPartyApiName()
					, vid.getVoiceThirdPartyApiMethod()
					, vid.getVoiceThirdPartyApiUrl()
					, vid.getVoiceThirdPartyApiHeaderParams()
					, vid.getVoiceThirdPartyApiResultType()
					, vid.getVoiceDescription() 
					, null
					, null);
    		outputLog("autoTalk exec SP_RECORD_SMART_DIALOG_RESULT end");			    		
    		trans.commit();
     		output = r.toString();
    		outputLog("autoTalk output: " + output);
		} catch (Throwable th) {
			r = Result.unknowException(th);
			th.printStackTrace();
			output = r.toString();
			outputLog("autoTalk error: " + th.toString());

			if (trans != null) {
				try {
					trans.rollback();
				} catch (Throwable t2) {
					r = Result.unknowException(t2);
					output = r.toString();
					outputLog("autoTalk error: " + th.toString());
				}
			}

		}
    	outputLog("整个会话过程用时："+(System.currentTimeMillis()-systemTime)+"ms");
    	return output;
//  		return "{\"code\":\"0\",\"message\":\"OK\",\"data\":{\"id\":0,\"voiceGroupId\":-1,\"voiceName\":\"噪音\",\"voicePath\":\"\",\"voiceText\":\"你真的难倒我了。请问您还有什么需要我帮助的吗？\",\"voiceCat\":\"2\",\"voiceDescription\":\"我还不知道\",\"voiceCommand\":0,\"voiceCommandParam\":\"\",\"voiceThirdPartyApiName\":\"\",\"voiceThirdPartyApiMethod\":\"\",\"voiceThirdPartyApiHeaderParams\":\"\",\"voiceThirdPartyApiUrl\":\"\",\"voiceThirdPartyApiResultType\":\"\",\"voiceThirdPartyApiRunAtServer\":false,\"voiceIncProp\":\" \",\"voiceExcProp\":\" \",\"voiceEmotion\":\"\",\"voiceEnabled\":true}}";
    }
	
	/**
	 * ADD BY LvDW 调用本地数据库查找配置键值对
	 * */
	public String checkValueLocal(String say,String sn) throws Throwable{
		long time = System.currentTimeMillis();
		
//		outputLog("调用本地数据库查找参数对应的值");
		TblCustomizedConfigForRobot en = (TblCustomizedConfigForRobot) ViewUtils.getViewDataFirstIndex(
	    		ViewUtils.sqlQuery("SELECT TOP 1 * FROM TBL_CUSTOMIZED_CONFIG_FOR_ROBOT A,ENT_ROBOT B WHERE A.ROBOT_ID = B.ID AND B.IMEI = ? AND A.NAME = ?", TblCustomizedConfigForRobot.class, sn,say));
		
		say = en.getValue();
		outputLog("调用本地键值对耗时："+(System.currentTimeMillis()-time));
		return say;
	}
	
	public static void main(String[] args) {
//		try {
//			String str = checkValueLocal("patrol","C8W7KY6Z10");
//			logger.info(str);
//		} catch (Throwable e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
	}
	
    /*
     * ADD BY LvDW设置缓存值
     * */
    public void setSessionInfoMap(String session_id,String flag,String count,String scene_id){
    	Map<String,String> map = new HashMap<String,String>();
    	map.put("flag", flag);
    	map.put("count", count);
    	map.put("scene_id", scene_id);
    	sessionInfoMap.put(session_id, map);
    }
	/*
	 * ADD BY LvDW 进入本地语料库识别的流程
	 * */
	public void localOpenNLP(String uid,Transaction trans){
		long time = System.currentTimeMillis();
		try{
			outputLog("进入本地语料库识别的流程");
			if (vid == null || ".".equals(vid.getVoiceText())) {
				// 自动模式
				outputLog("autoTalk exec [SP_SMART_DIALOG] begin");
				vid  = getVoice(uid);
				outputLog("autoTalk exec [SP_SMART_DIALOG] end");    		
			}
			
			// 事务提交
//			trans.commit();
//			
//			trans = HibSf.getSession().beginTransaction();
			
			handler(vid);
			outputLog("本地语料识别耗时："+(System.currentTimeMillis()-time));
		}catch(Throwable e){
			e.printStackTrace();
		}
		
	}
	
	/*
	 * ADD BY LvDW 开始调取百度语义
	 * */
    
    public  String utterance(String sceneId,String sessionId,String query,String accessToken) {
    	long time = System.currentTimeMillis();
    	outputLog("开始调取百度语义");
        // 请求URL
        String talkUrl = "https://aip.baidubce.com/rpc/2.0/solution/v1/unit_utterance";
        try {
            // 请求参数
            String params = "{\"scene_id\":\""+sceneId+"\",\""+sessionId+"\":\"\",\"query\":\""+query+"\"}";
            String result = HttpUtil.post(talkUrl, accessToken, "application/json", params);
            outputLog("调取百度上下文耗时："+(System.currentTimeMillis()-time));
            return result;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public  String getAuth(String ak, String sk) {
    	outputLog("开始获取access_token");
        // 获取token地址
    	long time1 = System.currentTimeMillis();
        String authHost = "https://aip.baidubce.com/oauth/2.0/token?";
        String getAccessTokenUrl = authHost
                // 1. grant_type为固定参数
                + "grant_type=client_credentials"
                // 2. 官网获取的 API Key
                + "&client_id=" + ak
                // 3. 官网获取的 Secret Key
                + "&client_secret=" + sk;
        try {
            URL realUrl = new URL(getAccessTokenUrl);
            // 打开和URL之间的连接
            HttpURLConnection connection = (HttpURLConnection) realUrl.openConnection();
            connection.setRequestMethod("GET");
            connection.connect();
            // 获取所有响应头字段
            Map<String, List<String>> map = connection.getHeaderFields();
            // 遍历所有的响应头字段
            for (String key : map.keySet()) {
            	logger.error(key + "--->" + map.get(key));
            }
            // 定义 BufferedReader输入流来读取URL的响应
            BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            String result = "";
            String line;
            while ((line = in.readLine()) != null) {
                result += line;
            }
            long time2 = System.currentTimeMillis();
            logger.info("time1="+(time2-time1));
            /**
             * 返回结果示例
             */
            logger.error("result:" + result);
            JSONObject jsonObject = new JSONObject(result);
            String access_token = jsonObject.getString("access_token");
            outputLog("获取到的access_token="+access_token);
            return access_token;
        } catch (Exception e) {
        	logger.error("获取token失败！");
        	logger.error(e.getMessage());
        }
        return null;
    }

	private List<NLP> getNlpList(String imei, Long robotId) throws Throwable {
		// TODO Auto-generated method stub
		List<NLP> list = null;
		
		String strNlpList = DBFunctionUtils.getConfig(imei, "nlp_list");
		
		if (strNlpList != null || !"".equals(strNlpList)) {
			JSONObject jo = new JSONObject(strNlpList);
			JSONArray ja = null;
			if (jo != null &&  (ja = jo.optJSONArray("items")) != null ) {
				list = new ArrayList<>();
				for (int i = 0 ; i < ja.length(); i++) {
					String nlpClass = ja.optString(i);
					@SuppressWarnings("unchecked")
					Class<? extends NLP> cls = (Class<? extends NLP>) Class.forName("org.sgpro._nlp_external." + nlpClass);
					list.add(cls.newInstance());
				}
			}
		}
		
		return list;
	}

	public void handler(ViewVoiceGroupId vid) throws Throwable {
		// TODO Auto-generated method stub
		// 1988 接口， 语料计算指定业务层处理的接口
		if (vid.getVoiceCommand() == 1988) {
			String[] params = vid.getVoiceCommandParam().split(",");
			
			if (params.length > 0) {
				for (int i = 0; i < params.length; i++) {
					params[i] = params[i].trim();
				}
				Class<?> _1988Cls = ReflectUtil.getClassWithNoError(_1988.class.getPackage().getName()+ "." + params[0]);
				_1988 exec = (_1988)_1988Cls.newInstance();
				exec.execute(request, vid, Arrays.copyOfRange(params, 1, params.length));
			}
		}
		
		// 外部接口， 语料指定接入第三方处理的接口
		if (StringUtil.isNotNullAndEmpy(vid.getVoiceThirdPartyApiName())) {
			outputLog("第三方接口");
			if ( vid.getVoiceThirdPartyApiRunAtServer()) {
				// 服务端运行
				String str = _3rdCall(vid);
				JSONObject jo = null;
				
				if ("JSON".equals(vid.getVoiceThirdPartyApiResultType())) {
					jo = new JSONObject(str);
				} else if ("XML".equals(vid.getVoiceThirdPartyApiResultType())){
					// xml
					XMLSerializer xs = new XMLSerializer();
					jo =  new JSONObject( xs.read(str).toString());
				} 
				
				if (jo != null) {
					Map<String, Integer> indexArr = new HashMap<>();
					vid.setVoiceText(get3RdContent(vid.getVoiceText(), jo, indexArr));
					vid.setVoiceCommandParam(get3RdContent(vid.getVoiceCommandParam(), jo, indexArr));
					//ADD BY LVDW 20180104;让voicePath可以调用第三方接口返回的参数
					vid.setVoicePath(get3RdContent(vid.getVoicePath(), jo, indexArr));
				} else  {
					vid.setVoiceText(str);
				}
				
				String cat = vid.getVoiceCat();
				char[] arrCat = cat.toCharArray();
				arrCat[arrCat.length - 1] = '4';
				vid.setVoiceCat(String.valueOf(arrCat, 0, arrCat.length));
				
			} else {
				// 客户端运行的API
				vid.setVoiceCommand(610L);
				vid.setVoiceCommandParam(vid.getVoiceThirdPartyApiUrl());
			}
			vid.setVoiceDescription(vid.getVoiceThirdPartyApiName());
		}		
	}

	private ViewVoiceGroupId getVoice(String uid) throws  Throwable {
		// TODO Auto-generated method stub
		ViewVoiceGroupId ret = null; 
		
		ret =
		(ViewVoiceGroupId) ViewUtils.getViewData(		
				ViewUtils.dbProcQuery(ViewVoiceGroup.class, "SP_SMART_DIALOG", uid));

		if (ret == null) {
			ret = new ViewVoiceGroupId
					(0L, 0L, "异常", "", "云端故障了", "1", "故障", 0L, "", "", "", "", "", "", false, "", "", "", true);
		}

		return ret;
	}


	private String get3RdContent(String text, JSONObject jo, Map<String, Integer> indexArr) throws JSONException {
		// TODO Auto-generated method stub
		List<String> resulParams =  
				findAll3rdResultParams(text);
		if (resulParams != null) {
			for (String p : resulParams) {
				if (p != null) {
					String v = getValueByPath(jo, p, indexArr);
					text = text.replace("@{" + p + "}", v == null? "null" : v);
				}
			}
		}
		return text;
	}


	private List<String> findAll3rdResultParams(String text) {
    	List<String> ret = null;
		// TODO Auto-generated method stub
    	if (text != null) {
    		ret = new ArrayList<>();

    		int b = 0;
    		int e = 0;
    		do {
    			b = text.indexOf("@{");
    			e = text.indexOf("}");
    			
    			if (e > b && b >= 0) {
    				ret.add(text.substring(b + 2, e));
    				text = e == text.length()? null : text.substring(e + 1);
    			} else {
    				break;
    			}
    		} while (true);
    	}
		return ret;
	}

	private String  getValueByPath(JSONObject jo, String path, Map<String, Integer> indexArr ) throws JSONException {
    	String ret = null;
    	
    	if (jo != null) {
    		if (StringUtil.isNotNullAndEmpy(path)) {
    			// a.b[n].x
    			
    			String[] nodes = path.split("/");
    			
    			for (String node : nodes) {
    				int b1 = node.indexOf('[');
    				int b2 = node.indexOf(']');
    				int index = INVALID_INDEX_OR_NONARRAY;
    				if (b2 > b1 && b1 >= 1) {
    					String strIndex = node.substring(b1 + 1, b2);
    					node = node.substring(0, b1);
    					
    					if ("d".equalsIgnoreCase(strIndex)) {
    						if (indexArr.containsKey(node)) {
    							index = indexArr.get(node);  
    						} else {
    							index = RELAY_RANDOM_INDEX_GEN;
    						}
    					} else {
    						index = Integer.valueOf(strIndex);
    					}
    				}
    				
    				if (jo != null && jo.has(node)) {
    					if (index == INVALID_INDEX_OR_NONARRAY) {
    						if ((jo.optJSONObject(node)) == null) {
    							ret = jo.get(node).toString();
    							break;
    						} else {
    							jo = jo.optJSONObject(node);
    						}
    					} else {
    						if (jo.optJSONArray(node) == null) {
    							throw new RuntimeException(node + " is not a array");
    						} else {
    							JSONArray ja = jo.optJSONArray(node);
    							
    							if (ja.length() > 0 && ja.length() > index) {
    								index = index == RELAY_RANDOM_INDEX_GEN? new Random().nextInt(ja.length()) : index;
    								indexArr.put(node, index);
    								Object o = ja.get(index);
    								
    								if (o == null) {
    									throw new RuntimeException(index + " is null elements");
    								}
    								
    								if (o.getClass().isPrimitive()) {
    									ret = o.toString();
    									// OK.
    									break;
    								} else if (o instanceof JSONObject ){
    									// json or json array.
    									jo = ja.getJSONObject(index);
    								}
    							} else {
    								// 数字太大错误
    								throw new RuntimeException(index + " out of range");
    							}
    						}
    					}
    				} else {
    					// 找不到路径
    					throw new RuntimeException("can not found " + node);
    				}
    			}
    		} else {
    			ret = jo.toString();
    		}
    	}
    	return ret;
    }


	
	private String _3rdCall(ViewVoiceGroupId vid) {
		// TODO Auto-generated method stub
		String ret = null;
		
		try {
			// TODO Auto-generated method stub
			Request req = new Request();
			
			Map<String, String> parameter = new HashMap<String, String>();
			parameter.put(Request.HTTP_PARAM_KEY_METHOD, vid.getVoiceThirdPartyApiMethod());
			
			if (vid.getVoiceThirdPartyApiHeaderParams() != null) {
				String params =  vid.getVoiceThirdPartyApiHeaderParams();
				String[] items = params.split("&");
				
				if (items != null) {
					for (String item : items) {
						String[] pair = item.split("=");
						if (pair != null && pair.length >= 2) {
							parameter.put(pair[0], pair[1]);
						}
					}
				}
			}
			
			req.setParameter(parameter);
			
			String  url = vid.getVoiceThirdPartyApiUrl();
			String  data = null;
			
			if ("POST".equals(vid.getVoiceThirdPartyApiMethod())) {
				String[] urls = url.split("[?]");
				if (urls != null && url.length() >= 2 ) {
					url = urls[0];
					data = urls[1];
				}
			}
			
			//ADD BY LvDW 20180108;为唱歌流程增加专用流程
			if("song".equals(url.substring(0,4))){
				outputLog("此URL是唱歌专属流程");
				int index= url.indexOf("首");
				url = url.substring(index+1,url.length());
				StringBuffer url_bak = new StringBuffer();
				if ( url != null){
					 for (char c : url.toCharArray()) {
						 String a="";
					        if ( c >= 0x4E00 &&  c <= 0x9FA5){
					        	
								try {
									a = URLEncoder.encode(String.valueOf(c), "UTF-8");
								} catch (UnsupportedEncodingException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
					        }else{
									a = String.valueOf(c);
							}
					        url_bak.append(a);
					    }
					 url = url_bak.toString();
				 }
				
				Response rsp;
//				String music_id="MUSIC_15123099";
				String album_id="";
				String FileHash = "";
//				try{
//					Random ran = new Random();
//					int num = ran.nextInt(5);
//					url = "http://search.kuwo.cn/r.s?all="+url+"&ft=music&itemset=web_2013&client=kt&pn="+num+"&rn=1&rformat=json&encoding=utf8";
//					outputLog("唱歌第一次访问的URL："+url);
//					rsp= req.getResponse(url, data);
//					ret = rsp.asString();
//					outputLog("唱歌链接第一步访问返回的json为："+ret);
//
//					Gson gs = new Gson();
//					Map<String,ArrayList<Map<String,String>>> map = gs.fromJson(ret, Map.class);
//					List<Map<String,String>> abslist = new ArrayList<Map<String,String>>();
//					abslist = map.get("abslist");
//					music_id = abslist.get(0).get("MUSICRID");
//					outputLog("歌曲播放的id="+music_id);
//				}catch(Exception e){
//					outputLog("此次唱歌流程不通过"+e);
//				}
//				
//				
//				url = "http://antiserver.kuwo.cn/anti.s?type=convert_url&rid="+music_id+"&format=aac|mp3&response=url";
//				outputLog("唱歌第二次访问的URL："+url);
//				rsp = req.getResponse(url, data);
//				ret = rsp.asString();
//				ret = "{'songUrl':'"+ret.trim()+"'}";
//				outputLog("唱歌链接第二步访问返回的json为："+ret);
//			}else{
//				outputLog("请求的URL为："+url);
//				Response rsp = req.getResponse(url, data);
//				
//				ret = rsp.asString();
//				
//				outputLog("返回的结果为："+ret);
//			}
			
				try{
					Random ran = new Random();
					int num = ran.nextInt(3)+1;
					url = "http://songsearch.kugou.com/song_search_v2?keyword="+url+"&page="+num+"&pagesize=1&clientver=&platform=WebFilter";
					outputLog("唱歌第一次访问的URL："+url);
					rsp= req.getResponse(url, data);
					ret = rsp.asString();
					outputLog("唱歌链接第一步访问返回的json为："+ret);
					
					//解析json
					JSONObject jo = new JSONObject(ret);
					jo = jo.getJSONObject("data");
					JSONArray jo1 = jo.getJSONArray("lists");
					FileHash = jo1.getJSONObject(0).getString("FileHash");
					album_id = jo1.getJSONObject(0).getString("AlbumID");

					outputLog("歌曲播放的id="+album_id);
					
					url = "http://www.kugou.com/yy/index.php?r=play/getdata&hash="+FileHash+"&album_id="+album_id;
					outputLog("唱歌第二次访问的URL："+url);
					rsp = req.getResponse(url, data);
					ret = rsp.asString();
					
					//解析json、
					JSONObject jjo = new JSONObject(ret);
					jjo = jjo.getJSONObject("data");
					String play_url = jjo.getString("play_url");
//					play_url = play_url.replace("\\/", "/");
					ret = "{'songUrl':'"+play_url.trim()+"'}";
					outputLog("唱歌链接第二步访问返回的json为："+ret);
				}catch(Exception e){
					outputLog("此次唱歌流程不通过"+e);
					ret = "{'songUrl':'http://fs.w.kugou.com/201803261141/a3bc822eea58ad226f3bdbad228e9568/G059/M02/17/1D/ew0DAFdr9KmAf5GnADSkTnjFCm0437.mp3'}";
				}
				
				
				
			}else{
				outputLog("请求的URL为："+url);
				Response rsp = req.getResponse(url, data);
				
				ret = rsp.asString();
				
				outputLog("返回的结果为："+ret);
			}
//			Response rsp = req.getResponse(url, data);
//			
//			ret = rsp.asString();
//			
//			logger.info(ret);
		} catch (Throwable t) {
			// throw new RuntimeException(t);
			t.printStackTrace();
		}
		return ret;
	}
}
