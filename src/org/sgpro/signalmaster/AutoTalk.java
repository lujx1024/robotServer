package org.sgpro.signalmaster;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

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
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.sgpro.db.HibSf;
import org.sgpro.db.ViewVoiceGroupId;
import org.sgpro.util.DateUtil;
import org.sgpro.util.StringUtil;
import org.sgpro.util.http.Request;
import org.sgpro.util.http.Response;

import com.iflytek.cloud.speech.SpeechError;
import com.iflytek.cloud.speech.SpeechUtility;
import com.iflytek.cloud.speech.TextUnderstander;
import com.iflytek.cloud.speech.TextUnderstanderListener;
import com.iflytek.cloud.speech.UnderstanderResult;
import com.iflytek.util.Version;

import config.Log4jInit;
/**
 */
@Path("/auto_talk_v1")
public class AutoTalk  extends HttpServlet  {
	static Logger logger = Logger.getLogger(AutoTalk.class.getName());
    
    private static final int INVALID_INDEX_OR_NONARRAY = -1;

	private static final int RELAY_RANDOM_INDEX_GEN = -2;

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public AutoTalk() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    private TextUnderstander tu =   TextUnderstander.createTextUnderstander();

	protected String rs;
 
    private TextUnderstanderListener tui = new TextUnderstanderListener() {
		
		@Override
		public void onResult(UnderstanderResult arg0) {
			// TODO Auto-generated method stub
			synchronized (AutoTalk.this) {
				
				rs = arg0.getResultString();
				logger.info("科大语义成功：" + rs);
				AutoTalk.this.notify();
			}
		}
		
		@Override
		public void onError(SpeechError arg0) {
			// TODO Auto-generated method stub
			synchronized (AutoTalk.this) {
				logger.error("科大语义失败：" + arg0.toString());
				AutoTalk.this.notify();
			}
		}
	};
    
    {
    	StringBuffer param = new StringBuffer();
    	param.append( "appid=" + Version.getAppid() );
    	SpeechUtility.createUtility( param.toString() );
    }
    
