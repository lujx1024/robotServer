package org.sgpro._nlp_external;

import java.util.Random;

import org.json.JSONArray;
import org.json.JSONObject;
import org.sgpro.db.ViewVoiceGroupId;
import org.sgpro.signalmaster.AutoTalkV2;
import org.sgpro.signalmaster.DBFunctionUtils;
import org.sgpro.signalmaster.RemoteAutoTalkV2;
import org.sgpro.util.StringUtil;

import com.iflytek.cloud.speech.SpeechError;
import com.iflytek.cloud.speech.SpeechUtility;
import com.iflytek.cloud.speech.TextUnderstander;
import com.iflytek.cloud.speech.TextUnderstanderListener;
import com.iflytek.cloud.speech.UnderstanderResult;
import com.iflytek.util.Version;

/**
 * 
 * 科大讯飞开放语义
 * @author 101000401
 *
 */

public class IflyOpenNLP implements NLP {

	private AutoTalkV2 context;
	private RemoteAutoTalkV2 remoteContext;
    private TextUnderstander tu =   TextUnderstander.createTextUnderstander();

	protected String rs;
 
    private TextUnderstanderListener tui = new TextUnderstanderListener() {
		
		@Override
		public void onResult(UnderstanderResult arg0) {
			// TODO Auto-generated method stub
			synchronized (IflyOpenNLP.this) {
				
				rs = arg0.getResultString();
				context.outputLog("科大语义成功：" + rs);
				IflyOpenNLP.this.notify();
			}
		}
		
		
		@Override
		public void onError(SpeechError arg0) {
			// TODO Auto-generated method stub
			synchronized (IflyOpenNLP.this) {
				context.outputLog("科大语义失败：" + arg0.toString());
				IflyOpenNLP.this.notify();
			}
		}
	};
    
    {
    	StringBuffer param = new StringBuffer();
    	param.append( "appid=" + Version.getAppid() );
    	SpeechUtility.createUtility( param.toString() );
    }
    
	@Override
	public void execute(Object context, ViewVoiceGroupId voice, String... args) throws Throwable {
		// TODO Auto-generated method stub
		this.context =  (AutoTalkV2) context;
		if (tu.isUnderstanding()) {
			tu.cancel();
		}
		
		this.context.outputLog("科大语义启动");
		tu.understandText(args[0], tui);
	
		synchronized (this) {
			rs = null;
			wait(10 * 1000);
			if (rs != null && new JSONObject(rs).optInt("rc") == 0) {
				JSONObject jo = new JSONObject(rs);
				String service = jo.optString("service");
				String operation = jo.optString("operation");
				if (StringUtil.isNullOrEmpty(operation)
						&& jo.has("moreResults")) {
					JSONArray ja = jo.optJSONArray("moreResults");
					for (int i = 0; i < ja.length(); i++) {
						jo = ja.getJSONObject(i);
						if ("ANSWER".equals(jo.optString("operation"))) {
							break;
						}
					}
				}
				
				this.context.outputLog("科大讯飞服务模块:"  + service); 
				String items = DBFunctionUtils.getConfig(args[1], "ifly_modules");
				
				this.context.outputLog("当前机器人可用ifly模块:"  + items); 
				
				if (!validModule(items, service)) {
					this.context.outputLog("无效模块"); 
					return;
				} else {
					this.context.outputLog("有效模块"); 
					voice.setVoiceCat("3");
					voice.setVoiceName(null);
				}
				
				switch (operation) {
				case "ANSWER":
					JSONObject joAnswer = jo.getJSONObject("answer");
					voice.setVoiceText(joAnswer.optString("text"));
					break;
				case "QUERY":
					switch (service) {
					case "weather":
						voice.setVoiceText("这是您要查询的天气");
						voice.setVoiceCommand(90L);
						voice.setVoiceCommandParam(jo.optJSONObject("webPage")
								.optString("url"));
						break;
					case "stock":
						voice.setVoiceText("这是您要查询的股票信息");
						voice.setVoiceCommand(90L);
						voice.setVoiceCommandParam(jo.optJSONObject("webPage")
								.optString("url"));
						break;
					case "pm25":
						voice.setVoiceText(jo.optJSONObject("webPage")
								.optString("header"));
						voice.setVoiceCommand(90L);
						voice.setVoiceCommandParam(jo.optJSONObject("webPage")
								.optString("url"));
						break;
						
					default:
						voice.setVoiceText("不支持啊");
						break;
					}
					break;
				case "PLAY":
					switch (service) {
					case "music":
						JSONObject musicData = jo.optJSONObject("data");
						JSONArray musicArray = musicData.optJSONArray("result");
						if (musicArray != null && musicArray.length() > 0) {
							Random random = new Random();
							int musicTotal = musicArray.length();
							String musicUrl = musicArray.optJSONObject(
									random.nextInt(musicTotal)).optString(
									"downloadUrl");
							voice.setVoiceText("");
							voice.setVoicePath(musicUrl);
						} else {
							voice.setVoiceText("肚子里没歌了，黔驴技穷");
						}
						break;
					default:
						voice.setVoiceText("不支持啊");
						break;
					}
					break;
				default:
					voice.setVoiceText("不支持啊");
					break;
				}
			}
		}
	}

	
	private boolean validModule(String items, String service) throws Throwable {
		// TODO Auto-generated method stub
		boolean ret = false;
		
		if (StringUtil.isNotNullAndEmpy(items)) {
			JSONObject  modules = new JSONObject(items);
			JSONArray ja = modules.optJSONArray("items");
			for (int i = 0; i < ja.length(); i++) {
				if (ja.getString(i).equals(service)) {
					ret = true;
					break;
				}
			}
		}

		return ret;
	}

	@Override
	public String description() {
		// TODO Auto-generated method stub
		return "科大讯飞开放语义";
	}

}
