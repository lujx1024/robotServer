package org.sgpro._nlp_external;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import net.sf.json.xml.XMLSerializer;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.sgpro.db.ViewVoiceGroup;
import org.sgpro.db.ViewVoiceGroupId;
import org.sgpro.signalmaster.Remote;
import org.sgpro.signalmaster.ViewUtils;
import org.sgpro.util.StringUtil;
import org.sgpro.util.http.Request;
import org.sgpro.util.http.Response;

/**
 * 经典的第三方 API NLP
 * @author 101000401
 *
 */
public class ClassicThirdPartyApiNLP implements NLP {
	static Logger logger = Logger.getLogger(ClassicThirdPartyApiNLP.class.getName());
    private static final int INVALID_INDEX_OR_NONARRAY = -1;

	private static final int RELAY_RANDOM_INDEX_GEN = -2;

	@Override
	public void execute(Object context, ViewVoiceGroupId voice, String... args)
			throws Throwable {

		// 服务端运行
		String imei  = args[1];
		String uid   = args[2];
		
		ViewVoiceGroupId vid = (ViewVoiceGroupId) ViewUtils
				.getViewData(ViewUtils.dbProcQuery(ViewVoiceGroup.class,
						"SP_GET_CLASSIC_NLP_API", imei, uid));

		if (vid != null) {
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
				String recommands  =  get3RdContent(vid.getVoiceCommandParam(), jo, indexArr);
				
				if (!"null".equals(recommands) && StringUtil.isNotNullAndEmpy(recommands)) {
					JSONArray jaRecommands = new JSONArray(recommands);
					
					if (jaRecommands.length() > 0) {
						JSONObject joRec = new JSONObject();
						joRec.put("items", jaRecommands);
						joRec.put("title", vid.getVoiceText());
						voice.setVoiceCommand(80L);
						voice.setVoiceCommandParam(joRec.toString());
					}
				}
			} else  {
				vid.setVoiceText(str);
			}
			
			String cat = vid.getVoiceCat();
			char[] arrCat = cat.toCharArray();
			arrCat[arrCat.length - 1] = '4';
			vid.setVoiceCat(String.valueOf(arrCat, 0, arrCat.length));
			
			voice.setVoiceCat(vid.getVoiceCat());
			voice.setVoiceDescription(vid.getVoiceDescription());
			voice.setVoiceText(vid.getVoiceText());
			voice.setVoiceName(description());
		}
	}

	@Override
	public String description() {
		// TODO Auto-generated method stub
		return "典型第三方语义API";
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
				if (urls != null && urls.length >= 2 ) {
					url = urls[0];
					data = urls[1];
				}
			}
			
			Response rsp = req.getResponse(url, data);
			
			ret = rsp.asString();
			
			logger.info(ret);
		} catch (Throwable t) {
			// throw new RuntimeException(t);
			t.printStackTrace();
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
    							logger.error(node + " is not a array");
    						} else {
    							JSONArray ja = jo.optJSONArray(node);
    							
    							if (ja.length() > 0 && ja.length() > index) {
    								index = index == RELAY_RANDOM_INDEX_GEN? new Random().nextInt(ja.length()) : index;
    								indexArr.put(node, index);
    								Object o = ja.get(index);
    								
    								if (o == null) {
    									logger.error(index + " is null elements");
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
    								logger.error(index + " out of range");
    							}
    						}
    					}
    				} else {
    					// 找不到路径
    					logger.error("can not found " + node);
    				}
    			}
    		} else {
    			ret = jo.toString();
    		}
    	}
    	return ret;
    }


}