    private String setInputParams(String text, Map<String, String> params) {
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
    
    @Context 
    private HttpServletRequest request;
    @Context 
    private HttpServletResponse  response;
 
    @Path("/{imei}/{model}/{input}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String autoTalk(
    	  @PathParam("imei") String imei 
  		  ,@PathParam("model") String model 
  		  ,@PathParam("input") String input 
  		) throws Throwable {
    	
    	Result r = Result.success();
    	
    	try {
       		
    		Map<String, String> requestProp = new HashMap<String, String>();
    		SimpleDateFormat sdpDt = new SimpleDateFormat("yyyy-MM-dd");
    		
    		requestProp.put("input", input);
    		requestProp.put("randint", String.valueOf(new Random().nextInt(500)));
    		requestProp.put("current_date",  sdpDt.format(DateUtil.getNow()));
    		// requestProp.put("location",  request.getRemoteAddr());
    		
    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		Connection c = HibSf.getConnection();
    		
    		CallableStatement call =
    				c.prepareCall("exec SP_SMART_DIALOG ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?");
    		
    		int argCount = 1;
    		call.setString(argCount++, input);
    		call.setString(argCount++, model);
    		call.setString(argCount++, imei);
    		
    		call.registerOutParameter(argCount++, Types.VARCHAR); // name
    		call.registerOutParameter(argCount++, Types.VARCHAR); // path
    		call.registerOutParameter(argCount++, Types.VARCHAR); // text
    		call.registerOutParameter(argCount++, Types.VARCHAR); // emotion
    		call.registerOutParameter(argCount++, Types.BIGINT);  // command
    		call.registerOutParameter(argCount++, Types.CLOB); // command params
    		call.registerOutParameter(argCount++, Types.VARCHAR); // 3rd name
    		call.registerOutParameter(argCount++, Types.VARCHAR); // 3rd method
    		call.registerOutParameter(argCount++, Types.VARCHAR); // 3rd headers
    		call.registerOutParameter(argCount++, Types.VARCHAR); // 3rd url
    		
    		call.registerOutParameter(argCount++, Types.VARCHAR); // 3rd result type
    		call.registerOutParameter(argCount++, Types.BIGINT);  // 3rd run at server
    		
    		call.registerOutParameter(argCount++, Types.VARCHAR); // cat
    		call.registerOutParameter(argCount++, Types.VARCHAR); // description
    		
    		call.execute();
    		
    		ViewVoiceGroupId vid =
    				new ViewVoiceGroupId();
    		
    		argCount = 4;
    		 		
    		vid.setVoiceName(call.getString(argCount++));
    		vid.setVoicePath(call.getString(argCount++));
    		vid.setVoiceText(call.getString(argCount++));
    		vid.setVoiceEmotion(call.getString(argCount++));
    		
    		long voiceCommand = call.getLong(argCount++);
    		
    		vid.setVoiceCommand(voiceCommand == 0? null : voiceCommand);
    		vid.setVoiceCommandParam(call.getString(argCount++));
    		vid.setVoiceThirdPartyApiName(call.getString(argCount++));
    		vid.setVoiceThirdPartyApiMethod(call.getString(argCount++));
    		vid.setVoiceThirdPartyApiHeaderParams(call.getString(argCount++));
    		vid.setVoiceThirdPartyApiUrl(call.getString(argCount++));
    		vid.setVoiceThirdPartyApiResultType(call.getString(argCount++));
    		vid.setVoiceThirdPartyApiRunAtServer(call.getBoolean(argCount++));
    		vid.setVoiceCat(call.getString(argCount++));
    		vid.setVoiceDescription(call.getString(argCount++));
    		
    		// 输入参数替换
    		vid.setVoiceText(setInputParams(vid.getVoiceText(), requestProp));
    		vid.setVoiceCommandParam(setInputParams(vid.getVoiceCommandParam(), requestProp));
    		
    		
    		// 接入第三方
			
    		if (StringUtil.isNotNullAndEmpy(vid.getVoiceThirdPartyApiName())) {
    			vid.setVoiceThirdPartyApiUrl(setInputParams(vid.getVoiceThirdPartyApiUrl(), requestProp));
    			
    			logger.info("第三方处理一轮");
    			if ( vid.getVoiceThirdPartyApiRunAtServer()) {
    				// 服务端运行
    				String str = _3rdCall(vid);
    				if ("JSON".equals(vid.getVoiceThirdPartyApiResultType())) {
    					JSONObject jo = new JSONObject(str);
    					
    					Map<String, Integer> indexArr = new HashMap<>();
    					vid.setVoiceText(get3RdContent(vid.getVoiceText(), jo, indexArr));
    					vid.setVoiceCommandParam(get3RdContent(vid.getVoiceCommandParam(), jo, indexArr));
    					
        				// 输入参数替换
    		    		vid.setVoiceText(setInputParams(vid.getVoiceText(), requestProp));
    		    		vid.setVoiceCommandParam(setInputParams(vid.getVoiceCommandParam(), requestProp));
    				} else  {
    					vid.setVoiceText(str);
    					
        				// 输入参数替换
    		    		vid.setVoiceText(setInputParams(vid.getVoiceText(), requestProp));
    				}
    				
    				vid.setVoiceCat("4");
    			} else {
    				// 客户端运行的API
    				vid.setVoiceCommand(90L);
    				vid.setVoiceCommandParam(vid.getVoiceThirdPartyApiUrl());
    				
    				// 输入参数替换
		    		vid.setVoiceCommandParam(setInputParams(vid.getVoiceCommandParam(), requestProp));
    			}
    			
    			vid.setVoiceDescription(vid.getVoiceThirdPartyApiName());
    		}
    		
    		// 未匹配
    		if ("2".equals(vid.getVoiceCat())) {
    			logger.info("科大最后一关");
    			
    			if (tu.isUnderstanding()) {
    				tu.cancel();
    			}
    			
    			logger.info("科大最后一关开始");
    			tu.understandText(input, tui);
    		
    			synchronized (this) {
    				rs = null;
					wait(10 * 1000);
					if (rs != null && new JSONObject(rs).optInt("rc") == 0) {
						vid.setVoiceText(rs);
						vid.setVoiceCat("3");
						vid.setVoiceDescription("科大讯飞开放语义");
						vid.setVoiceName(null);
						vid.setVoiceCommand(null);
						vid.setVoiceCommandParam(null);
						
						call = c.prepareCall("exec SP_RECORD_3RD_SMART_DIALOG_RESULT ?,?,?,? ");
						argCount = 1;
			    		call.setString(argCount++, input);
			    		call.setString(argCount++, model);
			    		call.setString(argCount++, imei);
			    		call.setString(argCount++, rs);
			    		call.execute();
					}
				}
    		}

    		r.setData(vid);
    		logger.info(input + ":" + ":" + r.toString());
    	} catch (Throwable th) {
    		r = Result.unknowException(th);
    		th.printStackTrace();
    	}
    	
    	return r.toString();
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
    						try {Integer.valueOf(strIndex);}catch (Throwable t){}
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
			Response rsp = req.getResponse(url);
			
			ret = rsp.asString();
			
			logger.info(ret);
		} catch (Throwable t) {
			// throw new RuntimeException(t);
			t.printStackTrace();
		}
		return ret;
	}
}
